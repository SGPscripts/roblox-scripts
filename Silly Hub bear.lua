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

--// window
local Window = Rayfield:CreateWindow({
    Name = "S1LLY HUB",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "By SGP SCRIPTS",
    ConfigurationSaving = {
        Enabled = false
    }
})

--// tab
local Tab = Window:CreateTab("Info", 4483362458)

--// texto
Tab:CreateParagraph({
    Title = "Info",
    Content = "Hola, Este es un script de bear alpha creado por SGP SCRIPTS, Fue hecho para que puedas farmear comodo en bear alpha sin necesidad de otros jugadores, ¡Gracias por usar este script!"
})
--// version
Tab:CreateParagraph({
    Title = "Version",
    Content = "Version: v1.0"
})
--// utilidades tab
local UtilTab = Window:CreateTab("Utilidades", 4483362458)

UtilTab:CreateButton({
    Name = "Bypass anticheat (con esto podes volar, usar velocidad, fling y mas sin necesidad de godmode o algun otro script)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/7QhAURp2"))()
    end
})
--// infinite yield loader
UtilTab:CreateButton({
    Name = "Cargar infinite yield",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end
})
--// fullbright toggle button
local Lighting = game:GetService("Lighting")

local fullbrightEnabled = false
local savedLighting = {}
local loopId = 0

UtilTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        fullbrightEnabled = Value
        loopId += 1
        local currentLoop = loopId

        if fullbrightEnabled then
            -- guardar valores
            savedLighting = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                OutdoorAmbient = Lighting.OutdoorAmbient
            }

            task.spawn(function()
                while fullbrightEnabled and currentLoop == loopId do
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 14
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)

                    task.wait(10)
                end
            end)

        else
            -- cortar loop (invalidando id)
            loopId += 1

            -- restaurar
            if savedLighting.Brightness then
                Lighting.Brightness = savedLighting.Brightness
                Lighting.ClockTime = savedLighting.ClockTime
                Lighting.FogEnd = savedLighting.FogEnd
                Lighting.GlobalShadows = savedLighting.GlobalShadows
                Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
            end
        end
    end
})
--collect all cakes
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local collectingCakes = false
local cakeLoopId = 0

UtilTab:CreateToggle({
    Name = "Collect all cakes (event)",
    CurrentValue = false,
    Callback = function(Value)
        collectingCakes = Value
        cakeLoopId += 1

        local currentLoop = cakeLoopId

        if collectingCakes then
            task.spawn(function()
                while collectingCakes and currentLoop == cakeLoopId do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not collectingCakes or currentLoop ~= cakeLoopId then
                            break
                        end

                        if (obj.Name == "CakePink" or obj.Name == "CakeRed") and obj:IsA("Model") then
                            local character = LocalPlayer.Character
                            local hrp = character and character:FindFirstChild("HumanoidRootPart")

                            if hrp then
                                local targetPart =
                                    obj.PrimaryPart
                                    or obj:FindFirstChildWhichIsA("BasePart")

                                if targetPart then
                                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end
})
--op FLING GUI
UtilTab:CreateButton({
    Name = "OP FLING GUI",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/4nYEdANe"))()
        end)
    end
})
-- autofarm quidz
UtilTab:CreateButton({
Name = "Autofarm quidz",
Callback = function()
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- Prevent duplicate execution
if _G.AutoQuidzCollectorRunning then
StarterGui:SetCore("SendNotification", {
Title = "El script esta funcionando",
Text = "¡El script esta funcionando correctamente!",
Duration = 5
})
return
end
_G.AutoQuidzCollectorRunning = true

-- GUI Setup    
local ScreenGui = Instance.new("ScreenGui")    
ScreenGui.ResetOnSpawn = false -- GUI persists after respawn    
ScreenGui.Parent = CoreGui    

local MainFrame = Instance.new("Frame")    
MainFrame.Size = UDim2.new(0, 200, 0, 150)    
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)    
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)    
MainFrame.BorderSizePixel = 2    
MainFrame.Draggable = true    
MainFrame.Active = true    
MainFrame.Parent = ScreenGui    

local Title = Instance.new("TextLabel")    
Title.Size = UDim2.new(1, 0, 0, 25)    
Title.Text = "Coleccionador de quidz"    
Title.TextColor3 = Color3.new(1, 1, 1)    
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)    
Title.Parent = MainFrame    

local QuidzCounter = Instance.new("TextLabel")    
QuidzCounter.Size = UDim2.new(1, 0, 0, 25)    
QuidzCounter.Position = UDim2.new(0, 0, 0, 30)    
QuidzCounter.Text = "Quidz Coleccionados: 0"    
QuidzCounter.TextColor3 = Color3.new(1, 1, 1)    
QuidzCounter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)    
QuidzCounter.Parent = MainFrame    

local LevelCounter = Instance.new("TextLabel")    
LevelCounter.Size = UDim2.new(1, 0, 0, 25)    
LevelCounter.Position = UDim2.new(0, 0, 0, 60)    
LevelCounter.Text = "Nivel: 1"    
LevelCounter.TextColor3 = Color3.new(1, 1, 1)    
LevelCounter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)    
LevelCounter.Parent = MainFrame    

local StartButton = Instance.new("TextButton")    
StartButton.Size = UDim2.new(1, 0, 0, 30)    
StartButton.Position = UDim2.new(0, 0, 0, 90)    
StartButton.Text = "Iniciar"    
StartButton.TextColor3 = Color3.new(0, 1, 0)    
StartButton.BackgroundColor3 = Color3.new(0, 1, 0)    
StartButton.Parent = MainFrame    

local StopButton = Instance.new("TextButton")    
StopButton.Size = UDim2.new(1, 0, 0, 30)    
StopButton.Position = UDim2.new(0, 0, 0, 120)    
StopButton.Text = "Parar"    
StopButton.TextColor3 = Color3.new(1, 1, 1)    
StopButton.BackgroundColor3 = Color3.new(1, 0, 0)    
StopButton.Parent = MainFrame    

local MinimizeButton = Instance.new("TextButton")    
MinimizeButton.Size = UDim2.new(0, 50, 0, 25)    
MinimizeButton.Position = UDim2.new(1, -50, 0, 0)    
MinimizeButton.Text = "-"    
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)    
MinimizeButton.BackgroundColor3 = Color3.new(0.8, 0.5, 0)    
MinimizeButton.Parent = MainFrame    

-- Variables    
local collecting = false    
local quidzPosition = Vector3.new(408.13, 31.94, -26.91) -- Quidz position    
local cooldown = 0.7 -- Cooldown (unused in the provided loop structure but kept for reference)    
local quidzCollected = 0    
local level = 1    
local quidzPerLevel = 10    
local quidzIncreaseAmount = 5    
local interval = 9    
local doubleQuidz = false  -- New variable for gamepass    

-- Check for Double Quidz Gamepass    
local function checkDoubleQuidz()    
    local gamepassId = 6610211 
    if LocalPlayer:HasPass(gamepassId) then    
        doubleQuidz = true    
    end    
end    

-- Teleport Function    
local function teleportToQuidz()    
    local character = LocalPlayer.Character    
    if character and character:FindFirstChild("HumanoidRootPart") then    
        print("Teleporting to Quidz...") -- Debugging    
        character.HumanoidRootPart.CFrame = CFrame.new(quidzPosition)    
    end    
end    

-- Collection Function    
local function startCollecting()    
    if not collecting then    
        collecting = true    
        while collecting do    
            teleportToQuidz()    

            -- Adjust quidz increase based on the gamepass    
            local quidzToAdd = doubleQuidz and quidzIncreaseAmount * 2 or quidzIncreaseAmount    
            quidzCollected = quidzCollected + quidzToAdd    
            QuidzCounter.Text = "Quidz Collected: " .. quidzCollected    
                
            -- Level up    
            if quidzCollected >= level * quidzPerLevel then    
                level = level + 1    
                LevelCounter.Text = "Level: " .. level    
            end    
                
            print("Quidz Collected: ", quidzCollected) -- Debugging    
            wait(interval) -- Wait 9 secs before next collection    
        end    
    end    
end    

-- Stop Collecting    
local function stopCollecting()    
    collecting = false    
    print("Stopped collecting.") -- Debugging    
end    

-- Minimize GUI    
local minimized = false    
MinimizeButton.MouseButton1Click:Connect(function()    
    minimized = not minimized    
    for _, child in pairs(MainFrame:GetChildren()) do    
        if (child:IsA("TextButton") and child.Name ~= "CloseButton") or child:IsA("TextLabel") then    
            child.Visible = not minimized    
        end    
    end    
    MinimizeButton.Visible = true -- Keep minimize button visible    
    Title.Visible = true -- Keep title visible    
end)    

-- Button Clicks    
StartButton.MouseButton1Click:Connect(startCollecting)    
StopButton.MouseButton1Click:Connect(stopCollecting)    

-- Keep GUI on Respawn    
LocalPlayer.CharacterAdded:Connect(function()    
    wait(1)    
    MainFrame.Parent = ScreenGui    
end)    

-- Notice Message    
StarterGui:SetCore("SendNotification", {    
    Title = "ALERTA DE AFK",    
    Text = "¡PRENDÉ EL MODO AFL AHORA! SI NO, RESULTARAS BANEADO,ESTAS AVISADO!",    
    Duration = 9    
})    
print("Silly hub: El autofarm quidz fue ejecutado correctamente! ✔")

end,

})
--// no clip (xd) 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local noclipEnabled = false
local noclipConnection

UtilTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        noclipEnabled = Value

        if noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character

                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            local character = LocalPlayer.Character

            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})
--survivor tab

local SurvivorTab = Window:CreateTab("Supervivientes", 4483362458)

--infinite stamina
local Button = SurvivorTab:CreateButton({
Name = "Infinite stamina (resistencia infinita, corre para siempre a la vrg xd)",
Callback = function()
if _G.__TPWALK_RUNNING then
    _G.__TPWALK_RUNNING:Disconnect()
    _G.__TPWALK_RUNNING = nil
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer

local TPWALK_SPEED = 5.275
local BEARTPWALK_SPEED = 4.7
local LADDER_SPEED = 5.275
local SAFE_BUFFER = 0.15

local LADDER_TAGS = { "Ladder", "Climb", "Climbable", "Truss" }

local function getChar()
    return plr.Character or plr.CharacterAdded:Wait()
end

local char = getChar()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

plr.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    hum = c:WaitForChild("Humanoid")
end)

-- Team checks
local function isBear()
    if plr.Team and plr.Team.Name == "Bear" then return true end
    if plr:FindFirstChild("Role") and plr.Role.Value == "Bear" then return true end
    return false
end

local function isSurvivors()
    if plr.Team and plr.Team.Name == "Survivors" then return true end
    if plr:FindFirstChild("Role") and plr.Role.Value == "Survivors" then return true end
    return false
end

-- Raycast params
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist
rayParams.IgnoreWater = true

-- Helpers
local function isLadder(hit)
    if not hit or not hit.Instance then return false end
    local inst = hit.Instance
    for _, tag in ipairs(LADDER_TAGS) do
        if inst.Name:lower():find(tag:lower()) then
            return true
        end
    end
    return false
end

-- Core loop
_G.__TPWALK_RUNNING = RunService.RenderStepped:Connect(function(dt)
    if not (isBear() or isSurvivors()) then return end
    if not hrp or not hum then return end

    rayParams.FilterDescendantsInstances = { char }

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude == 0 then return end

    local speed = isBear() and BEARTPWALK_SPEED or TPWALK_SPEED
    local step = speed * dt
    local stepDir = moveDir.Unit
    local desired = stepDir * step

    -- Thin-part safety
    if Workspace:Raycast(hrp.Position, desired + stepDir * SAFE_BUFFER, rayParams) then
        return
    end

    -- Slope handling
    local downHit = Workspace:Raycast(hrp.Position, Vector3.new(0, -4, 0), rayParams)
    if downHit then
        local normal = downHit.Normal
        desired = desired - normal * desired:Dot(normal)
    end

    -- Ladder logic with smooth horizontal movement
    local ladderCheck = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 1.5, rayParams)
    if ladderCheck and isLadder(ladderCheck) then
        -- vertical climb vector
        local climb = Vector3.new(0, LADDER_SPEED * dt, 0)
        -- combine horizontal movement with vertical climb
        hrp.CFrame = hrp.CFrame + desired + climb
        return
    end

    hrp.CFrame = hrp.CFrame + desired
end)
print("silly Hub: infinite sta mina fue ejecutado correctamente")
end,
})
