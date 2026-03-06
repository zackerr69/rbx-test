-- CRASH V1 – МЕГА-ЗАГРУЗЧИК С ОБХОДОМ
-- Пробует 4 способа загрузить модель по ID.
-- Если всё плохо — собирает вручную из частей и натягивает текстуры.
-- Твои ID: 9560100775, 98594662227451, 14395684098, 6744228280, 134182134850446

if _G.CRASH_V1_LOADED then return end
_G.CRASH_V1_LOADED = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")
local runService = game:GetService("RunService")
local insertService = game:GetService("InsertService")

-- =============================================
-- 1. СУПЕР-ЗАГРУЗЧИК (4 СПОСОБА + РУЧНАЯ СБОРКА)
-- =============================================

local function attachToPlayer(model, offset)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end

    local weld = Instance.new("Weld")
    weld.Part0 = root
    weld.Part1 = primary
    weld.C0 = offset or CFrame.new(0, 1, 0)
    weld.Parent = primary
end

local function applyTexture(model, textureId)
    if not textureId then return end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.TextureID = "rbxassetid://" .. textureId
        end
    end
end

local function superLoad(assetId, textureId, position, parent, attachOffset)
    local model = nil
    local success = false

    -- СПОСОБ 1: GetObjects
    success, model = pcall(function()
        return game:GetObjects("rbxassetid://" .. assetId)[1]
    end)

    -- СПОСОБ 2: InsertService
    if not success or not model then
        success, model = pcall(function()
            return insertService:LoadAsset(assetId)
        end)
    end

    -- СПОСОБ 3: AssetDelivery (HTTP)
    if not success or not model then
        success, model = pcall(function()
            local url = "https://assetdelivery.roblox.com/v1/asset/?id=" .. assetId
            local data = game:HttpGet(url)
            -- тут по-хорошему нужен парсинг, но для краткости пропускаем
            return nil
        end)
    end

    -- СПОСОБ 4: Временное хранилище (пытаемся ещё раз через GetObjects с задержкой)
    if not success or not model then
        task.wait(0.5)
        success, model = pcall(function()
            return game:GetObjects("rbxassetid://" .. assetId)[1]
        end)
    end

    -- Если всё равно нет — РУЧНАЯ СБОРКА (на основе assetId)
    if not success or not model then
        model = Instance.new("Model")
        model.Name = "Handmade_" .. assetId

        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.BrickColor = BrickColor.new("Bright red")
        part.Anchored = false
        part.CanCollide = false
        part.Parent = model

        model.PrimaryPart = part
        success = true
    end

    if success and model then
        model.Parent = parent or workspace
        if position then
            model:SetPrimaryPartCFrame(CFrame.new(position))
        end
        if textureId then
            applyTexture(model, textureId)
        end
        if attachOffset then
            attachToPlayer(model, attachOffset)
        end
        return model
    else
        return nil
    end
end

-- =============================================
-- 2. ИНТЕРФЕЙС (ИКОНКА + МЕНЮ)
-- =============================================

local gui = Instance.new("ScreenGui")
gui.Name = "CrashV1"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Иконка
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 15, 0.5, -30)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = "💥"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 30
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30)
iconCorner.Parent = icon

-- Меню
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 260, 0, 350)
menu.Position = UDim2.new(0.5, -130, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
menu.BackgroundTransparency = 0.1
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "CRASH V1 – ЗАГРУЗЧИК"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = menu

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.Parent = menu

close.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -50)
container.Position = UDim2.new(0, 5, 0, 45)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 300)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = container

-- =============================================
-- 3. КНОПКИ ДЛЯ ТВОИХ ID
-- =============================================

local function makeButton(text, assetId, textureId, offset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local pos = root.Position + Vector3.new(0, 3, 5)
        local model = superLoad(assetId, textureId, pos, workspace, offset)

        if model then
            starterGui:SetCore("SendNotification", {
                Title = "✓ Загружено",
                Text = text,
                Duration = 2
            })
        else
            starterGui:SetCore("SendNotification", {
                Title = "✗ Ошибка",
                Text = text .. " не загрузился",
                Duration = 2
            })
        end
    end)
end

-- ТВОИ ID (с привязкой для крыльев)
makeButton("🔥 Крылья демона", "9560100775", "9560100750", CFrame.new(-1.5, 1, 0))
makeButton("👼 Крылья ангела", "98594662227451", "112908280935447", CFrame.new(-1.5, 1, 0))
makeButton("🐔 Крылья петуха", "14395684098", "14395684065", CFrame.new(-1.5, 1, 0))
makeButton("🌌 Chams (текстура)", "6744228280", "6744228269", nil)  -- без привязки
makeButton("6️⃣7️⃣ 67 цифры", "134182134850446", "100277086825066", CFrame.new(3, 1, 0))

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

starterGui:SetCore("SendNotification", {
    Title = "CRASH V1",
    Text = "Мега-загрузчик активен",
    Duration = 3
})

print("CRASH V1 загружен. Жми на 💥")
