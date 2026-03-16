-- SGP hub (loader seguro) : rayfield + ship fly (pc/móvil) + esp nombre/distancia + boat dash
-- Cambios clave: loader de Rayfield con pcall y fallback; ScreenGui en PlayerGui; desconexiones seguras

-- intentar cargar Rayfield desde varias fuentes (safe)
local Rayfield = nil
local function tryLoadRayfield()
    local urls = {
        "https://sirius.menu/rayfield",
        -- fallback común (si tu mirror lo tiene)
        "https://raw.githubusercontent.com/Sirius12345/rayfield/master/rayfield.lua",
        "https://raw.githubusercontent.com/Sirius/menu/main/rayfield.lua"
    }
    for _, url in ipairs(urls) do
        local ok, res = pcall(function()
            local s = game:HttpGet(url)
            local lib = loadstring(s)()
            return lib
        end)
        if ok and res then
            return res
        end
    end
    return nil
end

Rayfield = tryLoadRayfield()
if not Rayfield then
    -- si no carga, avisamos por consola y terminamos (no tira errores)
    warn("SGP: no se pudo cargar Rayfield. Revisa tu executor o el link.")
    return
end

-- ventana y tab (si Rayfield cargó)
local Window = Rayfield:CreateWindow({
   Name = "SGP Scripts",
   LoadingTitle = "SGP",
   LoadingSubtitle = "Hub",
   ConfigurationSaving = {Enabled = false}
})
local MainTab = Window:CreateTab("Main", 4483362458)

-- servicios y vars generales
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

---------------------
-- FLY (pc + móvil)
---------------------
local flying = false
local speed = 80
local bv, bg
local goingUp = false
local goingDown = false

local upButton, downButton
local flyConnection = nil

local function getPlayerGui()
    local pg = player:FindFirstChild("PlayerGui")
    if pg then return pg end
    return game:GetService("Players"):GetPlayerFromCharacter(player.Character) and player:WaitForChild("PlayerGui")
end

local function createButtons()
    if upButton and upButton.Parent then return end
    local parentGui = getPlayerGui() or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "SGP_FLY_GUI"
    gui.ResetOnSpawn = false
    gui.Parent = parentGui

    upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0,60,0,60)
    upButton.Position = UDim2.new(1,-90,0.45,-30)
    upButton.Text = "↑"
    upButton.TextScaled = true
    upButton.BackgroundTransparency = 0.35
    upButton.Parent = gui

    downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0,60,0,60)
    downButton.Position = UDim2.new(1,-90,0.55,-30)
    downButton.Text = "↓"
    downButton.TextScaled = true
    downButton.BackgroundTransparency = 0.35
    downButton.Parent = gui

    upButton.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            goingUp = true
        end
    end)
    upButton.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            goingUp = false
        end
    end)

    downButton.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            goingDown = true
        end
    end)
    downButton.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            goingDown = false
        end
    end)
end

local function removeButtons()
    local parentGui = getPlayerGui() or game:GetService("CoreGui")
    local gui = parentGui:FindFirstChild("SGP_FLY_GUI")
    if gui then gui:Destroy() end
    upButton = nil
    downButton = nil
    goingUp = false
    goingDown = false
end

local function startFly()
    if flying then return end
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5)
    if not hrp then return end

    -- cleanup conexión vieja si existe
    if flyConnection then
        pcall(function() flyConnection:Disconnect() end)
        flyConnection = nil
    end

    -- crear body objects
    if not (bv and bv.Parent) then
        bv = Instance.new("BodyVelocity")
        bv.Name = "SGP_BodyVelocity"
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Parent = hrp
    end

    if not (bg and bg.Parent) then
        bg = Instance.new("BodyGyro")
        bg.Name = "SGP_BodyGyro"
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
    end

    createButtons()

    flying = true
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local char2 = player.Character
        if not char2 or not char2.Parent then
            -- cleanup seguro
            flying = false
            removeButtons()
            pcall(function() if bv and bv.Parent then bv:Destroy() end end)
            pcall(function() if bg and bg.Parent then bg:Destroy() end end)
            if flyConnection then pcall(function() flyConnection:Disconnect() end) end
            flyConnection = nil
            return
        end

        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)

        -- pc input
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end

        -- móvil: usar MoveDirection
        local humanoid = char2:FindFirstChildOfClass("Humanoid")
        if humanoid then
            move = move + Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z)
        end

        if goingUp then move = move + Vector3.new(0,1,0) end
        if goingDown then move = move - Vector3.new(0,1,0) end

        if move.Magnitude > 0 then move = move.Unit end

        if bv and bv.Parent then
            pcall(function() bv.Velocity = move * speed end)
        end
        if bg and bg.Parent and workspace.CurrentCamera then
            pcall(function() bg.CFrame = workspace.CurrentCamera.CFrame end)
        end
    end)
end

local function stopFly()
    if flyConnection then
        pcall(function() flyConnection:Disconnect() end)
        flyConnection = nil
    end

    pcall(function() if bv and bv.Parent then bv:Destroy() end end)
    pcall(function() if bg and bg.Parent then bg:Destroy() end end)

    removeButtons()
    flying = false
end

-- UI fly controls
MainTab:CreateSlider({
   Name = "Ship Fly Speed",
   Range = {20, 200},
   Increment = 5,
   CurrentValue = speed,
   Callback = function(Value) speed = Value end
})
MainTab:CreateToggle({
   Name = "Ship Fly",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         local ok, err = pcall(startFly)
         if not ok and Rayfield then Rayfield:Notify({Title = "SGP", Content = "error al iniciar fly: "..tostring(err), Duration = 4}) end
      else
         local ok, err = pcall(stopFly)
         if not ok and Rayfield then Rayfield:Notify({Title = "SGP", Content = "error al detener fly: "..tostring(err), Duration = 4}) end
      end
   end
})

---------------------
-- ESP con nombre y distancia (billboard muy chico)
---------------------
local BoatsFolder = workspace:WaitForChild("ActiveBoats")
local espEnabled = false
local espGuis = {} -- mapa boat -> {highlight, billboard, text, root}
local espUpdateConn = nil

local function createBoatESP(boat)
    if espGuis[boat] then return end
    local root = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
    if not root then return end

    local ok, highlight = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "SGP_ESP_HL"
        h.FillColor = Color3.fromRGB(255,0,0)
        h.OutlineColor = Color3.fromRGB(255,255,255)
        h.FillTransparency = 0.6
        h.Parent = boat
        return h
    end)
    if not ok then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SGP_NAME"
    billboard.Size = UDim2.new(0,80,0,16)
    billboard.StudsOffset = Vector3.new(0,4,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,1,1)
    text.TextStrokeTransparency = 0.8
    text.TextScaled = false
    text.TextSize = 8 -- casi invisible
    text.TextWrapped = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = ""
    text.Parent = billboard

    espGuis[boat] = { highlight = highlight, billboard = billboard, text = text, root = root }
end

local function removeBoatESP(boat)
    local info = espGuis[boat]
    if not info then return end
    pcall(function()
        if info.highlight and info.highlight.Parent then info.highlight:Destroy() end
        if info.billboard and info.billboard.Parent then info.billboard:Destroy() end
    end)
    espGuis[boat] = nil
end

local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, boat in pairs(BoatsFolder:GetChildren()) do
        if not tostring(boat.Name):lower():find(player.Name:lower()) then
            createBoatESP(boat)
        end
    end
    if espUpdateConn then pcall(function() espUpdateConn:Disconnect() end) end
    espUpdateConn = RunService.RenderStepped:Connect(function()
        if not espEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for boat, info in pairs(espGuis) do
            if not boat or not boat.Parent or not info.root or not info.text then
                removeBoatESP(boat)
            else
                local dist = math.floor((hrp.Position - info.root.Position).Magnitude)
                local pname = tostring(boat.Name):gsub("_Boat","")
                info.text.Text = pname .. " | " .. tostring(dist) .. " studs"
            end
        end
    end)
end

local function disableESP()
    espEnabled = false
    if espUpdateConn then
        pcall(function() espUpdateConn:Disconnect() end)
        espUpdateConn = nil
    end
    for boat, _ in pairs(espGuis) do
        removeBoatESP(boat)
    end
    espGuis = {}
end

MainTab:CreateToggle({
   Name = "Enemy Ship ESP",
   CurrentValue = false,
   Callback = function(Value)
      if Value then enableESP() else disableESP() end
   end
})

BoatsFolder.ChildAdded:Connect(function(boat)
   if espEnabled and not tostring(boat.Name):lower():find(player.Name:lower()) then
      createBoatESP(boat)
   end
end)

BoatsFolder.ChildRemoved:Connect(function(boat)
   if espGuis[boat] then removeBoatESP(boat) end
end)

---------------------
-- BOAT DASH (sin noclip)
---------------------
local dashStrength = 20 -- default
local dashMaxVel = 200  -- seguridad

local function getMyBoat()
    local namePattern = player.Name .. "_Boat"
    for _, m in pairs(BoatsFolder:GetChildren()) do
        if m.Name == namePattern then return m end
    end
    for _, m in pairs(BoatsFolder:GetChildren()) do
        if tostring(m.Name):lower():find(player.Name:lower()) then return m end
    end
    return nil
end

local function safeClamp(vec, maxMag)
    local mag = vec.Magnitude
    if mag > maxMag then
        return vec.Unit * maxMag
    end
    return vec
end

local function doBoatDash()
    local boat = getMyBoat()
    if not boat then
        pcall(function() Rayfield:Notify({ Title = "SGP", Content = "no se encontró tu barco.", Duration = 3 }) end)
        return
    end

    local boatRoot = boat:FindFirstChild("BoatRoot") or boat.PrimaryPart
    if not boatRoot then
        pcall(function() Rayfield:Notify({ Title = "SGP", Content = "BoatRoot no encontrado.", Duration = 3 }) end)
        return
    end

    local ok, currVel = pcall(function() return boatRoot.AssemblyLinearVelocity end)
    if not ok or not currVel then currVel = Vector3.new(0,0,0) end

    local forward = boatRoot.CFrame.LookVector
    local boostVec = forward * dashStrength

    local newVel = currVel + boostVec
    newVel = safeClamp(newVel, dashMaxVel)

    pcall(function()
        boatRoot.AssemblyLinearVelocity = newVel
    end)

    pcall(function() Rayfield:Notify({ Title = "SGP", Content = "dash aplicado :D", Duration = 1.5 }) end)
end

-- UI: slider para dash strength y botón dash
MainTab:CreateSlider({
    Name = "Dash Strength",
    Range = {5, 100},
    Increment = 1,
    CurrentValue = dashStrength,
    Flag = "BoatDashStrength",
    Callback = function(val) dashStrength = val end
})

MainTab:CreateButton({
    Name = "Boat Dash (impulso)",
    Callback = function() pcall(doBoatDash) end
})
