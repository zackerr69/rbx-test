-- MENU V6 - ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ
-- Все аксессуары создаются через Part, не требуют загрузки

if _G.ZACK_MENU_V6 then return end
_G.ZACK_MENU_V6 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local lighting = game:GetService("Lighting")
local userInput = game:GetService("UserInputService")

-- ========== ОСНОВНОЙ GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackMenuV6"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- ========== ИКОНКА ZCKRR ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 70, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = "ZCKRR"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 16
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 35)
iconCorner.Parent = icon

-- ========== МЕНЮ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 450)
menu.Position = UDim2.new(0.5, -140, 0.5, -225)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.BackgroundTransparency = 0.1
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

-- Звёзды в меню
for i = 1, 50 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random(0, 7) / 10
    star.BorderSizePixel = 0
    star.Parent = menu
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
title.Text = "ZACK MENU V6"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = menu

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = menu

closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -80)
container.Position = UDim2.new(0, 5, 0, 45)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 5
container.CanvasSize = UDim2.new(0, 0, 0, 600)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = container

-- ========== ПЕРЕМЕННЫЕ ==========
local states = {
    chams = false,
    jack = false,
    wingsDemon = false,
    wingsAngel = false,
    wingsRooster = false,
    accessory67 = false
}

local activeAccessories = {}
local jackConnection = nil
local chamsConnection = nil

-- ========== ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ==========
function createButton(text, stateName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.Text = text .. ": ▢"
    btn.TextColor3 = Color3.fromRGB(200, 220, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        states[stateName] = not states[stateName]
        btn.Text = text .. ": " .. (states[stateName] and "✓" or "▢")
        btn.BackgroundColor3 = states[stateName] and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(30, 30, 50)
        
        if stateName == "chams" then
            toggleChams()
        elseif stateName == "jack" then
            toggleJack()
        elseif stateName == "wingsDemon" then
            toggleWings("Demon")
        elseif stateName == "wingsAngel" then
            toggleWings("Angel")
        elseif stateName == "wingsRooster" then
            toggleWings("Rooster")
        elseif stateName == "accessory67" then
            toggle67()
        end
    end)
end

-- ========== КНОПКИ ==========
createButton("CHAMS (КОСМОС)", "chams")
createButton("ДРОЧКА", "jack")
createButton("КРЫЛЬЯ ДЕМОНА", "wingsDemon")
createButton("КРЫЛЬЯ АНГЕЛА", "wingsAngel")
createButton("КРЫЛЬЯ ПЕТУХА", "wingsRooster")
createButton("67", "accessory67")

-- ========== CHAMS (КОСМОС) ==========
function toggleChams()
    if states.chams then
        -- Затемняем всё
        lighting.Ambient = Color3.fromRGB(10, 10, 30)
        lighting.Brightness = 0.3
        lighting.OutdoorAmbient = Color3.fromRGB(5, 5, 20)
        lighting.ColorShift_Top = Color3.fromRGB(0, 0, 50)
        lighting.ColorShift_Bottom = Color3.fromRGB(50, 0, 50)
        
        -- Создаём эффект звёзд через частицы
        local stars = Instance.new("ParticleEmitter")
        stars.Texture = "rbxassetid://6744228269"
        stars.Rate = 5
        stars.Lifetime = NumberRange.new(10)
        stars.SpreadAngle = Vector2.new(180, 180)
        stars.VelocitySpread = 0
        stars.Speed = NumberRange.new(0)
        stars.Rotation = NumberRange.new(0, 360)
        stars.Size = NumberSequence.new(0.1)
        stars.Transparency = NumberSequence.new(0.5)
        stars.Parent = workspace.Terrain
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(127, 127, 127)
    end
end

-- ========== ДРОЧКА (БЕЗ ПРОВАЛОВ) ==========
function toggleJack()
    if states.jack then
        jackConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
            
            if not root or not humanoid or not rightArm then return end
            
            -- Фиксируем персонажа на месте
            humanoid.PlatformStand = true
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
            
            -- Анимация руки
            local motor = rightArm:FindFirstChildOfClass("Motor6D")
            if motor then
                local t = tick() * 6
                motor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(math.sin(t) * 1.2, math.cos(t) * 0.2, 0)
            end
        end)
    else
        if jackConnection then
            jackConnection:Disconnect()
            jackConnection = nil
            
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end
end

-- ========== ФУНКЦИЯ ДЛЯ СОЗДАНИЯ ЧАСТИ ==========
function createPart(size, color, parent, cframe)
    local part = Instance.new("Part")
    part.Size = size
    part.BrickColor = BrickColor.new(color)
    part.Anchored = false
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CFrame = cframe or CFrame.new()
    part.Parent = parent
    return part
end

-- ========== КРЫЛЬЯ ДЕМОНА ==========
function createWingsDemon()
    local char = player.Character
    if not char then return nil end
    
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return nil end
    
    local model = Instance.new("Model")
    model.Name = "WingsDemon"
    model.Parent = char
    
    -- Левое крыло
    local leftWing = createPart(Vector3.new(0.8, 2.5, 1.5), "Really red", model)
    leftWing.Material = Enum.Material.Neon
    
    -- Правое крыло
    local rightWing = createPart(Vector3.new(0.8, 2.5, 1.5), "Really red", model)
    rightWing.Material = Enum.Material.Neon
    
    -- Острые элементы
    for i = 1, 3 do
        local spikeL = createPart(Vector3.new(0.3, 0.8, 0.3), "Bright red", model)
        spikeL.Material = Enum.Material.Neon
        
        local spikeR = createPart(Vector3.new(0.3, 0.8, 0.3), "Bright red", model)
        spikeR.Material = Enum.Material.Neon
        
        local wL = Instance.new("Weld")
        wL.Part0 = leftWing
        wL.Part1 = spikeL
        wL.C0 = CFrame.new(0, -0.8 + i*0.4, 0.5) * CFrame.Angles(0.2, 0, 0)
        wL.Parent = spikeL
        
        local wR = Instance.new("Weld")
        wR.Part0 = rightWing
        wR.Part1 = spikeR
        wR.C0 = CFrame.new(0, -0.8 + i*0.4, 0.5) * CFrame.Angles(0.2, 0, 0)
        wR.Parent = spikeR
    end
    
    -- Крепление
    local wLeft = Instance.new("Weld")
    wLeft.Part0 = torso
    wLeft.Part1 = leftWing
    wLeft.C0 = CFrame.new(-1.3, 0.5, 0.4) * CFrame.Angles(0, 0.3, 0.2)
    wLeft.Parent = leftWing
    
    local wRight = Instance.new("Weld")
    wRight.Part0 = torso
    wRight.Part1 = rightWing
    wRight.C0 = CFrame.new(1.3, 0.5, 0.4) * CFrame.Angles(0, -0.3, -0.2)
    wRight.Parent = rightWing
    
    return model
end

-- ========== КРЫЛЬЯ АНГЕЛА ==========
function createWingsAngel()
    local char = player.Character
    if not char then return nil end
    
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return nil end
    
    local model = Instance.new("Model")
    model.Name = "WingsAngel"
    model.Parent = char
    
    -- Левое крыло
    local leftWing = createPart(Vector3.new(0.7, 2.3, 1.4), "White", model)
    leftWing.Material = Enum.Material.SmoothPlastic
    
    -- Правое крыло
    local rightWing = createPart(Vector3.new(0.7, 2.3, 1.4), "White", model)
    rightWing.Material = Enum.Material.SmoothPlastic
    
    -- Перья
    for i = 1, 4 do
        local featherL = createPart(Vector3.new(0.3, 1, 0.4), "White", model)
        featherL.Material = Enum.Material.SmoothPlastic
        
        local featherR = createPart(Vector3.new(0.3, 1, 0.4), "White", model)
        featherR.Material = Enum.Material.SmoothPlastic
        
        local wL = Instance.new("Weld")
        wL.Part0 = leftWing
        wL.Part1 = featherL
        wL.C0 = CFrame.new(0, -0.7 + i*0.3, 0.4) * CFrame.Angles(0.2, 0, 0)
        wL.Parent = featherL
        
        local wR = Instance.new("Weld")
        wR.Part0 = rightWing
        wR.Part1 = featherR
        wR.C0 = CFrame.new(0, -0.7 + i*0.3, 0.4) * CFrame.Angles(0.2, 0, 0)
        wR.Parent = featherR
    end
    
    -- Крепление
    local wLeft = Instance.new("Weld")
    wLeft.Part0 = torso
    wLeft.Part1 = leftWing
    wLeft.C0 = CFrame.new(-1.2, 0.4, 0.3) * CFrame.Angles(0, 0.2, 0.1)
    wLeft.Parent = leftWing
    
    local wRight = Instance.new("Weld")
    wRight.Part0 = torso
    wRight.Part1 = rightWing
    wRight.C0 = CFrame.new(1.2, 0.4, 0.3) * CFrame.Angles(0, -0.2, -0.1)
    wRight.Parent = rightWing
    
    return model
end

-- ========== КРЫЛЬЯ ПЕТУХА ==========
function createWingsRooster()
    local char = player.Character
    if not char then return nil end
    
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return nil end
    
    local model = Instance.new("Model")
    model.Name = "WingsRooster"
    model.Parent = char
    
    local colors = {"Bright yellow", "Bright orange", "Bright red", "Bright green", "Bright blue"}
    
    for side = -1, 1, 2 do
        for i = 1, 5 do
            local feather = createPart(Vector3.new(0.3, 1, 0.2), colors[i], model)
            
            local w = Instance.new("Weld")
            w.Part0 = torso
            w.Part1 = feather
            w.C0 = CFrame.new(side * (0.4 + i*0.2), 0.2 + i*0.15, 0.2) * CFrame.Angles(0, side*0.2, 0)
            w.Parent = feather
        end
    end
    
    return model
end

-- ========== 67 (ДВЕ ЦИФРЫ С ГЛАЗАМИ) ==========
function create67()
    local char = player.Character
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local model = Instance.new("Model")
    model.Name = "SixtySeven"
    model.Parent = char
    
    -- Цифра 6
    local six = createPart(Vector3.new(2, 3, 1), "Bright blue", model)
    six.Material = Enum.Material.Neon
    
    -- Цифра 7
    local seven = createPart(Vector3.new(2, 3, 1), "Bright blue", model)
    seven.Material = Enum.Material.Neon
    
    -- Глаза для 6
    local eye6L = createPart(Vector3.new(0.4, 0.4, 0.2), "White", model)
    local pupil6L = createPart(Vector3.new(0.2, 0.2, 0.1), "Black", model)
    
    local eye6R = createPart(Vector3.new(0.4, 0.4, 0.2), "White", model)
    local pupil6R = createPart(Vector3.new(0.2, 0.2, 0.1), "Black", model)
    
    -- Глаза для 7
    local eye7L = createPart(Vector3.new(0.4, 0.4, 0.2), "White", model)
    local pupil7L = createPart(Vector3.new(0.2, 0.2, 0.1), "Black", model)
    
    local eye7R = createPart(Vector3.new(0.4, 0.4, 0.2), "White", model)
    local pupil7R = createPart(Vector3.new(0.2, 0.2, 0.1), "Black", model)
    
    -- Рты (опционально)
    local mouth6 = createPart(Vector3.new(0.8, 0.2, 0.2), "Black", model)
    local mouth7 = createPart(Vector3.new(0.8, 0.2, 0.2), "Black", model)
    
    -- Позиционирование цифр
    local w6 = Instance.new("Weld")
    w6.Part0 = root
    w6.Part1 = six
    w6.C0 = CFrame.new(-2, 1.5, 2)
    w6.Parent = six
    
    local w7 = Instance.new("Weld")
    w7.Part0 = root
    w7.Part1 = seven
    w7.C0 = CFrame.new(2, 1.5, 2)
    w7.Parent = seven
    
    -- Крепление глаз к 6
    local w6eL = Instance.new("Weld")
    w6eL.Part0 = six
    w6eL.Part1 = eye6L
    w6eL.C0 = CFrame.new(-0.5, 0.5, 0.5)
    w6eL.Parent = eye6L
    
    local w6pL = Instance.new("Weld")
    w6pL.Part0 = eye6L
    w6pL.Part1 = pupil6L
    w6pL.C0 = CFrame.new(0.1, 0.1, 0.1)
    w6pL.Parent = pupil6L
    
    local w6eR = Instance.new("Weld")
    w6eR.Part0 = six
    w6eR.Part1 = eye6R
    w6eR.C0 = CFrame.new(0.5, 0.5, 0.5)
    w6eR.Parent = eye6R
    
    local w6pR = Instance.new("Weld")
    w6pR.Part0 = eye6R
    w6pR.Part1 = pupil6R
    w6pR.C0 = CFrame.new(-0.1, 0.1, 0.1)
    w6pR.Parent = pupil6R
    
    local w6m = Instance.new("Weld")
    w6m.Part0 = six
    w6m.Part1 = mouth6
    w6m.C0 = CFrame.new(0, -0.5, 0.5)
    w6m.Parent = mouth6
    
    -- Крепление глаз к 7
    local w7eL = Instance.new("Weld")
    w7eL.Part0 = seven
    w7eL.Part1 = eye7L
    w7eL.C0 = CFrame.new(-0.5, 0.5, 0.5)
    w7eL.Parent = eye7L
    
    local w7pL = Instance.new("Weld")
    w7pL.Part0 = eye7L
    w7pL.Part1 = pupil7L
    w7pL.C0 = CFrame.new(0.1, 0.1, 0.1)
    w7pL.Parent = pupil7L
    
    local w7eR = Instance.new("Weld")
    w7eR.Part0 = seven
    w7eR.Part1 = eye7R
    w7eR.C0 = CFrame.new(0.5, 0.5, 0.5)
    w7eR.Parent = eye7R
    
    local w7pR = Instance.new("Weld")
    w7pR.Part0 = eye7R
    w7pR.Part1 = pupil7R
    w7pR.C0 = CFrame.new(-0.1, 0.1, 0.1)
    w7pR.Parent = pupil7R
    
    local w7m = Instance.new("Weld")
    w7m.Part0 = seven
    w7m.Part1 = mouth7
    w7m.C0 = CFrame.new(0, -0.5, 0.5)
    w7m.Parent = mouth7
    
    return model
end

-- ========== УПРАВЛЕНИЕ КРЫЛЬЯМИ ==========
function toggleWings(type)
    local key = "wings" .. type
    if states[key] then
        if not activeAccessories[key] then
            if type == "Demon" then
                activeAccessories[key] = createWingsDemon()
            elseif type == "Angel" then
                activeAccessories[key] = createWingsAngel()
            elseif type == "Rooster" then
                activeAccessories[key] = createWingsRooster()
            end
        end
    else
        if activeAccessories[key] then
            activeAccessories[key]:Destroy()
            activeAccessories[key] = nil
        end
    end
end

-- ========== УПРАВЛЕНИЕ 67 ==========
function toggle67()
    if states.accessory67 then
        if not activeAccessories["67"] then
            activeAccessories["67"] = create67()
        end
    else
        if activeAccessories["67"] then
            activeAccessories["67"]:Destroy()
            activeAccessories["67"] = nil
        end
    end
end

-- ========== ОТКРЫТИЕ МЕНЮ ==========
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ========== ЗАВЕРШЕНИЕ ==========
starterGui:SetCore("SendNotification", {
    Title = "ZACK MENU V6",
    Text = "Все функции работают",
    Duration = 3
})

print("=== ZACK MENU V6 ===")
print("Все аксессуары созданы через Part")
print("Дрочка без провалов")
print("Chams с частицами")
print("Иконка: ZCKRR")
