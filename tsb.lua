--// services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// rayfield loader estable
pcall(function()
    getgenv().SecureMode = true
end)

local mirrors = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    "https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source"
}

local function httpget(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(res) == "string" then
        return res
    end
    return nil
end

local Rayfield
for _, url in ipairs(mirrors) do
    local src = httpget(url)
    if src then
        local ok, lib = pcall(function()
            return loadstring(src)()
        end)
        if ok and lib then
            Rayfield = lib
            break
        end
    end
end

if not Rayfield then
    warn("rayfield no cargo")
    return
end

--// ui
local Window = Rayfield:CreateWindow({
    Name = "tsb | pc hub",
    LoadingTitle = "tsb hub",
    LoadingSubtitle = "pc version",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("main")
local PlayerTab = Window:CreateTab("players")

--// variables
local Autofarm = false
local AutoSpam = false
local AutofarmConn
local SpectateZoom = 8

local ExcludedPlayers = {}

--// cam state
local originalCameraSubject = nil
local originalCameraType = nil
local lastSpectated = nil

--// noclip
local function noclip(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

--// get closest player
local function getClosestPlayer()
    local closest = nil
    local dist = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and not ExcludedPlayers[plr.Name]
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart")
        and plr.Character:FindFirstChild("Humanoid")
        and plr.Character.Humanoid.Health > 0
        and LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

            local d = (
                plr.Character.HumanoidRootPart.Position -
                LocalPlayer.Character.HumanoidRootPart.Position
            ).Magnitude

            if d < dist then
                dist = d
                closest = plr
            end
        end
    end

    return closest
end

--// spectate
local function spectateTarget(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not originalCameraSubject then
        originalCameraSubject = Camera.CameraSubject
    end
    if not originalCameraType then
        originalCameraType = Camera.CameraType
    end

    if lastSpectated == plr then return end

    local lookVec = hrp.CFrame.LookVector
    local camPos = hrp.Position - (lookVec * SpectateZoom) + Vector3.new(0,3,0)

    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = CFrame.new(camPos, hrp.Position)

    lastSpectated = plr
end

local function updateSpectate(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local lookVec = hrp.CFrame.LookVector
    local camPos = hrp.Position - (lookVec * SpectateZoom) + Vector3.new(0,3,0)

    Camera.CFrame = CFrame.new(camPos, hrp.Position)
end

local function resetCamera()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        else
            Camera.CameraType = originalCameraType or Enum.CameraType.Custom
            if originalCameraSubject then
                Camera.CameraSubject = originalCameraSubject
            end
        end
        lastSpectated = nil
    end)
end

--// autofarm NORMAL (sin anti ult)
local function startAutofarm()
    AutofarmConn = RunService.Heartbeat:Connect(function()
        if not Autofarm then return end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            resetCamera()
            return
        end

        noclip(char)

        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local thrp = target.Character.HumanoidRootPart

            spectateTarget(target)

            if lastSpectated == target then
                updateSpectate(target)
            end

            local pos = Vector3.new(
                thrp.Position.X,
                thrp.Position.Y - 7,
                thrp.Position.Z
            )

            hrp.CFrame = CFrame.lookAt(pos, thrp.Position)
            hrp.Velocity = Vector3.zero
        else
            resetCamera()
        end
    end)
end

local function stopAutofarm()
    if AutofarmConn then
        AutofarmConn:Disconnect()
        AutofarmConn = nil
    end
    resetCamera()
end

--// auto spam
task.spawn(function()
    while true do
        task.wait()
        if AutoSpam then
            pcall(function()
                local size = Camera.ViewportSize
                local x, y = size.X / 2, size.Y / 2

                VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                task.wait(0.03)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)

                for _, key in ipairs({
                    Enum.KeyCode.One,
                    Enum.KeyCode.Two,
                    Enum.KeyCode.Three,
                    Enum.KeyCode.Four,
                    Enum.KeyCode.Q
                }) do
                    VIM:SendKeyEvent(true, key, false, game)
                    task.wait(0.04)
                    VIM:SendKeyEvent(false, key, false, game)
                end
            end)

            task.wait(0.12)
        end
    end
end)

--// toggles
MainTab:CreateToggle({
    Name = "autofarm (under floor)",
    CurrentValue = false,
    Callback = function(v)
        Autofarm = v
        if v then startAutofarm() else stopAutofarm() end
    end
})

MainTab:CreateToggle({
    Name = "auto spam (click + 1 2 3 4 q)",
    CurrentValue = false,
    Callback = function(v)
        AutoSpam = v
    end
})

MainTab:CreateSlider({
    Name = "spectate zoom",
    Range = {3,20},
    Increment = 1,
    CurrentValue = SpectateZoom,
    Callback = function(v)
        SpectateZoom = v
    end
})

--// players tab
local function createPlayerToggle(plr)
    if plr ~= LocalPlayer then
        PlayerTab:CreateToggle({
            Name = "excluir "..plr.Name,
            CurrentValue = ExcludedPlayers[plr.Name] == true,
            Callback = function(v)
                if v then
                    ExcludedPlayers[plr.Name] = true
                else
                    ExcludedPlayers[plr.Name] = nil
                end
            end
        })
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    createPlayerToggle(plr)
end

Players.PlayerAdded:Connect(function(plr)
    task.wait(0.1)
    createPlayerToggle(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    ExcludedPlayers[plr.Name] = nil
end)

--// boton
MainTab:CreateButton({
    Name = "trashcanman",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://rawscripts.net/raw/The-Strongest-Battlegrounds-TSB-TrashCanMan-Moveset-55951"
            ))()
        end)
    end
})

--// ult system PRO (death counter real)

local ViewUlt = false
local UltPlayers = {} -- [plr] = tiempo
local UltState = {} -- "ready" / "used"
local UltHighlights = {}

task.spawn(function()
    while true do
        task.wait(1)

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then

                local hasUlt = false

                -- buscar tool en character
                for _, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("Tool") and v.Name == "Death Counter" then
                        hasUlt = true
                        break
                    end
                end

                -- buscar en backpack
                if not hasUlt and plr:FindFirstChild("Backpack") then
                    for _, v in pairs(plr.Backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name == "Death Counter" then
                            hasUlt = true
                            break
                        end
                    end
                end

                if hasUlt then
                    -- tiene la ulti lista
                    UltPlayers[plr] = tick()
                    UltState[plr] = "ready"

                else
                    -- si antes la tenía → ahora la usó
                    if UltState[plr] == "ready" then
                        UltPlayers[plr] = tick()
                        UltState[plr] = "used"
                    end
                end

                -- limpiar después de 14s
                if UltState[plr] == "used" then
                    if tick() - (UltPlayers[plr] or 0) > 14 then
                        UltPlayers[plr] = nil
                        UltState[plr] = nil
                    end
                end

                -- highlight
                if ViewUlt then
                    if UltState[plr] == "ready" then
                        if not UltHighlights[plr] then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = Color3.fromRGB(255, 0, 0) -- rojo
                            hl.OutlineColor = Color3.fromRGB(255,255,255)
                            hl.FillTransparency = 0.5
                            hl.Parent = plr.Character
                            UltHighlights[plr] = hl
                        else
                            UltHighlights[plr].FillColor = Color3.fromRGB(255, 0, 0)
                        end

                    elseif UltState[plr] == "used" then
                        if not UltHighlights[plr] then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = Color3.fromRGB(255, 255, 0) -- amarillo
                            hl.OutlineColor = Color3.fromRGB(255,255,255)
                            hl.FillTransparency = 0.5
                            hl.Parent = plr.Character
                            UltHighlights[plr] = hl
                        else
                            UltHighlights[plr].FillColor = Color3.fromRGB(255, 255, 0)
                        end

                    else
                        if UltHighlights[plr] then
                            UltHighlights[plr]:Destroy()
                            UltHighlights[plr] = nil
                        end
                    end
                end

            end
        end

        if not ViewUlt then
            for plr, hl in pairs(UltHighlights) do
                if hl then hl:Destroy() end
                UltHighlights[plr] = nil
            end
        end
    end
end)

-- reemplazo autofarm con anti ult real
local oldStart = startAutofarm
function startAutofarm()
    AutofarmConn = RunService.Heartbeat:Connect(function()
        if not Autofarm then return end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            resetCamera()
            return
        end

        noclip(char)

        local hrp = char.HumanoidRootPart

        -- detectar peligro (jugadores en estado "used")
        local danger = false
        for plr, state in pairs(UltState) do
            if state == "used" and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d <= 5 then
                    danger = true
                    break
                end
            end
        end

        local target = nil

        if danger then
            -- ir al más lejos
            local maxDist = 0
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer
                and not ExcludedPlayers[plr.Name]
                and not UltState[plr]
                and plr.Character
                and plr.Character:FindFirstChild("HumanoidRootPart") then

                    local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d > maxDist then
                        maxDist = d
                        target = plr
                    end
                end
            end
        else
            target = getClosestPlayer()
        end

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local thrp = target.Character.HumanoidRootPart

            spectateTarget(target)

            if lastSpectated == target then
                updateSpectate(target)
            end

            local pos = Vector3.new(
                thrp.Position.X,
                thrp.Position.Y - 7,
                thrp.Position.Z
            )

            hrp.CFrame = CFrame.lookAt(pos, thrp.Position)
            hrp.Velocity = Vector3.zero
        else
            resetCamera()
        end
    end)
end

-- toggle
MainTab:CreateToggle({
    Name = "View Ult Players",
    CurrentValue = false,
    Callback = function(v)
        ViewUlt = v
    end
})

-- auto tp
local autoTP = false

MainTab:CreateToggle({
    Name = "tp a las montañas en baja vida",
    CurrentValue = false,
    Callback = function(Value)
        autoTP = Value
    end,
})

task.spawn(function()
    while true do
        task.wait(0.2)

        if autoTP then
            local char = LocalPlayer.Character

            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                local humanoid = char.Humanoid

                if humanoid.Health > 0 and humanoid.Health < 10 then
                    char.HumanoidRootPart.CFrame = CFrame.new(166, 629, -480)
                end
            end
        end
    end
end)
