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

-- nueva tab para players (exclusiones)
local PlayerTab = Window:CreateTab("players")

--// variables
local Autofarm = false
local AutoSpam = false
local AutofarmConn
local SpectateZoom = 8

-- tabla de jugadores excluidos (key = player.Name)
local ExcludedPlayers = {}

--// cam state
local originalCameraSubject = nil
local originalCameraType = nil
local lastSpectated = nil

--// noclip
local function noclip(char)
    -- ANTI DEATH COUNTER + ESCAPE
local DangerDistance = 5

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then

        local function hasUlt(p)
            for _, v in pairs(p.Character:GetChildren()) do
                if v:IsA("Tool") and v.Name == "Death Counter" then
                    return true
                end
            end
            if p:FindFirstChild("Backpack") then
                for _, v in pairs(p.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name == "Death Counter" then
                        return true
                    end
                end
            end
            return false
        end

        if hasUlt(plr) then
            local dist = (
                plr.Character.HumanoidRootPart.Position -
                char.HumanoidRootPart.Position
            ).Magnitude

            if dist <= DangerDistance then
                for _, safePlr in pairs(Players:GetPlayers()) do
                    if safePlr ~= LocalPlayer
                    and safePlr.Character
                    and safePlr.Character:FindFirstChild("HumanoidRootPart")
                    and not hasUlt(safePlr) then

                        char.HumanoidRootPart.CFrame =
                            safePlr.Character.HumanoidRootPart.CFrame + Vector3.new(0,-7,0)

                        return
                    end
                end
            end
        end
    end
    end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

--// get closest player (ignora excluidos y players sin humanoid / muertos)
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

    -- permitir cambiar la posicion de la camara si cambia el target
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
        if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        else
            Camera.CameraType = originalCameraType or Enum.CameraType.Custom
            if originalCameraSubject then
                Camera.CameraSubject = originalCameraSubject
            end
        end
        lastSpectated = nil
    end)
end

--// autofarm
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
        if v then
            startAutofarm()
        else
            stopAutofarm()
        end
    end
})

MainTab:CreateToggle({
    Name = "auto spam (click + 1 2 3 4 q)",
    CurrentValue = false,
    Callback = function(v)
        AutoSpam = v
    end
})

--// slider zoom
MainTab:CreateSlider({
    Name = "spectate zoom",
    Range = {3,20},
    Increment = 1,
    CurrentValue = SpectateZoom,
    Callback = function(v)
        SpectateZoom = v
    end
})

--// helpers para la tab de players (crear toggles dinamicamente)
local function createPlayerToggle(plr)
    if not plr or not plr.Name then return end
    if plr == LocalPlayer then return end

    -- crear toggle para excluir/permitir target
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

-- crear toggles iniciales
for _, plr in pairs(Players:GetPlayers()) do
    createPlayerToggle(plr)
end

-- cuando entra un jugador nuevo, le creamos el toggle
Players.PlayerAdded:Connect(function(plr)
    -- esperar un tick para que Rayfield no rompa si crea muchas cosas de golpe
    task.wait(0.1)
    createPlayerToggle(plr)
end)

-- cuando un jugador sale, limpiamos la exclusion
Players.PlayerRemoving:Connect(function(plr)
    ExcludedPlayers[plr.Name] = nil
end)

--// boton trashcanman
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
--// view ult players (death counter esp)

local ViewUlt = false
local UltHighlights = {}

-- loop
task.spawn(function()
    while true do
        task.wait(0.5)

        if ViewUlt then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then

                    local hasUlt = false

                    -- revisar tools en character
                    for _, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("Tool") and v.Name == "Death Counter" then
                            hasUlt = true
                            break
                        end
                    end

                    -- revisar backpack
                    if not hasUlt and plr:FindFirstChild("Backpack") then
                        for _, v in pairs(plr.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v.Name == "Death Counter" then
                                hasUlt = true
                                break
                            end
                        end
                    end

                    -- aplicar highlight
                    if hasUlt then
                        if not UltHighlights[plr] then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                            hl.OutlineColor = Color3.fromRGB(255,255,255)
                            hl.FillTransparency = 0.5
                            hl.Parent = plr.Character

                            UltHighlights[plr] = hl
                        end
                    else
                        if UltHighlights[plr] then
                            UltHighlights[plr]:Destroy()
                            UltHighlights[plr] = nil
                        end
                    end

                end
            end
        else
            -- limpiar todo
            for plr, hl in pairs(UltHighlights) do
                if hl then
                    hl:Destroy()
                end
                UltHighlights[plr] = nil
            end
        end
    end
end)

-- toggle en rayfield
MainTab:CreateToggle({
    Name = "View Ult Players",
    CurrentValue = false,
    Callback = function(v)
        ViewUlt = v
    end
})
