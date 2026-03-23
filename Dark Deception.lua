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
