--// SGP HUB - FINAL UI (AVATAR LEFT FIX)
--// by SantiGodPlay :D

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-------------------------------------------------
-- GAME NAME
-------------------------------------------------
local placeName = "Unknown Game"
pcall(function()
	placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-------------------------------------------------
-- GUI
-------------------------------------------------
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "SGP_HUB"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

-------------------------------------------------
-- BLUR
-------------------------------------------------
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

-------------------------------------------------
-- INTRO
-------------------------------------------------
local intro = Instance.new("Frame", gui)
intro.Size = UDim2.fromScale(1,1)
intro.BackgroundTransparency = 1

local introImg = Instance.new("ImageLabel", intro)
introImg.AnchorPoint = Vector2.new(0.5,0.5)
introImg.Position = UDim2.fromScale(0.5,0.5)
introImg.Size = UDim2.fromScale(0.6,0.6)
introImg.Image = "rbxassetid://100486662794232"
introImg.BackgroundTransparency = 1
introImg.ImageTransparency = 1

Instance.new("UIAspectRatioConstraint", introImg).AspectRatio = 1

TweenService:Create(introImg, TweenInfo.new(1), {
	ImageTransparency = 0,
	Size = UDim2.fromScale(0.7,0.7)
}):Play()

task.wait(2)

TweenService:Create(introImg, TweenInfo.new(0.6), {
	ImageTransparency = 1
}):Play()

task.wait(0.7)
intro:Destroy()

-------------------------------------------------
-- MAIN UI
-------------------------------------------------
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(1,1)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.BackgroundTransparency = 0.2

-------------------------------------------------
-- CONTENT
-------------------------------------------------
local content = Instance.new("Frame", main)
content.AnchorPoint = Vector2.new(0.5,0.5)
content.Position = UDim2.fromScale(0.5,0.55)
content.Size = UDim2.fromScale(0.85,0.85)
content.BackgroundTransparency = 1

-------------------------------------------------
-- BORDERS
-------------------------------------------------
local function border(pos,size)
	local f = Instance.new("Frame", content)
	f.Position = pos
	f.Size = size
	f.BackgroundColor3 = Color3.fromRGB(0,200,255)
end

border(UDim2.new(0,0,0,0), UDim2.new(1,0,0,2))
border(UDim2.new(0,0,1,-2), UDim2.new(1,0,0,2))
border(UDim2.new(0,0,0,0), UDim2.new(0,2,1,0))
border(UDim2.new(1,-2,0,0), UDim2.new(0,2,1,0))

-------------------------------------------------
-- TITLE
-------------------------------------------------
local title = Instance.new("TextLabel", content)
title.Size = UDim2.fromScale(1,0.1)
title.Position = UDim2.fromScale(0,0.04)
title.Text = "SGP SCRIPTS >:)"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,120,255)
title.TextStrokeColor3 = Color3.fromRGB(0,200,255)
title.TextStrokeTransparency = 0
title.BackgroundTransparency = 1

-------------------------------------------------
-- INFO
-------------------------------------------------
local info = Instance.new("TextLabel", content)
info.Position = UDim2.fromScale(0.05,0.18)
info.Size = UDim2.fromScale(0.9,0.28)
info.TextWrapped = true
info.TextScaled = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Font = Enum.Font.Gotham
info.TextColor3 = Color3.fromRGB(0,120,255)
info.TextStrokeColor3 = Color3.fromRGB(0,200,255)
info.TextStrokeTransparency = 0
info.BackgroundTransparency = 1

info.Text =
"📍 Game: "..placeName..
"\n👤 User ID: "..player.UserId..
"\n🌎 Place ID: "..game.PlaceId..
"\n⚙️ Executor: "..(identifyexecutor and identifyexecutor() or "Unknown")..
"\n\nSGP SCRIPTS READY :D"

-------------------------------------------------
-- AVATAR (MORE LEFT)
-------------------------------------------------
local thumb = Players:GetUserThumbnailAsync(
	player.UserId,
	Enum.ThumbnailType.HeadShot,
	Enum.ThumbnailSize.Size420x420
)

local avatar = Instance.new("ImageLabel", content)
avatar.Position = UDim2.fromScale(0.05,0.52) -- << MÁS A LA IZQUIERDA
avatar.Size = UDim2.fromScale(0.18,0.18)
avatar.Image = thumb
avatar.BackgroundTransparency = 1

Instance.new("UIAspectRatioConstraint", avatar).AspectRatio = 1

local stroke = Instance.new("UIStroke", avatar)
stroke.Color = Color3.fromRGB(0,200,255)
stroke.Thickness = 2

-------------------------------------------------
-- USERNAME (MORE LEFT)
-------------------------------------------------
local username = Instance.new("TextLabel", content)
username.Position = UDim2.fromScale(0.05,0.72) -- << MÁS A LA IZQUIERDA
username.Size = UDim2.fromScale(0.25,0.06)
username.Text = player.Name
username.Font = Enum.Font.GothamBold
username.TextScaled = true
username.TextColor3 = Color3.fromRGB(0,120,255)
username.TextStrokeColor3 = Color3.fromRGB(0,200,255)
username.TextStrokeTransparency = 0
username.BackgroundTransparency = 1

-------------------------------------------------
-- BUTTONS
-------------------------------------------------
local close = Instance.new("TextButton", content)
close.Size = UDim2.fromScale(0.06,0.06)
close.Position = UDim2.fromScale(0.93,0.02)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.TextColor3 = Color3.fromRGB(255,80,80)
close.BackgroundTransparency = 1

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.14,0.06)
openBtn.Position = UDim2.fromScale(0.43,0.03)
openBtn.Text = "SGP HUB"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.TextColor3 = Color3.fromRGB(0,120,255)
openBtn.TextStrokeColor3 = Color3.fromRGB(0,200,255)
openBtn.TextStrokeTransparency = 0
openBtn.BackgroundColor3 = Color3.fromRGB(10,10,10)
openBtn.BackgroundTransparency = 0.3
openBtn.Visible = false

-------------------------------------------------
-- FUNCTIONS
-------------------------------------------------
local function openUI()
	main.Visible = true
	openBtn.Visible = false
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 18}):Play()
end

local function closeUI()
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()
	main.Visible = false
	openBtn.Visible = true
end

close.MouseButton1Click:Connect(closeUI)
openBtn.MouseButton1Click:Connect(openUI)

TweenService:Create(blur, TweenInfo.new(0.4), {Size = 18}):Play()

-------------------------------------------------
-- INFINITY YIELD BUTTON + SWIPE BAR (ADD-ON)
-------------------------------------------------
local UserInputService = game:GetService("UserInputService")

-- BOTÓN GRANDE
local iyButton = Instance.new("ImageButton", content)
iyButton.AnchorPoint = Vector2.new(1, 0.5)
iyButton.Position = UDim2.fromScale(0.92, 0.55)
iyButton.Size = UDim2.fromScale(0.28, 0.28) -- BIEN GRANDE
iyButton.Image = "rbxassetid://101069221323863"
iyButton.BackgroundTransparency = 1

Instance.new("UIAspectRatioConstraint", iyButton).AspectRatio = 1

-- TEXTO ABAJO
local iyText = Instance.new("TextLabel", content)
iyText.AnchorPoint = Vector2.new(1, 0)
iyText.Position = UDim2.fromScale(0.92, 0.71)
iyText.Size = UDim2.fromScale(0.28, 0.06)
iyText.Text = "Infinity Yield"
iyText.Font = Enum.Font.GothamBold
iyText.TextScaled = true
iyText.TextColor3 = Color3.fromRGB(255,255,255)
iyText.TextStrokeTransparency = 0
iyText.BackgroundTransparency = 1

-- EJECUTAR INFINITY YIELD
iyButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-------------------------------------------------
-- SWIPE BAR (DERECHA, GRANDE)
-------------------------------------------------
local swipeBar = Instance.new("Frame", content)
swipeBar.AnchorPoint = Vector2.new(1, 0.5)
swipeBar.Position = UDim2.fromScale(0.985, 0.5)
swipeBar.Size = UDim2.fromScale(0.025, 0.6)
swipeBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
swipeBar.BackgroundTransparency = 0.2
swipeBar.BorderSizePixel = 0

Instance.new("UICorner", swipeBar).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", swipeBar)
stroke.Color = Color3.fromRGB(0,200,255)
stroke.Thickness = 2

-- DRAG
local dragging = false
local dragStart, startPos

swipeBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = content.Position
	end
end)

swipeBar.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
	or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dragStart
		content.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
