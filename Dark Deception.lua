-- cargar rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ventana
local Window = Rayfield:CreateWindow({
    Name = "Dark Deception",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "SGP Scripts",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- tab base
local Tab = Window:CreateTab("Main", 4483362458)

-- variables
local shardAmount = 0
local farming = false

-- input (cantidad de shards)
Tab:CreateInput({
    Name = "Cantidad de Shards",
    PlaceholderText = "Ej: 50",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        shardAmount = tonumber(text) or 0
    end,
})

-- botón auto shard
Tab:CreateButton({
    Name = "Auto Shard",
    Callback = function()
        if farming then return end -- evita spam
        farming = true

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            local collected = 0

            for _, v in pairs(workspace:GetDescendants()) do
                if collected >= shardAmount then break end

                if v:IsA("BasePart") and v.Name == "Shard" then
                    hrp.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                    collected += 1
                    task.wait(0.05)
                end
            end

            farming = false
        end)
    end,
})

-- variables anti monstruos
local antiMonsters = false
local spawnPosition = nil

-- guardar spawn inicial
task.spawn(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    spawnPosition = hrp.CFrame
end)

-- toggle anti monstruos
Tab:CreateToggle({
    Name = "Anti Mounstros",
    CurrentValue = false,
    Callback = function(value)
        antiMonsters = value

        if antiMonsters then
            task.spawn(function()
                while antiMonsters do
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    local npcFolder = workspace:FindFirstChild("NPCs")

                    if hrp and npcFolder then
                        for _, npc in pairs(npcFolder:GetChildren()) do
                            if npc:IsA("Model") then
                                local npcPart = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                                if npcPart then
                                    local distance = (hrp.Position - npcPart.Position).Magnitude
                                    
                                    if distance <= 10 then
                                        if spawnPosition then
                                            hrp.CFrame = spawnPosition + Vector3.new(0, 3, 0)
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end

                    task.wait(0.2)
                end
            end)
        end
    end,
})

-- tab teleports
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

-- botón TP al orb
TeleportTab:CreateButton({
    Name = "TP to Orb",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local ringFolder = workspace:FindFirstChild("RingPiece")
        if ringFolder then
            local orb = ringFolder:FindFirstChild("Orb")
            if orb then
                local target

                if orb:IsA("Model") then
                    target = orb:GetPivot()
                elseif orb:IsA("BasePart") then
                    target = orb.CFrame
                end

                if target then
                    hrp.CFrame = target + Vector3.new(0, 3, 0)
                end
            end
        end
    end,
})

-- botón TP a la salida
TeleportTab:CreateButton({
    Name = "TP to Exit",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local exit = workspace:FindFirstChild("ExitPortal")
        if exit and exit:IsA("BasePart") then
            hrp.CFrame = exit.CFrame + Vector3.new(0, 3, 0)
        end
    end,
})

-- tab ESP
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- función crear ESP
local function createESP(obj, color)
    if obj:FindFirstChild("SGP_ESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SGP_ESP"
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = obj
    highlight.Parent = obj
end

-- función remover ESP
local function removeESP(obj)
    local esp = obj:FindFirstChild("SGP_ESP")
    if esp then esp:Destroy() end
end

-- estados
local espMonsters = false
local espPlayers = false
local espShards = false
local espOrb = false

-- ESP MONSTERS
ESPTab:CreateToggle({
    Name = "ESP Monsters",
    CurrentValue = false,
    Callback = function(val)
        espMonsters = val
    end,
})

-- ESP PLAYERS
ESPTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(val)
        espPlayers = val
    end,
})

-- ESP SHARDS
ESPTab:CreateToggle({
    Name = "ESP Shards",
    CurrentValue = false,
    Callback = function(val)
        espShards = val
    end,
})

-- ESP ORB
ESPTab:CreateToggle({
    Name = "ESP ORB",
    CurrentValue = false,
    Callback = function(val)
        espOrb = val
    end,
})

-- loop principal ESP
task.spawn(function()
    while true do
        -- monsters
        local npcFolder = workspace:FindFirstChild("NPCs")
        if npcFolder then
            for _, npc in pairs(npcFolder:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
                    if espMonsters then
                        createESP(npc, Color3.fromRGB(255, 0, 0))
                    else
                        removeESP(npc)
                    end
                end
            end
        end

        -- players
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
                if espPlayers then
                    createESP(plr.Character, Color3.fromRGB(0, 170, 255))
                else
                    removeESP(plr.Character)
                end
            end
        end

        -- shards
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "Shard" then
                if espShards then
                    createESP(v, Color3.fromRGB(0, 255, 255))
                else
                    removeESP(v)
                end
            end
        end

        -- orb
        local ring = workspace:FindFirstChild("RingPiece")
        if ring then
            local orb = ring:FindFirstChild("Orb")
            if orb then
                if espOrb then
                    createESP(orb, Color3.fromRGB(255, 0, 255))
                else
                    removeESP(orb)
                end
            end
        end

        task.wait(1)
    end
end)
