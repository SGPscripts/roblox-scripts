-- cargar rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ventana
local Window = Rayfield:CreateWindow({
    Name = "Dark Deception",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "SGP Scripts",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- tab base
local Tab = Window:CreateTab("Main", 4483362458)
