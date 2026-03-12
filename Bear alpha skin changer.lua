-- cargar rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Bear Skin Changer",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "test",
   ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Skin Changer")
local SkinsTab = Window:CreateTab("Skins")

local IdleID = ""
local Walk1ID = ""
local Walk2ID = ""

local function FindSprite()

   for _,v in pairs(workspace:GetDescendants()) do
      if v:IsA("ImageLabel") then
         if v.Image ~= "" then
            return v
         end
      end
   end

end

local function ApplySkin()

   local player = game.Players.LocalPlayer
   local char = player.Character
   if not char then return end

   local humanoid = char:FindFirstChildOfClass("Humanoid")
   if not humanoid then return end

   local sprite = FindSprite()
   if not sprite then
      print("no se encontró sprite")
      return
   end

   task.spawn(function()

      local frame = false

      while sprite and sprite.Parent do

         if humanoid.MoveDirection.Magnitude > 0 then

            frame = not frame

            if frame then
               sprite.Image = "rbxassetid://"..Walk1ID
            else
               sprite.Image = "rbxassetid://"..Walk2ID
            end

         else
            sprite.Image = "rbxassetid://"..IdleID
         end

         task.wait(0.08)

      end

   end)

end

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
      ApplySkin()
   end
})

SkinsTab:CreateButton({
   Name = "Captain Bear",
   Callback = function()

      IdleID = "92159161315680"
      Walk1ID = "9344509375188"
      Walk2ID = "103419316396073"

      ApplySkin()

      print("Captain Bear aplicado")

   end
})
