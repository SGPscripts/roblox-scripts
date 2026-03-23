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
