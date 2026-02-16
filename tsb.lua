--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

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
