local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Spin Farm",
    LoadingTitle = "Cargando...",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

local toggle = false

Tab:CreateToggle({
    Name = "FREE SPINS",
    CurrentValue = false,
    Callback = function(Value)
        toggle = Value

        if toggle then
            task.spawn(function()
                while toggle do
                    -- nueva ruta correcta
                    local obbies = workspace:FindFirstChild("Obbies")
                    local folder = obbies and obbies:FindFirstChild("WinParts")

                    if folder then
                        local parts = {}

                        for _, v in pairs(folder:GetChildren()) do
                            if v:IsA("BasePart") then
                                table.insert(parts, v)
                            end
                        end

                        if #parts > 0 then
                            local randomPart = parts[math.random(1, #parts)]

                            local player = game.Players.LocalPlayer
                            local char = player.Character or player.CharacterAdded:Wait()

                            char:MoveTo(randomPart.Position + Vector3.new(0,3,0))
                        end
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
})
