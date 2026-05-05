--// services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// rayfield loader estable
pcall(function()
    getgenv().SecureMode = true
end)

local mirrors = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    "https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source"
}

local function httpget(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(res) == "string" then
        return res
    end
    return nil
end

local Rayfield
for _, url in ipairs(mirrors) do
    local src = httpget(url)
    if src then
        local ok, lib = pcall(function()
            return loadstring(src)()
        end)
        if ok and lib then
            Rayfield = lib
            break
        end
    end
end

if not Rayfield then
    warn("rayfield no cargo")
    return
end

--// window
local Window = Rayfield:CreateWindow({
    Name = "S1LLY HUB",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "By SGP SCRIPTS",
    ConfigurationSaving = {
        Enabled = false
    }
})

--// tab
local Tab = Window:CreateTab("Info", 4483362458)

--// texto
Tab:CreateParagraph({
    Title = "Info",
    Content = "Hola, Este es un script de bear alpha creado por SGP SCRIPTS, Fue hecho para que puedas farmear comodo en bear alpha sin necesidad de otros jugadores, ¡Gracias por usar este script!"
})
--// version
Tab:CreateParagraph({
    Title = "Version",
    Content = "Version: v1.0"
})
--// utilidades tab
local UtilTab = Window:CreateTab("Utilidades", 4483362458)

UtilTab:CreateButton({
    Name = "Bypass anticheat (con esto podes volar, usar velocidad, fling y mas sin necesidad de godmode o algun otro script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/7QhAURp2"))()
    end
})
