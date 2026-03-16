-- SGP hub : rayfield + ship fly (pc/móvil) + esp nombre/distancia + boat dash
-- botones movidos a la izquierda y separados

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

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            move += cam.CFrame.LookVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.S) then
            move -= cam.CFrame.LookVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.A) then
            move -= cam.CFrame.RightVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.D) then
            move += cam.CFrame.RightVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            move += Vector3.new(0,1,0)
        end

        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            move -= Vector3.new(0,1,0)
        end

        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            move += Vector3.new(hum.MoveDirection.X,0,hum.MoveDirection.Z)
        end

        if goingUp then
            move += Vector3.new(0,1,0)
        end

        if goingDown then
            move -= Vector3.new(0,1,0)
        end

        if move.Magnitude > 0 then
            move = move.Unit
        end

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
      if v then
         startFly()
      else
         stopFly()
      end
   end
})

----------------
-- ESP
----------------

local BoatsFolder = workspace:WaitForChild("ActiveBoats")

local espEnabled = false
local esp = {}

local function createESP(boat)

    if esp[boat] then return end

    local root = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
    if not root then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.FillTransparency = 0.6
    highlight.Parent = boat

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,80,0,16)
    bill.StudsOffset = Vector3.new(0,4,0)
    bill.AlwaysOnTop = true
    bill.Parent = root

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,1,1)
    text.TextStrokeTransparency = 0.8
    text.TextSize = 8
    text.TextScaled = false
    text.Font = Enum.Font.SourceSansBold
    text.Parent = bill

    esp[boat] = {highlight,bill,text,root}

end

local function removeESP(boat)

    if not esp[boat] then return end

    for _,v in pairs(esp[boat]) do
        if typeof(v) == "Instance" then
            v:Destroy()
        end
    end

    esp[boat] = nil

end

MainTab:CreateToggle({

   Name = "Enemy Ship ESP",

   CurrentValue = false,

   Callback = function(v)

      espEnabled = v

      if not v then
         for b,_ in pairs(esp) do
            removeESP(b)
         end
      end

   end

})

RunService.RenderStepped:Connect(function()

    if not espEnabled then return end

    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _,boat in pairs(BoatsFolder:GetChildren()) do

        if not tostring(boat.Name):lower():find(player.Name:lower()) then

            if not esp[boat] then
                createESP(boat)
            end

        end

    end

    for boat,data in pairs(esp) do

        local root = data[4]
        local text = data[3]

        if boat.Parent then

            local dist = math.floor((hrp.Position - root.Position).Magnitude)
            local name = boat.Name:gsub("_Boat","")

            text.Text = name.." | "..dist

        else
            removeESP(boat)
        end

    end

end)

----------------
-- BOAT DASH
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

MainTab:CreateSlider({

    Name = "Dash Strength",

    Range = {5,100},

    Increment = 1,

    CurrentValue = dashStrength,

    Callback = function(v)

        dashStrength = v

    end

})

MainTab:CreateButton({

    Name = "Boat Dash",

    Callback = function()

        dash()

    end

})

----------------
-- AUTO RAM
----------------

local function getClosestEnemyBoat()

    local myBoat = getMyBoat()
    if not myBoat then return nil end

    local myRoot = myBoat:FindFirstChild("BoatRoot") or myBoat.PrimaryPart
    if not myRoot then return nil end

    local closestBoat = nil
    local closestDist = math.huge

    for _,boat in pairs(BoatsFolder:GetChildren()) do

        if not tostring(boat.Name):lower():find(player.Name:lower()) then

            local root = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart

            if root then

                local dist = (myRoot.Position - root.Position).Magnitude

                if dist < closestDist then
                    closestDist = dist
                    closestBoat = root
                end

            end

        end

    end

    return closestBoat

end


local function autoRam()

    local myBoat = getMyBoat()
    if not myBoat then return end

    local myRoot = myBoat:FindFirstChild("BoatRoot") or myBoat.PrimaryPart
    if not myRoot then return end

    local enemyRoot = getClosestEnemyBoat()
    if not enemyRoot then return end

    local direction = (enemyRoot.Position - myRoot.Position).Unit

    myRoot.AssemblyLinearVelocity += direction * 90

end


MainTab:CreateButton({

    Name = "Auto Ram",

    Callback = function()

        autoRam()

    end

})
