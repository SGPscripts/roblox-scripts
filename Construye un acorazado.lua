-- SGP hub : rayfield + ship fly (pc/móvil) + esp nombre/distancia + boat dash

-- cargar rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ventana
local Window = Rayfield:CreateWindow({
   Name = "SGP Scripts",
   LoadingTitle = "SGP",
   LoadingSubtitle = "Hub",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main",4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local BoatsFolder = workspace:WaitForChild("ActiveBoats")

----------------
-- FLY
----------------

local flying = false
local speed = 80
local bv
local bg
local flyConnection

local goingUp = false
local goingDown = false

local upButton
local downButton

local function createButtons()

    if upButton then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SGP_FLY_GUI"
    gui.ResetOnSpawn = false
    gui.Parent = game.CoreGui

    upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0,60,0,60)
    upButton.Position = UDim2.new(1,-170,0.40,-30)
    upButton.Text = "↑"
    upButton.TextScaled = true
    upButton.BackgroundTransparency = 0.3
    upButton.Parent = gui

    downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0,60,0,60)
    downButton.Position = UDim2.new(1,-170,0.65,-30)
    downButton.Text = "↓"
    downButton.TextScaled = true
    downButton.BackgroundTransparency = 0.3
    downButton.Parent = gui

    upButton.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            goingUp = true
        end
    end)

    upButton.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            goingUp = false
        end
    end)

    downButton.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            goingDown = true
        end
    end)

    downButton.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            goingDown = false
        end
    end)

end

local function removeButtons()

    local gui = game.CoreGui:FindFirstChild("SGP_FLY_GUI")
    if gui then
        gui:Destroy()
    end

    upButton = nil
    downButton = nil
    goingUp = false
    goingDown = false

end

local function startFly()

    if flying then return end

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    createButtons()

    flying = true

    flyConnection = RunService.RenderStepped:Connect(function()

        local cam = workspace.CurrentCamera
        local move = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            move += Vector3.new(hum.MoveDirection.X,0,hum.MoveDirection.Z)
        end

        if goingUp then move += Vector3.new(0,1,0) end
        if goingDown then move -= Vector3.new(0,1,0) end

        if move.Magnitude > 0 then move = move.Unit end

        bv.Velocity = move * speed
        bg.CFrame = cam.CFrame

    end)

end

local function stopFly()

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    removeButtons()
    flying = false

end

MainTab:CreateSlider({
   Name = "Ship Fly Speed",
   Range = {20,200},
   Increment = 5,
   CurrentValue = speed,
   Callback = function(v)
      speed = v
   end
})

MainTab:CreateToggle({
   Name = "Ship Fly",
   CurrentValue = false,
   Callback = function(v)
      if v then startFly() else stopFly() end
   end
})

----------------
-- BOAT SYSTEM
----------------

local dashStrength = 20

local function getMyBoat()
    for _,b in pairs(BoatsFolder:GetChildren()) do
        if tostring(b.Name):lower():find(player.Name:lower()) then
            return b
        end
    end
end

local function dash()

    local boat = getMyBoat()
    if not boat then return end

    local root = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
    if not root then return end

    root.AssemblyLinearVelocity += root.CFrame.LookVector * dashStrength

end

local function autoRam()

    local myBoat = getMyBoat()
    if not myBoat then return end

    local myRoot = myBoat:FindFirstChild("BoatRoot") or myBoat.PrimaryPart
    if not myRoot then return end

    local closest
    local dist = math.huge

    for _,boat in pairs(BoatsFolder:GetChildren()) do
        if not tostring(boat.Name):lower():find(player.Name:lower()) then
            local root = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
            if root then
                local d = (myRoot.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = root
                end
            end
        end
    end

    if not closest then return end

    local dir = (closest.Position - myRoot.Position).Unit
    myRoot.AssemblyLinearVelocity += dir * 150

end

----------------
-- UI BUTTONS
----------------

local gui = Instance.new("ScreenGui")
gui.Name = "SGP_RAM_DASH"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = game.CoreGui

local ram = Instance.new("TextButton")
ram.Size = UDim2.new(0,90,0,40)
ram.Position = UDim2.new(0,10,0,10)
ram.Text = "RAM"
ram.TextScaled = true
ram.Visible = false
ram.Parent = gui

local rc = Instance.new("UICorner")
rc.Parent = ram

ram.MouseButton1Click:Connect(autoRam)

local dashBtn = Instance.new("TextButton")
dashBtn.Size = UDim2.new(0,90,0,40)
dashBtn.Position = UDim2.new(0,10,0,60)
dashBtn.Text = "DASH"
dashBtn.TextScaled = true
dashBtn.Visible = false
dashBtn.Parent = gui

local dc = Instance.new("UICorner")
dc.Parent = dashBtn

dashBtn.MouseButton1Click:Connect(dash)

----------------
-- TOGGLES
----------------

MainTab:CreateSlider({
    Name = "Dash Strength",
    Range = {5,100},
    Increment = 1,
    CurrentValue = dashStrength,
    Callback = function(v)
        dashStrength = v
    end
})

MainTab:CreateToggle({
    Name = "Dash Button",
    CurrentValue = false,
    Callback = function(v)
        dashBtn.Visible = v
    end
})

MainTab:CreateToggle({
    Name = "Auto Ram Button",
    CurrentValue = false,
    Callback = function(v)
        ram.Visible = v
    end
})

RunService.RenderStepped:Connect(function()
    gui.Enabled = ram.Visible or dashBtn.Visible
end)
