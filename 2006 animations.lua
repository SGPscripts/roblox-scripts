-- ULTRA FIXED OLD ANIMS (ANTI TODO)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setup(char)
    local hum = char:WaitForChild("Humanoid")
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)

    -- 🔥 BORRAR ANIMATE + ANTI RESTORE
    local function removeAnimate()
        local a = char:FindFirstChild("Animate")
        if a then a:Destroy() end
    end

    removeAnimate()

    char.ChildAdded:Connect(function(child)
        if child.Name == "Animate" then
            task.wait()
            child:Destroy()
        end
    end)

    -- 🔥 IDS
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

        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action4 -- 🔥 PRIORIDAD MÁXIMA
        tracks[name] = track
    end

    -- 🔥 FUNCIÓN PARA MATAR TODAS LAS ANIMS (MUY IMPORTANTE)
    local function stopAll()
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            t:Stop(0)
        end
    end

    local current = ""

    -- 🔥 LOOP AGRESIVO (CLAVE)
    task.spawn(function()
        while task.wait(0.08) do
            if not hum or hum.Health <= 0 then continue end

            -- matar todo lo q no sea tuyo
            stopAll()

            local state = hum:GetState()
            local speed = hum.MoveDirection.Magnitude

            if state == Enum.HumanoidStateType.Climbing then
                if current ~= "Climb" then
                    tracks.Climb.Looped = true
                    tracks.Climb:Play(0)
                    current = "Climb"
                end

            elseif state == Enum.HumanoidStateType.Freefall then
                if current ~= "Fall" then
                    tracks.Fall.Looped = true
                    tracks.Fall:Play(0)
                    current = "Fall"
                end

            elseif state == Enum.HumanoidStateType.Jumping then
                tracks.Jump:Play(0)
                current = "Jump"

            elseif speed > 0 then
                if current ~= "Walk" then
                    tracks.Walk.Looped = true
                    tracks.Walk:Play(0)
                    current = "Walk"
                end

            else
                if current ~= "Idle" then
                    tracks.Idle.Looped = true
                    tracks.Idle:Play(0)
                    current = "Idle"
                end
            end
        end
    end)

    -- 🔥 TOOLS
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then

            child.Equipped:Connect(function()
                tracks.ToolIdle.Looped = true
                tracks.ToolIdle:Play(0)
            end)

            child.Activated:Connect(function()
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
