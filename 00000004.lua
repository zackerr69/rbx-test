-- ЧАСТЬ 5: CHAMS 3, 4, 5 (аниме, чёрное, белое)
if _G.ZACK_PART5 then return end
_G.ZACK_PART5 = true

-- Подключаемся к тому же гуи
local player = game.Players.LocalPlayer
local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("ZackHubChams")
if not gui then
    warn("Сначала запусти Часть 4")
    return
end

local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")

-- Находим контейнер меню
local menu = gui:FindFirstChild("Frame")
if not menu then return end

local container = menu:FindFirstChild("ScrollingFrame")
if not container then return end

-- ========== ФУНКЦИЯ ДОБАВЛЕНИЯ КНОПКИ ==========
function addButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 55)
    btn.BackgroundColor3 = color or Color3.fromRGB(80, 80, 150)
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

-- ========== CHAMS 3 – АНИМЕ ДЕВЧОНКА В НЕБЕ ==========
addButton("🌸 CHAMS 3 (АНИМЕ)", Color3.fromRGB(255, 100, 200), function()
    lighting.Ambient = Color3.fromRGB(255, 200, 240)
    lighting.Brightness = 0.8
    lighting.OutdoorAmbient = Color3.fromRGB(255, 180, 220)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://9821833563"  -- небо с аниме
    sky.SkyboxDn = "rbxassetid://9821833563"
    sky.SkyboxFt = "rbxassetid://9821833563"
    sky.SkyboxLf = "rbxassetid://9821833563"
    sky.SkyboxRt = "rbxassetid://9821833563"
    sky.SkyboxUp = "rbxassetid://9821833563"
    sky.Parent = lighting

    -- Анимированная девчонка (Billboard)
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
        img.Image = "rbxassetid://13944203572" -- аниме девочка
        img.Parent = bill

        -- Анимация покачивания
        local t = 0
        spawn(function()
            while bill and bill.Parent do
                t = t + 0.05
                bill.StudsOffset = Vector3.new(math.sin(t) * 2, 30 + math.sin(t*2) * 2, 0)
                wait(0.05)
            end
        end)
    end
end)

-- ========== CHAMS 4 – ПОЛНОСТЬЮ ЧЁРНОЕ НЕБО ==========
addButton("⚫ CHAMS 4 (ЧЁРНОЕ)", Color3.fromRGB(30, 30, 30), function()
    lighting.Ambient = Color3.fromRGB(0, 0, 0)
    lighting.Brightness = 0
    lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://161221083"  -- чёрная текстура
    sky.SkyboxDn = "rbxassetid://161221083"
    sky.SkyboxFt = "rbxassetid://161221083"
    sky.SkyboxLf = "rbxassetid://161221083"
    sky.SkyboxRt = "rbxassetid://161221083"
    sky.SkyboxUp = "rbxassetid://161221083"
    sky.StarCount = 0
    sky.Parent = lighting
end)

-- ========== CHAMS 5 – ПОЛНОСТЬЮ БЕЛОЕ НЕБО ==========
addButton("⚪ CHAMS 5 (БЕЛОЕ)", Color3.fromRGB(255, 255, 255), function()
    lighting.Ambient = Color3.fromRGB(255, 255, 255)
    lighting.Brightness = 2
    lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://161221083"  -- белая текстура
    sky.SkyboxDn = "rbxassetid://161221083"
    sky.SkyboxFt = "rbxassetid://161221083"
    sky.SkyboxLf = "rbxassetid://161221083"
    sky.SkyboxRt = "rbxassetid://161221083"
    sky.SkyboxUp = "rbxassetid://161221083"
    sky.StarCount = 0
    sky.Parent = lighting
end)

print("Часть 5: Chams 3,4,5 добавлены")
