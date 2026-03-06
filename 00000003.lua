-- ЧАСТЬ 4: ИКОНКА В ЦИФРАХ, МЕНЮ, CHAMS 1 И 2
if _G.ZACK_PART4 then return end
_G.ZACK_PART4 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubChams"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ========== ИКОНКА (ВСЯ В ЦИФРАХ) ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 180, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 35)
iconCorner.Parent = icon

-- ЦИФРЫ НА ВСЮ ИКОНКУ (более плотно)
local chars = {"0","1"}
for i = 1, 15 do
    for j = 1, 4 do
        local digit = Instance.new("TextLabel")
        digit.Size = UDim2.new(0, 12, 0, 12)
        digit.Position = UDim2.new(0, (j-1) * 14, 0, (i-1) * 14)
        digit.BackgroundTransparency = 1
        digit.Text = chars[math.random(1,2)]
        digit.TextColor3 = Color3.fromRGB(0, 255, 0) -- зелёные
        digit.TextSize = 10
        digit.Font = Enum.Font.Code
        digit.Parent = icon
    end
end

-- СЕРЕБРЯНАЯ НАДПИСЬ (поверх цифр)
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250) -- серебро
iconText.TextSize = 28
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = icon

-- ========== МЕНЮ (БЕЗ КАРТИНКИ, ПРОСТО КРАСИВЫЙ ФОН) ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 400, 0, 500)
menu.Position = UDim2.new(0.5, -200, 0.5, -250)
menu.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 25)
menuCorner.Parent = menu

-- Градиентный фон
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 30, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 40, 130))
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
local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 70)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "ZACK HUB"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextSize = 42
menuTitle.Parent = menu

-- Контейнер для кнопок
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -90)
container.Position = UDim2.new(0, 10, 0, 80)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 300)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.Parent = container

-- ========== ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ==========
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

-- ========== CHAMS 1 (ИДЕАЛЬНОЕ НЕБО) ==========
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

-- ========== CHAMS 2 (РАДУЖНОЕ НЕБО + КОНЬКИ) ==========
local rainbowActive = false
local rainbowConn = nil

createButton("🌈 CHAMS 2 (РАДУГА)", Color3.fromRGB(150, 50, 150), function()
    rainbowActive = not rainbowActive
    
    if rainbowActive then
        -- Радужное небо
        local hue = 0
        rainbowConn = runService.Heartbeat:Connect(function()
            hue = (hue + 0.002) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            lighting.Ambient = color
            lighting.OutdoorAmbient = color
            lighting.Brightness = 0.7
        end)
        
        -- Коньковая ходьба (визуально: скорость + частицы)
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 28 -- быстрее
            
                -- Частицы под ногами
                local particles = Instance.new("ParticleEmitter")
                particles.Texture = "rbxassetid://12371622394"
                particles.Rate = 30
                particles.Lifetime = NumberRange.new(0.5)
                particles.Speed = NumberRange.new(5)
                particles.SpreadAngle = Vector2.new(30, 30)
                particles.Parent = char.HumanoidRootPart
                
                -- Удалим при выключении
                rainbowConn = particles
            end
        end
    else
        if rainbowConn then
            rainbowConn:Disconnect()
            rainbowConn = nil
        end
        -- Сброс освещения
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
    end
end)

-- ========== ОТКРЫТИЕ МЕНЮ ==========
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

print("Часть 4: иконка в цифрах, меню, chams 1 и 2")
