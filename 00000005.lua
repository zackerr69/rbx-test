-- ЧАСТЬ 1: ИКОНКА (абсолютно независимая)
if _G.ZACK_ICON_FINAL then return end
_G.ZACK_ICON_FINAL = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZackIconFinal"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- ========== ИКОНКА ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 180, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- чёрный фон
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

-- Скругление
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 35)
iconCorner.Parent = icon

-- ЦИФРЫ 0101 НА ВСЮ ИКОНКУ (плотно)
local chars = {"0", "1"}
for row = 0, 6 do
    for col = 0, 12 do
        local digit = Instance.new("TextLabel")
        digit.Size = UDim2.new(0, 14, 0, 10)
        digit.Position = UDim2.new(0, col * 14, 0, row * 10)
        digit.BackgroundTransparency = 1
        digit.Text = chars[math.random(1,2)]
        digit.TextColor3 = Color3.fromRGB(0, 255, 0) -- зелёные
        digit.TextSize = 10
        digit.Font = Enum.Font.Code
        digit.Parent = icon
    end
end

-- СЕРЕБРЯНАЯ НАДПИСЬ ПОВЕРХ ЦИФР
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250) -- серебро
iconText.TextSize = 30
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = icon

print("✅ Часть 1: Иконка готова")
