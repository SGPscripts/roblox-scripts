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

local Hooked = false

local function ApplySkin()

   if Hooked then return end
   Hooked = true

   local player = game.Players.LocalPlayer
   local char = player.Character
   if not char then return end

   for _,v in pairs(char:GetDescendants()) do
      if v:IsA("ImageLabel") then

         v:GetPropertyChangedSignal("Image"):Connect(function()

            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            if hum.MoveDirection.Magnitude > 0 then

               if math.random(1,2) == 1 then
                  v.Image = "rbxassetid://"..Walk1ID
               else
                  v.Image = "rbxassetid://"..Walk2ID
               end

            else
               v.Image = "rbxassetid://"..IdleID
            end

         end)

      end
   end

   print("skin hook aplicada")

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
