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

      local player = game.Players.LocalPlayer
      local char = player.Character
      if not char then return end

      local humanoid = char:FindFirstChildOfClass("Humanoid")
      if not humanoid then return end

      local sprite

      for _,v in pairs(char:GetDescendants()) do
         if v:IsA("ImageLabel") then
            sprite = v
            break
         end
      end

      if not sprite then return end

      print("sprite encontrado")

      task.spawn(function()
         while sprite and sprite.Parent do

            if humanoid.MoveDirection.Magnitude > 0 then
               sprite.Image = "rbxassetid://"..Walk1ID
               task.wait(0.15)

               sprite.Image = "rbxassetid://"..Walk2ID
               task.wait(0.15)
            else
               sprite.Image = "rbxassetid://"..IdleID
               task.wait(0.2)
            end

         end
      end)

      print("skin aplicada :)")

   end
})
