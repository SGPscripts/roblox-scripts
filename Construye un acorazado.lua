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
   Name = "Ship Fly Speed",
   Range = {20, 200},
   Increment = 5,
   CurrentValue = 80,
   Callback = function(Value)
      speed = Value
   end
})

-- toggle fly
MainTab:CreateToggle({
   Name = "Ship Fly",
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

local BoatsFolder = workspace:WaitForChild("ActiveBoats")
local player = game.Players.LocalPlayer
local espEnabled = false

MainTab:CreateToggle({
   Name = "Enemy Ship ESP",
   CurrentValue = false,
   Callback = function(Value)
      espEnabled = Value

      if espEnabled then
         for _,boat in pairs(BoatsFolder:GetChildren()) do
            if not boat.Name:find(player.Name) then
               if not boat:FindFirstChild("SGP_ESP") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "SGP_ESP"
                  highlight.FillColor = Color3.fromRGB(255,0,0)
                  highlight.OutlineColor = Color3.fromRGB(255,255,255)
                  highlight.FillTransparency = 0.5
                  highlight.Parent = boat
               end
            end
         end
      else
         for _,boat in pairs(BoatsFolder:GetChildren()) do
            local esp = boat:FindFirstChild("SGP_ESP")
            if esp then
               esp:Destroy()
            end
         end
      end
   end
})

BoatsFolder.ChildAdded:Connect(function(boat)
   if espEnabled and not boat.Name:find(player.Name) then
      local highlight = Instance.new("Highlight")
      highlight.Name = "SGP_ESP"
      highlight.FillColor = Color3.fromRGB(255,0,0)
      highlight.OutlineColor = Color3.fromRGB(255,255,255)
      highlight.FillTransparency = 0.5
      highlight.Parent = boat
   end
end)

-- Boat Boost: noclip + speed multiplier (toggle + slider, max 100)
local BoatsFolder = workspace:WaitForChild("ActiveBoats")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local boostEnabled = false
local speedMultiplier = 1 -- default
local originalCanCollide = {}
local keepConnection = nil
local bindName = "SGP_BOAT_BOOST_KEEP"

-- funciona con MainTab ya creado (si no, crea uno temporal)
if not MainTab then
    if Rayfield then
        MainTab = Rayfield:CreateTab("Main", 4483362458)
    else
        error("Rayfield o MainTab no encontrado")
    end
end

local function getMyBoat()
    local namePattern = player.Name .. "_Boat"
    for _, m in pairs(BoatsFolder:GetChildren()) do
        if m.Name == namePattern then
            return m
        end
    end
    -- fallback: contains
    for _, m in pairs(BoatsFolder:GetChildren()) do
        if tostring(m.Name):lower():find(player.Name:lower()) then
            return m
        end
    end
    return nil
end

local function setBoatNoclip(boat, state)
    -- guarda/restaura CanCollide en todas las BasePart del barco
    if state then
        originalCanCollide = {}
        for _, v in pairs(boat:GetDescendants()) do
            if v:IsA("BasePart") then
                originalCanCollide[v] = v.CanCollide
                pcall(function() v.CanCollide = false end)
            end
        end
    else
        for part, val in pairs(originalCanCollide) do
            if part and part.Parent then
                pcall(function() part.CanCollide = val end)
            end
        end
        originalCanCollide = {}
    end
end

local function applySpeedTick(boat)
    -- seguridad
    if not boat or not boat.Parent then return end
    local boatRoot = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
    if not boatRoot then return end

    -- velocidad base: si el barco está quieto, toma 1 para no quedar en 0
    local baseSpeed = math.max(boatRoot.AssemblyLinearVelocity.Magnitude, 1)
    -- dirección hacia adelante según el boatRoot (mirada)
    local dir = boatRoot.CFrame.LookVector
    local targetVel = dir * (baseSpeed * speedMultiplier)

    pcall(function()
        -- escribir AssemblyLinearVelocity directamente
        boatRoot.AssemblyLinearVelocity = targetVel
    end)
end

local function startBoost()
    if boostEnabled then return end
    local boat = getMyBoat()
    if not boat then
        if Rayfield then Rayfield:Notify({ Title = "SGP", Content = "no se encontró tu barco en ActiveBoats.", Duration = 4 }) end
        return
    end

    -- activar noclip
    setBoatNoclip(boat, true)

    boostEnabled = true
    if Rayfield then Rayfield:Notify({ Title = "SGP", Content = "boat boost activado :D", Duration = 3 }) end

    -- conectar ticker (Heartbeat)
    keepConnection = RunService.Heartbeat:Connect(function()
        if not boostEnabled then return end
        local b = getMyBoat()
        if not b then return end
        -- aplicar velocidad forzada
        applySpeedTick(b)
    end)
end

local function stopBoost()
    if not boostEnabled then return end
    boostEnabled = false

    if keepConnection then
        keepConnection:Disconnect()
        keepConnection = nil
    end

    -- intentar restaurar colisiones y notificar
    local boat = getMyBoat()
    if boat then
        setBoatNoclip(boat, false)
    else
        -- si no lo encontramos, igual restauramos cualquier parte guardada
        setBoatNoclip({GetDescendants = function() return {} end}, false)
    end

    if Rayfield then Rayfield:Notify({ Title = "SGP", Content = "boat boost desactivado", Duration = 3 }) end
end

-- UI: slider (1..100) y toggle
MainTab:CreateSlider({
    Name = "Boat Speed Multiplier",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = speedMultiplier,
    Flag = "BoatSpeedMult",
    Callback = function(val)
        speedMultiplier = val
    end
})

MainTab:CreateToggle({
    Name = "Boat Boost (noclip + speed)",
    CurrentValue = false,
    Callback = function(val)
        if val then
            startBoost()
        else
            stopBoost()
        end
    end
})
