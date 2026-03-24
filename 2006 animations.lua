-- CUSTOM OLD ANIMATE (usando tus animaciones)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setup(char)
    local hum = char:WaitForChild("Humanoid")

    -- borrar animate default
    local animate = char:FindFirstChild("Animate")
    if animate then animate:Destroy() end

    -- IDs tuyos
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

    local function stopAll()
        for _, t in pairs(tracks) do
            t:Stop(0)
        end
    end

    -- IDLE
    task.spawn(function()
        while char.Parent do
            stopAll()
            tracks.Idle.Looped = true
            tracks.Idle:Play(0)
            task.wait(4)
        end
    end)

    -- WALK
    hum.Running:Connect(function(speed)
        if speed > 1 then
            stopAll()
            tracks.Walk.Looped = true
            tracks.Walk:Play(0)
        end
    end)

    -- JUMP
    hum.Jumping:Connect(function()
        stopAll()
        tracks.Jump:Play(0)
    end)

    -- FALL
    hum.FreeFalling:Connect(function(state)
        if state then
            stopAll()
            tracks.Fall.Looped = true
            tracks.Fall:Play(0)
        end
    end)

    -- CLIMB
    hum.Climbing:Connect(function(speed)
        if speed > 0 then
            stopAll()
            tracks.Climb.Looped = true
            tracks.Climb:Play(0)
        end
    end)

    -- TOOL DETECCIÓN
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            stopAll()
            tracks.ToolIdle.Looped = true
            tracks.ToolIdle:Play(0)

            child.Activated:Connect(function()
                stopAll()
                tracks.Slash:Play(0)
            end)
        end
    end)
end

-- aplicar
if player.Character then
    setup(player.Character)
end

player.CharacterAdded:Connect(setup)
