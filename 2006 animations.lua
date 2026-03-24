-- CUSTOM OLD ANIMS (EXECUTOR FRIENDLY)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setup(char)
    local hum = char:WaitForChild("Humanoid")

    -- eliminar animate
    local function removeAnimate()
        local a = char:FindFirstChild("Animate")
        if a then a:Destroy() end
    end

    removeAnimate()

    -- anti-restore
    char.ChildAdded:Connect(function(child)
        if child.Name == "Animate" then
            task.wait()
            child:Destroy()
        end
    end)

    -- IDs
    local ids = {
        Idle = "rbxassetid://80247769204860",
        Walk = "rbxassetid://119207180977930",
        Jump = "rbxassetid://128245637274553",
        Fall = "rbxassetid://137268346972841",
        Climb = "rbxassetid://85691845399452",
        ToolIdle = "rbxassetid://76528794913854",
        Lunge = "rbxassetid://106027613177784",
        Slash = "rbxassetid://86426014331595"
    }

    local tracks = {}

    for name, id in pairs(ids) do
        local anim = Instance.new("Animation")
        anim.AnimationId = id
        local track = hum:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action
        tracks[name] = track
    end

    local current = nil

    local function play(track, looped)
        if current == track then return end
        if current then current:Stop(0) end

        current = track
        track.Looped = looped or false
        track:Play(0)
    end

    -- MOVIMIENTO
    hum.Running:Connect(function(speed)
        if speed > 1 then
            play(tracks.Walk, true)
        else
            play(tracks.Idle, true)
        end
    end)

    -- JUMP
    hum.Jumping:Connect(function()
        play(tracks.Jump, false)
    end)

    -- FALL
    hum.FreeFalling:Connect(function(state)
        if state then
            play(tracks.Fall, true)
        end
    end)

    -- CLIMB
    hum.Climbing:Connect(function(speed)
        if speed > 0 then
            play(tracks.Climb, true)
        end
    end)

    -- TOOL
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then

            child.Equipped:Connect(function()
                play(tracks.ToolIdle, true)
            end)

            child.Activated:Connect(function()
                play(tracks.Slash, false)
            end)
        end
    end)
end

-- aplicar
if player.Character then
    setup(player.Character)
end

player.CharacterAdded:Connect(setup)
