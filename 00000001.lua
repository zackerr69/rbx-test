-- ЧАСТЬ 2: ДОБАВЛЯЕМ ФОН С ЦИФРАМИ
-- Запускай ПОВЕРХ части 1 (они уже в одном скрипте)

if _G.ZACK_PART2 then return end
_G.ZACK_PART2 = true

-- Берём ту же самую иконку из части 1, если её нет — создаём
local player = game.Players.LocalPlayer
local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("ZackPart1") 
    or Instance.new("ScreenGui")

if not gui.Parent then
    gui.Name = "ZackPart1"
    gui.Parent = player:WaitForChild("PlayerGui")
    gui.ResetOnSpawn = false
end

-- Если иконки ещё нет — создаём
local icon = gui:FindFirstChild("TextButton")
if not icon then
    icon = Instance.new("TextButton")
    icon.Size = UDim2.new(0, 140, 0, 50)
    icon.Position = UDim2.new(0, 15, 0.5, -25)
    icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    icon.BackgroundTransparency = 0.2
    icon.Text = "ZACK_HUB"
    icon.TextColor3 = Color3.fromRGB(230, 230, 250)
    icon.TextSize = 24
    icon.TextScaled = true
    icon.Font = Enum.Font.GothamBold
    icon.Draggable = true
    icon.Parent = gui
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 25)
    iconCorner.Parent = icon
end

-- СОЗДАЁМ ФОН С ЦИФРАМИ (НОВОЕ ОКНО МЕНЮ)
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 350, 0, 450)
menu.Position = UDim2.new(0.5, -175, 0.5, -225)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- чёрный фон
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

-- ГЕНЕРАЦИЯ ЦИФР (01010100101...)
local chars = {"0","1"}
for i = 1, 300 do
    local line = Instance.new("TextLabel")
    line.Size = UDim2.new(1, 0, 0, 20)
    line.Position = UDim2.new(0, 0, 0, (i-1) * 20)
    line.BackgroundTransparency = 1
    line.Text = ""
    line.TextColor3 = Color3.fromRGB(0, 255, 0) -- зелёные цифры
    line.TextSize = 16
    line.Font = Enum.Font.Code -- моноширинный шрифт
    line.Parent = menu
    
    -- Генерируем случайную строку из 0 и 1
    local str = ""
    for j = 1, 30 do
        str = str .. chars[math.random(1,2)]
    end
    line.Text = str
end

-- ЗАГОЛОВОК (поверх цифр)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 80)
title.Position = UDim2.new(0, 0, 0.5, -40)
title.BackgroundTransparency = 1
title.Text = "ZACK_HUB"
title.TextColor3 = Color3.fromRGB(230, 230, 250) -- серебро
title.TextSize = 60
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

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

-- ОТКРЫТИЕ МЕНЮ ПО КЛИКУ НА ИКОНКУ
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

print("Часть 2: фон с цифрами готов")
