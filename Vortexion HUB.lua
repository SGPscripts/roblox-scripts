local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Vortexion",
	LoadingTitle = "Vortexion Hub",
	LoadingSubtitle = "Loading...",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false
})
---- useful xD
local UsefulTab = Window:CreateTab("Useful", 4483362458)

local player = game.Players.LocalPlayer

-- SPEED
UsefulTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {16, 200},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Callback = function(Value)
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = Value
		end
	end,
})

-- JUMP POWER
UsefulTab:CreateSlider({
	Name = "JumpPower",
	Range = {50, 200},
	Increment = 1,
	Suffix = "Jump",
	CurrentValue = 50,
	Callback = function(Value)
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.JumpPower = Value
		end
	end,
})

-- INFINITE YIELD
UsefulTab:CreateButton({
	Name = "Load Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end,
})
