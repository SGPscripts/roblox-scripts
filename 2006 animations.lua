--// OLD ROBLOX 2006 STYLE (DELTA EXECUTOR)
-- sistema pulido basado en referencias reales R6

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setup(char)
    local hum = char:WaitForChild("Humanoid")
    local torso = char:WaitForChild("Torso")

    -- joints R6
    local RS = torso:WaitForChild("Right Shoulder")
    local LS = torso:WaitForChild("Left Shoulder")
    local RH = torso:WaitForChild("Right Hip")
    local LH = torso:WaitForChild("Left Hip")

    -- offsets originales
    local RS0, LS0 = RS.C0, LS.C0
    local RH0, LH0 = RH.C0, LH.C0

    -- estado
    local state = "Idle"
    local t = 0

    -- parámetros estilo OLD
    local WALK_SPEED = 0.18
    local WALK_SWING = 0.32
    local IDLE_SWAY = 0.04

    local function setState(new)
        state = new
    end

    -- detectar tool
    local holdingTool = false

    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") then
            holdingTool = true

            obj.Unequipped:Connect(function()
                holdingTool = false
            end)

            obj.Activated:Connect(function()
                -- SLASH old simple
                RS.C0 = RS0 * CFrame.Angles(-1.2,0,0)
                task.wait(0.15)
                RS.C0 = RS0
            end)
        end
    end)

    -- loop principal (IMPORTANTE)
    task.spawn(function()
        while char.Parent do
            local speed = hum.MoveDirection.Magnitude
            local humState = hum:GetState()

            -- detectar estados reales
            if humState == Enum.HumanoidStateType.Jumping then
                setState("Jump")
            elseif humState == Enum.HumanoidStateType.Freefall then
                setState("Fall")
            elseif speed > 0.1 then
                setState("Walk")
            else
                setState("Idle")
            end

            -- WALK (estilo 2006 real)
            if state == "Walk" then
                local swing = math.sin(t) * WALK_SWING

                RS.C0 = RS0 * CFrame.Angles(swing,0,0)
                LS.C0 = LS0 * CFrame.Angles(-swing,0,0)
                RH.C0 = RH0 * CFrame.Angles(-swing,0,0)
                LH.C0 = LH0 * CFrame.Angles(swing,0,0)

                t += WALK_SPEED

            -- IDLE (casi sin movimiento)
            elseif state == "Idle" then
                local sway = math.sin(t) * IDLE_SWAY

                RS.C0 = RS0 * CFrame.Angles(sway,0,0)
                LS.C0 = LS0 * CFrame.Angles(-sway,0,0)
                RH.C0 = RH0
                LH.C0 = LH0

                t += 0.05

            -- JUMP (brazos adelante)
            elseif state == "Jump" then
                RS.C0 = RS0 * CFrame.Angles(-0.5,0,0)
                LS.C0 = LS0 * CFrame.Angles(-0.5,0,0)

            -- FALL (ligero forward)
            elseif state == "Fall" then
                RS.C0 = RS0 * CFrame.Angles(0.25,0,0)
                LS.C0 = LS0 * CFrame.Angles(0.25,0,0)
            end

            -- TOOL IDLE (brazo arriba estilo espada vieja)
            if holdingTool and state == "Idle" then
                RS.C0 = RS0 * CFrame.Angles(-0.3,0,0)
            end

            task.wait(0.05)
        end
    end)
end

-- aplicar
if player.Character then
    setup(player.Character)
end

player.CharacterAdded:Connect(setup)
