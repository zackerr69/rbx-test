-- ЧАСТЬ 1.3: ИКОНКА (окончательная)
if _G.ZACK_ICON_FINAL2 then return end
_G.ZACK_ICON_FINAL2 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubFinal"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- ========== ИКОНКА (ПРЯМОУГОЛЬНИК) ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 220, 0, 70)  -- чуть меньше высота
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = ""
icon.Draggable = true
icon.Parent = gui

-- Скругление (совсем небольшое, чтобы было как прямоугольник)
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 8)
iconCorner.Parent = icon

-- КОНТЕЙНЕР С ОБРЕЗКОЙ (ВАЖНО!)
local clip = Instance.new("Frame")
clip.Size = UDim2.new(1, 0, 1, 0)
clip.BackgroundTransparency = 1
clip.ClipsDescendants = true  -- это режет всё, что вылезает
clip.Parent = icon

-- МЕЛКИЕ ЦИФРЫ (010101), очень много
local chars = {"0", "1"}
for row = 0, 12 do  -- больше рядов
    for col = 0, 25 do  -- больше колонок
        local digit = Instance.new("TextLabel")
        digit.Size = UDim2.new(0, 8, 0, 5)  -- мельче
        digit.Position = UDim2.new(0, col * 8, 0, row * 5)
        digit.BackgroundTransparency = 1
        digit.Text = chars[math.random(1,2)]
        digit.TextColor3 = Color3.fromRGB(0, 255, 0)
        digit.TextSize = 5
        digit.Font = Enum.Font.Code
        digit.Parent = clip
    end
end

-- СЕРЕБРЯНАЯ НАДПИСЬ (поверх)
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "ZACK HUB"
iconText.TextColor3 = Color3.fromRGB(230, 230, 250)
iconText.TextSize = 28
iconText.TextScaled = true
iconText.Font = Enum.Font.GothamBold
iconText.Parent = clip

print("✅ Часть 1.3: Иконка готова (мелкие цифры, прямоугольник)")
