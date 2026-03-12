-- bear skin companion (para usar con el script original)
-- pega esto en tu executor DESPUÉS de ejecutar el script mrd (o antes, se engancha cuando aparezcan los objetos)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- load rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Bear Skin Companion",
    LoadingTitle = "skin changer",
    LoadingSubtitle = "companion",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Skin Changer")
local SkinsTab = Window:CreateTab("Skins")

-- tus ids (puedes editarlos en la UI)
local IdleID = ""
local Walk1ID = ""
local Walk2ID = ""

-- estado
local Hooked = {}             -- mapa label -> true
local LabelFrameState = {}    -- alternador por label para walk1/walk2
local ScanInterval = 0.6      -- cada cuanto escanear workspace para encontrar labels
local MaxDistance = 60        -- distancia maxima para considerar un billboard "tu" sprite

-- util: devuelve un basepart cercano asociado al billboard gui (si existe)
local function getBillboardBasePart(billboard)
    if not billboard then return nil end
    -- adornee (si existe)
    local ok, adornee = pcall(function() return billboard.Adornee end)
    if ok and adornee and adornee:IsA("BasePart") then
        return adornee
    end
    -- tal vez el billboard está parented a un modelo con un root
    local parent = billboard.Parent
    if parent and parent:IsA("Model") then
        local hrp = parent:FindFirstChild("HumanoidRootPart") or parent:FindFirstChildWhichIsA("BasePart")
        if hrp then return hrp end
    end
    return nil
end

-- decide si este billboard es relevante (cerca tu personaje o su nombre sugiere bear)
local function isRelevantBillboard(billboard)
    if not player or not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local basepart = getBillboardBasePart(billboard)
    if basepart then
        local ok, dist = pcall(function() return (basepart.Position - hrp.Position).Magnitude end)
        if ok and dist and dist <= MaxDistance then
            return true
        end
    end

    -- heuristica por nombre (si el parent contiene "bear" o "sprite")
    local pname = tostring(billboard.Parent):lower()
    if pname:find("bear") or pname:find("sprite") or pname:find("rig") then
        return true
    end

    return false
end

-- hookea un ImageLabel: cuando cambie Image lo reemplazamos por nuestros frames
local function HookLabel(lbl)
    if not lbl or not lbl.Parent then return end
    if Hooked[lbl] then return end
    Hooked[lbl] = true
    LabelFrameState[lbl] = false

    -- conectar el cambio de propiedad
    local conn
    conn = lbl:GetPropertyChangedSignal("Image"):Connect(function()
        pcall(function()
            -- si no hay ids válidos, no tocamos
            if IdleID == "" and Walk1ID == "" and Walk2ID == "" then return end

            -- si label fue destruido desconectamos
            if not lbl.Parent then
                if conn then conn:Disconnect() end
                Hooked[lbl] = nil
                LabelFrameState[lbl] = nil
                return
            end

            -- comprobamos si local player esta en modo "bear" (no fiable siempre)
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local moving = false
            if hum and hum.MoveDirection then
                moving = hum.MoveDirection.Magnitude > 0.1
            end

            -- si se mueve alternamos frames por label
            if moving and Walk1ID ~= "" and Walk2ID ~= "" then
                LabelFrameState[lbl] = not LabelFrameState[lbl]
                if LabelFrameState[lbl] then
                    lbl.Image = "rbxassetid://" .. Walk1ID
                else
                    lbl.Image = "rbxassetid://" .. Walk2ID
                end
            else
                -- idle o sin movimiento
                if IdleID ~= "" then
                    lbl.Image = "rbxassetid://" .. IdleID
                end
            end
        end)
    end)

    -- forzamos imagen inicial para que reemplace de una vez
    pcall(function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        local moving = hum and hum.MoveDirection and hum.MoveDirection.Magnitude > 0.1 or false
        if moving and Walk1ID ~= "" then
            lbl.Image = "rbxassetid://" .. (Walk1ID)
        elseif IdleID ~= "" then
            lbl.Image = "rbxassetid://" .. IdleID
        end
    end)
end

-- escanea workspace y hookea labels relevantes
local function ScanAndHook()
    local desc = workspace:GetDescendants()
    for i = 1, #desc do
        local v = desc[i]
        if v and v:IsA("ImageLabel") and v.Parent and v.Parent:IsA("BillboardGui") then
            if not Hooked[v] and isRelevantBillboard(v.Parent) then
                HookLabel(v)
            end
        end
    end
end

-- start scanner en background
task.spawn(function()
    while true do
        pcall(function() ScanAndHook() end)
        task.wait(ScanInterval)
    end
end)

-- UI inputs / botones

Tab:CreateInput({
    Name = "Idle ID",
    PlaceholderText = "pon el id idle",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) IdleID = text end
})

Tab:CreateInput({
    Name = "Walk Frame 1 ID",
    PlaceholderText = "pon walkframe1",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) Walk1ID = text end
})

Tab:CreateInput({
    Name = "Walk Frame 2 ID",
    PlaceholderText = "pon walkframe2",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) Walk2ID = text end
})

Tab:CreateButton({
    Name = "Apply / Hook now",
    Callback = function()
        ScanAndHook()
        print("intentando hookear sprites :D")
    end
})

-- skins prehechas
SkinsTab:CreateButton({
    Name = "Captain Bear",
    Callback = function()
        IdleID  = "92159161315680"
        Walk1ID = "9344509375188"
        Walk2ID = "103419316396073"
        ScanAndHook()
        print("captain bear cargado :D")
    end
})

-- info rapida
Tab:CreateLabel("si no funciona al toque, espera 1-2s o presiona 'apply / hook now'")
