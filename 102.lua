-- ЧАСТЬ 2: МЕНЮ (подключается к той же иконке)
-- Запускай ПОСЛЕ Части 1.3

local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ZackHubFinal")
if not gui then
    warn("Сначала запусти Часть 1.3")
    return
end

local icon = gui:FindFirstChild("TextButton")
if not icon then return end

local player = game.Players.LocalPlayer
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

-- ========== МЕНЮ ==========
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
menuCorner.CornerRadius = UDim.new(0, 25)
menuCorner.Parent = menu

-- Градиент
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
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -45, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 24
close.Parent = menu

close.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.BackgroundTransparency = 1
title.Text = "ZACK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 42
title.Parent = menu

-- Контейнер для кнопок
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -90)
container.Position = UDim2.new(0, 10, 0, 80)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 800)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = container

-- Функция создания кнопки
function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 55)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 150)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- ========== CHAMS 1 ==========
createButton("🌌 CHAMS 1 (НЕБО)", Color3.fromRGB(30, 80, 150), function()
    lighting.Ambient = Color3.fromRGB(50, 70, 150)
    lighting.Brightness = 0.6
    lighting.OutdoorAmbient = Color3.fromRGB(40, 60, 140)
    lighting.ColorShift_Top = Color3.fromRGB(100, 150, 255)
    lighting.ColorShift_Bottom = Color3.fromRGB(30, 30, 100)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://12371622424"
    sky.SkyboxDn = "rbxassetid://12371622424"
    sky.SkyboxFt = "rbxassetid://12371622424"
    sky.SkyboxLf = "rbxassetid://12371622424"
    sky.SkyboxRt = "rbxassetid://12371622424"
    sky.SkyboxUp = "rbxassetid://12371622424"
    sky.StarCount = 3000
    sky.Parent = lighting
end)

-- ========== CHAMS 2 ==========
local rainbowActive = false
local rainbowConn = nil

createButton("🌈 CHAMS 2 (РАДУГА)", Color3.fromRGB(150, 50, 150), function()
    rainbowActive = not rainbowActive
    
    if rainbowActive then
        local hue = 0
        rainbowConn = runService.Heartbeat:Connect(function()
            hue = (hue + 0.002) % 1
            lighting.Ambient = Color3.fromHSV(hue, 1, 1)
            lighting.OutdoorAmbient = lighting.Ambient
            lighting.Brightness = 0.7
        end)
    else
        if rainbowConn then
            rainbowConn:Disconnect()
            rainbowConn = nil
        end
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
    end
end)

-- ========== CHAMS 3 ==========
createButton("🌸 CHAMS 3 (АНИМЕ)", Color3.fromRGB(255, 100, 200), function()
    lighting.Ambient = Color3.fromRGB(255, 200, 240)
    lighting.Brightness = 0.8
    lighting.OutdoorAmbient = Color3.fromRGB(255, 180, 220)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://9821833563"
    sky.SkyboxDn = "rbxassetid://9821833563"
    sky.SkyboxFt = "rbxassetid://9821833563"
    sky.SkyboxLf = "rbxassetid://9821833563"
    sky.SkyboxRt = "rbxassetid://9821833563"
    sky.SkyboxUp = "rbxassetid://9821833563"
    sky.Parent = lighting

    local char = player.Character
    if char and char:FindFirstChild("Head") then
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 200, 0, 200)
        bill.StudsOffset = Vector3.new(0, 30, 0)
        bill.AlwaysOnTop = true
        bill.Parent = char.Head

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://13944203572"
        img.Parent = bill

        spawn(function()
            local t = 0
            while bill and bill.Parent do
                t = t + 0.05
                bill.StudsOffset = Vector3.new(math.sin(t) * 2, 30 + math.sin(t*2) * 2, 0)
                wait(0.05)
            end
        end)
    end
end)

-- ========== CHAMS 4 ==========
createButton("⚫ CHAMS 4 (ЧЁРНОЕ)", Color3.fromRGB(30, 30, 30), function()
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
end)

-- ========== CHAMS 5 ==========
createButton("⚪ CHAMS 5 (БЕЛОЕ)", Color3.fromRGB(255, 255, 255), function()
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
end)

-- ========== ОТКРЫТИЕ МЕНЮ ==========
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

starterGui:SetCore("SendNotification", {
    Title = "ZACK HUB",
    Text = "Меню загружено",
    Duration = 2
})

print("✅ Часть 2: Меню со всеми Chams готово")
