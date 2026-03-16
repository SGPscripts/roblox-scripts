-- cargar rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ventana
local Window = Rayfield:CreateWindow({
   Name = "SGP Scripts",
   LoadingTitle = "SGP",
   LoadingSubtitle = "Hub",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- tab
local MainTab = Window:CreateTab("Main", 4483362458)

local flying = false
local speed = 80
local bv
local bg

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

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

    RunService:BindToRenderStep("SGP_FLY",0,function()
        if not flying then return end

        local cam = workspace.CurrentCamera
        local move = Vector3.zero

        -- PC
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        -- móvil (joystick)
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            move += humanoid.MoveDirection
        end

        bv.Velocity = move * speed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    RunService:UnbindFromRenderStep("SGP_FLY")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

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
