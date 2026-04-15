--// loader universal (delta / xeno)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- protección básica
pcall(function()
    getgenv().SecureMode = true
end)

-- carga del script
local url = "https://rawscripts.net/raw/Universal-Script-Cl*ic-Roblox-Animations-WITH-JUMP-111591"

local success, err = pcall(function()
    loadstring(game:HttpGet(url))()
end)

if success then
    print("script cargado correctamente B)")
else
    warn("error al cargar: "..tostring(err))
end
