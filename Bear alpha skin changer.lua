-- cargar rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Bear Skin Changer",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "test",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Skin Changer")

local IdleID = ""
local Walk1ID = ""
local Walk2ID = ""

Tab:CreateInput({
   Name = "Idle ID",
   PlaceholderText = "pon el id idle",
   RemoveTextAfterFocusLost = false,
   Callback = function(text)
      IdleID = text
   end
})

Tab:CreateInput({
   Name = "Walk Frame 1 ID",
   PlaceholderText = "pon walkframe1",
   RemoveTextAfterFocusLost = false,
   Callback = function(text)
      Walk1ID = text
   end
})

Tab:CreateInput({
   Name = "Walk Frame 2 ID",
   PlaceholderText = "pon walkframe2",
   RemoveTextAfterFocusLost = false,
   Callback = function(text)
      Walk2ID = text
   end
})

Tab:CreateButton({
   Name = "Apply Skin",
   Callback = function()

      local char = game.Players.LocalPlayer.Character
      if not char then return end

      for _,v in pairs(char:GetDescendants()) do
         if v:IsA("ImageLabel") then
            v.Image = "rbxassetid://"..IdleID
         end
      end

      print("skin aplicada :)")

   end
})
