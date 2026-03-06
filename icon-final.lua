-- ЧАСТЬ 1.2: ИКОНКА (цифры строго внутри, без вылезаний)
if _G.ZACK_ICON_FIXED then return end
_G.ZACK_ICON_FIXED = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZackIconFixed"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- ========== ИКОНКА ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 200, 0, 80)
icon.Position = UDim2.new(0, 15, 0.5, -40)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

-- Скругление (важно: применяется до цифр)
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 40)
iconCorner.Parent = icon

-- КОНТЕЙНЕР ДЛЯ ЦИФР (чтобы не вылезали за скругление)
local clip = Instance.new("Frame")
clip.Size = UDim2.new(1, 0, 1, 0)
clip.BackgroundTransparency = 1
clip.ClipsDescendants = true -- обрезает всё, что выходит за пределы
clip.Parent = icon

-- ЦИФРЫ 0101 (теперь внутри контейнера, не вылезут)
local chars = {"0", "1"}
for row = 0, 7 do
    for col = 0, 14 do
        local digit = Instance.new("TextLabel")
        digit.Size = UDim2.new(0, 13, 0, 10)
        digit.Position = UDim2.new(0, col * 13, 0, row * 10)
        digit.BackgroundTransparency = 1
        digit.Text = chars[math.random(1,2)]
        digit.TextColor3 = Color3.fromRGB(0, 255, 0)
        digit.TextSize = 10
        digit.Font = Enum.Font.Code
        digit.Parent = clip -- теперь внутри контейнера с обрезкой
    end
end

-- СЕРЕБРЯНАЯ НАДПИСЬ (поверх, тоже внутри контейнера)
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250)
iconText.TextSize = 32
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = clip

print("✅ Часть 1.2: Иконка исправлена (цифры не вылезают)")
