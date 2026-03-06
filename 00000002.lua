-- ЧАСТЬ 3: ИКОНКА С ЦИФРАМИ, МЕНЮ С ТВОЕЙ КАРТИНКОЙ
if _G.ZACK_PART3 then return end
_G.ZACK_PART3 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubFinal"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ========== ИКОНКА ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 160, 0, 60)
icon.Position = UDim2.new(0, 15, 0.5, -30)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- чёрный фон
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30)
iconCorner.Parent = icon

-- ЦИФРЫ НА ИКОНКЕ
local chars = {"0","1"}
for i = 1, 8 do
    local line = Instance.new("TextLabel")
    line.Size = UDim2.new(1, 0, 0, 7)
    line.Position = UDim2.new(0, 0, 0, (i-1) * 7.5)
    line.BackgroundTransparency = 1
    line.TextColor3 = Color3.fromRGB(0, 255, 0) -- зелёные
    line.TextSize = 7
    line.Font = Enum.Font.Code
    line.Parent = icon
    
    local str = ""
    for j = 1, 20 do
        str = str .. chars[math.random(1,2)]
    end
    line.Text = str
end

-- НАДПИСЬ ПОВЕРХ ЦИФР
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK_HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250) -- серебро
iconText.TextSize = 24
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = icon

-- ========== МЕНЮ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 400, 0, 500)
menu.Position = UDim2.new(0.5, -200, 0.5, -250)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

-- ТВОЯ КАРТИНКА (ЗАДНИЙ ФОН МЕНЮ)
local menuBg = Instance.new("ImageLabel")
menuBg.Size = UDim2.new(1, 0, 1, 0)
menuBg.BackgroundTransparency = 1
menuBg.Image = "rbxassetid://75797746036726" -- твой ID
menuBg.ScaleType = Enum.ScaleType.Crop
menuBg.Parent = menu

-- КНОПКА ЗАКРЫТИЯ
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

-- ЗАГОЛОВОК МЕНЮ (поверх картинки)
local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 60)
menuTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuTitle.BackgroundTransparency = 0.5
menuTitle.Text = "ZACK HUB"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextSize = 36
menuTitle.Parent = menu

-- КОНТЕЙНЕР ДЛЯ КНОПОК
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -80)
container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 600)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = container

-- ========== ПРИМЕР КНОПКИ ==========
local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(1, 0, 0, 50)
testBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
testBtn.Text = "ТЕСТОВАЯ КНОПКА"
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 20
testBtn.Parent = container

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = testBtn

testBtn.MouseButton1Click:Connect(function()
    print("Кнопка работает")
end)

-- ОТКРЫТИЕ МЕНЮ
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

print("Часть 3: иконка с цифрами, меню с картинкой")
