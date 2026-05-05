local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Silly Hub",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "By SGP SCRIPTS",
    ConfigurationSaving = {
        Enabled = true
    }
})

local Tab = Window:CreateTab("Info", 4483362458)
- Info Text
Tab:CreateParagraph({
    Title = "Info",
    Content = "Hola, Este script fue creado por SGP SCRIPTS, esta hecho para que farmees quidz faciles y uses tus exploits comodos con este hub"
})
