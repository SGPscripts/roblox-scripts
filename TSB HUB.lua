local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TSB HUB",
   LoadingTitle = "SGP SCRIPTS",
   LoadingSubtitle = "Hecho por SantiGodPlay",
   ConfigurationSaving = {
      Enabled = false,
   }
})

-- tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateButton({
   Name = "Copiar Discord",
   Callback = function()
      local invite = "https://discord.gg/TjwsBQ9Mt4"
      local success = false

      pcall(function()
         if setclipboard then
            setclipboard(invite)
            success = true
         elseif toclipboard then
            toclipboard(invite)
            success = true
         end
      end)

      if success then
         Rayfield:Notify({
            Title = "Discord",
            Content = "Link copiado al portapapeles",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Discord",
            Content = "No se pudo copiar, copialo manual: "..invite,
            Duration = 4
         })
      end
   end,
})
