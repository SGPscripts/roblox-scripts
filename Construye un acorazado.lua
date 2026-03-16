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

-- submarine mode (toggle para bajar barco 20 studs y mantenerlo)
local BoatsFolder = workspace:WaitForChild("ActiveBoats")
local player = game.Players.LocalPlayer

local subEnabled = false
local depth = 20 -- studs abajo (cambiá a 15 si preferís)
local originalPartsCanCollide = {}
local originalBoatCFrame = nil
local keepBindName = "SGP_SUBMARINE_KEEP"

-- busca el barco del jugador (ej: Santyroblox55_Boat)
local function getMyBoat()
    local namePattern = player.Name .. "_Boat"
    local folder = BoatsFolder
    for _, m in pairs(folder:GetChildren()) do
        if m.Name == namePattern then
            return m
        end
    end
    -- si no lo encuentra por exacto, intenta contains (por si hay mayúsculas raras)
    for _, m in pairs(folder:GetChildren()) do
        if tostring(m.Name):lower():find(player.Name:lower()) then
            return m
        end
    end
    return nil
end

-- guarda y desactiva collisions del barco
local function disableCollisions(boat)
    originalPartsCanCollide = {}
    for _, desc in pairs(boat:GetDescendants()) do
        if desc:IsA("BasePart") then
            originalPartsCanCollide[desc] = desc.CanCollide
            desc.CanCollide = false
        end
    end
    -- tambien intenta poner CanCollide false al HRP del jugador (por si queda afuera)
    local chr = player.Character
    if chr then
        for _, p in pairs(chr:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                -- opcional: no tocar todas las piezas del personaje salvo HRP si querés
            end
        end
    end
end

-- restaura collisions
local function restoreCollisions()
    for part, val in pairs(originalPartsCanCollide) do
        if part and part.Parent then
            pcall(function() part.CanCollide = val end)
        end
    end
    originalPartsCanCollide = {}
end

-- activa submarine: teleporta el BoatRoot abajo y mantiene la altura
local function enableSubmarine()
    local boat = getMyBoat()
    if not boat then
        Rayfield:Notify({ Title = "SGP", Content = "no se encontró tu barco (ActiveBoats).", Duration = 4 })
        return
    end

    local boatRoot = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
    if not boatRoot then
        Rayfield:Notify({ Title = "SGP", Content = "BoatRoot no encontrado en tu barco.", Duration = 4 })
        return
    end

    -- guardar cframe original para poder restaurar
    originalBoatCFrame = boatRoot.CFrame

    -- depth target (guardamos la y que queremos mantener)
    local desiredY = boatRoot.Position.Y - depth

    -- desactivar colisiones
    disableCollisions(boat)

    subEnabled = true
    Rayfield:Notify({ Title = "SGP", Content = "submarine mode activado :D", Duration = 3 })

    -- mantener la y constante (preserva x,z y rotación del boatRoot)
    game:GetService("RunService").Heartbeat:Connect(function()
        if not subEnabled then return end
        if not boatRoot or not boatRoot.Parent then return end

        local curr = boatRoot.CFrame
        -- nueva posición: misma X,Z y rotación, pero Y = desiredY
        local pos = Vector3.new(curr.Position.X, desiredY, curr.Position.Z)
        local lookVector = curr.LookVector
        local targetCFrame = CFrame.new(pos, pos + lookVector)
        -- pcall para evitar errores si el servidor lo resetea
        pcall(function() 
            if boat.PrimaryPart then
                boat:SetPrimaryPartCFrame(targetCFrame)
            else
                boatRoot.CFrame = targetCFrame
            end
        end)
    end)
end

-- desactiva submarine: restaura posición y colisiones
local function disableSubmarine()
    subEnabled = false
    -- intentar restaurar la posición original (si aún existe)
    local boat = getMyBoat()
    if boat then
        local boatRoot = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
        if boatRoot and originalBoatCFrame then
            pcall(function() 
                if boat.PrimaryPart then
                    boat:SetPrimaryPartCFrame(originalBoatCFrame)
                else
                    boatRoot.CFrame = originalBoatCFrame
                end
            end)
        end
    end

    restoreCollisions()
    Rayfield:Notify({ Title = "SGP", Content = "submarine mode desactivado", Duration = 3 })
end

-- ui: toggle submarine
MainTab:CreateToggle({
    Name = "Submarine Mode",
    CurrentValue = false,
    Callback = function(val)
        if val then
            enableSubmarine()
        else
            disableSubmarine()
        end
    end
})

-- optional: slider para ajustar depth rapido (si querés)
MainTab:CreateSlider({
    Name = "Depth (studs)",
    Range = {5, 60},
    Increment = 1,
    CurrentValue = depth,
    Callback = function(v)
        depth = v
    end
})
