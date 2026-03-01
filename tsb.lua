--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// RAYFIELD (fix loader)
pcall(function()
    getgenv().SecureMode = true
end)

local mirrors = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    "https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source"
}

local function http_get(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(res) == "string" then
        return res
    end

    if syn and syn.request then
        local r = syn.request({ Url = url, Method = "GET" })
        if r and r.Body then return r.Body end
    end

    if request then
        local r = request({ Url = url, Method = "GET" })
        if r and r.Body then return r.Body end
    end

    if http and http.request then
        local r = http.request({ Url = url, Method = "GET" })
        if r and r.Body then return r.Body end
    end

    return nil
end

local Rayfield
for _, url in ipairs(mirrors) do
    local src = http_get(url)
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

local Window = Rayfield:CreateWindow({
    Name = "TSB | PC Hub",
    LoadingTitle = "TSB Hub",
    LoadingSubtitle = "PC Version",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

--// VARIABLES
local Autofarm = false
local AutoSpam = false
local AutofarmConn

--// NOCLIP
local function noclip(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

--// GET CLOSEST PLAYER
local function getClosestPlayer()
    local closest, dist = nil, math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart")
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

--// AUTOFARM (UNDER FLOOR)
local function startAutofarm()
    AutofarmConn = RunService.Heartbeat:Connect(function()
        if not Autofarm then return end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        noclip(char)

        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local tHrp = target.Character.HumanoidRootPart

            local pos = Vector3.new(
                tHrp.Position.X,
                tHrp.Position.Y - 7,
                tHrp.Position.Z
            )

            hrp.CFrame = CFrame.lookAt(pos, tHrp.Position)
            hrp.Velocity = Vector3.zero
        end
    end)
end

local function stopAutofarm()
    if AutofarmConn then
        AutofarmConn:Disconnect()
        AutofarmConn = nil
    end
end

--// AUTO SPAM (PC CLICK + KEYS)
task.spawn(function()
    while true do
        task.wait()
        if AutoSpam then
            pcall(function()
                -- 🖱️ CLICK NORMAL (PC)
                local size = Camera.ViewportSize
                local x, y = size.X / 2, size.Y / 2

                VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                task.wait(0.03)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)

                -- ⌨️ TECLAS 1 2 3 4 Q
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

--// UI
MainTab:CreateToggle({
    Name = "Autofarm (Under Floor)",
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
    Name = "Auto spam (Click + 1 2 3 4 Q)",
    CurrentValue = false,
    Callback = function(v)
        AutoSpam = v
    end
})

                task.wait(0.2)

                -- boost velocidad si lo agarró
                hum.WalkSpeed = 30

                break
            end
        end

        -- volver a la posición original
        task.wait(0.1)
        hrp.CFrame = oldCFrame
        hum.WalkSpeed = oldSpeed
    end
})
