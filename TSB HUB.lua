local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FPS Hub",
   LoadingTitle = "FPS Hub",
   LoadingSubtitle = "by Santi & ChatGPT",
   ConfigurationSaving = {
      Enabled = false,
   }
})

-- tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)
