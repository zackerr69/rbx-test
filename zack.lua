-- DRTK hook | Luau | Desktop UI build 05
-- Intended for a LocalScript in your own Roblox experience.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

do
	local old = playerGui:FindFirstChild("DRTK_Hook")
	if old then old:Destroy() end
	local oldFx = Lighting:FindFirstChild("DRTK_LocalSkyTint")
	if oldFx then oldFx:Destroy() end
	local oldSnow = workspace:FindFirstChild("DRTK_LocalSnow")
	if oldSnow then oldSnow:Destroy() end
end

local GUI_NAME = "Hk" .. tostring(math.random(100000, 999999))

local C = {
	white = Color3.fromRGB(255, 255, 255),
	pink = Color3.fromRGB(255, 132, 207),
	pinkLight = Color3.fromRGB(255, 191, 232),
	purple = Color3.fromRGB(185, 108, 255),
	softPurple = Color3.fromRGB(196, 158, 255),
	purpleDeep = Color3.fromRGB(78, 36, 120),
	gray = Color3.fromRGB(150, 150, 158),
	meteor = Color3.fromRGB(192, 142, 255),
	trail = Color3.fromRGB(119, 74, 172),
	dark = Color3.fromRGB(37, 35, 44),
	panel = Color3.fromRGB(92, 92, 98),
}
local RED = Color3.fromRGB(255, 72, 88)
local SOFT_PURPLE = Color3.fromRGB(176, 128, 240)
local ESP_COLORS = {
	innocent = Color3.fromRGB(80, 255, 120),
	sheriff = Color3.fromRGB(70, 140, 255),
	murderer = Color3.fromRGB(255, 60, 60),
}
local KNIFE_KEY = "knife"
local GUN_KEY = "gun"
local PROJ_KEYS = {"knife", "bullet", "projectile"}

local function make(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	obj.Parent = parent
	return obj
end

local function tween(obj, duration, props, style, direction)
	local t = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function corner(obj, radius)
	make("UICorner", {CornerRadius = UDim.new(0, radius)}, obj)
end

local function stroke(obj, color, thickness, transparency)
	return make("UIStroke", {Color = color, Thickness = thickness, Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, obj)
end

local function isClick(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local gui = make("ScreenGui", {Name = GUI_NAME, IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)

-- shared state
local S = {
	tab = "combat",
	menuOpen = false,
	menuBusy = false,
	wasGround = true,
	jumpT = 0,
	fly = {on = false, speed = 60, bv = nil, bg = nil},
	bhop = {on = false, speed = 1.6, jumpH = 7.2, bv = nil, cur = 16, lastJump = 0},
	anti = {on = false, mode = "legit", spin = nil, gyro = nil, hum = nil, angle = 0, pauseUntil = 0, lastDodge = 0, radius = 5},
	aim = {on = false, fov = 120, mode = "players", visible = true, killerThrows = false, range = 300, smooth = 0.85},
	tb = {on = false, knifeM = 0.7, gunMode = "killer", last = 0},
	farm = {on = false, radius = 60, speed = 40, mode = "both", bv = nil, target = nil, deadline = 0, nextScan = 0, black = {}},
	esp = {roles = false, skel = false, lines = false},
	trail = {on = false, origin = "back", len = 1.2, color = C.pink},
	puddle = {on = false, color = Color3.fromRGB(200, 235, 255)},
	hat = {on = false, who = "me", color = Color3.fromRGB(247, 164, 201), transparency = 0.5, scale = 1, height = 0.25, tilt = 0},
	atmo = {on = false, color = Color3.fromRGB(177, 106, 255), sat = -0.72},
	cape = {on = false, color = Color3.fromRGB(210, 160, 220), transparency = 0.38, flare = 2.1},
	snow = {on = false, count = 70, speed = 1, color = Color3.fromRGB(248, 252, 255)},
	projSet = {},
	farmSet = {},
}

local contentFrame, previewFrame, placePreview

-- INTRO + PANEL ---------------------------------------------------------------
do
	local intro = make("Frame", {Name = "Intro", Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 50}, gui)
	local logo = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.46), Size = UDim2.fromOffset(440, 150), BackgroundTransparency = 1, ZIndex = 51}, intro)
	local letters = {}
	local info = {
		{text = "D", x = 30, rot = -9, from = UDim2.new(0, -250, 0, 0)},
		{text = "R", x = 120, rot = 7, from = UDim2.new(0, 250, 0, 0)},
		{text = "T", x = 210, rot = -6, from = UDim2.new(0, 0, 0, -200)},
		{text = "K", x = 300, rot = 9, from = UDim2.new(0, 0, 0, 200)},
	}
	for i, d in ipairs(info) do
		local depth = make("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(d.x + 60, 80), Size = UDim2.fromOffset(112, 126), BackgroundTransparency = 1, Text = d.text, Font = Enum.Font.GothamBlack, TextSize = 104, TextColor3 = C.purple, TextTransparency = 0.72, Rotation = d.rot, ZIndex = 51}, logo)
		local front = make("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = d.from + UDim2.fromOffset(d.x + 55, 74), Size = UDim2.fromOffset(112, 126), BackgroundTransparency = 1, Text = d.text, Font = Enum.Font.GothamBlack, TextSize = 104, TextColor3 = C.pink, TextTransparency = 1, Rotation = d.rot, ZIndex = 52}, logo)
		letters[i] = {front = front, depth = depth, x = d.x, rot = d.rot}
	end
	local hook = make("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 143), Size = UDim2.fromOffset(250, 36), BackgroundTransparency = 1, Text = "h  o  o  k", Font = Enum.Font.GothamMedium, TextSize = 21, TextColor3 = C.purple, TextTransparency = 1, ZIndex = 53}, logo)

	local launcher = make("TextButton", {Name = "Launcher", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 28, 0.5, 0), Size = UDim2.fromOffset(42, 42), BackgroundColor3 = C.dark, BackgroundTransparency = 0.12, Text = "", AutoButtonColor = false, Visible = false, ZIndex = 10}, gui)
	corner(launcher, 11)
	local launcherStroke = stroke(launcher, C.white, 1.5, 0.1)
	make("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.purple), ColorSequenceKeypoint.new(1, C.pink)}), Rotation = 35}, launcher)
	local dot = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 12}, launcher)
	corner(dot, 4)

	local meteorLayer = make("Frame", {Name = "MeteorShower", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ClipsDescendants = true, ZIndex = 2}, gui)
	local meteorActive, meteorCount = false, 0
	local function spawnMeteor()
		if not meteorActive or not meteorLayer.Visible or meteorCount >= 42 then return end
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		local startX = math.random(-80, math.max(100, math.floor(vp.X)))
		local startY = math.random(-100, math.max(20, math.floor(vp.Y * 0.65)))
		local angle = math.random(35, 145)
		local length = math.random(95, 190)
		local travel = math.random(280, 620)
		local rad = math.rad(angle)
		local meteor = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(startX, startY), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.meteor, BackgroundTransparency = math.random(5, 22) / 100, BorderSizePixel = 0, Rotation = angle, ZIndex = 3}, meteorLayer)
		corner(meteor, 100)
		local glow = make("UIStroke", {Color = C.pinkLight, Thickness = 1, Transparency = 0.45}, meteor)
		make("Frame", {Name = "Trail", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(0, -2, 0.5, 0), Size = UDim2.fromOffset(length, 2), BackgroundColor3 = C.trail, BackgroundTransparency = 0.18, BorderSizePixel = 0, ZIndex = 2}, meteor)
		local duration = math.random(18, 34) / 10
		meteorCount += 1
		tween(meteor, duration, {Position = UDim2.fromOffset(startX + math.cos(rad) * travel, startY + math.sin(rad) * travel), BackgroundTransparency = 1, Size = UDim2.fromOffset(3, 3)}, Enum.EasingStyle.Linear)
		tween(glow, duration * 0.75, {Transparency = 1}, Enum.EasingStyle.Linear)
		task.delay(duration + 0.1, function()
			if meteor then meteor:Destroy() end
			meteorCount = math.max(0, meteorCount - 1)
		end)
	end
	task.spawn(function()
		while gui.Parent do
			if meteorActive and meteorLayer.Visible then
				spawnMeteor()
				if math.random() < 0.42 then
					task.wait(0.045)
					spawnMeteor()
				end
				task.wait(math.random(7, 15) / 100)
			else
				task.wait(0.15)
			end
		end
	end)
	local function setMeteorShower(on)
		meteorActive = on
		meteorLayer.Visible = on
		if not on then
			for _, item in ipairs(meteorLayer:GetChildren()) do item:Destroy() end
			meteorCount = 0
		end
	end

	local PANEL_SIZE = Vector2.new(900, 580)
	local HEADER_H = 66
	local WORD_LETTERS = {{text = "D", color = C.pink}, {text = "R", color = C.softPurple}, {text = "T", color = C.white}, {text = "K", color = C.gray}}

	local panel = make("Frame", {Name = "MainPanel", Size = UDim2.fromOffset(100, HEADER_H), BackgroundColor3 = C.panel, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Visible = false, ZIndex = 20}, gui)
	corner(panel, 18)
	local panelStroke = stroke(panel, C.white, 1.5, 1)
	make("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 106, 112)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 86))}), Rotation = 35}, panel)
	local header = make("Frame", {Size = UDim2.new(1, 0, 0, HEADER_H), BackgroundTransparency = 1, ZIndex = 21}, panel)
	local close = make("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -22, 0.5, 0), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = C.white, BackgroundTransparency = 0.9, Text = "×", TextColor3 = C.white, TextSize = 25, TextTransparency = 1, Font = Enum.Font.GothamMedium, AutoButtonColor = false, Visible = false, ZIndex = 22}, header)
	corner(close, 10)
	local separator = make("Frame", {Position = UDim2.new(0, 22, 0, HEADER_H), Size = UDim2.new(1, -44, 0, 1), BackgroundColor3 = C.white, BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 22}, panel)
	contentFrame = make("Frame", {Name = "Content", Position = UDim2.fromOffset(22, HEADER_H + 20), Size = UDim2.new(1, -44, 1, -(HEADER_H + 42)), BackgroundTransparency = 1, Visible = false, ZIndex = 21}, panel)

	local wordGroups = {}
	local function measure(text)
		return TextService:GetTextSize(text, 36, Enum.Font.GothamBlack, Vector2.new(1000, 1000)).X
	end
	local function buildLayout()
		local layout, x = {}, 26
		for _, d in ipairs(WORD_LETTERS) do
			local w = measure(d.text) + 4
			table.insert(layout, {text = d.text, color = d.color, localX = x, width = w})
			x += w + 2
		end
		return layout, x + 22
	end
	local function letterGroup(d)
		local g = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(d.width + 6, 56), BackgroundTransparency = 1, Rotation = -8, ZIndex = 40}, gui)
		for i = 3, 1, -1 do
			make("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, i, 0.5, i), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = d.text, Font = Enum.Font.GothamBlack, TextSize = 36, TextColor3 = C.purpleDeep, TextTransparency = 0.1 + (3 - i) * 0.12, ZIndex = 40}, g)
		end
		make("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = d.text, Font = Enum.Font.GothamBlack, TextSize = 36, TextColor3 = d.color, ZIndex = 40}, g)
		return g
	end
	local function clearWord()
		for _, g in ipairs(wordGroups) do g:Destroy() end
		table.clear(wordGroups)
	end
	local function flyLetter(group, from, to, delay, duration, bend, onLanded)
		task.delay(delay, function()
			local mid = (from + to) / 2
			local dir = to - from
			local control = mid + Vector2.new(-dir.Y, dir.X).Unit * (bend * 70)
			local t0 = os.clock()
			local conn
			conn = RunService.RenderStepped:Connect(function()
				local a = math.clamp((os.clock() - t0) / duration, 0, 1)
				local e = 1 - (1 - a) ^ 3
				local wave = math.sin(a * math.pi * 2) * 12 * (1 - a)
				local p = (1 - e) ^ 2 * from + 2 * (1 - e) * e * control + e ^ 2 * to
				group.Position = UDim2.fromOffset(p.X, p.Y + wave)
				if a >= 1 then
					conn:Disconnect()
					onLanded()
				end
			end)
		end)
	end
	local function panelTopLeft()
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		return Vector2.new(math.floor(vp.X * 0.53 - PANEL_SIZE.X / 2), math.floor(vp.Y * 0.5 - PANEL_SIZE.Y / 2))
	end
	placePreview = function()
		local tl = panelTopLeft()
		previewFrame.Position = UDim2.fromOffset(math.max(10, tl.X - 360), tl.Y)
	end
	S.showPreviewIfVisuals = function()
		if previewFrame then previewFrame.Visible = (S.tab == "visuals" and S.menuOpen) end
	end

	local function expandPanel()
		tween(panel, 0.18, {BackgroundTransparency = 0.08}, Enum.EasingStyle.Quad)
		tween(panelStroke, 0.18, {Transparency = 0.12})
		task.wait(0.12)
		tween(panel, 0.5, {Size = UDim2.fromOffset(PANEL_SIZE.X, PANEL_SIZE.Y)}, Enum.EasingStyle.Quint)
		task.wait(0.28)
		close.Visible = true
		separator.Visible = true
		tween(close, 0.25, {TextTransparency = 0})
		tween(separator, 0.25, {BackgroundTransparency = 0.78})
		contentFrame.Visible = true
		setMeteorShower(true)
		placePreview()
		S.showPreviewIfVisuals()
		S.menuBusy = false
		S.menuOpen = true
	end
	local function openPanel()
		if S.menuBusy or S.menuOpen then return end
		S.menuBusy = true
		local origin = launcher.AbsolutePosition + launcher.AbsoluteSize / 2
		local tl = panelTopLeft()
		local layout, badgeW = buildLayout()
		launcher.Visible = false
		contentFrame.Visible = false
		panel.Position = UDim2.fromOffset(tl.X, tl.Y)
		panel.Size = UDim2.fromOffset(badgeW, HEADER_H)
		panel.BackgroundTransparency = 1
		panelStroke.Transparency = 1
		panel.Visible = true
		local landed = 0
		for i, d in ipairs(layout) do
			local g = letterGroup(d)
			g.Position = UDim2.fromOffset(origin.X, origin.Y)
			table.insert(wordGroups, g)
			local target = Vector2.new(tl.X + d.localX + d.width / 2, tl.Y + HEADER_H / 2)
			flyLetter(g, origin, target, (i - 1) * 0.2, 0.42, (i % 2 == 0) and 1 or -1, function()
				g.Parent = panel
				g.Position = UDim2.fromOffset(d.localX + d.width / 2, HEADER_H / 2)
				landed += 1
				if landed == #layout then task.spawn(expandPanel) end
			end)
		end
	end
	local function closePanel()
		if S.menuBusy or not S.menuOpen then return end
		S.menuBusy = true
		S.menuOpen = false
		setMeteorShower(false)
		if previewFrame then previewFrame.Visible = false end
		contentFrame.Visible = false
		close.Visible = false
		separator.Visible = false
		close.TextTransparency = 1
		separator.BackgroundTransparency = 1
		local target = launcher.AbsolutePosition
		tween(panel, 0.3, {Size = UDim2.fromOffset(42, 42), Position = UDim2.fromOffset(target.X, target.Y), BackgroundTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		tween(panelStroke, 0.2, {Transparency = 1})
		task.spawn(function()
			task.wait(0.32)
			panel.Visible = false
			clearWord()
			launcher.Visible = true
			launcher.Size = UDim2.fromOffset(4, 4)
			launcher.BackgroundTransparency = 1
			launcherStroke.Transparency = 1
			tween(launcher, 0.3, {Size = UDim2.fromOffset(42, 42), BackgroundTransparency = 0.12}, Enum.EasingStyle.Back)
			tween(launcherStroke, 0.25, {Transparency = 0.1})
			S.menuBusy = false
		end)
	end

	local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
	launcher.InputBegan:Connect(function(input)
		if isClick(input) then
			dragging = true
			dragStart = input.Position
			startPos = launcher.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	launcher.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			launcher.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	launcher.Activated:Connect(function()
		if S.menuOpen then closePanel() else openPanel() end
	end)
	close.Activated:Connect(closePanel)

	task.spawn(function()
		task.wait(0.2)
		for _, item in ipairs(letters) do
			local target = UDim2.fromOffset(item.x + 55, 74)
			tween(item.front, 0.56, {Position = target, TextTransparency = 0, Rotation = item.rot}, Enum.EasingStyle.Back)
			tween(item.depth, 0.56, {Position = target + UDim2.fromOffset(5, 6), TextTransparency = 0.72}, Enum.EasingStyle.Quint)
			task.wait(0.4)
		end
		task.wait(0.08)
		tween(hook, 0.52, {TextTransparency = 0})
		task.wait(0.85)
		for _, item in ipairs(letters) do
			tween(item.front, 0.28, {TextTransparency = 1})
			tween(item.depth, 0.28, {TextTransparency = 1})
		end
		tween(hook, 0.22, {TextTransparency = 1})
		tween(intro, 0.42, {BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
		task.wait(0.44)
		intro:Destroy()
		launcher.Visible = true
		launcher.Size = UDim2.fromOffset(4, 4)
		launcher.BackgroundTransparency = 1
		launcherStroke.Transparency = 1
		dot.BackgroundTransparency = 1
		tween(launcher, 0.42, {Size = UDim2.fromOffset(42, 42), BackgroundTransparency = 0.12}, Enum.EasingStyle.Back)
		tween(launcherStroke, 0.35, {Transparency = 0.1})
		tween(dot, 0.35, {BackgroundTransparency = 0})
	end)
end

-- UI WIDGETS ------------------------------------------------------------------
local function nextOrder(parent)
	local n = 0
	for _, c in ipairs(parent:GetChildren()) do
		if c:IsA("GuiObject") then n += 1 end
	end
	return n + 1
end

local function fmtVal(v, step)
	if step < 0.1 then return string.format("%.2f", v) end
	if step < 1 then return string.format("%.2f", v) end
	return string.format("%d", v)
end

local function makePill(parent, default, onChange)
	local state = default
	local pill = make("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(46, 24), BackgroundColor3 = C.dark, BorderSizePixel = 0, ZIndex = 25}, parent)
	corner(pill, 12)
	local knob = make("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(18, 18), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 26}, pill)
	corner(knob, 9)
	local hit = make("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 27}, pill)
	local function render()
		tween(pill, 0.2, {BackgroundColor3 = state and RED or C.dark})
		tween(knob, 0.2, {Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)})
	end
	hit.Activated:Connect(function()
		state = not state
		render()
		if onChange then onChange(state) end
	end)
	render()
	return function(v)
		state = v
		render()
	end
end

-- card: title + pill; body (shown only while on) gets the feature's controls and its customize button
local function makeCard(parent, title, onToggle, alwaysOn)
	local card = make("Frame", {Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.white, BackgroundTransparency = 0.94, BorderSizePixel = 0, LayoutOrder = nextOrder(parent), ZIndex = 23}, parent)
	corner(card, 12)
	stroke(card, C.pinkLight, 1, 0.5)
	make("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)}, card)
	make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, card)
	local head = make("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 24}, card)
	local titleLbl = make("TextLabel", {Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamBlack, TextScaled = true, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 24}, head)
	make("UITextSizeConstraint", {MaxTextSize = 18, MinTextSize = 12}, titleLbl)
	local body = make("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = alwaysOn or false, LayoutOrder = 2, ZIndex = 24}, card)
	make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, body)
	if not alwaysOn then
		makePill(head, false, function(on)
			body.Visible = on
			if onToggle then onToggle(on) end
		end)
	end
	return body
end

local function makeSlider(parent, text, minV, maxV, step, default, onChange)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, LayoutOrder = nextOrder(parent), ZIndex = 24}, parent)
	make("TextLabel", {Size = UDim2.new(1, -70, 0, 20), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 24}, row)
	local valLabel = make("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(60, 20), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.pinkLight, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 24}, row)
	local track = make("Frame", {Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.dark, BorderSizePixel = 0, ZIndex = 24}, row)
	corner(track, 3)
	local fill = make("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = RED, BorderSizePixel = 0, ZIndex = 25}, track)
	corner(fill, 3)
	local knob = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 26}, track)
	corner(knob, 8)
	local hit = make("TextButton", {Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 27}, row)
	local function apply(v, fire)
		v = math.clamp(math.floor(v / step + 0.5) * step, minV, maxV)
		local a = (v - minV) / (maxV - minV)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, 0, 0.5, 0)
		valLabel.Text = fmtVal(v, step)
		if fire and onChange then onChange(v) end
	end
	apply(default, false)
	local dragging = false
	local function setFromX(x)
		local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		apply(minV + (maxV - minV) * a, true)
	end
	hit.InputBegan:Connect(function(input)
		if isClick(input) then
			dragging = true
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if isClick(input) then dragging = false end
	end)
end

local function makeChoice(parent, options, default, onChange)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nextOrder(parent), ZIndex = 24}, parent)
	make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, row)
	local btns = {}
	local function render(v)
		for k, b in pairs(btns) do
			tween(b, 0.2, {BackgroundColor3 = (k == v) and RED or C.dark, TextColor3 = (k == v) and C.white or C.gray})
		end
	end
	for i, opt in ipairs(options) do
		local b = make("TextButton", {Size = UDim2.new(1 / #options, -6, 1, 0), BackgroundColor3 = C.dark, Text = opt.label, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.gray, AutoButtonColor = false, LayoutOrder = i, ZIndex = 25}, row)
		corner(b, 8)
		btns[opt.value] = b
		b.Activated:Connect(function()
			render(opt.value)
			onChange(opt.value)
		end)
	end
	render(default)
end

local function makeRowToggle(parent, text, default, onChange)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nextOrder(parent), ZIndex = 24}, parent)
	make("TextLabel", {Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 24}, row)
	makePill(row, default, onChange)
end

local function makeButton(parent, text, cb)
	local b = make("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.dark, Text = text, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.pinkLight, AutoButtonColor = false, LayoutOrder = nextOrder(parent), ZIndex = 25}, parent)
	corner(b, 8)
	b.Activated:Connect(function() cb() end)
	return b
end

-- colour palette: one shared popup
local pal = make("Frame", {Name = "Palette", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(236, 268), BackgroundColor3 = C.dark, BorderSizePixel = 0, Visible = false, ZIndex = 60}, gui)
corner(pal, 14)
stroke(pal, C.pinkLight, 1, 0.3)
make("TextLabel", {Position = UDim2.fromOffset(12, 6), Size = UDim2.new(1, -50, 0, 26), BackgroundTransparency = 1, Text = "color", Font = Enum.Font.GothamBlack, TextSize = 15, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 61}, pal)
local palClose = make("TextButton", {Position = UDim2.new(1, -34, 0, 6), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = C.white, BackgroundTransparency = 0.9, Text = "×", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = C.white, AutoButtonColor = false, ZIndex = 61}, pal)
corner(palClose, 6)
local svF = make("Frame", {Position = UDim2.fromOffset(12, 36), Size = UDim2.fromOffset(212, 150), BackgroundColor3 = Color3.new(1, 0, 0), BorderSizePixel = 0, ZIndex = 61}, pal)
corner(svF, 8)
local svWhite = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 62}, svF)
corner(svWhite, 8)
make("UIGradient", {Transparency = NumberSequence.new(0, 1)}, svWhite)
local svBlack = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 63}, svF)
corner(svBlack, 8)
make("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}, svBlack)
local hueF = make("Frame", {Position = UDim2.fromOffset(12, 196), Size = UDim2.fromOffset(212, 14), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 61}, pal)
corner(hueF, 7)
local hueKps = {}
for i = 0, 6 do table.insert(hueKps, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1))) end
make("UIGradient", {Color = ColorSequence.new(hueKps)}, hueF)
local svKnob = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 65}, svF)
corner(svKnob, 6)
stroke(svKnob, Color3.new(0, 0, 0), 1.5, 0)
local hueKnob = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 20), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 65}, hueF)
corner(hueKnob, 3)
local swatch = make("Frame", {Position = UDim2.fromOffset(12, 222), Size = UDim2.fromOffset(212, 30), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 61}, pal)
corner(swatch, 8)
local svHit = make("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 66}, svF)
local hueHit = make("TextButton", {Position = UDim2.fromOffset(0, -6), Size = UDim2.new(1, 0, 1, 12), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 66}, hueF)

local palH, palS, palV = 0, 1, 1
local palCb = nil
local palDrag = nil

local function palPaint()
	local col = Color3.fromHSV(palH, palS, palV)
	svF.BackgroundColor3 = Color3.fromHSV(palH, 1, 1)
	svKnob.Position = UDim2.new(palS, 0, 1 - palV, 0)
	hueKnob.Position = UDim2.new(palH, 0, 0.5, 0)
	swatch.BackgroundColor3 = col
	return col
end
local function palChanged()
	local col = palPaint()
	if palCb then palCb(col) end
end
local function palSetSV(x, y)
	palS = math.clamp((x - svF.AbsolutePosition.X) / svF.AbsoluteSize.X, 0, 1)
	palV = 1 - math.clamp((y - svF.AbsolutePosition.Y) / svF.AbsoluteSize.Y, 0, 1)
	palChanged()
end
local function palSetHue(x)
	palH = math.clamp((x - hueF.AbsolutePosition.X) / hueF.AbsoluteSize.X, 0, 1)
	palChanged()
end
svHit.InputBegan:Connect(function(input)
	if isClick(input) then
		palDrag = "sv"
		palSetSV(input.Position.X, input.Position.Y)
	end
end)
hueHit.InputBegan:Connect(function(input)
	if isClick(input) then
		palDrag = "hue"
		palSetHue(input.Position.X)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if not palDrag then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	if palDrag == "sv" then palSetSV(input.Position.X, input.Position.Y) else palSetHue(input.Position.X) end
end)
UserInputService.InputEnded:Connect(function(input)
	if isClick(input) then palDrag = nil end
end)
palClose.Activated:Connect(function()
	pal.Visible = false
	palDrag = nil
end)

local function openPalette(initial, cb)
	palH, palS, palV = initial:ToHSV()
	palCb = cb
	palPaint()
	pal.Visible = true
end

local function makeColorBtn(parent, text, initial, onChange)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nextOrder(parent), ZIndex = 24}, parent)
	make("TextLabel", {Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 24}, row)
	local sw = make("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(46, 24), BackgroundColor3 = initial, Text = "", AutoButtonColor = false, ZIndex = 25}, row)
	corner(sw, 8)
	stroke(sw, C.white, 1, 0.3)
	local cur = initial
	sw.Activated:Connect(function()
		openPalette(cur, function(c)
			cur = c
			sw.BackgroundColor3 = c
			onChange(c)
		end)
	end)
end

local function makeColumn(page, side)
	local sc = make("ScrollingFrame", {Position = (side == "left") and UDim2.fromOffset(0, 0) or UDim2.new(0.5, 12, 0, 0), Size = UDim2.new(0.5, -12, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.pink, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 23}, page)
	make("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, sc)
	return sc
end

-- HELPERS ---------------------------------------------------------------------
local function getRoot()
	local char = player.Character
	if not char then return nil, nil end
	return char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart")
end

local function partOf(obj)
	if obj:IsA("BasePart") then return obj end
	if obj:IsA("Tool") then return obj:FindFirstChild("Handle") end
	if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
	return nil
end

local function inAnyCharacter(obj)
	local a = obj
	while a and a ~= workspace do
		if Players:GetPlayerFromCharacter(a) then return true end
		a = a.Parent
	end
	return false
end

local function nameKind(name)
	local n = string.lower(name)
	for _, k in ipairs(PROJ_KEYS) do
		if string.find(n, k, 1, true) then return "proj" end
	end
	if string.find(n, "coin", 1, true) then return "coin" end
	if string.find(n, "candy", 1, true) then return "candy" end
	return nil
end

local function trackObj(obj)
	if not (obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Tool")) then return end
	local kind = nameKind(obj.Name)
	if not kind then return end
	if kind == "proj" then S.projSet[obj] = true else S.farmSet[obj] = kind end
end
for _, d in ipairs(workspace:GetDescendants()) do trackObj(d) end
workspace.DescendantAdded:Connect(trackObj)
workspace.DescendantRemoving:Connect(function(d)
	S.projSet[d] = nil
	S.farmSet[d] = nil
end)

local function toolHas(container, key)
	if not container then return false end
	for _, c in ipairs(container:GetChildren()) do
		if c:IsA("Tool") and string.find(string.lower(c.Name), key, 1, true) then return true end
	end
	return false
end

local function getRole(plr)
	local bp = plr:FindFirstChildOfClass("Backpack")
	local char = plr.Character
	if toolHas(bp, KNIFE_KEY) or toolHas(char, KNIFE_KEY) then return "murderer" end
	if toolHas(bp, GUN_KEY) or toolHas(char, GUN_KEY) then return "sheriff" end
	return "innocent"
end

local function equippedToolName(char)
	local tool = char and char:FindFirstChildOfClass("Tool")
	return tool and string.lower(tool.Name) or nil
end

local function mousePos()
	return UserInputService:GetMouseLocation()
end

local function yawOf(cf)
	local l = cf.LookVector
	return math.atan2(-l.X, -l.Z)
end

-- ANTI-SHERIFF ----------------------------------------------------------------
local function destroyAnti()
	local A = S.anti
	if A.spin then A.spin:Destroy() A.spin = nil end
	if A.gyro then A.gyro:Destroy() A.gyro = nil end
	if A.hum then A.hum.AutoRotate = true A.hum = nil end
end

local function pauseAnti()
	S.anti.pauseUntil = os.clock() + 1
	S.anti.angle = yawOf(workspace.CurrentCamera.CFrame)
end

local function murderDistance(root)
	if getRole(player) == "murderer" then return math.huge end
	local best = math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and getRole(plr) == "murderer" then
			local r = plr.Character:FindFirstChild("HumanoidRootPart")
			if r then best = math.min(best, (r.Position - root.Position).Magnitude) end
		end
	end
	return best
end

local function incomingProjectile(root)
	for obj in pairs(S.projSet) do
		if obj.Parent and not inAnyCharacter(obj) then
			local part = partOf(obj)
			if part then
				local toMe = root.Position - part.Position
				local d = toMe.Magnitude
				local v = part.AssemblyLinearVelocity
				if d > 0.1 and d < S.anti.radius and v.Magnitude > 30 and v.Unit:Dot(toMe.Unit) > 0.5 then
					return v, toMe
				end
			end
		end
	end
	return nil, nil
end

local function doDodge(root, v, toMe, speed)
	local side = v:Cross(Vector3.yAxis)
	if side.Magnitude < 0.01 then side = Vector3.xAxis end
	side = side.Unit
	if side:Dot(toMe) < 0 then side = -side end
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(4e5, 0, 4e5)
	bv.Velocity = side * speed
	bv.Parent = root
	task.delay(0.14, function()
		if bv then bv:Destroy() end
	end)
end

local function setSpin(w)
	if S.anti.spin then S.anti.spin.AngularVelocity = Vector3.new(0, w, 0) end
end

local function updateAnti(dt, hum, root)
	local A = S.anti
	if not A.on or S.fly.on then
		destroyAnti()
		return
	end
	if not A.hum then
		A.hum = hum
		hum.AutoRotate = false
	end
	if not A.spin or A.spin.Parent ~= root then
		if A.spin then A.spin:Destroy() end
		A.spin = Instance.new("BodyAngularVelocity")
		A.spin.Name = "As" .. tostring(math.random(1000, 9999))
		A.spin.MaxTorque = Vector3.new(0, 4e5, 0)
		A.spin.P = 1e4
		A.spin.AngularVelocity = Vector3.zero
		A.spin.Parent = root
	end

	if os.clock() < A.pauseUntil then
		setSpin(0)
		if not A.gyro then
			A.gyro = Instance.new("BodyGyro")
			A.gyro.MaxTorque = Vector3.new(0, 4e5, 0)
			A.gyro.P = 3e4
			A.gyro.D = 2e3
			A.gyro.Parent = root
		end
		A.gyro.CFrame = CFrame.Angles(0, A.angle, 0)
		return
	end
	if A.gyro then A.gyro:Destroy() A.gyro = nil end

	local st = hum:GetState()
	local v = root.AssemblyLinearVelocity
	local horiz = Vector3.new(v.X, 0, v.Z).Magnitude
	if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
		or st == Enum.HumanoidStateType.Physics or horiz > 30 then
		setSpin(0)
		return
	end

	local omega
	if A.mode == "rage" then
		local prox = 1 - math.clamp(murderDistance(root) / 12, 0, 1)
		omega = math.rad(360) * (5 + prox * 7)
	else
		omega = math.rad(360) * 2.5
	end
	setSpin(omega)

	local pv, toMe = incomingProjectile(root)
	if pv and os.clock() - A.lastDodge > 0.3 then
		A.lastDodge = os.clock()
		doDodge(root, pv, toMe, A.mode == "rage" and 110 or 45)
	end
end

-- FLY -------------------------------------------------------------------------
local function stopFly()
	local F = S.fly
	F.on = false
	if F.bv then F.bv:Destroy() F.bv = nil end
	if F.bg then F.bg:Destroy() F.bg = nil end
	local hum = getRoot()
	if hum then hum.PlatformStand = false end
end

local function startFly()
	local hum, root = getRoot()
	if not (hum and root) then return end
	local F = S.fly
	destroyAnti()
	if S.bhop.bv then S.bhop.bv:Destroy() S.bhop.bv = nil end
	if S.farm.bv then S.farm.bv:Destroy() S.farm.bv = nil end
	S.farm.target = nil
	F.on = true
	hum.PlatformStand = true
	F.bv = Instance.new("BodyVelocity")
	F.bv.Name = "Mv" .. tostring(math.random(1000, 9999))
	F.bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
	F.bv.Velocity = Vector3.zero
	F.bv.Parent = root
	F.bg = Instance.new("BodyGyro")
	F.bg.Name = "Gy" .. tostring(math.random(1000, 9999))
	F.bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
	F.bg.P = 1e4
	F.bg.D = 500
	F.bg.CFrame = root.CFrame
	F.bg.Parent = root
end

local function updateFly(dt, root)
	local F = S.fly
	if not (F.bv and F.bv.Parent and F.bg and F.bg.Parent) then return end
	local cam = workspace.CurrentCamera.CFrame
	local flat = Vector3.new(cam.LookVector.X, 0, cam.LookVector.Z)
	if flat.Magnitude > 0.01 then
		F.bg.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
	end
	local move = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end
	local target = (move.Magnitude > 0) and (move.Unit * F.speed) or Vector3.zero
	F.bv.Velocity = F.bv.Velocity:Lerp(target, math.clamp(dt * 10, 0, 1))
end

-- BHOP ------------------------------------------------------------------------
local function removeBhopBV()
	if S.bhop.bv then S.bhop.bv:Destroy() S.bhop.bv = nil end
end

local function updateBhop(dt, hum, root, farming, grounded)
	local B = S.bhop
	if not B.on or S.fly.on or farming then
		removeBhopBV()
		B.cur = 16
		return
	end
	local md = hum.MoveDirection
	local cap = 16 * B.speed * 1.8
	if grounded then
		removeBhopBV()
		B.cur = math.max(16, B.cur - 20 * dt)
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) and os.clock() - B.lastJump > 0.12 then
			B.lastJump = os.clock()
			hum.Jump = true
		end
	else
		if not B.bv then
			B.bv = Instance.new("BodyVelocity")
			B.bv.Velocity = Vector3.zero
			B.bv.Parent = root
		end
		if md.Magnitude > 0 then B.cur = math.min(cap, B.cur + 12 * dt) end
		local v = root.AssemblyLinearVelocity
		local cur = Vector3.new(v.X, 0, v.Z)
		local goal = (md.Magnitude > 0) and (md * B.cur) or (cur * 0.98)
		local blended = cur:Lerp(goal, 1 - math.exp(-dt * 4))
		local capV = math.sqrt(2 * workspace.Gravity * B.jumpH)
		local clampY = v.Y > capV
		B.bv.MaxForce = Vector3.new(4e5, clampY and 4e5 or 0, 4e5)
		B.bv.Velocity = Vector3.new(blended.X, clampY and capV or 0, blended.Z)
	end
end

-- FARM ------------------------------------------------------------------------
local function clearFarm()
	local F = S.farm
	F.target = nil
	F.black = {}
	if F.bv then F.bv:Destroy() F.bv = nil end
end

local function pickFarmTarget(root)
	local now = os.clock()
	local best, bestD = nil, S.farm.radius
	for obj, kind in pairs(S.farmSet) do
		if obj.Parent and (S.farm.mode == "both" or S.farm.mode == kind) and (not S.farm.black[obj] or S.farm.black[obj] < now) then
			local part = partOf(obj)
			if part then
				local d = (part.Position - root.Position).Magnitude
				if d < bestD then best, bestD = obj, d end
			end
		end
	end
	return best
end

local function updateFarm(hum, root)
	local F = S.farm
	if not F.on or S.fly.on then
		if F.bv or F.target then clearFarm() end
		return false
	end
	local now = os.clock()
	if F.target and (not S.farmSet[F.target] or not F.target.Parent) then
		F.target = nil
		if F.bv then F.bv:Destroy() F.bv = nil end
	end
	if F.target and now > F.deadline then
		F.black[F.target] = now + 8
		F.target = nil
		if F.bv then F.bv:Destroy() F.bv = nil end
	end
	if not F.target and now >= F.nextScan then
		F.nextScan = now + 0.25
		F.target = pickFarmTarget(root)
		if F.target then F.deadline = now + 4 end
	end
	local part = F.target and partOf(F.target)
	if not part then
		if F.bv then F.bv:Destroy() F.bv = nil end
		return false
	end
	local dir = part.Position - root.Position
	if dir.Magnitude < 3 then
		F.black[F.target] = now + 8
		F.target = nil
		if F.bv then F.bv:Destroy() F.bv = nil end
		return false
	end
	if not F.bv then
		F.bv = Instance.new("BodyVelocity")
		F.bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
		F.bv.Parent = root
	end
	F.bv.Velocity = hum.MoveDirection * 16 + dir.Unit * F.speed
	return true
end

-- AIMBOT + TRIGGERBOT ---------------------------------------------------------
local fovCircle = make("Frame", {Name = "Fov", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(240, 240), BackgroundTransparency = 1, Visible = false, ZIndex = 5}, gui)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, fovCircle)
stroke(fovCircle, C.pinkLight, 1.5, 0.2)

local function isVisible(head)
	local cam = workspace.CurrentCamera
	local origin = cam.CFrame.Position
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local ignore = {}
	if player.Character then table.insert(ignore, player.Character) end
	if head.Parent then table.insert(ignore, head.Parent) end
	params.FilterDescendantsInstances = ignore
	return workspace:Raycast(origin, head.Position - origin, params) == nil
end

local function findAimHead(center)
	local A = S.aim
	local cam = workspace.CurrentCamera
	local _, myRoot = getRoot()
	local origin = myRoot and myRoot.Position or cam.CFrame.Position
	local myChar = player.Character
	local effRange = A.range
	if A.mode == "killer" and not A.killerThrows then effRange = math.min(A.range, 5) end
	local best, bestDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		local char = plr.Character
		if plr ~= player and char and char ~= myChar then
			local h = char:FindFirstChildOfClass("Humanoid")
			local head = char:FindFirstChild("Head")
			if h and h.Health > 0 and head and (A.mode ~= "killer" or getRole(plr) == "murderer") then
				if (head.Position - origin).Magnitude <= effRange then
					local sp, onScreen = cam:WorldToViewportPoint(head.Position)
					if onScreen and sp.Z > 0 then
						local d2 = (Vector2.new(sp.X, sp.Y) - center).Magnitude
						if d2 <= A.fov and d2 < bestDist and (not A.visible or isVisible(head)) then
							best = head
							bestDist = d2
						end
					end
				end
			end
		end
	end
	return best
end

local mouseRemX, mouseRemY = 0, 0
local function moveCursorBy(dx, dy)
	mouseRemX += dx
	mouseRemY += dy
	local ix = mouseRemX >= 0 and math.floor(mouseRemX) or math.ceil(mouseRemX)
	local iy = mouseRemY >= 0 and math.floor(mouseRemY) or math.ceil(mouseRemY)
	mouseRemX -= ix
	mouseRemY -= iy
	if (ix ~= 0 or iy ~= 0) and typeof(mousemoverel) == "function" then
		pcall(mousemoverel, ix, iy)
	end
end

pcall(function() RunService:UnbindFromRenderStep("DrtkAim") end)
RunService:BindToRenderStep("DrtkAim", Enum.RenderPriority.Camera.Value + 1, function()
	local A = S.aim
	local cam = workspace.CurrentCamera
	local vp = cam.ViewportSize
	local center = Vector2.new(vp.X / 2, vp.Y / 2)
	fovCircle.Size = UDim2.fromOffset(A.fov * 2, A.fov * 2)
	fovCircle.Position = UDim2.fromOffset(center.X, center.Y)
	fovCircle.Visible = A.on
	if not A.on or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
	local head = findAimHead(center)
	if not head then return end
	local cursorFree = typeof(mousemoverel) == "function" and UserInputService.MouseBehavior == Enum.MouseBehavior.Default
	if cursorFree then
		local sp = cam:WorldToViewportPoint(head.Position)
		local delta = (Vector2.new(sp.X, sp.Y) - mousePos()) * A.smooth
		moveCursorBy(delta.X, delta.Y)
	else
		local goal = CFrame.lookAt(cam.CFrame.Position, head.Position)
		cam.CFrame = cam.CFrame:Lerp(goal, A.smooth)
	end
end)

local function clickMouse()
	if typeof(mouse1click) == "function" then
		pcall(mouse1click)
	else
		local m = mousePos()
		VIM:SendMouseButtonEvent(m.X, m.Y, 0, true, game, 0)
		VIM:SendMouseButtonEvent(m.X, m.Y, 0, false, game, 0)
	end
end

local function fireTrigger()
	S.tb.last = os.clock()
	pauseAnti()
	clickMouse()
end

local function updateTriggerbot(char, root)
	local T = S.tb
	if not T.on or S.fly.on then return end
	local tool = equippedToolName(char)
	if not tool then return end
	if os.clock() - T.last < 0.25 then return end
	if string.find(tool, KNIFE_KEY, 1, true) then
		local rangeStuds = T.knifeM / 0.28
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				local h = plr.Character:FindFirstChildOfClass("Humanoid")
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if h and h.Health > 0 and hrp and (hrp.Position - root.Position).Magnitude <= rangeStuds then
					fireTrigger()
					return
				end
			end
		end
	elseif string.find(tool, GUN_KEY, 1, true) then
		local m = mousePos()
		local ray = workspace.CurrentCamera:ViewportPointToRay(m.X, m.Y)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {char}
		local res = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
		if res then
			local model = res.Instance:FindFirstAncestorOfClass("Model")
			local plr = model and Players:GetPlayerFromCharacter(model)
			if plr and plr ~= player and (T.gunMode == "all" or getRole(plr) == "murderer") then
				fireTrigger()
			end
		end
	end
end

-- VISUALS: ESP ----------------------------------------------------------------
local espLayer = make("Frame", {Name = "EspLayer", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 4}, gui)
local drawPool = {}

local function getDraw(plr)
	local d = drawPool[plr]
	if not d then
		d = {lines = {}, tracer = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.pinkLight, BorderSizePixel = 0, Visible = false, ZIndex = 4}, espLayer)}
		drawPool[plr] = d
	end
	return d
end

local function setLine(f, a, b)
	local d = b - a
	f.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
	f.Size = UDim2.fromOffset(d.Magnitude, 2)
	f.Rotation = math.deg(math.atan2(d.Y, d.X))
	f.Visible = true
end

local function lineFrame(d, i)
	local f = d.lines[i]
	if not f then
		f = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.pink, BorderSizePixel = 0, ZIndex = 4}, espLayer)
		d.lines[i] = f
	end
	return f
end

local function hideDraw(d)
	for _, l in ipairs(d.lines) do l.Visible = false end
	d.tracer.Visible = false
end

local R15_PAIRS = {
	{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}
local R6_PAIRS = {{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}}

RunService.RenderStepped:Connect(function()
	local cam = workspace.CurrentCamera
	local vp = cam.ViewportSize
	for _, plr in ipairs(Players:GetPlayers()) do
		local d = getDraw(plr)
		local char = plr.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not (char and hrp and hum and hum.Health > 0) or not (S.esp.skel or S.esp.lines) then
			hideDraw(d)
		else
			local used = 0
			if S.esp.skel then
				local pairsList = char:FindFirstChild("UpperTorso") and R15_PAIRS or R6_PAIRS
				for _, pr in ipairs(pairsList) do
					local p1 = char:FindFirstChild(pr[1])
					local p2 = char:FindFirstChild(pr[2])
					if p1 and p2 then
						local s1, o1 = cam:WorldToViewportPoint(p1.Position)
						local s2, o2 = cam:WorldToViewportPoint(p2.Position)
						if o1 and o2 and s1.Z > 0 and s2.Z > 0 then
							used += 1
							setLine(lineFrame(d, used), Vector2.new(s1.X, s1.Y), Vector2.new(s2.X, s2.Y))
						end
					end
				end
			end
			for i = used + 1, #d.lines do d.lines[i].Visible = false end
			if S.esp.lines and plr ~= player then
				local sp, on = cam:WorldToViewportPoint(hrp.Position)
				if on and sp.Z > 0 then
					setLine(d.tracer, Vector2.new(vp.X / 2, vp.Y), Vector2.new(sp.X, sp.Y))
				else
					d.tracer.Visible = false
				end
			else
				d.tracer.Visible = false
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	local d = drawPool[plr]
	if d then
		for _, l in ipairs(d.lines) do l:Destroy() end
		d.tracer:Destroy()
		drawPool[plr] = nil
	end
end)

-- ROLE HIGHLIGHTS (includes you)
local roleHi = {}
local function updateRoles()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local h = roleHi[plr]
			if not h or h.Parent ~= plr.Character then
				if h then h:Destroy() end
				h = Instance.new("Highlight")
				h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				h.FillTransparency = 0.6
				h.OutlineTransparency = 0
				h.Parent = plr.Character
				roleHi[plr] = h
			end
			local col = ESP_COLORS[getRole(plr)]
			h.FillColor = col
			h.OutlineColor = col
		elseif roleHi[plr] then
			roleHi[plr]:Destroy()
			roleHi[plr] = nil
		end
	end
end
local function clearRoles()
	for plr, h in pairs(roleHi) do
		h:Destroy()
		roleHi[plr] = nil
	end
end
Players.PlayerRemoving:Connect(function(plr)
	if roleHi[plr] then
		roleHi[plr]:Destroy()
		roleHi[plr] = nil
	end
end)

-- VISUALS: TRAILS -------------------------------------------------------------
local function trailParts(char, origin)
	local out = {}
	local function add(n)
		local p = char:FindFirstChild(n)
		if p and p:IsA("BasePart") then table.insert(out, p) end
	end
	if origin == "head" then
		add("Head")
	elseif origin == "back" then
		add("UpperTorso")
		if #out == 0 then add("Torso") end
	elseif origin == "legs" then
		add("LeftUpperLeg")
		add("RightUpperLeg")
		if #out == 0 then add("Left Leg") add("Right Leg") end
	elseif origin == "feet" then
		add("LeftFoot")
		add("RightFoot")
		if #out == 0 then add("Left Leg") add("Right Leg") end
	end
	return out
end

local trailCache = {}
local function ensureTrails(model, enabled, origin, len, color)
	local entry = trailCache[model]
	if not entry then
		entry = {sig = "", items = {}}
		trailCache[model] = entry
	end
	local sig = enabled and (origin .. ":" .. string.format("%.2f", len) .. ":" .. tostring(color)) or "off"
	if sig == entry.sig then return end
	entry.sig = sig
	for _, it in ipairs(entry.items) do it:Destroy() end
	entry.items = {}
	if not enabled then return end
	for _, part in ipairs(trailParts(model, origin)) do
		local a0 = make("Attachment", {Position = Vector3.new(0, 0.7, 0)}, part)
		local a1 = make("Attachment", {Position = Vector3.new(0, -0.7, 0)}, part)
		local t = make("Trail", {Attachment0 = a0, Attachment1 = a1, Lifetime = len, Color = ColorSequence.new(color), Transparency = NumberSequence.new(0.1, 1), FaceCamera = true, LightEmission = 0.6}, part)
		table.insert(entry.items, a0)
		table.insert(entry.items, a1)
		table.insert(entry.items, t)
	end
end

-- VISUALS: PUDDLE -------------------------------------------------------------
local function spawnPuddle(root)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {player.Character}
	local res = workspace:Raycast(root.Position, Vector3.new(0, -8, 0), params)
	if not res then return end
	local pos = res.Position + Vector3.new(0, 0.06, 0)
	local function ring(delay, maxD, dur)
		task.delay(delay, function()
			local d = Instance.new("Part")
			d.Shape = Enum.PartType.Cylinder
			d.Anchored = true
			d.CanCollide = false
			d.CanQuery = false
			d.CanTouch = false
			d.CastShadow = false
			d.Material = Enum.Material.Neon
			d.Color = S.puddle.color
			d.Transparency = 0.45
			d.Size = Vector3.new(0.05, 0.6, 0.6)
			d.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
			d.Parent = workspace
			tween(d, dur, {Size = Vector3.new(0.05, maxD, maxD), Transparency = 1}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			task.delay(dur + 0.05, function()
				if d.Parent then d:Destroy() end
			end)
		end)
	end
	ring(0, 4.6, 0.95)
	ring(0.16, 3.0, 0.8)
end

-- VISUALS: CHINA HAT ----------------------------------------------------------
-- geometry from the china hat script: wedge panels around a cone, apex above the head
local HAT_PANELS, HAT_BRIM, HAT_SHELL, HAT_CONE = 32, 1.9, 0.06, 1.15
local hatRecs = {}
local hiddenAcc = {}

local function hatDescriptors()
	local desc = {}
	local N, R, H, T = HAT_PANELS, HAT_BRIM, HAT_CONE, HAT_SHELL
	local step = math.pi / N
	local c = R * math.sin(step)
	local apo = R * math.cos(step)
	local apex = Vector3.new(0, H, 0)
	for k = 0, N - 1 do
		local th = (2 * math.pi * k) / N
		local u = Vector3.new(math.sin(th), 0, math.cos(th))
		local t = Vector3.new(math.cos(th), 0, -math.sin(th))
		local M = u * apo
		local s = (M - apex).Unit
		local L = (M - apex).Magnitude
		local nA = t:Cross(s)
		table.insert(desc, {basePos = apex + s * (L * 0.5) + t * (c * 0.5), baseRot = CFrame.fromMatrix(Vector3.new(), nA, t, s), baseSize = Vector3.new(T, c, L), tint = 1})
		table.insert(desc, {basePos = apex + s * (L * 0.5) - t * (c * 0.5), baseRot = CFrame.fromMatrix(Vector3.new(), -nA, -t, s), baseSize = Vector3.new(T, c, L), tint = 1})
	end
	return desc
end

local function hatApply(rec)
	local H = S.hat
	local root = CFrame.new(0, H.height, 0) * CFrame.Angles(math.rad(H.tilt), 0, 0)
	local c = H.color
	for _, s in ipairs(rec.segs) do
		s.weld.C0 = root * CFrame.new(s.basePos * H.scale) * s.baseRot
		s.part.Size = s.baseSize * H.scale
		s.part.Color = Color3.new(math.clamp(c.R * s.tint, 0, 1), math.clamp(c.G * s.tint, 0, 1), math.clamp(c.B * s.tint, 0, 1))
		s.part.Transparency = H.transparency
	end
end

local function hatBuild(owner, head)
	local model = Instance.new("Model")
	model.Name = "ChinaHatOverlay"
	local rec = {owner = owner, head = head, model = model, segs = {}}
	for _, d in ipairs(hatDescriptors()) do
		local p = Instance.new("Part")
		p.Name = "HatSeg"
		p.Shape = Enum.PartType.Wedge
		p.Size = d.baseSize
		p.Anchored = false
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
		p.CastShadow = false
		p.Massless = true
		p.Material = Enum.Material.SmoothPlastic
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Parent = model
		local w = Instance.new("Weld")
		w.Part0 = head
		w.Part1 = p
		w.C1 = CFrame.new()
		w.Parent = p
		table.insert(rec.segs, {part = p, weld = w, basePos = d.basePos, baseRot = d.baseRot, baseSize = d.baseSize, tint = d.tint})
	end
	model.Parent = head
	hatApply(rec)
	return rec
end

local function hatFor(owner)
	for _, r in ipairs(hatRecs) do
		if r.owner == owner then return r end
	end
	return nil
end

local function hatRefresh()
	for _, r in ipairs(hatRecs) do hatApply(r) end
end

local function isHeadAccessory(acc)
	if not acc:IsA("Accessory") then return false end
	local handle = acc:FindFirstChild("Handle")
	if not handle then return false end
	local att = handle:FindFirstChild("HatAttachment") or handle:FindFirstChild("HairAttachment")
		or handle:FindFirstChild("FaceFrontAttachment") or handle:FindFirstChild("FaceCenterAttachment")
		or handle:FindFirstChild("NeckAttachment")
	if att then return true end
	local n = string.lower(acc.Name)
	for _, k in ipairs({"hat", "hair", "hood", "helmet", "cap", "crown", "beanie", "headband"}) do
		if string.find(n, k, 1, true) then return true end
	end
	return false
end

local function hideLocalAccessories(char)
	if #hiddenAcc > 0 then return end
	for _, obj in ipairs(char:GetChildren()) do
		if isHeadAccessory(obj) then
			table.insert(hiddenAcc, obj)
			obj.Parent = nil
		end
	end
end

local function restoreAccessories()
	local char = player.Character
	for _, obj in ipairs(hiddenAcc) do
		if obj and obj.Parent == nil and char then obj.Parent = char end
	end
	hiddenAcc = {}
end

local function hatDestroyAll()
	for _, r in ipairs(hatRecs) do
		if r.model then r.model:Destroy() end
	end
	hatRecs = {}
	restoreAccessories()
end

local function hatSync()
	for i = #hatRecs, 1, -1 do
		local r = hatRecs[i]
		local dead = not r.head.Parent or not r.owner.Parent
		local unwanted = not S.hat.on or (S.hat.who == "me" and r.owner ~= player.Character)
		if dead or unwanted then
			if r.model then r.model:Destroy() end
			table.remove(hatRecs, i)
		end
	end
	if not S.hat.on then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if S.hat.who == "all" or plr == player then
			local char = plr.Character
			local head = char and char:FindFirstChild("Head")
			if head and not hatFor(char) then
				if char == player.Character then hideLocalAccessories(char) end
				table.insert(hatRecs, hatBuild(char, head))
			end
		end
	end
end

-- VISUALS: ATMOSPHERE ---------------------------------------------------------
-- tint filter from the sky menu: ColorCorrectionEffect, colour from the palette
local atmoFx = nil
local function atmoApply()
	if not S.atmo.on then
		if atmoFx then atmoFx:Destroy() atmoFx = nil end
		return
	end
	if not atmoFx or not atmoFx.Parent then
		atmoFx = Instance.new("ColorCorrectionEffect")
		atmoFx.Name = "DRTK_LocalSkyTint"
		atmoFx.Brightness = 0.03
		atmoFx.Contrast = 0.08
		atmoFx.Parent = Lighting
	end
	atmoFx.TintColor = S.atmo.color
	atmoFx.Saturation = S.atmo.sat
end

-- VISUALS: CAPE ---------------------------------------------------------------
local capeModel, capeRender, capeChar = nil, nil, nil
local capeJoints, capeParts = {}, {}
local capeSm = {p = 0, y = 0, r = 0}

local function capeClear()
	if capeRender then capeRender:Disconnect() capeRender = nil end
	if capeModel then capeModel:Destroy() capeModel = nil end
	capeJoints, capeParts = {}, {}
	capeChar = nil
	capeSm = {p = 0, y = 0, r = 0}
end

local function capeLink(parent, child)
	local w = Instance.new("Weld")
	w.Name = "CapeJoint"
	w.Part0 = parent
	w.Part1 = child
	w.C0 = CFrame.new(0, -parent.Size.Y * 0.5, 0)
	w.C1 = CFrame.new(0, child.Size.Y * 0.5, 0)
	w.Parent = child
	return w
end

local function capeMount(char)
	capeClear()
	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not torso or not hrp then return end

	local shoulderSpan = torso.Size.X + 0.25
	local shoulderY = torso.Size.Y * 0.44
	local backZ = torso.Size.Z * 0.5 + 0.03
	local hip = (hum and hum.HipHeight) or 2
	local length = math.clamp(hip * 1.55 + torso.Size.Y * 0.7, 2.8, 5.8)
	local n = 22
	local segH = length / n
	local topW = shoulderSpan
	local botW = shoulderSpan * S.cape.flare
	local thick = 0.032

	local function mkPart(name, size)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.Anchored = false
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
		p.CastShadow = false
		p.Massless = true
		p.Material = Enum.Material.SmoothPlastic
		p.Color = S.cape.color
		p.Transparency = S.cape.transparency
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		return p
	end

	local model = Instance.new("Model")
	model.Name = "DRTK_Cape"
	local bar = mkPart("ShoulderBar", Vector3.new(topW, 0.06, thick))
	bar.Parent = model
	local barWeld = Instance.new("Weld")
	barWeld.Part0 = torso
	barWeld.Part1 = bar
	barWeld.C0 = CFrame.new(0, shoulderY, backZ)
	barWeld.C1 = CFrame.new()
	barWeld.Parent = bar
	table.insert(capeParts, bar)

	local parent = bar
	for i = 1, n do
		local t0 = (i - 1) / n
		local t1 = i / n
		local w0 = topW + (botW - topW) * t0
		local w1 = topW + (botW - topW) * t1
		local part = mkPart("Cloth" .. i, Vector3.new((w0 + w1) * 0.5, segH + 0.02, thick))
		part.Parent = model
		local weld = capeLink(parent, part)
		table.insert(capeJoints, {weld = weld, weight = t1 ^ 0.9})
		table.insert(capeParts, part)
		parent = part
	end

	model.Parent = char
	capeModel = model
	capeChar = char

	capeRender = RunService.RenderStepped:Connect(function(dt)
		if not capeModel or not capeModel.Parent or not torso.Parent or not hrp.Parent then return end
		for _, p in ipairs(capeParts) do
			p.Color = S.cape.color
			p.Transparency = S.cape.transparency
		end
		local vel = hrp.AssemblyLinearVelocity
		local forward = vel:Dot(torso.CFrame.LookVector)
		local side = vel:Dot(torso.CFrame.RightVector)
		local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
		local airborne = hum and hum.FloorMaterial == Enum.Material.Air
		local targetPitch = math.clamp(forward * 0.95, -8, 18)
		if airborne then targetPitch = targetPitch + 10 end
		local wave = math.sin(os.clock() * 5.5) * (1.8 + speed * 0.07)
		local targetYaw = math.clamp(-side * 0.85, -18, 18) + wave * 0.25
		local targetRoll = math.clamp(side * 0.28, -8, 8) + math.sin(os.clock() * 3.2) * 1.2
		local k = math.clamp(dt * 5, 0, 1)
		capeSm.p = capeSm.p + (targetPitch - capeSm.p) * k
		capeSm.y = capeSm.y + (targetYaw - capeSm.y) * k
		capeSm.r = capeSm.r + (targetRoll - capeSm.r) * k
		for _, j in ipairs(capeJoints) do
			local wgt = j.weight
			local p0sz = j.weld.Part0.Size.Y
			j.weld.C0 = CFrame.new(0, -p0sz * 0.5, 0) * CFrame.Angles(
				math.rad(-capeSm.p * wgt),
				math.rad(capeSm.y * wgt),
				math.rad(capeSm.r * wgt * 0.55)
			)
		end
	end)
end

local function capeSync()
	if not S.cape.on then
		if capeModel then capeClear() end
		return
	end
	local char = player.Character
	if char and char ~= capeChar and char:FindFirstChild("HumanoidRootPart") then
		if char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") then
			capeMount(char)
		end
	end
end

-- VISUALS: SNOW ---------------------------------------------------------------
local snowFolder = make("Folder", {Name = "DRTK_LocalSnow"}, workspace)
local flakes = {}
local snowRng = Random.new()

local function snowReset(f, initial)
	local cam = workspace.CurrentCamera
	local origin = cam and cam.CFrame.Position or Vector3.zero
	f.pos = origin + Vector3.new(snowRng:NextNumber(-45, 45), snowRng:NextNumber(initial and -8 or 25, 32), snowRng:NextNumber(-45, 45))
	f.speed = snowRng:NextNumber(3.5, 8.5)
	f.drift = snowRng:NextNumber(1.2, 3.5)
	f.phase = snowRng:NextNumber(0, math.pi * 2)
	f.obj.CFrame = CFrame.new(f.pos)
end

local function snowSpawn()
	local size = snowRng:NextNumber(0.09, 0.19)
	local part = Instance.new("Part")
	part.Name = "Snowflake"
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(size, size, size)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Material = Enum.Material.Neon
	part.Color = S.snow.color
	part.Transparency = snowRng:NextNumber(0.02, 0.18)
	part.Parent = snowFolder
	local f = {obj = part, pos = Vector3.zero, speed = 5, drift = 2, phase = 0, age = 0}
	table.insert(flakes, f)
	snowReset(f, true)
end

local function snowClear()
	for _, f in ipairs(flakes) do f.obj:Destroy() end
	table.clear(flakes)
end

RunService.RenderStepped:Connect(function(dt)
	if not S.snow.on then return end
	local target = S.snow.count
	while #flakes < target do snowSpawn() end
	while #flakes > target do
		local f = table.remove(flakes)
		f.obj:Destroy()
	end
	local cam = workspace.CurrentCamera
	local origin = cam and cam.CFrame.Position or Vector3.zero
	local col = S.snow.color
	local sp = S.snow.speed
	for _, f in ipairs(flakes) do
		f.age += dt
		f.pos -= Vector3.new(-math.sin(f.age * 0.8 + f.phase) * f.drift * dt, f.speed * sp * dt, math.cos(f.age * 0.7 + f.phase) * f.drift * dt)
		if f.pos.Y < origin.Y - 10 then snowReset(f, false) end
		f.obj.CFrame = CFrame.new(f.pos)
		f.obj.Color = col
	end
end)

-- PREVIEW ---------------------------------------------------------------------
previewFrame = make("Frame", {Name = "Preview", Size = UDim2.fromOffset(340, 580), BackgroundColor3 = C.panel, BackgroundTransparency = 0.08, BorderSizePixel = 0, Visible = false, ZIndex = 20}, gui)
corner(previewFrame, 18)
stroke(previewFrame, C.white, 1.5, 0.2)
make("TextLabel", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "preview", Font = Enum.Font.GothamBlack, TextSize = 18, TextColor3 = C.white, ZIndex = 21}, previewFrame)
local vpf = make("ViewportFrame", {Position = UDim2.fromOffset(10, 44), Size = UDim2.new(1, -20, 1, -54), BackgroundColor3 = C.dark, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 21}, previewFrame)
corner(vpf, 12)
local vpCam = make("Camera", {CFrame = CFrame.lookAt(Vector3.new(4.5, 1.2, -7.2), Vector3.new(0, 0.2, 0))}, vpf)
vpf.CurrentCamera = vpCam

local pvModel, pvHi, pvHat = nil, nil, nil
local pvBeams, pvMotors = {}, {}
local pvSource = nil
local PV_R6 = {{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}}
local PV_R15 = {
	{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
	{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
	{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
	{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
}

local function destroyPreview()
	if pvModel then pvModel:Destroy() end
	pvModel, pvHi, pvHat = nil, nil, nil
	pvBeams, pvMotors = {}, {}
end

local function buildPreview()
	local src = player.Character
	if not src then return false end
	if pvSource == src and pvModel and pvModel.Parent then return true end
	destroyPreview()
	local ok, m = pcall(function()
		src.Archivable = true
		return src:Clone()
	end)
	if not ok or not m then return false end
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Accessory") or d:IsA("Tool") or d:IsA("Shirt")
			or d:IsA("Pants") or d:IsA("ShirtGraphic") or d:IsA("Decal") then
			d:Destroy()
		end
	end
	local hrp = m:FindFirstChild("HumanoidRootPart")
	if not hrp then
		m:Destroy()
		return false
	end
	m.PrimaryPart = hrp
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then
			p.CanCollide = false
			p.CastShadow = false
			p.Anchored = false
		end
	end
	hrp.Anchored = true
	m.Parent = vpf
	pvModel = m
	pvSource = src
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("Motor6D") then pvMotors[d.Name] = d end
	end
	pvHi = Instance.new("Highlight")
	pvHi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	pvHi.FillTransparency = 0.6
	pvHi.OutlineTransparency = 0
	pvHi.Enabled = false
	pvHi.Parent = m
	local list = m:FindFirstChild("UpperTorso") and PV_R15 or PV_R6
	for _, pr in ipairs(list) do
		local p1 = m:FindFirstChild(pr[1])
		local p2 = m:FindFirstChild(pr[2])
		if p1 and p2 then
			local a0 = Instance.new("Attachment")
			a0.Parent = p1
			local a1 = Instance.new("Attachment")
			a1.Parent = p2
			local b = Instance.new("Beam")
			b.Attachment0 = a0
			b.Attachment1 = a1
			b.Width0 = 0.08
			b.Width1 = 0.08
			b.FaceCamera = true
			b.Color = ColorSequence.new(C.pink)
			b.Enabled = false
			b.Parent = p1
			table.insert(pvBeams, b)
		end
	end
	return true
end

local function setMotor(r15, r6, cf)
	local mo = pvMotors[r15] or pvMotors[r6]
	if mo then mo.Transform = cf end
end

local function posePreview(t)
	local sw = math.sin(t * 6.5) * 0.55
	setMotor("LeftHip", "Left Hip", CFrame.Angles(sw, 0, 0))
	setMotor("RightHip", "Right Hip", CFrame.Angles(-sw, 0, 0))
	setMotor("LeftShoulder", "Left Shoulder", CFrame.Angles(-sw * 0.8, 0, 0))
	setMotor("RightShoulder", "Right Shoulder", CFrame.Angles(sw * 0.8, 0, 0))
	setMotor("LeftKnee", "", CFrame.Angles(math.max(0, -sw) * 0.9, 0, 0))
	setMotor("RightKnee", "", CFrame.Angles(math.max(0, sw) * 0.9, 0, 0))
	local bob = math.abs(math.sin(t * 6.5)) * 0.06
	local yaw = math.rad(-30) + math.sin(t * 1.1) * math.rad(28)
	pvModel:PivotTo(CFrame.new(0, bob, 0) * CFrame.Angles(0, yaw, 0))
end

RunService.RenderStepped:Connect(function()
	if not previewFrame.Visible then return end
	if not buildPreview() then return end
	posePreview(os.clock())
	ensureTrails(pvModel, S.trail.on, S.trail.origin, S.trail.len, S.trail.color)
	for _, b in ipairs(pvBeams) do b.Enabled = S.esp.skel end
	pvHi.Enabled = S.esp.roles
	local col = ESP_COLORS[getRole(player)]
	pvHi.FillColor = col
	pvHi.OutlineColor = col
	if S.hat.on then
		local head = pvModel:FindFirstChild("Head")
		if head and (not pvHat or pvHat.head ~= head) then
			if pvHat then pvHat.model:Destroy() end
			pvHat = hatBuild(pvModel, head)
		end
		if pvHat then hatApply(pvHat) end
	elseif pvHat then
		pvHat.model:Destroy()
		pvHat = nil
	end
end)

placePreview = placePreview or function() end

-- MAIN LOOP -------------------------------------------------------------------
task.spawn(function()
	while gui.Parent do
		hatSync()
		capeSync()
		if S.esp.roles then updateRoles() else clearRoles() end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Character and (plr ~= player or true) then
				ensureTrails(plr.Character, S.trail.on, S.trail.origin, S.trail.len, S.trail.color)
			end
		end
		for model in pairs(trailCache) do
			if not model.Parent then trailCache[model] = nil end
		end
		task.wait(0.4)
	end
end)

local lastT = os.clock()
RunService.Heartbeat:Connect(function()
	local now = os.clock()
	local dt = math.min(now - lastT, 0.1)
	lastT = now
	local char = player.Character
	local hum, root = getRoot()
	if not (char and hum and root) then return end

	local st = hum:GetState()
	if st == Enum.HumanoidStateType.Jumping then S.jumpT = now end
	local grounded = hum.FloorMaterial ~= Enum.Material.Air
	if grounded and not S.wasGround and S.puddle.on and now - S.jumpT < 3 then
		spawnPuddle(root)
	end
	S.wasGround = grounded

	if S.fly.on then
		updateFly(dt, root)
		return
	end
	local farming = updateFarm(hum, root)
	updateBhop(dt, hum, root, farming, grounded)
	updateTriggerbot(char, root)
	updateAnti(dt, hum, root)
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local char = player.Character
	if char and char:FindFirstChildOfClass("Tool") then
		pauseAnti()
	end
end)

player.CharacterAdded:Connect(function()
	S.fly.on = false
	S.fly.bv = nil
	S.fly.bg = nil
	S.bhop.bv = nil
	S.bhop.cur = 16
	S.farm.bv = nil
	S.farm.target = nil
	S.farm.black = {}
	S.anti.spin = nil
	S.anti.gyro = nil
	S.anti.hum = nil
	S.wasGround = true
	hiddenAcc = {}
	hatRecs = {}
	capeClear()
end)

-- TABS ------------------------------------------------------------------------
local tabBar = make("Frame", {Name = "TabBar", Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, ZIndex = 22}, contentFrame)
local pagesHolder = make("Frame", {Name = "Pages", Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 1, -56), BackgroundTransparency = 1, ZIndex = 22}, contentFrame)

local TAB_DEFS = {
	{key = "combat", label = "combat", color = RED},
	{key = "visuals", label = "visuals", color = C.white},
	{key = "farm", label = 'farm <font size="10" color="#FFFFFF">beta</font>', color = C.white, rich = true},
	{key = "duel", label = "duel\nbug", color = C.white},
}
local pages, tabLabels, tabBars = {}, {}, {}

local function showPage(key)
	S.tab = key
	for k, page in pairs(pages) do page.Visible = (k == key) end
	for k, label in pairs(tabLabels) do
		local on = (k == key)
		tween(label, 0.2, {TextTransparency = on and 0 or 0.55})
		tween(tabBars[k], 0.2, {BackgroundTransparency = on and 0 or 1})
	end
	S.showPreviewIfVisuals()
end

for i, def in ipairs(TAB_DEFS) do
	local width = 1 / #TAB_DEFS
	local btn = make("TextButton", {Name = def.key .. "Tab", Position = UDim2.new(width * (i - 1), 0, 0, 0), Size = UDim2.new(width, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 23}, tabBar)
	tabLabels[def.key] = make("TextLabel", {Size = UDim2.new(1, 0, 1, -6), BackgroundTransparency = 1, Text = def.label, RichText = def.rich or false, Font = Enum.Font.GothamBlack, TextSize = 17, TextColor3 = def.color, TextTransparency = 0.55, TextWrapped = true, ZIndex = 23}, btn)
	tabBars[def.key] = make("Frame", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(0.6, 0, 0, 2), BackgroundColor3 = def.color, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 23}, btn)
	pages[def.key] = make("Frame", {Name = def.key .. "Page", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 22}, pagesHolder)
	btn.Activated:Connect(function() showPage(def.key) end)
end

-- FLY PANEL -------------------------------------------------------------------
local flyPanel = make("Frame", {Name = "FlyPanel", Position = UDim2.fromOffset(40, 200), Size = UDim2.fromOffset(210, 108), BackgroundColor3 = SOFT_PURPLE, BackgroundTransparency = 0.12, BorderSizePixel = 0, Visible = false, ZIndex = 30}, gui)
corner(flyPanel, 14)
stroke(flyPanel, C.white, 1.2, 0.2)
local handle = make("Frame", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, ZIndex = 31}, flyPanel)
make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(36, 3), BackgroundColor3 = C.white, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 31}, handle)
do
	local dragging2, startInput, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if isClick(input) then
			dragging2 = true
			startInput = input.Position
			startPos = flyPanel.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging2 = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - startInput
			flyPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end
local function speedBtn(text, y)
	return make("TextButton", {Position = UDim2.fromOffset(0, y), Size = UDim2.fromOffset(110, 28), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = C.white, AutoButtonColor = false, ZIndex = 31}, flyPanel)
end
local plusBtn = speedBtn("+", 16)
local speedLabel = make("TextLabel", {Position = UDim2.fromOffset(0, 44), Size = UDim2.fromOffset(110, 26), BackgroundTransparency = 1, Text = tostring(S.fly.speed), Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = C.white, ZIndex = 31}, flyPanel)
local minusBtn = speedBtn("-", 72)
local flyBtn = make("TextButton", {Position = UDim2.fromOffset(118, 16), Size = UDim2.fromOffset(78, 84), BackgroundColor3 = C.dark, BackgroundTransparency = 0.1, Text = "fly", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = C.white, AutoButtonColor = false, ZIndex = 31}, flyPanel)
corner(flyBtn, 12)
local function setFlyVisual(on)
	tween(flyBtn, 0.2, {BackgroundColor3 = on and RED or C.dark})
end
plusBtn.Activated:Connect(function()
	S.fly.speed = math.min(S.fly.speed + 10, 300)
	speedLabel.Text = tostring(S.fly.speed)
end)
minusBtn.Activated:Connect(function()
	S.fly.speed = math.max(S.fly.speed - 10, 10)
	speedLabel.Text = tostring(S.fly.speed)
end)
flyBtn.Activated:Connect(function()
	if S.fly.on then
		stopFly()
		setFlyVisual(false)
	else
		startFly()
		setFlyVisual(S.fly.on)
	end
end)

-- COMBAT PAGE -----------------------------------------------------------------
local combatPage = pages.combat
local leftCol = makeColumn(combatPage, "left")
local rightCol = makeColumn(combatPage, "right")
make("Frame", {Name = "Divider", Position = UDim2.new(0.5, -1, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = C.white, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 23}, combatPage)

local bhopBody = makeCard(leftCol, "bunnyhop", function(on) S.bhop.on = on end)
makeSlider(bhopBody, "bhop speed", 1, 3, 0.1, S.bhop.speed, function(v) S.bhop.speed = v end)
makeSlider(bhopBody, "jump height (studs)", 2, 7.2, 0.1, S.bhop.jumpH, function(v) S.bhop.jumpH = v end)

makeCard(leftCol, "fly", function(on)
	flyPanel.Visible = on
	if not on then
		stopFly()
		setFlyVisual(false)
	end
end)

local tbBody = makeCard(leftCol, "triggerbot", function(on) S.tb.on = on end)
makeSlider(tbBody, "knife range (m)", 0.3, 2, 0.1, S.tb.knifeM, function(v) S.tb.knifeM = v end)
makeChoice(tbBody, {{value = "killer", label = "killer"}, {value = "all", label = "all"}}, S.tb.gunMode, function(v) S.tb.gunMode = v end)

local aimBody = makeCard(rightCol, "aimbot", function(on) S.aim.on = on end)
makeSlider(aimBody, "fov", 40, 400, 5, S.aim.fov, function(v) S.aim.fov = v end)
makeChoice(aimBody, {{value = "players", label = "players"}, {value = "killer", label = "killer"}}, S.aim.mode, function(v) S.aim.mode = v end)
makeRowToggle(aimBody, "visible check", S.aim.visible, function(on) S.aim.visible = on end)
makeRowToggle(aimBody, "killer throws knife", S.aim.killerThrows, function(on) S.aim.killerThrows = on end)
makeSlider(aimBody, "range (studs)", 5, 400, 5, S.aim.range, function(v) S.aim.range = v end)
makeSlider(aimBody, "smooth (1 = instant)", 0.2, 1, 0.05, S.aim.smooth, function(v) S.aim.smooth = v end)

local antiBody = makeCard(rightCol, "anti-sheriff", function(on)
	S.anti.on = on
	if not on then destroyAnti() end
end)
makeChoice(antiBody, {{value = "legit", label = "legit"}, {value = "rage", label = "rage"}}, S.anti.mode, function(v) S.anti.mode = v end)

-- VISUALS PAGE ----------------------------------------------------------------
-- feature cards open a sub-view with their customization; the customize button only shows while the feature is on
local visualsPage = pages.visuals
local mainView = make("Frame", {Name = "MainView", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 22}, visualsPage)
local vLeft = makeColumn(mainView, "left")
local vRight = makeColumn(mainView, "right")
make("Frame", {Name = "Divider", Position = UDim2.new(0.5, -1, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = C.white, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 23}, mainView)

local subs = {}
local function closeSub()
	for _, v in pairs(subs) do v.Visible = false end
	mainView.Visible = true
end
local function openSub(name)
	mainView.Visible = false
	for k, v in pairs(subs) do v.Visible = (k == name) end
end
local function makeSub(name)
	local v = make("ScrollingFrame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.pink, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 22}, visualsPage)
	make("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, v)
	makeButton(v, "‹  back", closeSub)
	subs[name] = v
	return v
end

-- ESP
local espBody = makeCard(vLeft, "esp", nil, true)
makeButton(espBody, "help esp  ›", function() openSub("esp") end)
local viewEsp = makeSub("esp")
local espOpts = makeCard(viewEsp, "esp options", nil, true)
makeRowToggle(espOpts, "roles (color by role)", S.esp.roles, function(on) S.esp.roles = on end)
makeRowToggle(espOpts, "skeleton", S.esp.skel, function(on) S.esp.skel = on end)
makeRowToggle(espOpts, "lines (tracers)", S.esp.lines, function(on) S.esp.lines = on end)

-- TRAILS
local trailBody = makeCard(vLeft, "trails", function(on) S.trail.on = on end)
makeColorBtn(trailBody, "trail color", S.trail.color, function(c) S.trail.color = c end)
makeSlider(trailBody, "length", 0.2, 3, 0.1, S.trail.len, function(v) S.trail.len = v end)
makeChoice(trailBody, {{value = "head", label = "head"}, {value = "back", label = "back"}, {value = "legs", label = "legs"}, {value = "feet", label = "feet"}}, S.trail.origin, function(v) S.trail.origin = v end)

-- PUDDLE
local puddleBody = makeCard(vLeft, "puddle (after jump)", function(on) S.puddle.on = on end)
makeColorBtn(puddleBody, "ring color", S.puddle.color, function(c) S.puddle.color = c end)

-- CHINA HAT
local hatBody = makeCard(vRight, "china hat", function(on)
	S.hat.on = on
	if not on then hatDestroyAll() end
	hatSync()
end)
makeButton(hatBody, "customize  ›", function() openSub("hat") end)
local viewHat = makeSub("hat")
local hatCard = makeCard(viewHat, "china hat settings", nil, true)
makeColorBtn(hatCard, "color", S.hat.color, function(c)
	S.hat.color = c
	hatRefresh()
end)
makeSlider(hatCard, "height", -0.5, 1.5, 0.05, S.hat.height, function(v)
	S.hat.height = v
	hatRefresh()
end)
makeSlider(hatCard, "size", 0.6, 2, 0.05, S.hat.scale, function(v)
	S.hat.scale = v
	hatRefresh()
end)
makeSlider(hatCard, "tilt", -30, 30, 1, S.hat.tilt, function(v)
	S.hat.tilt = v
	hatRefresh()
end)
makeSlider(hatCard, "transparency", 0, 0.9, 0.05, S.hat.transparency, function(v)
	S.hat.transparency = v
	hatRefresh()
end)
makeChoice(hatCard, {{value = "me", label = "me"}, {value = "all", label = "everyone"}}, S.hat.who, function(v)
	S.hat.who = v
	hatSync()
end)

-- ATMOSPHERE
local atmoBody = makeCard(vRight, "atmosphere", function(on)
	S.atmo.on = on
	atmoApply()
end)
makeButton(atmoBody, "customize  ›", function() openSub("atmo") end)
local viewAtmo = makeSub("atmo")
local atmoCard = makeCard(viewAtmo, "atmosphere settings", nil, true)
makeColorBtn(atmoCard, "tint color", S.atmo.color, function(c)
	S.atmo.color = c
	atmoApply()
end)
makeSlider(atmoCard, "saturation", -1, 0.3, 0.02, S.atmo.sat, function(v)
	S.atmo.sat = v
	atmoApply()
end)
makeChoice(atmoCard, {
	{value = "violet", label = "violet"},
	{value = "rose", label = "rose"},
	{value = "ocean", label = "ocean"},
}, "violet", function(v)
	local presets = {violet = Color3.fromRGB(177, 106, 255), rose = Color3.fromRGB(255, 115, 190), ocean = Color3.fromRGB(92, 180, 255)}
	S.atmo.color = presets[v]
	atmoApply()
end)

-- CAPE
local capeBody = makeCard(vRight, "cape", function(on)
	S.cape.on = on
	if not on then capeClear() end
end)
makeButton(capeBody, "customize  ›", function() openSub("cape") end)
local viewCape = makeSub("cape")
local capeCard = makeCard(viewCape, "cape settings", nil, true)
makeColorBtn(capeCard, "cape color", S.cape.color, function(c) S.cape.color = c end)
makeSlider(capeCard, "transparency", 0, 0.9, 0.02, S.cape.transparency, function(v) S.cape.transparency = v end)
makeSlider(capeCard, "flare (bottom width)", 1.2, 3, 0.05, S.cape.flare, function(v)
	S.cape.flare = v
	capeClear()
end)

-- SNOW
local snowBody = makeCard(vRight, "3D snow", function(on)
	S.snow.on = on
	if not on then snowClear() end
end)
makeButton(snowBody, "customize  ›", function() openSub("snow") end)
local viewSnow = makeSub("snow")
local snowCard = makeCard(viewSnow, "snow settings", nil, true)
makeSlider(snowCard, "amount", 10, 200, 5, S.snow.count, function(v) S.snow.count = v end)
makeSlider(snowCard, "speed", 0.3, 3, 0.1, S.snow.speed, function(v) S.snow.speed = v end)
makeColorBtn(snowCard, "snow tint", S.snow.color, function(c) S.snow.color = c end)

-- FARM PAGE -------------------------------------------------------------------
local farmLeft = makeColumn(pages.farm, "left")
local farmBody = makeCard(farmLeft, "coin / candy farm", function(on)
	S.farm.on = on
	if not on then clearFarm() end
end)
makeChoice(farmBody, {{value = "both", label = "both"}, {value = "coin", label = "coins"}, {value = "candy", label = "candy"}}, S.farm.mode, function(v)
	S.farm.mode = v
	clearFarm()
end)
makeSlider(farmBody, "radius (studs)", 10, 150, 5, S.farm.radius, function(v) S.farm.radius = v end)
makeSlider(farmBody, "pull speed", 15, 80, 1, S.farm.speed, function(v) S.farm.speed = v end)

-- DUEL BUG PAGE (about) -------------------------------------------------------
local aboutText = make("TextLabel", {
	Name = "About",
	Size = UDim2.new(1, -40, 1, -40),
	Position = UDim2.fromOffset(20, 20),
	BackgroundTransparency = 1,
	RichText = true,
	Text = '<font color="#FF84CF">•</font>  скрипт был сделан крипом\n<font color="#FF84CF">•</font>  наш тг @tggton',
	Font = Enum.Font.GothamBlack,
	TextScaled = true,
	TextWrapped = true,
	TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 23,
}, pages.duel)
make("UITextSizeConstraint", {MaxTextSize = 44, MinTextSize = 14}, aboutText)

showPage("combat")
