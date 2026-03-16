-- cargar rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SGP Scripts",
   LoadingTitle = "SGP",
   LoadingSubtitle = "Hub",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main", 4483362458)

local flying = false
local speed = 80
local bv
local bg

local upButton
local downButton

local goingUp = false
local goingDown = false

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

function createButtons()

    local gui = Instance.new("ScreenGui")
    gui.Name = "SGP_FLY_GUI"
    gui.Parent = game.CoreGui

    -- botón subir
    upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0,80,0,80)
    upButton.Position = UDim2.new(1,-110,0.45,-40)
    upButton.Text = "↑"
    upButton.TextScaled = true
    upButton.BackgroundTransparency = 0.3
    upButton.Parent = gui

    -- botón bajar
    downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0,80,0,80)
    downButton.Position = UDim2.new(1,-110,0.60,-40)
    downButton.Text = "↓"
    downButton.TextScaled = true
    downButton.BackgroundTransparency = 0.3
    downButton.Parent = gui

    upButton.MouseButton1Down:Connect(function()
        goingUp = true
    end)

    upButton.MouseButton1Up:Connect(function()
        goingUp = false
    end)

    downButton.MouseButton1Down:Connect(function()
        goingDown = true
    end)

    downButton.MouseButton1Up:Connect(function()
        goingDown = false
    end)

end

function removeButtons()
    local gui = game.CoreGui:FindFirstChild("SGP_FLY_GUI")
    if gui then
        gui:Destroy()
    end
end

local function startFly()

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

    RunService:BindToRenderStep("SGP_FLY",0,function()

        if not flying then return end

        local cam = workspace.CurrentCamera
        local move = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            move += humanoid.MoveDirection
        end

        if goingUp then
            move += Vector3.new(0,1,0)
        end

        if goingDown then
            move -= Vector3.new(0,1,0)
        end

        bv.Velocity = move * speed
        bg.CFrame = cam.CFrame

    end)
end

local function stopFly()

    RunService:UnbindFromRenderStep("SGP_FLY")

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    removeButtons()

end

-- slider velocidad
MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {20, 200},
   Increment = 5,
   CurrentValue = 80,
   Callback = function(Value)
      speed = Value
   end
})

-- toggle fly
MainTab:CreateToggle({
   Name = "VFly",
   CurrentValue = false,
   Callback = function(Value)

      flying = Value

      if flying then
         startFly()
      else
         stopFly()
      end

   end
})
