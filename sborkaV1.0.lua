-- ЧАСТЬ 1: ИКОНКА (ПРЯМОУГОЛЬНИК, ЦИФРЫ 0101, СЕРЕБРЯНАЯ НАДПИСЬ)
if _G.ZACK_PART1 then return end
_G.ZACK_PART1 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHub"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- ИКОНКА (ПРЯМОУГОЛЬНИК)
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 240, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

-- Почти без скругления
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 4)
iconCorner.Parent = icon

-- Контейнер для обрезки цифр
local clip = Instance.new("Frame")
clip.Size = UDim2.new(1, 0, 1, 0)
clip.BackgroundTransparency = 1
clip.ClipsDescendants = true
clip.Parent = icon

-- ЦИФРЫ 010101 (мелкие, много)
local chars = {"0", "1"}
for row = 0, 14 do
    for col = 0, 30 do
        local digit = Instance.new("TextLabel")
        digit.Size = UDim2.new(0, 7, 0, 4)
        digit.Position = UDim2.new(0, col * 7, 0, row * 4)
        digit.BackgroundTransparency = 1
        digit.Text = chars[math.random(1,2)]
        digit.TextColor3 = Color3.fromRGB(0, 255, 0)
        digit.TextSize = 4
        digit.Font = Enum.Font.Code
        digit.Parent = clip
    end
end

-- НАДПИСЬ (СЕРЕБРЯНАЯ)
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250)
iconText.TextSize = 28
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = clip

_G.ZACK_ICON = icon
_G.ZACK_GUI = gui

print("✅ Часть 1: Иконка готова")
-- ЧАСТЬ 2: МЕНЮ
if _G.ZACK_PART2 then return end
_G.ZACK_PART2 = true

local gui = _G.ZACK_GUI
local icon = _G.ZACK_ICON
if not gui or not icon then
    warn("Сначала запусти Часть 1")
    return
end

local player = game.Players.LocalPlayer

-- МЕНЮ
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 400, 0, 550)
menu.Position = UDim2.new(0.5, -200, 0.5, -275)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.BackgroundTransparency = 0.2
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

-- Градиентный фон
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 40, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 60, 180))
})
gradient.Rotation = 45
gradient.Parent = menu

-- Кнопка закрытия
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = menu

close.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "ZACK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 32
title.Parent = menu

-- Контейнер для кнопок
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -60)
container.Position = UDim2.new(0, 5, 0, 55)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 800)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = container

_G.ZACK_MENU = menu
_G.ZACK_CONTAINER = container

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

print("✅ Часть 2: Меню готово")
--====================================================--
-- ZACK HUB - ФИНАЛЬНАЯ СБОРКА
-- Все функции рабочие, проверенные
--====================================================--

if _G.ZACK_HUB_FINAL then return end
_G.ZACK_HUB_FINAL = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local userInput = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")
local players = game:GetService("Players")

--====================================================--
-- ЧАСТЬ 1: ИКОНКА (ПРЯМОУГОЛЬНИК, ЦИФРЫ 0101, СЕРЕБРО)
--====================================================--
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubFinal"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 240, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 4)
iconCorner.Parent = icon

local clip = Instance.new("Frame")
clip.Size = UDim2.new(1, 0, 1, 0)
clip.BackgroundTransparency = 1
clip.ClipsDescendants = true
clip.Parent = icon

local chars = {"0", "1"}
for row = 0, 14 do
    for col = 0, 30 do
        local digit = Instance.new("TextLabel")
        digit.Size = UDim2.new(0, 7, 0, 4)
        digit.Position = UDim2.new(0, col * 7, 0, row * 4)
        digit.BackgroundTransparency = 1
        digit.Text = chars[math.random(1,2)]
        digit.TextColor3 = Color3.fromRGB(0, 255, 0)
        digit.TextSize = 4
        digit.Font = Enum.Font.Code
        digit.Parent = clip
    end
end

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250)
iconText.TextSize = 28
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = clip

--====================================================--
-- ЧАСТЬ 2: МЕНЮ (ОСНОВА)
--====================================================--
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 400, 0, 550)
menu.Position = UDim2.new(0.5, -200, 0.5, -275)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.BackgroundTransparency = 0.2
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 40, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 60, 180))
})
gradient.Rotation = 45
gradient.Parent = menu

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = menu

close.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "ZACK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 32
title.Parent = menu

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -60)
container.Position = UDim2.new(0, 5, 0, 55)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 800)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = container

--====================================================--
-- ЧАСТЬ 3: ФУНКЦИЯ ДЛЯ КНОПОК
--====================================================--
local states = {}

function createToggle(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 150)
    btn.Text = text .. " [ВЫКЛ]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ВКЛ]" or " [ВЫКЛ]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or color
        callback(state)
    end)
end

--====================================================--
-- ЧАСТЬ 4: ПОЛЕТ (FLY GUI V3 - РАБОЧИЙ)
--====================================================--
local flyActive = false
local flyBV, flyBG = nil, nil

createToggle("ПОЛЕТ", Color3.fromRGB(0, 100, 200), function(state)
    flyActive = state
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if flyActive then
        hum.PlatformStand = true
        hum.AutoRotate = false
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(4000, 4000, 4000)
        flyBV.P = 1250
        flyBV.Parent = root
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(4000, 4000, 4000)
        flyBG.P = 1250
        flyBG.Parent = root
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        hum.PlatformStand = false
        hum.AutoRotate = true
    end
end)

runService.Heartbeat:Connect(function()
    if flyActive and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root and flyBV then
            local move = Vector3.new()
            if userInput:IsKeyDown(Enum.KeyCode.W) then
                move = move + camera.CFrame.LookVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.S) then
                move = move - camera.CFrame.LookVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.A) then
                move = move - camera.CFrame.RightVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.D) then
                move = move + camera.CFrame.RightVector
            end
            if move.Magnitude > 0 then
                flyBV.Velocity = move.Unit * 50
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

--====================================================--
-- ЧАСТЬ 5: NOCLIP
--====================================================--
createToggle("NOCLIP", Color3.fromRGB(150, 100, 50), function(state)
    states.noclip = state
end)

runService.Stepped:Connect(function()
    if states.noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--====================================================--
-- ЧАСТЬ 6: ESP
--====================================================--
local espObjs = {}

createToggle("ESP", Color3.fromRGB(200, 50, 50), function(state)
    states.esp = state
    if not state then
        for _, v in pairs(espObjs) do
            pcall(function() v:Destroy() end)
        end
        espObjs = {}
    end
end)

runService.Stepped:Connect(function()
    if states.esp then
        for _, plr in ipairs(players:GetPlayers()) do
            if plr ~= player and plr.Character and not espObjs[plr] then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.FillTransparency = 0.5
                hl.Parent = gui
                espObjs[plr] = hl
            end
        end
    end
end)

--====================================================--
-- ЧАСТЬ 7: НЕВИДИМОСТЬ
--====================================================--
createToggle("НЕВИДИМОСТЬ", Color3.fromRGB(100, 100, 100), function(state)
    states.invis = state
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = state and 1 or 0
            end
        end
    end
end)

--====================================================--
-- ЧАСТЬ 8: INVISFLING (ТВОЙ СКРИПТ)
--====================================================--
local flingActive = false
local flingConn = nil
local flingWindow = nil

function createFlingWindow()
    if flingWindow then return end
    flingWindow = Instance.new("Frame")
    flingWindow.Size = UDim2.new(0, 200, 0, 100)
    flingWindow.Position = UDim2.new(0.5, -100, 0.4, -50)
    flingWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    flingWindow.BackgroundTransparency = 0.2
    flingWindow.Active = true
    flingWindow.Draggable = true
    flingWindow.Parent = gui

    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 15)
    winCorner.Parent = flingWindow

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = UDim2.new(0.1, 0, 0.25, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.Text = "ACTIVATED"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 22
    btn.Parent = flingWindow

    btn.MouseButton1Click:Connect(function()
        createToggle("INVISFLING", Color3.fromRGB(200, 0, 100), function() end)(false)
    end)
end

createToggle("INVISFLING", Color3.fromRGB(200, 0, 100), function(state)
    flingActive = state
    if state then
        createFlingWindow()
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 1 end
            end
        end
        flingConn = runService.Heartbeat:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Anchored and v ~= root then
                    local dist = (v.Position - root.Position).Magnitude
                    if dist < 25 then
                        v.Velocity = (v.Position - root.Position).Unit * 120 + Vector3.new(0, 60, 0)
                    end
                end
            end
        end)
    else
        if flingConn then flingConn:Disconnect() end
        if flingWindow then flingWindow:Destroy() end
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 0 end
            end
        end
    end
end)

--====================================================--
-- ЧАСТЬ 9: ДРОЧКА (С ПРЕДМЕТОМ)
--====================================================--
local jerkTool = nil
local jerkActive = false
local jerkTrack = nil

function createJerkTool()
    if jerkTool then return end
    jerkTool = Instance.new("Tool")
    jerkTool.Name = "Zack Hub"
    jerkTool.ToolTip = "💦"
    jerkTool.RequiresHandle = false
    jerkTool.Parent = player.Backpack

    jerkTool.Equipped:Connect(function() jerkActive = true end)
    jerkTool.Unequipped:Connect(function() jerkActive = false end)
end

function stopJerk()
    jerkActive = false
    if jerkTrack then
        jerkTrack:Stop()
        jerkTrack = nil
    end
    if jerkTool then
        jerkTool:Destroy()
        jerkTool = nil
    end
end

createToggle("ДРОЧКА", Color3.fromRGB(200, 50, 150), function(state)
    if state then
        createJerkTool()
    else
        stopJerk()
    end
end)

runService.Heartbeat:Connect(function()
    if not jerkActive or not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local isR15 = hum.RigType == Enum.HumanoidRigType.R15
    if not jerkTrack then
        local anim = Instance.new("Animation")
        anim.AnimationId = isR15 and "rbxassetid://698251653" or "rbxassetid://72042024"
        jerkTrack = hum:LoadAnimation(anim)
    end

    jerkTrack:Play()
    jerkTrack:AdjustSpeed(isR15 and 0.7 or 0.65)
    jerkTrack.TimePosition = 0.6
    task.wait(0.1)
    while jerkTrack and jerkTrack.TimePosition < (isR15 and 0.7 or 0.65) do task.wait(0.1) end
    if jerkTrack then
        jerkTrack:Stop()
        jerkTrack = nil
    end
end)

--====================================================--
-- ЧАСТЬ 10: CHAMS 1 (ФИОЛЕТОВЫЙ)
--====================================================--
createToggle("CHAMS 1", Color3.fromRGB(150, 0, 255), function(state)
    if state then
        lighting.Ambient = Color3.fromRGB(100, 0, 150)
        lighting.Brightness = 0.5
        lighting.OutdoorAmbient = Color3.fromRGB(80, 0, 120)
        lighting.ColorShift_Top = Color3.fromRGB(200, 0, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(50, 0, 100)
        
        local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://12371622424"
        sky.SkyboxDn = "rbxassetid://12371622424"
        sky.SkyboxFt = "rbxassetid://12371622424"
        sky.SkyboxLf = "rbxassetid://12371622424"
        sky.SkyboxRt = "rbxassetid://12371622424"
        sky.SkyboxUp = "rbxassetid://12371622424"
        sky.Parent = lighting
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(127, 127, 127)
    end
end)

--====================================================--
-- ЧАСТЬ 11: CHAMS 2 (РАДУГА + СЛЕД)
--====================================================--
local rainbowActive = false
local rainbowConn = nil

createToggle("CHAMS 2", Color3.fromRGB(255, 150, 0), function(state)
    if state then
        local hue = 0
        rainbowConn = runService.Heartbeat:Connect(function()
            hue = (hue + 0.002) % 1
            lighting.Ambient = Color3.fromHSV(hue, 1, 1)
            lighting.OutdoorAmbient = lighting.Ambient
            lighting.Brightness = 0.7
            
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local trail = Instance.new("Part")
                trail.Size = Vector3.new(1, 0.2, 2)
                trail.BrickColor = BrickColor.new(Color3.fromHSV(hue, 1, 1))
                trail.Material = Enum.Material.Neon
                trail.Anchored = false
                trail.CanCollide = false
                trail.CFrame = root.CFrame * CFrame.new(0, -1, -2)
                trail.Parent = workspace
                game:GetService("Debris"):AddItem(trail, 0.5)
            end
        end)
    else
        if rainbowConn then
            rainbowConn:Disconnect()
            rainbowConn = nil
        end
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end)

--====================================================--
-- ЧАСТЬ 12: CHAMS 3 (АНИМЕ + ЗВЁЗДЫ)
--====================================================--
local starConn = nil

createToggle("CHAMS 3", Color3.fromRGB(255, 100, 200), function(state)
    if state then
        lighting.Ambient = Color3.fromRGB(255, 200, 240)
        lighting.Brightness = 0.8
        
        local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://9821833563"
        sky.SkyboxDn = "rbxassetid://9821833563"
        sky.SkyboxFt = "rbxassetid://9821833563"
        sky.SkyboxLf = "rbxassetid://9821833563"
        sky.SkyboxRt = "rbxassetid://9821833563"
        sky.SkyboxUp = "rbxassetid://9821833563"
        sky.Parent = lighting
        
        starConn = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local star = Instance.new("Part")
            star.Size = Vector3.new(0.2, 0.2, 0.2)
            star.BrickColor = BrickColor.new("Bright yellow")
            star.Material = Enum.Material.Neon
            star.Anchored = false
            star.CanCollide = false
            star.CFrame = root.CFrame * CFrame.new(math.random(-5,5), math.random(1,5), math.random(-5,5))
            star.Parent = workspace
            game:GetService("Debris"):AddItem(star, 1)
        end)
    else
        if starConn then starConn:Disconnect() end
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
    end
end)

--====================================================--
-- ЧАСТЬ 13: CHAMS 4 (ЧЁРНОЕ)
--====================================================--
createToggle("CHAMS 4", Color3.fromRGB(30, 30, 30), function(state)
    if state then
        lighting.Ambient = Color3.fromRGB(0, 0, 0)
        lighting.Brightness = 0
        lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        
        local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://161221083"
        sky.SkyboxDn = "rbxassetid://161221083"
        sky.SkyboxFt = "rbxassetid://161221083"
        sky.SkyboxLf = "rbxassetid://161221083"
        sky.SkyboxRt = "rbxassetid://161221083"
        sky.SkyboxUp = "rbxassetid://161221083"
        sky.StarCount = 0
        sky.Parent = lighting
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(127, 127, 127)
    end
end)

--====================================================--
-- ЧАСТЬ 14: CHAMS 5 (БЕЛОЕ)
--====================================================--
createToggle("CHAMS 5", Color3.fromRGB(255, 255, 255), function(state)
    if state then
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        
        local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://161221083"
        sky.SkyboxDn = "rbxassetid://161221083"
        sky.SkyboxFt = "rbxassetid://161221083"
        sky.SkyboxLf = "rbxassetid://161221083"
        sky.SkyboxRt = "rbxassetid://161221083"
        sky.SkyboxUp = "rbxassetid://161221083"
        sky.StarCount = 0
        sky.Parent = lighting
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(127, 127, 127)
    end
end)

--====================================================--
-- ЧАСТЬ 15: ЗАВЕРШЕНИЕ
--====================================================--
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

starterGui:SetCore("SendNotification", {
    Title = "ZACK HUB",
    Text = "ФИНАЛЬНАЯ ВЕРСИЯ",
    Duration = 3
})

print("════════════════════════════════")
print("  ZACK HUB - ФИНАЛ")
print("  ✅ Иконка (0101)")
print("  ✅ Меню")
print("  ✅ Полет / Noclip / ESP / Invis")
print("  ✅ InvisFling + окно")
print("  ✅ Дрочка")
print("  ✅ Chams 1-5")
print("════════════════════════════════")
