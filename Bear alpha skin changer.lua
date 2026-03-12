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

local Running = false

local function ApplySkin()

   if Running then return end
   Running = true

   task.spawn(function()

      while Running do

         local char = game.Players.LocalPlayer.Character
         if char then

            local hum = char:FindFirstChildOfClass("Humanoid")

            for _,v in pairs(game:GetDescendants()) do
               if v:IsA("ImageLabel") then

                  if hum and hum.MoveDirection.Magnitude > 0 then

                     v.Image = "rbxassetid://"..Walk1ID
                     task.wait(0.08)

                     v.Image = "rbxassetid://"..Walk2ID

                  else

                     v.Image = "rbxassetid://"..IdleID

                  end

               end
            end

         end

         task.wait(0.05)

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

   end
})
