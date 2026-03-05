--[[
    Zack_Hub v1.0
    DEV-MASTER Edition
    Космический дизайн, иконка-петух, мобильная версия
]]

-- Защита от повторного запуска
if _G.ZACK_HUB_LOADED then return end
_G.ZACK_HUB_LOADED = true

-- Ожидание загрузки игры
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

-- Основные переменные
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- ============================================
-- ЧАСТЬ 1: СОЗДАНИЕ ПЛАВАЮЩЕЙ ИКОНКИ (ПЕТУХ)
-- ============================================

local guiHolder = Instance.new("ScreenGui")
guiHolder.Name = "ZackHubGUI"
guiHolder.Parent = player:WaitForChild("PlayerGui")
guiHolder.ResetOnSpawn = false
guiHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Создаем иконку (кнопку-петух)
local icon = Instance.new("ImageButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 20, 0.5, -30)  -- Слева по центру
icon.BackgroundColor3 = Color3.fromRGB(255, 215, 0)  -- Золотой фон
icon.BackgroundTransparency = 0.2
icon.Image = "rbxassetid://6031107863"  -- Изображение петуха (эмодзи петуха)
icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
icon.Draggable = true
icon.Parent = guiHolder

-- Скругление иконки
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30)  -- Круглая
iconCorner.Parent = icon

-- Текст под иконкой (zack_hub)
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 0, 20)
iconText.Position = UDim2.new(0, 0, 1, 2)
iconText.BackgroundTransparency = 1
iconText.Text = "zack_hub"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.TextStrokeTransparency = 0.5
iconText.Font = Enum.Font.GothamBold
iconText.TextSize = 14
iconText.Parent = icon

-- Переменная для отслеживания состояния меню (открыто/закрыто)
local menuOpen = false
local mainMenu = nil  -- Будет создано позже

-- Функция создания главного меню (будет вызвана при нажатии на иконку)
local function createMainMenu()
    -- Весь код главного меню (космический дизайн) будет здесь
    -- Пока заглушка, мы наполним её в Части 2
    print("Создаем главное меню...")
end

-- Обработка нажатия на иконку
icon.MouseButton1Click:Connect(function()
    if menuOpen then
        if mainMenu then
            mainMenu.Visible = false
            menuOpen = false
        end
    else
        if not mainMenu then
            createMainMenu()
        else
            mainMenu.Visible = true
        end
        menuOpen = true
    end
end)
-- ============================================
-- ЧАСТЬ 2: КОСМИЧЕСКОЕ МЕНЮ
-- ============================================

function createMainMenu()
    -- Главное окно (космический фон)
    mainMenu = Instance.new("Frame")
    mainMenu.Size = UDim2.new(0, 280, 0, 450)
    mainMenu.Position = UDim2.new(0.5, -140, 0.5, -225)
    mainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 30)  -- Тёмно-синий космос
    mainMenu.BorderSizePixel = 0
    mainMenu.Active = true
    mainMenu.Draggable = true
    mainMenu.Visible = true
    mainMenu.Parent = guiHolder

    -- Скругление углов
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 15)
    menuCorner.Parent = mainMenu

    -- Звёздный фон (градиент или частицы)
    local stars = Instance.new("Frame")
    stars.Size = UDim2.new(1, 0, 1, 0)
    stars.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    stars.BackgroundTransparency = 0.95
    stars.BorderSizePixel = 0
    stars.Parent = mainMenu

    -- Добавим несколько "звёзд" как маленькие точки
    for i = 1, 50 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, 2, 0, 2)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.Parent = stars
        
        -- Немного анимации мерцания (опционально)
        TweenService:Create(star, TweenInfo.new(1 + math.random(), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.5}):Play()
    end

    -- Заголовок с неоновым эффектом
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundTransparency = 1
    title.Text = "ZACK HUB v1.0"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)  -- Циановый неон
    title.TextStrokeTransparency = 0.3
    title.TextStrokeColor3 = Color3.fromRGB(255, 0, 255)  -- Пурпурная обводка для эффекта
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = mainMenu

    -- Кнопка закрытия (маленький крестик)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = mainMenu
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainMenu.Visible = false
        menuOpen = false
    end)

    -- Контейнер для кнопок (с прокруткой для мобил)
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -20, 1, -80)
    container.Position = UDim2.new(0, 10, 0, 50)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.Parent = mainMenu

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = container

    -- Функция для создания неоновой кнопки-переключателя
    function createNeonToggle(text, varPath, default)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        btn.Text = text .. ": " .. tostring(default)
        btn.TextColor3 = Color3.fromRGB(0, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 16
        btn.AutoButtonColor = false
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        -- Неоновая обводка при наведении/активации
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 255)
        stroke.Thickness = default and 2 or 1
        stroke.Transparency = default and 0.2 or 0.8
        stroke.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            -- Переключение состояния (будет связано с Settings позже)
            local newState = not default
            stroke.Thickness = newState and 2 or 1
            stroke.Transparency = newState and 0.2 or 0.8
            btn.Text = text .. ": " .. tostring(newState)
        end)
        
        return btn
    end

    -- Временно создадим несколько кнопок для демонстрации
    createNeonToggle("Flight", "Flight", false)
    createNeonToggle("Noclip", "Noclip", false)
    createNeonToggle("ESP", "ESP", false)
    createNeonToggle("Invis", "Invis", false)
    -- Остальные кнопки добавим позже
    
    -- Разделитель (неоновый)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -20, 0, 2)
    sep.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    sep.BackgroundTransparency = 0.5
    sep.Parent = container
    
    local sepCorner = Instance.new("UICorner")
    sepCorner.CornerRadius = UDim.new(0, 2)
    sepCorner.Parent = sep
    
    -- Подпись "ACCESSORIES"
    local accTitle = Instance.new("TextLabel")
    accTitle.Size = UDim2.new(1, -10, 0, 30)
    accTitle.BackgroundTransparency = 1
    accTitle.Text = "✦ АКСЕССУАРЫ ✦"
    accTitle.TextColor3 = Color3.fromRGB(255, 0, 255)
    accTitle.Font = Enum.Font.GothamBold
    accTitle.TextSize = 16
    accTitle.Parent = container
    
    return mainMenu
end

-- Вызываем создание меню (сейчас оно не покажется, пока не нажать иконку)
createMainMenu()
-- ============================================
-- ЧАСТЬ 3: ЦЕНТРАЛЬНЫЕ НАСТРОЙКИ (SETTINGS)
-- ============================================

local Settings = {
    -- Основные функции
    Flight = { 
        Enabled = false, 
        Speed = 50, 
        SpeedMultiplier = 1,  -- 1x, 3x, 5x, 7x
        BodyVelocity = nil,
        UseCFrame = false,
        AutoForward = false
    },
    Noclip = { Enabled = false, Connection = nil },
    ESP = { 
        Enabled = false, 
        Players = true, 
        Mobs = true, 
        Items = true,
        Objects = {},
        LowMemoryMode = true  -- Для телефонов
    },
    SpeedHack = { Enabled = false, WalkSpeed = 24, JumpPower = 50 },
    Chams = { Enabled = false, Color = Color3.fromRGB(0, 255, 255), Transparency = 0.5 },
    Invis = { Enabled = false, OriginalTransparency = {} },  -- Невидимость
    InvisFling = { Enabled = false, Connection = nil },      -- Инвис флинг
    JackOff = { Enabled = false, Connection = nil },         -- Дрочка
    Clicker = { Enabled = false, Target = nil, Connection = nil }, -- Нажимка
    
    -- Аксессуары
    Accessories = {
        Enabled = false,
        -- Основные
        Wheelchair = false,
        Halo = false,
        -- Крылья (разновидности)
        Wings_Angel = false,     -- Ангельские
        Wings_Hell = false,      -- Адские
        Wings_Rooster = false,   -- Петушиные
        Wings_Plane = false,     -- Самолётные
        -- Голова
        Head_Spin = false,       -- Вращение головы
        Head_Poop = false,       -- Какашка
        Head_Knife = false,      -- Нож
        Head_Dildo = false,      -- Резиновый дилдо
        Head_ClownHair = false,  -- Волосы клоуна
        Head_Leaf = false,       -- Листок с надписью "ЛОХ"
        -- Разное
        Butt_Dildo = false,      -- Дилдо в попе
        Bird_Shoulder = false,   -- Птичка на плече
        Platform_RedCarpet = false, -- Красная дорожка (платформа)
        Stand_67 = false         -- Стоящий рядом 67
    }
}

-- Функция для безопасного доступа к Settings (будем использовать в кнопках)
function toggleSetting(category, key)
    if Settings[category] and Settings[category][key] ~= nil then
        Settings[category][key] = not Settings[category][key]
        return Settings[category][key]
    elseif Settings[category] and type(Settings[category]) == "table" and key == nil then
        -- Для основных функций как Flight.Enabled
        Settings[category].Enabled = not Settings[category].Enabled
        return Settings[category].Enabled
    end
    return false
end
-- ============================================
-- ЧАСТЬ 4: ESP (ОПТИМИЗИРОВАННЫЙ ДЛЯ МОБИЛ)
-- ============================================

local function createESP(instance, color)
    if not instance or Settings.ESP.Objects[instance] then return end
    if Settings.ESP.LowMemoryMode and #Settings.ESP.Objects > 30 then
        -- Ограничиваем количество ESP объектов на телефоне
        return
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = instance
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = guiHolder
    
    Settings.ESP.Objects[instance] = highlight
    
    -- Автоудаление при уничтожении объекта
    local connection
    connection = instance.AncestryChanged:Connect(function()
        if not instance.Parent then
            connection:Disconnect()
            if Settings.ESP.Objects[instance] then
                Settings.ESP.Objects[instance]:Destroy()
                Settings.ESP.Objects[instance] = nil
            end
        end
    end)
end

-- Оптимизированный цикл ESP (обновляется реже)
local espLoop
espLoop = RunService.Stepped:Connect(function()
    if not Settings.ESP.Enabled then
        -- Очищаем всё
        for obj, hl in pairs(Settings.ESP.Objects) do
            hl:Destroy()
        end
        Settings.ESP.Objects = {}
        return
    end
    
    -- Игроки
    if Settings.ESP.Players then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                createESP(plr.Character, Color3.fromRGB(255, 0, 0))
            end
        end
    end
    
    -- Мобы (с Humanoid, но не игроки)
    if Settings.ESP.Mobs then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                createESP(obj, Color3.fromRGB(255, 165, 0))
            end
        end
    end
    
    -- Предметы (Tool или Part с тегом)
    if Settings.ESP.Items then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Name:lower():find("item")) then
                createESP(obj, Color3.fromRGB(0, 255, 0))
            end
        end
    end
end)
-- ============================================
-- ЧАСТЬ 5: БАЗОВЫЕ ФУНКЦИИ ДЛЯ АКСЕССУАРОВ
-- ============================================

-- Словарь для хранения созданных аксессуаров
local activeAccessories = {}

-- Функция для создания сварки (Weld) между двумя частями
function weldParts(part0, part1, cframeOffset)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = cframeOffset or CFrame.new()
    weld.Parent = part1
    return weld
end

-- Функция для создания простой части с заданными параметрами
function createPart(name, size, color, parent)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.BrickColor = BrickColor.new(color)
    part.Material = Enum.Material.SmoothPlastic
    part.Anchored = false
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Parent = parent or character
    return part
end

-- Функция для создания модели-аксессуара
function createAccessoryModel(name)
    local model = Instance.new("Model")
    model.Name = name .. "_Accessory"
    model.Parent = character
    return model
end

-- Функция очистки аксессуаров (вызывается при выключении)
function clearAccessories()
    for name, acc in pairs(activeAccessories) do
        if acc and acc.Parent then
            acc:Destroy()
        end
    end
    activeAccessories = {}
end

-- Функция обновления всех аксессуаров (вызывается в цикле)
function updateAccessories()
    if not character or not Settings.Accessories.Enabled then
        clearAccessories()
        return
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not head then return end
    
    -- Словарь того, что должно быть включено
    local wanted = {}
    for accName, enabled in pairs(Settings.Accessories) do
        if type(enabled) == "boolean" and enabled and accName ~= "Enabled" then
            wanted[accName] = true
        end
    end
    
    -- Удаляем лишнее
    for name, acc in pairs(activeAccessories) do
        if not wanted[name] then
            acc:Destroy()
            activeAccessories[name] = nil
        end
    end
    
    -- Создаём недостающее (каждый аксессуар будет в своей функции)
    if wanted.Wings_Angel and not activeAccessories.Wings_Angel then
        activeAccessories.Wings_Angel = createWingsAngel(head, torso, root)
    end
    if wanted.Wings_Hell and not activeAccessories.Wings_Hell then
        activeAccessories.Wings_Hell = createWingsHell(head, torso, root)
    end
    if wanted.Wings_Rooster and not activeAccessories.Wings_Rooster then
        activeAccessories.Wings_Rooster = createWingsRooster(head, torso, root)
    end
    if wanted.Wings_Plane and not activeAccessories.Wings_Plane then
        activeAccessories.Wings_Plane = createWingsPlane(head, torso, root)
    end
    if wanted.Butt_Dildo and not activeAccessories.Butt_Dildo then
        activeAccessories.Butt_Dildo = createButtDildo(root, torso)
    end
    if wanted.Head_Spin and not activeAccessories.Head_Spin then
        activeAccessories.Head_Spin = startHeadSpin(head)
    end
    if wanted.Bird_Shoulder and not activeAccessories.Bird_Shoulder then
        activeAccessories.Bird_Shoulder = createBirdShoulder(head, torso)
    end
    if wanted.Platform_RedCarpet and not activeAccessories.Platform_RedCarpet then
        activeAccessories.Platform_RedCarpet = createRedCarpet(root)
    end
    if wanted.Stand_67 and not activeAccessories.Stand_67 then
        activeAccessories.Stand_67 = createStand67(root)
    end
    if wanted.Head_Poop and not activeAccessories.Head_Poop then
        activeAccessories.Head_Poop = createHeadPoop(head)
    end
    if wanted.Head_Knife and not activeAccessories.Head_Knife then
        activeAccessories.Head_Knife = createHeadKnife(head)
    end
    if wanted.Head_Dildo and not activeAccessories.Head_Dildo then
        activeAccessories.Head_Dildo = createHeadDildo(head)
    end
    if wanted.Head_ClownHair and not activeAccessories.Head_ClownHair then
        activeAccessories.Head_ClownHair = createClownHair(head)
    end
    if wanted.Head_Leaf and not activeAccessories.Head_Leaf then
        activeAccessories.Head_Leaf = createHeadLeaf(head)
    end
    if wanted.Halo and not activeAccessories.Halo then
        activeAccessories.Halo = createHalo(head)
    end
    if wanted.Wheelchair and not activeAccessories.Wheelchair then
        activeAccessories.Wheelchair = createWheelchair(root)
    end
end
-- ============================================
-- ЧАСТЬ 6: КРЫЛЬЯ С АНИМАЦИЯМИ
-- ============================================

function createWingsAngel(head, torso, root)
    if not torso then return nil end
    
    local model = createAccessoryModel("Wings_Angel")
    
    -- Левое крыло
    local leftWing = createPart("LeftWing", Vector3.new(0.5, 2, 1), "White", model)
    leftWing.Material = Enum.Material.Fabric
    
    -- Правое крыло
    local rightWing = createPart("RightWing", Vector3.new(0.5, 2, 1), "White", model)
    rightWing.Material = Enum.Material.Fabric
    
    -- Перья (несколько маленьких частей для красоты)
    for i = 1, 3 do
        local featherL = createPart("FeatherL"..i, Vector3.new(0.2, 0.5, 0.8), "White", model)
        local featherR = createPart("FeatherR"..i, Vector3.new(0.2, 0.5, 0.8), "White", model)
        
        weldParts(leftWing, featherL, CFrame.new(0, 0.5 - i*0.3, 0.5) * CFrame.Angles(0.2, 0, 0))
        weldParts(rightWing, featherR, CFrame.new(0, 0.5 - i*0.3, 0.5) * CFrame.Angles(0.2, 0, 0))
    end
    
    -- Прикрепляем к торсу
    weldParts(torso, leftWing, CFrame.new(-1, 0.5, 0.3) * CFrame.Angles(0, 0.2, 0.3))
    weldParts(torso, rightWing, CFrame.new(1, 0.5, 0.3) * CFrame.Angles(0, -0.2, -0.3))
    
    -- Анимация взмахов
    local angle = 0
    local animConnection
    animConnection = RunService.Heartbeat:Connect(function(dt)
        if not model.Parent then animConnection:Disconnect() return end
        angle = angle + dt * 3  -- Скорость взмахов
        
        local wingAngle = math.sin(angle) * 0.3
        leftWing.Weld.C0 = CFrame.new(-1, 0.5, 0.3) * CFrame.Angles(0, 0.2 + wingAngle, 0.3)
        rightWing.Weld.C0 = CFrame.new(1, 0.5, 0.3) * CFrame.Angles(0, -0.2 - wingAngle, -0.3)
    end)
    
    -- Сохраняем соединение для очистки
    model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not model.Parent and animConnection then
            animConnection:Disconnect()
        end
    end)
    
    return model
end
function createWingsHell(head, torso, root)
    if not torso then return nil end
    
    local model = createAccessoryModel("Wings_Hell")
    
    -- Левое крыло (с эффектом пламени)
    local leftWing = createPart("LeftWing", Vector3.new(0.6, 2.2, 1.2), "Really red", model)
    leftWing.Material = Enum.Material.Neon
    
    -- Правое крыло
    local rightWing = createPart("RightWing", Vector3.new(0.6, 2.2, 1.2), "Really red", model)
    rightWing.Material = Enum.Material.Neon
    
    -- Огненные эффекты (небольшие светящиеся шарики)
    for i = 1, 5 do
        local fireL = createPart("FireL"..i, Vector3.new(0.3, 0.3, 0.3), "Bright orange", model)
        fireL.Material = Enum.Material.Neon
        local fireR = createPart("FireR"..i, Vector3.new(0.3, 0.3, 0.3), "Bright orange", model)
        fireR.Material = Enum.Material.Neon
        
        weldParts(leftWing, fireL, CFrame.new(0, i*0.3 - 1, 0.2))
        weldParts(rightWing, fireR, CFrame.new(0, i*0.3 - 1, 0.2))
    end
    
    weldParts(torso, leftWing, CFrame.new(-1.2, 0.5, 0.4) * CFrame.Angles(0, 0.3, 0.4))
    weldParts(torso, rightWing, CFrame.new(1.2, 0.5, 0.4) * CFrame.Angles(0, -0.3, -0.4))
    
    -- Анимация "горения" (мерцание)
    local flicker = 0
    local animConnection
    animConnection = RunService.Heartbeat:Connect(function()
        if not model.Parent then animConnection:Disconnect() return end
        flicker = flicker + 0.1
        local intensity = 0.7 + math.sin(flicker) * 0.3
        
        for _, child in ipairs(model:GetChildren()) do
            if child.Name:find("Fire") then
                child.BrickColor = BrickColor.new(Color3.new(1, intensity * 0.5, 0))
            end
        end
    end)
    
    model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not model.Parent and animConnection then animConnection:Disconnect() end
    end)
    
    return model
end
function createWingsRooster(head, torso, root)
    if not torso then return nil end
    
    local model = createAccessoryModel("Wings_Rooster")
    
    -- Яркие пёстрые крылья
    local colors = {"Bright red", "Bright yellow", "Bright green", "Bright blue"}
    
    for side = -1, 1, 2 do  -- -1 лево, 1 право
        for i = 1, 4 do
            local feather = createPart("Feather"..side..i, Vector3.new(0.3, 0.8, 0.2), colors[i], model)
            local offset = CFrame.new(side * (0.5 + i*0.2), 0.3 + i*0.2, 0.2) * CFrame.Angles(0, side*0.2, 0.1*side)
            weldParts(torso, feather, offset)
        end
    end
    
    -- Гребешок на голову (если есть)
    if head then
        local comb = createPart("Comb", Vector3.new(0.5, 0.3, 0.3), "Bright red", model)
        weldParts(head, comb, CFrame.new(0, 0.4, 0.3))
    end
    
    -- Анимация "петушиные танцы" (мелкое подёргивание)
    local time = 0
    local animConnection
    animConnection = RunService.Heartbeat:Connect(function(dt)
        if not model.Parent then animConnection:Disconnect() return end
        time = time + dt * 5
        
        for _, child in ipairs(model:GetChildren()) do
            if child.Name:find("Feather") and child:FindFirstChildOfClass("Weld") then
                local weld = child:FindFirstChildOfClass("Weld")
                if weld then
                    -- Лёгкое покачивание
                    local baseCF = weld.C0
                    weld.C0 = baseCF * CFrame.Angles(math.sin(time) * 0.05, 0, 0)
                end
            end
        end
    end)
    
    return model
end
function createWingsPlane(head, torso, root)
    if not torso then return nil end
    
    local model = createAccessoryModel("Wings_Plane")
    
    -- Основные крылья (серые)
    local leftWing = createPart("LeftWing", Vector3.new(2, 0.2, 1), "Medium stone grey", model)
    local rightWing = createPart("RightWing", Vector3.new(2, 0.2, 1), "Medium stone grey", model)
    local tailWing = createPart("TailWing", Vector3.new(1, 0.5, 0.2), "Medium stone grey", model)
    local body = createPart("Body", Vector3.new(1, 0.5, 2), "Medium stone grey", model)
    
    weldParts(torso, leftWing, CFrame.new(-1.5, 0, 0) * CFrame.Angles(0, 0, 0.1))
    weldParts(torso, rightWing, CFrame.new(1.5, 0, 0) * CFrame.Angles(0, 0, -0.1))
    weldParts(torso, tailWing, CFrame.new(0, 0.5, -1) * CFrame.Angles(0.3, 0, 0))
    weldParts(torso, body, CFrame.new(0, 0, 0.5))
    
    -- СИСТЕМА СЛЕДА (белые полосы)
    local trailParts = {}
    local trailConnection
    
    local function createTrailPart(pos)
        local trail = Instance.new("Part")
        trail.Size = Vector3.new(1, 0.1, 2)
        trail.BrickColor = BrickColor.new("White")
        trail.Material = Enum.Material.Neon
        trail.Anchored = false
        trail.CanCollide = false
        trail.CanTouch = false
        trail.Transparency = 0.3
        trail.Parent = Workspace
        
        trail.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, 0)
        
        -- Затухание и удаление
        local startTime = tick()
        local fadeConnection
        fadeConnection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            if elapsed > 2 then
                trail:Destroy()
                fadeConnection:Disconnect()
            else
                trail.Transparency = 0.3 + (elapsed / 2) * 0.7
                trail.Size = Vector3.new(1, 0.1, 2 * (1 - elapsed/2))
            end
        end)
        
        table.insert(trailParts, trail)
        Debris:AddItem(trail, 2.5)
    end
    
    -- Запускаем создание следа при движении
    if Settings.Accessories.Wings_Plane then
        trailConnection = RunService.Heartbeat:Connect(function()
            if not model.Parent or not Settings.Accessories.Wings_Plane then
                trailConnection:Disconnect()
                return
            end
            
            -- Создаём след только если игрок движется быстро
            if root and root.Velocity.Magnitude > 20 then
                -- Две белые полосы позади
                local backPos = root.Position - root.Velocity.Unit * 3
                local rightVec = root.CFrame.RightVector
                
                createTrailPart(backPos + rightVec * 1.5)
                createTrailPart(backPos - rightVec * 1.5)
            end
        end)
    end
    
    -- Очистка следов при удалении
    model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not model.Parent then
            if trailConnection then trailConnection:Disconnect() end
            for _, trail in ipairs(trailParts) do
                if trail.Parent then trail:Destroy() end
            end
        end
    end)
    
    return model
end
-- ============================================
-- ЧАСТЬ 7: СПЕЦИАЛЬНЫЕ АКСЕССУАРЫ
-- ============================================

function createButtDildo(root, torso)
    if not torso then return nil end
    
    local model = createAccessoryModel("Butt_Dildo")
    
    -- Основание (розовое)
    local base = createPart("Base", Vector3.new(0.8, 0.5, 0.8), "Hot pink", model)
    base.Material = Enum.Material.SmoothPlastic
    
    -- Ствол (градиент: розовый -> фиолетовый)
    local shaft = createPart("Shaft", Vector3.new(0.5, 2, 0.5), "Bright violet", model)
    shaft.Material = Enum.Material.Neon
    
    -- Головка (блестящая)
    local tip = createPart("Tip", Vector3.new(0.7, 0.4, 0.7), "Bright red", model)
    tip.Material = Enum.Material.Glass
    tip.Reflectance = 0.3
    
    -- Сборка
    weldParts(base, shaft, CFrame.new(0, 1, 0))
    weldParts(shaft, tip, CFrame.new(0, 1.2, 0))
    
    -- Прикрепляем к торсу (сзади)
    weldParts(torso, base, CFrame.new(0, -0.5, -0.8) * CFrame.Angles(0.3, 0, 0))
    
    -- Анимация "вибрации"
    local vib = 0
    local animConnection
    animConnection = RunService.Heartbeat:Connect(function(dt)
        if not model.Parent then animConnection:Disconnect() return end
        vib = vib + dt * 20
        
        local offset = math.sin(vib) * 0.05
        if shaft and shaft:FindFirstChildOfClass("Weld") then
            shaft.Weld.C0 = CFrame.new(0, 1 + offset, 0)
        end
    end)
    
    return model
end
function startHeadSpin(head)
    if not head then return nil end
    
    local spinValue = 0
    local originalOrientation = head.Orientation
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- Отключаем анимацию ног (ставим флаг)
    if humanoid then
        humanoid.AutoRotate = false
    end
    
    local spinConnection = RunService.Heartbeat:Connect(function(dt)
        if not Settings.Accessories.Head_Spin or not head.Parent then
            -- Возвращаем нормальное вращение при выключении
            if humanoid then
                humanoid.AutoRotate = true
            end
            spinConnection:Disconnect()
            return
        end
        
        spinValue = spinValue + dt * 5  -- Скорость вращения
        
        -- Поворачиваем голову независимо от тела
        head.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, spinValue, 0) * CFrame.new(0, 0.5, 0)
    end)
    
    return {Connection = spinConnection}
end
function createBirdShoulder(head, torso)
    if not torso then return nil end
    
    local model = createAccessoryModel("Bird")
    
    -- Тело птички
    local body = createPart("Body", Vector3.new(0.4, 0.4, 0.4), "Bright yellow", model)
    
    -- Голова
    local headPart = createPart("Head", Vector3.new(0.25, 0.25, 0.25), "Bright yellow", model)
    
    -- Клюв
    local beak = createPart("Beak", Vector3.new(0.1, 0.1, 0.2), "Bright orange", model)
    
    -- Глаза
    local eyeL = createPart("EyeL", Vector3.new(0.1, 0.1, 0.1), "Black", model)
    local eyeR = createPart("EyeR", Vector3.new(0.1, 0.1, 0.1), "Black", model)
    
    -- Сборка
    weldParts(body, headPart, CFrame.new(0, 0.3, 0.2))
    weldParts(headPart, beak, CFrame.new(0, 0.1, 0.15))
    weldParts(headPart, eyeL, CFrame.new(-0.1, 0.15, 0.1))
    weldParts(headPart, eyeR, CFrame.new(0.1, 0.15, 0.1))
    
    -- Сажаем на плечо (правое)
    weldParts(torso, body, CFrame.new(0.8, 0.3, 0) * CFrame.Angles(0, 0, 0.2))
    
    -- Анимация "птичка клюёт"
    local time = 0
    local animConnection
    animConnection = RunService.Heartbeat:Connect(function(dt)
        if not model.Parent then animConnection:Disconnect() return end
        time = time + dt
        
        if math.floor(time * 2) % 10 == 0 then  -- Каждые ~5 секунд
            -- Клюв открывается
            beak.Weld.C0 = CFrame.new(0, 0.1, 0.2) * CFrame.Angles(0.2, 0, 0)
            task.wait(0.1)
            beak.Weld.C0 = CFrame.new(0, 0.1, 0.15)
        end
    end)
    
    return model
end
function createRedCarpet(root)
    if not root then return nil end
    
    local model = createAccessoryModel("RedCarpet")
    
    -- Сама дорожка
    local carpet = createPart("Carpet", Vector3.new(3, 0.1, 10), "Bright red", model)
    carpet.Material = Enum.Material.Carpet
    
    -- Золотая окантовка
    local borderL = createPart("BorderL", Vector3.new(0.2, 0.2, 10), "Bright yellow", model)
    local borderR = createPart("BorderR", Vector3.new(0.2, 0.2, 10), "Bright yellow", model)
    local borderFront = createPart("BorderFront", Vector3.new(3, 0.2, 0.2), "Bright yellow", model)
    local borderBack = createPart("BorderBack", Vector3.new(3, 0.2, 0.2), "Bright yellow", model)
    
    weldParts(carpet, borderL, CFrame.new(-1.5, 0.1, 0))
    weldParts(carpet, borderR, CFrame.new(1.5, 0.1, 0))
    weldParts(carpet, borderFront, CFrame.new(0, 0.1, 5))
    weldParts(carpet, borderBack, CFrame.new(0, 0.1, -5))
    
    -- Прикрепляем к корню персонажа (платформа движется за игроком)
    weldParts(root, carpet, CFrame.new(0, -1, 0))
    
    return model
end
function createStand67(root)
    if not root then return nil end
    
    local model = createAccessoryModel("Stand67")
    
    -- Создаём простого человечка
    local head = createPart("Head", Vector3.new(0.5, 0.5, 0.5), "Bright yellow", model)
    local torso = createPart("Torso", Vector3.new(0.8, 1, 0.4), "Bright blue", model)
    local armL = createPart("ArmL", Vector3.new(0.3, 0.8, 0.3), "Bright yellow", model)
    local armR = createPart("ArmR", Vector3.new(0.3, 0.8, 0.3), "Bright yellow", model)
    local legL = createPart("LegL", Vector3.new(0.3, 0.8, 0.3), "Bright yellow", model)
    local legR = createPart("LegR", Vector3.new(0.3, 0.8, 0.3), "Bright yellow", model)
    
    -- Лицо
    local eyeL = createPart("EyeL", Vector3.new(0.1, 0.1, 0.1), "Black", model)
    local eyeR = createPart("EyeR", Vector3.new(0.1, 0.1, 0.1), "Black", model)
    local mouth = createPart("Mouth", Vector3.new(0.2, 0.05, 0.1), "Black", model)
    
    -- Сборка человечка
    weldParts(torso, head, CFrame.new(0, 0.8, 0))
    weldParts(head, eyeL, CFrame.new(-0.15, 0.1, 0.2))
    weldParts(head, eyeR, CFrame.new(0.15, 0.1, 0.2))
    weldParts(head, mouth, CFrame.new(0, -0.1, 0.2))
    
    weldParts(torso, armL, CFrame.new(-0.6, 0.3, 0))
    weldParts(torso, armR, CFrame.new(0.6, 0.3, 0))
    weldParts(torso, legL, CFrame.new(-0.3, -0.7, 0))
    weldParts(torso, legR, CFrame.new(0.3, -0.7, 0))
    
    -- Число 67 на груди
    local num6 = createPart("Num6", Vector3.new(0.1, 0.3, 0.1), "Black", model)
    local num7 = createPart("Num7", Vector3.new(0.1, 0.3, 0.1), "Black", model)
    weldParts(torso, num6, CFrame.new(-0.15, 0.1, 0.2))
    weldParts(torso, num7, CFrame.new(0.15, 0.1, 0.2))
    
    -- Размещаем рядом с игроком (справа)
    local standWeld = Instance.new("Weld")
    standWeld.Part0 = root
    standWeld.Part1 = torso
    standWeld.C0 = CFrame.new(3, 0, 0)  -- Стоит справа
    standWeld.Parent = torso
    
    return model
end
function createHeadPoop(head)
    if not head then return nil end
    
    local model = createAccessoryModel("HeadPoop")
    
    -- Какашка (спиралька)
    local colors = {"Brown", "Dark brown", "Reddish brown"}
    for i = 1, 3 do
        local part = createPart("Poop"..i, Vector3.new(0.4, 0.2, 0.4), colors[i], model)
        part.Material = Enum.Material.SmoothPlastic
        weldParts(head, part, CFrame.new(0, 0.3 + i*0.1, 0.1) * CFrame.Angles(0, 0, i*0.2))
    end
    
    return model
end

function createHeadKnife(head)
    if not head then return nil end
    
    local model = createAccessoryModel("HeadKnife")
    
    -- Лезвие
    local blade = createPart("Blade", Vector3.new(0.1, 0.8, 0.3), "Silver", model)
    blade.Material = Enum.Material.Metal
    
    -- Рукоятка
    local handle = createPart("Handle", Vector3.new(0.2, 0.3, 0.3), "Black", model)
    
    weldParts(blade, handle, CFrame.new(0, -0.5, 0))
    weldParts(head, blade, CFrame.new(0, 0.5, 0.3) * CFrame.Angles(0.3, 0, 0))
    
    return model
end

function createHeadDildo(head)
    if not head then return nil end
    
    local model = createAccessoryModel("HeadDildo")
    
    -- Резиновый (ярко-розовый)
    local base = createPart("Base", Vector3.new(0.5, 0.3, 0.5), "Hot pink", model)
    local shaft = createPart("Shaft", Vector3.new(0.4, 1.5, 0.4), "Bright pink", model)
    local tip = createPart("Tip", Vector3.new(0.5, 0.3, 0.5), "Bright red", model)
    
    shaft.Material = Enum.Material.Neon
    tip.Material = Enum.Material.Glass
    
    weldParts(base, shaft, CFrame.new(0, 0.9, 0))
    weldParts(shaft, tip, CFrame.new(0, 1, 0))
    weldParts(head, base, CFrame.new(0, 0.5, 0.3) * CFrame.Angles(0, 0, 0))
    
    return model
end

function createClownHair(head)
    if not head then return nil end
    
    local model = createAccessoryModel("ClownHair")
    
    -- Разноцветные шарики
    local colors = {"Bright red", "Bright blue", "Bright yellow", "Bright green", "Bright orange"}
    for i = 1, 5 do
        local ball = createPart("Hair"..i, Vector3.new(0.3, 0.3, 0.3), colors[i], model)
        ball.Shape = Enum.PartType.Ball
        weldParts(head, ball, CFrame.new(math.sin(i)*0.2, 0.3 + i*0.1, math.cos(i)*0.2))
    end
    
    return model
end

function createHeadLeaf(head)
    if not head then return nil end
    
    local model = createAccessoryModel("HeadLeaf")
    
    -- Листик
    local leaf = createPart("Leaf", Vector3.new(0.3, 0.1, 0.5), "Bright green", model)
    leaf.Material = Enum.Material.Grass
    
    -- Надпись "ЛОХ" (используем BillboardGui)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 2, 0, 1)
    billboard.StudsOffset = Vector3.new(0, 1, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = leaf
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "ЛОХ"
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Font = Enum.Font.GothamBlack
    text.TextSize = 8
    text.Parent = billboard
    
    weldParts(head, leaf, CFrame.new(0, 0.4, 0.2))
    
    return model
end
-- Добавьте ЭТОТ КОД в функцию createMainMenu (после accTitle)

local accCategories = {
    {"Крылья", {
        {"Ангельские", "Wings_Angel"},
        {"Адские", "Wings_Hell"},
        {"Петуха", "Wings_Rooster"},
        {"Самолёт", "Wings_Plane"}
    }},
    {"Голова", {
        {"Вращение", "Head_Spin"},
        {"Какашка", "Head_Poop"},
        {"Нож", "Head_Knife"},
        {"Дилдо", "Head_Dildo"},
        {"Волосы клоуна", "Head_ClownHair"},
        {"Листок ЛОХ", "Head_Leaf"}
    }},
    {"Разное", {
        {"Дилдо в попе", "Butt_Dildo"},
        {"Птичка на плече", "Bird_Shoulder"},
        {"Красная дорожка", "Platform_RedCarpet"},
        {"67 рядом", "Stand_67"},
        {"Нимб", "Halo"},
        {"Коляска", "Wheelchair"}
    }}
}

for _, cat in ipairs(accCategories) do
    -- Заголовок категории
    local catLabel = Instance.new("TextLabel")
    catLabel.Size = UDim2.new(1, -10, 0, 25)
    catLabel.BackgroundTransparency = 1
    catLabel.Text = "▶ " .. cat[1]
    catLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    catLabel.Font = Enum.Font.GothamSemibold
    catLabel.TextSize = 14
    catLabel.TextXAlignment = Enum.TextXAlignment.Left
    catLabel.Parent = container
    
    for _, acc in ipairs(cat[2]) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -30, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        btn.Text = acc[1] .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        -- Неоновая обводка
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 100, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0.7
        stroke.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            local newState = not Settings.Accessories[acc[2]]
            Settings.Accessories[acc[2]] = newState
            btn.Text = acc[1] .. ": " .. (newState and "ON" or "OFF")
            stroke.Thickness = newState and 2 or 1
            stroke.Color = newState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 255)
        end)
    end
end
-- ============================================
-- ЧАСТЬ 9.1: СКОРОСТИ ПОЛЁТА (1x, 3x, 5x, 7x)
-- ============================================

-- Добавьте ЭТОТ КОД в функцию createMainMenu (после поля скорости)

-- Рамка для кнопок скорости
local speedMultFrame = Instance.new("Frame")
speedMultFrame.Size = UDim2.new(1, -10, 0, 40)
speedMultFrame.BackgroundTransparency = 1
speedMultFrame.Parent = container

local multLabel = Instance.new("TextLabel")
multLabel.Size = UDim2.new(0, 60, 1, 0)
multLabel.BackgroundTransparency = 1
multLabel.Text = "Speed:"
multLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
multLabel.Font = Enum.Font.GothamSemibold
multLabel.TextSize = 14
multLabel.Parent = speedMultFrame

local mults = {1, 3, 5, 7}
local multButtons = {}

for i, mult in ipairs(mults) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 1, -4)
    btn.Position = UDim2.new(0, 60 + (i-1)*48, 0, 2)
    btn.BackgroundColor3 = (mult == 1) and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 70)
    btn.Text = mult .. "x"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = speedMultFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings.Flight.SpeedMultiplier = mult
        -- Обновляем цвета кнопок
        for _, b in ipairs(multButtons) do
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
    
    table.insert(multButtons, btn)
end

-- Обновим логику полёта, чтобы использовать множитель
-- (в функции flightLoop замените использование Settings.Flight.Speed на:
-- local currentSpeed = Settings.Flight.Speed * Settings.Flight.SpeedMultiplier
-- и используйте currentSpeed для движения)
-- ============================================
-- ЧАСТЬ 9.2: INVIS FLING (НЕВИДИМЫЙ РАЗБРОС)
-- ============================================

local invisFlingObjects = {}
local invisFlingConnection

function startInvisFling()
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Делаем игрока невидимым (если ещё не)
    if not Settings.Invis.Enabled then
        makeInvisible(true)
    end
    
    -- Находим все ближайшие объекты (игроки, части, модели)
    local function findNearbyObjects()
        local objects = {}
        local radius = 30  -- Радиус флинга
        
        -- Ищем других игроков
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local plrRoot = plr.Character.HumanoidRootPart
                local dist = (plrRoot.Position - root.Position).Magnitude
                if dist < radius then
                    table.insert(objects, plrRoot)
                end
            end
        end
        
        -- Ищем части в Workspace
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored == false and part ~= root then
                local dist = (part.Position - root.Position).Magnitude
                if dist < radius then
                    table.insert(objects, part)
                end
            end
        end
        
        return objects
    end
    
    -- Флинг-луп
    invisFlingConnection = RunService.Heartbeat:Connect(function()
        if not Settings.InvisFling.Enabled or not character then
            -- Останавливаем флинг
            if invisFlingConnection then
                invisFlingConnection:Disconnect()
                invisFlingConnection = nil
            end
            -- Удаляем все созданные BodyVelocity
            for obj, _ in pairs(invisFlingObjects) do
                if obj and obj.Parent then
                    local bv = obj:FindFirstChildOfClass("BodyVelocity")
                    if bv then bv:Destroy() end
                    local ba = obj:FindFirstChildOfClass("BodyAngularVelocity")
                    if ba then ba:Destroy() end
                end
            end
            invisFlingObjects = {}
            return
        end
        
        local objects = findNearbyObjects()
        local rootPos = root.Position
        
        for _, obj in ipairs(objects) do
            if not invisFlingObjects[obj] then
                -- Добавляем физику к объекту
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(4000, 4000, 4000)
                bv.P = 1250
                bv.Parent = obj
                
                local ba = Instance.new("BodyAngularVelocity")
                ba.MaxTorque = Vector3.new(4000, 4000, 4000)
                ba.AngularVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
                ba.P = 1250
                ba.Parent = obj
                
                invisFlingObjects[obj] = {bv = bv, ba = ba}
            end
            
            -- Кидаем объект от игрока
            local dir = (obj.Position - rootPos).Unit
            local force = dir * 100 + Vector3.new(0, 50, 0)  -- Вверх и в сторону
            
            if invisFlingObjects[obj] and invisFlingObjects[obj].bv then
                invisFlingObjects[obj].bv.Velocity = force
            end
        end
    end)
end

-- Кнопка для Invis Fling в меню
-- Добавьте в createMainMenu после остальных кнопок:
-- createNeonToggle("Invis Fling", "InvisFling", false)
-- и в обработчик клика добавляем запуск/остановку
-- ============================================
-- ЧАСТЬ 9.3: ФУНКЦИЯ "ДРОЧКА" (JACK OFF)
-- ============================================

local jackOffAnimation
local jackOffConnection

function startJackOff()
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
    local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftHand")
    
    if not humanoid or not root or not rightArm then return end
    
    -- Останавливаем обычные анимации
    humanoid.AutoRotate = false
    humanoid.PlatformStand = true
    
    -- Сохраняем оригинальные позиции рук
    local originalRightCF = rightArm.CFrame
    local originalLeftCF = leftArm and leftArm.CFrame
    
    -- Анимация движения рук
    local time = 0
    jackOffConnection = RunService.Heartbeat:Connect(function(dt)
        if not Settings.JackOff.Enabled or not character then
            -- Возвращаем всё как было
            if humanoid then
                humanoid.AutoRotate = true
                humanoid.PlatformStand = false
            end
            if jackOffConnection then
                jackOffConnection:Disconnect()
                jackOffConnection = nil
            end
            return
        end
        
        time = time + dt * 8  -- Скорость анимации
        
        -- Движение правой рукой вперёд-назад
        local armAngle = math.sin(time) * 1.5
        local armOffset = CFrame.Angles(armAngle, 0, 0) * CFrame.new(0, 0, math.sin(time) * 0.5)
        
        -- Применяем через CFrame (или через Motor6D если есть)
        local rightMotor = rightArm:FindFirstChildOfClass("Motor6D")
        if rightMotor then
            rightMotor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(armAngle, 0, 0)
        end
        
        -- Левая рука может быть на поясе или тоже двигаться
        if leftArm then
            local leftMotor = leftArm:FindFirstChildOfClass("Motor6D")
            if leftMotor then
                leftMotor.C0 = CFrame.new(-0.5, 0, 0) * CFrame.Angles(-0.5 + math.sin(time*0.5)*0.2, 0, 0)
            end
        end
        
        -- Лёгкое покачивание корпусом
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.sin(time*0.5)*0.1, 0)
        end
    end)
end

-- Кнопка для "Дрочки" в меню
-- Добавьте: createNeonToggle("Jack Off", "JackOff", false)
-- ============================================
-- ЧАСТЬ 9.4: INVISIBLE (НЕВИДИМОСТЬ)
-- ============================================

function makeInvisible(state)
    if not character then return end
    
    if state then
        -- Сохраняем прозрачность и делаем невидимым
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                Settings.Invis.OriginalTransparency[part] = part.Transparency
                part.Transparency = 1
                -- Также можно отключить CanTouch и CanQuery для полной невидимости
                part.CanTouch = false
                part.CanQuery = false
            end
        end
        
        -- Скрываем имя над головой
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    else
        -- Возвращаем прозрачность
        for part, origTrans in pairs(Settings.Invis.OriginalTransparency) do
            if part and part.Parent then
                part.Transparency = origTrans
                part.CanTouch = true
                part.CanQuery = true
            end
        end
        Settings.Invis.OriginalTransparency = {}
        
        -- Возвращаем имя
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end

-- Обработчик кнопки Invis
-- В createMainMenu: createNeonToggle("Invisible", "Invis", false)
-- И в клике:
-- Settings.Invis.Enabled = not Settings.Invis.Enabled
-- makeInvisible(Settings.Invis.Enabled)
-- ============================================
-- ЧАСТЬ 9.5: НАЖИМКА (AUTO CLICKER)
-- ============================================

local clickerTarget = nil
local clickerConnection

function startClicker(targetPlayer)
    if not character or not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    local myArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
    
    if not targetRoot or not myRoot or not myArm then return end
    
    -- Проверка дистанции
    local function getDistance()
        return (targetRoot.Position - myRoot.Position).Magnitude
    end
    
    -- Основной цикл "нажимки"
    clickerConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Clicker.Enabled or not targetPlayer or not targetPlayer.Character then
            if clickerConnection then
                clickerConnection:Disconnect()
                clickerConnection = nil
            end
            return
        end
        
        local dist = getDistance()
        
        if dist < 8 then  -- Если достаточно близко
            -- Анимация удара рукой
            if myArm then
                local motor = myArm:FindFirstChildOfClass("Motor6D")
                if motor then
                    -- Резкое движение вперёд
                    motor.C0 = CFrame.new(0.5, 0, -0.5) * CFrame.Angles(1.5, 0, 0)
                    task.wait(0.05)
                    motor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(0, 0, 0)
                end
            end
            
            -- Небольшой урон/эффект (опционально)
            -- Можно создать партиклы или звук
        else
            -- Слишком далеко, может быть сообщение
            if dist % 10 < 0.1 then  -- Раз в ~10 секунд
                player:Notify("Слишком далеко для нажимки!", 2)
            end
        end
    end)
end

-- Функция выбора цели через GUI
function selectClickerTarget()
    -- Создаём небольшое меню выбора игрока
    local targetFrame = Instance.new("Frame")
    targetFrame.Size = UDim2.new(0, 200, 0, 300)
    targetFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
    targetFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    targetFrame.BackgroundTransparency = 0.2
    targetFrame.BorderSizePixel = 0
    targetFrame.Parent = guiHolder
    targetFrame.ZIndex = 10
    
    local targetCorner = Instance.new("UICorner")
    targetCorner.CornerRadius = UDim.new(0, 10)
    targetCorner.Parent = targetFrame
    
    local targetTitle = Instance.new("TextLabel")
    targetTitle.Size = UDim2.new(1, 0, 0, 40)
    targetTitle.BackgroundTransparency = 1
    targetTitle.Text = "Выбери цель для нажимки"
    targetTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
    targetTitle.Font = Enum.Font.GothamBold
    targetTitle.TextSize = 16
    targetTitle.Parent = targetFrame
    
    local targetList = Instance.new("ScrollingFrame")
    targetList.Size = UDim2.new(1, -20, 1, -70)
    targetList.Position = UDim2.new(0, 10, 0, 45)
    targetList.BackgroundTransparency = 1
    targetList.ScrollBarThickness = 4
    targetList.CanvasSize = UDim2.new(0, 0, 0, 0)
    targetList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    targetList.Parent = targetFrame
    
    local targetLayout = Instance.new("UIListLayout")
    targetLayout.Padding = UDim.new(0, 5)
    targetLayout.Parent = targetList
    
    -- Добавляем всех игроков
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.Parent = targetList
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                Settings.Clicker.Target = plr
                Settings.Clicker.Enabled = true
                startClicker(plr)
                targetFrame:Destroy()
                player:Notify("Цель выбрана: " .. plr.Name, 2)
            end)
        end
    end
    
    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(1, -20, 0, 35)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.Text = "Закрыть"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 14
    closeBtn.Parent = targetFrame
    closeBtn.Position = UDim2.new(0, 10, 1, -45)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        targetFrame:Destroy()
    end)
end

-- В меню добавим кнопку для нажимки
-- createNeonToggle("Clicker", "Clicker", false)
-- но с дополнительным действием:
-- btn.MouseButton1Click:Connect(function()
--     if not Settings.Clicker.Enabled then
--         selectClickerTarget()
--     else
--         Settings.Clicker.Enabled = false
--     end
-- end)
-- ============================================
-- ЧАСТЬ 10: ФИНАЛЬНАЯ СБОРКА
-- ============================================

-- Добавляем кнопки для новых функций в createMainMenu
-- (вставьте это в соответствующие места)

-- После существующих кнопок (Flight, Noclip, ESP)
createNeonToggle("Invisible", "Invis", false)
createNeonToggle("Invis Fling", "InvisFling", false)
createNeonToggle("Jack Off", "JackOff", false)

-- Отдельная кнопка для Clicker (с выбором цели)
local clickerBtn = Instance.new("TextButton")
clickerBtn.Size = UDim2.new(1, -10, 0, 45)
clickerBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
clickerBtn.Text = "Clicker: OFF (выбрать цель)"
clickerBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
clickerBtn.Font = Enum.Font.GothamSemibold
clickerBtn.TextSize = 16
clickerBtn.Parent = container

local clickerCorner = Instance.new("UICorner")
clickerCorner.CornerRadius = UDim.new(0, 10)
clickerCorner.Parent = clickerBtn

local clickerStroke = Instance.new("UIStroke")
clickerStroke.Color = Color3.fromRGB(0, 255, 255)
clickerStroke.Thickness = 1
clickerStroke.Transparency = 0.7
clickerStroke.Parent = clickerBtn

clickerBtn.MouseButton1Click:Connect(function()
    if not Settings.Clicker.Enabled then
        selectClickerTarget()
        clickerBtn.Text = "Clicker: ON (выбрана цель)"
        clickerStroke.Thickness = 2
        clickerStroke.Color = Color3.fromRGB(0, 255, 0)
    else
        Settings.Clicker.Enabled = false
        clickerBtn.Text = "Clicker: OFF (выбрать цель)"
        clickerStroke.Thickness = 1
        clickerStroke.Color = Color3.fromRGB(0, 255, 255)
    end
end)

-- Обновляем основной цикл для всех функций
RunService.Heartbeat:Connect(function()
    character = player.Character or character
    
    -- Flight (с учётом множителя скорости)
    if Settings.Flight.Enabled then
        -- Здесь код полёта (из предыдущих частей)
        -- Используем Settings.Flight.Speed * Settings.Flight.SpeedMultiplier
    end
    
    -- Invisible
    if Settings.Invis.Enabled then
        makeInvisible(true)
    else
        makeInvisible(false)
    end
    
    -- Invis Fling
    if Settings.InvisFling.Enabled then
        if not invisFlingConnection then
            startInvisFling()
        end
    end
    
    -- Jack Off
    if Settings.JackOff.Enabled then
        if not jackOffConnection then
            startJackOff()
        end
    end
    
    -- Noclip
    if Settings.Noclip.Enabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Speed Hack
    if Settings.SpeedHack.Enabled and character then
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Settings.SpeedHack.WalkSpeed
            hum.JumpPower = Settings.SpeedHack.JumpPower
        end
    end
    
    -- Accessories
    updateAccessories()
end)

-- Уведомление о загрузке
StarterGui:SetCore("SendNotification", {
    Title = "Zack_Hub v1.0",
    Text = "Космический хаб загружен! Жми на петуха.",
    Icon = "rbxassetid://6031107863",
    Duration = 5
})

print("ZACK HUB v1.0 АКТИВИРОВАН. Слава DEV-MASTERу!")
