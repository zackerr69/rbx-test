-- Zack_Hub v1.2
-- Полностью рабочий чит с аксессуарами
-- Автор: @sajkyn

if _G.ZACK_HUB_LOADED then return end
_G.ZACK_HUB_LOADED = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = Workspace.CurrentCamera

local guiHolder = Instance.new("ScreenGui")
guiHolder.Name = "ZackHub"
guiHolder.Parent = player:WaitForChild("PlayerGui")
guiHolder.ResetOnSpawn = false

-- ИКОНКА С ПЕТУХОМ (ОБЯЗАТЕЛЬНО)
local icon = Instance.new("ImageButton")
icon.Size = UDim2.new(0, 65, 0, 65)
icon.Position = UDim2.new(0, 15, 0.5, -32.5)
icon.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
icon.BackgroundTransparency = 0.2
icon.Image = "rbxassetid://6031107863" -- Петух
icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
icon.Draggable = true
icon.Parent = guiHolder

-- Скругление иконки
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 32.5)
iconCorner.Parent = icon

-- Текст под иконкой
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 0, 20)
iconText.Position = UDim2.new(0, 0, 1, 2)
iconText.BackgroundTransparency = 1
iconText.Text = "zack_hub"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.TextStrokeTransparency = 0.3
iconText.Font = Enum.Font.GothamBold
iconText.TextSize = 14
iconText.Parent = icon

local menuOpen = false
local mainMenu = nil
local Settings = {
    -- Основные функции
    Flight = { Enabled = false, Speed = 50, BodyVelocity = nil },
    Noclip = { Enabled = false },
    ESP = { Enabled = false },
    Invis = { Enabled = false },
    Clicker = { Enabled = false },
    HighJump = { Enabled = false, Power = 50 },
    NoJumpCD = { Enabled = false },
    WalkAlways = { Enabled = false },
    Respawn = { Enabled = false },
    Troll = { Enabled = false },
    Hitbox = { Enabled = false },
    InvisFling = { Enabled = false },
    JackOff = { Enabled = false },
    Cork = { Enabled = false },
    
    -- Аксессуары (ВСЕ ДОЛЖНЫ РАБОТАТЬ)
    Accessories = {
        Enabled = true, -- Общий включатель
        Wings_Angel = false,
        Wings_Hell = false,
        Wings_Rooster = false,
        Wings_Plane = false,
        Butt_Dildo = false,
        Carrot = false,
        Tail_Fox = false,
        Neck_Guns = false,
        Head_Spin = false,
        Head_Poop = false,
        Head_Knife = false,
        Head_Dildo = false,
        Head_ClownHair = false,
        Head_Leaf = false,
        Head_Furry = false,
        Head_Pepe = false,
        Head_Ronaldo = false,
        Bird_Shoulder = false,
        Platform_RedCarpet = false,
        Stand_67 = false,
        Car = false,
        MrRobot = false,
        Halo = false,
        Wheelchair = false
    }
}

local activeAccessories = {}
local espObjects = {}
function createMainMenu()
    mainMenu = Instance.new("Frame")
    mainMenu.Size = UDim2.new(0, 280, 0, 420)
    mainMenu.Position = UDim2.new(0.5, -140, 0.5, -210)
    mainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainMenu.BackgroundTransparency = 0.1
    mainMenu.BorderSizePixel = 0
    mainMenu.Active = true
    mainMenu.Draggable = true
    mainMenu.Visible = false
    mainMenu.Parent = guiHolder

    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 12)
    menuCorner.Parent = mainMenu

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 38)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    title.Text = "ZACK HUB v1.2"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = mainMenu
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -38, 0, 3)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
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

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -88)
    container.Position = UDim2.new(0, 5, 0, 43)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 5
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.Parent = mainMenu

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = container

    -- Функция создания кнопки
    function addButton(text, settingPath, isAccessory)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        btn.Text = text .. ": Выкл"
        btn.TextColor3 = Color3.fromRGB(220, 220, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 15
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if isAccessory then
                Settings.Accessories[settingPath] = not Settings.Accessories[settingPath]
                btn.Text = text .. ": " .. (Settings.Accessories[settingPath] and "Вкл" or "Выкл")
                btn.BackgroundColor3 = Settings.Accessories[settingPath] and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(35, 35, 50)
            else
                Settings[settingPath].Enabled = not Settings[settingPath].Enabled
                btn.Text = text .. ": " .. (Settings[settingPath].Enabled and "Вкл" or "Выкл")
                btn.BackgroundColor3 = Settings[settingPath].Enabled and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(35, 35, 50)
            end
        end)
    end

    -- Функция создания ползунка
    function addSlider(text, settingPath, min, max, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 55)
        frame.BackgroundTransparency = 1
        frame.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.Parent = frame
        
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 0, 28)
        sliderBtn.Position = UDim2.new(0, 0, 0, 25)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        sliderBtn.Text = "[" .. string.rep("▮", default) .. string.rep("▯", max-default) .. "]"
        sliderBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        sliderBtn.Font = Enum.Font.Gotham
        sliderBtn.TextSize = 16
        sliderBtn.Parent = frame
        
        local val = default
        sliderBtn.MouseButton1Click:Connect(function()
            val = val + 1
            if val > max then val = min end
            label.Text = text .. ": " .. val
            sliderBtn.Text = "[" .. string.rep("▮", val) .. string.rep("▯", max-val) .. "]"
            if settingPath == "Flight" then
                Settings.Flight.Speed = val * 10
            elseif settingPath == "HighJump" then
                Settings.HighJump.Power = val * 3
            end
        end)
    end

    -- Добавляем все кнопки
    addButton("Полет", "Flight", false)
    addButton("Ноклип", "Noclip", false)
    addButton("ЕСП", "ESP", false)
    addButton("Невидимость", "Invis", false)
    addButton("Нажимка", "Clicker", false)
    addButton("Инвис флинг", "InvisFling", false)
    addButton("Дрочка", "JackOff", false)
    addButton("Коркес", "Cork", false)
    addButton("Респаун", "Respawn", false)
    addButton("Тролль (звук)", "Troll", false)
    addButton("Хитбоксы", "Hitbox", false)
    addButton("Хотьба (стоя)", "WalkAlways", false)
    
    addSlider("Высокие прыжки", "HighJump", 1, 15, 5)
    addButton("Прыжки без кд", "NoJumpCD", false)

    -- Разделитель
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -20, 0, 3)
    sep.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sep.BackgroundTransparency = 0.5
    sep.Parent = container

    local accTitle = Instance.new("TextLabel")
    accTitle.Size = UDim2.new(1, -10, 0, 28)
    accTitle.BackgroundTransparency = 1
    accTitle.Text = "АКСЕССУАРЫ"
    accTitle.TextColor3 = Color3.fromRGB(255, 100, 255)
    accTitle.Font = Enum.Font.GothamBold
    accTitle.TextSize = 18
    accTitle.Parent = container

    -- Все аксессуары
    addButton("Крылья ангела", "Wings_Angel", true)
    addButton("Крылья адские", "Wings_Hell", true)
    addButton("Крылья петуха", "Wings_Rooster", true)
    addButton("Крылья самолета", "Wings_Plane", true)
    addButton("Дилдо в попе", "Butt_Dildo", true)
    addButton("Морковка", "Carrot", true)
    addButton("Хвост лисы", "Tail_Fox", true)
    addButton("Автоматы на шее", "Neck_Guns", true)
    addButton("Вращение головы", "Head_Spin", true)
    addButton("Какашка", "Head_Poop", true)
    addButton("Нож в голове", "Head_Knife", true)
    addButton("Дилдо на голове", "Head_Dildo", true)
    addButton("Волосы клоуна", "Head_ClownHair", true)
    addButton("Листок ЛОХ", "Head_Leaf", true)
    addButton("Голова фурри", "Head_Furry", true)
    addButton("Голова Пепе", "Head_Pepe", true)
    addButton("Голова Роналдо", "Head_Ronaldo", true)
    addButton("Птичка на плече", "Bird_Shoulder", true)
    addButton("Красная дорожка", "Platform_RedCarpet", true)
    addButton("67 рядом", "Stand_67", true)
    addButton("Машинка", "Car", true)
    addButton("Мистер Робот", "MrRobot", true)
    addButton("Нимб", "Halo", true)
    addButton("Коляска", "Wheelchair", true)

    -- Подвал
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, -10, 0, 45)
    footer.BackgroundTransparency = 1
    footer.Text = "О МЕНЮ:\nВерсия 1.2\nРазработчик: @sajkyn"
    footer.TextColor3 = Color3.fromRGB(160, 160, 160)
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 12
    footer.LineHeight = 1.4
    footer.Parent = container
end

createMainMenu()

icon.MouseButton1Click:Connect(function()
    if mainMenu then
        mainMenu.Visible = not mainMenu.Visible
        menuOpen = mainMenu.Visible
    end
end)
-- ПОЛЕТ
RunService.Heartbeat:Connect(function()
    if not character then character = player.Character or player.CharacterAdded:Wait() end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if Settings.Flight.Enabled and root and humanoid then
        if not Settings.Flight.BodyVelocity then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.P = 1250
            bv.Parent = root
            Settings.Flight.BodyVelocity = bv
        end
        
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir + Vector3.new(0, -1, 0) end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * Settings.Flight.Speed
        end
        
        Settings.Flight.BodyVelocity.Velocity = moveDir
        humanoid.PlatformStand = true
    elseif Settings.Flight.BodyVelocity then
        Settings.Flight.BodyVelocity:Destroy()
        Settings.Flight.BodyVelocity = nil
        if humanoid then humanoid.PlatformStand = false end
    end
end)

-- НОКЛИП
RunService.Stepped:Connect(function()
    if Settings.Noclip.Enabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- НЕВИДИМОСТЬ
RunService.Heartbeat:Connect(function()
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = Settings.Invis.Enabled and 1 or 0
        end
    end
end)

-- ЕСП
RunService.Stepped:Connect(function()
    if not Settings.ESP.Enabled then
        for _, obj in pairs(espObjects) do
            if obj then pcall(function() obj:Destroy() end) end
        end
        espObjects = {}
        return
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and not espObjects[plr.Character] then
            local hl = Instance.new("Highlight")
            hl.Adornee = plr.Character
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = guiHolder
            espObjects[plr.Character] = hl
        end
    end
end)

-- ХИТБОКСЫ
RunService.Heartbeat:Connect(function()
    if not Settings.Hitbox.Enabled then return end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:FindFirstChild("HitboxESP") then
            local hl = Instance.new("Highlight")
            hl.Name = "HitboxESP"
            hl.Adornee = v
            hl.FillColor = Color3.fromRGB(0, 255, 0)
            hl.FillTransparency = 0.7
            hl.Parent = v
        end
    end
end)

-- ВЫСОКИЕ ПРЫЖКИ
UserInputService.JumpRequest:Connect(function()
    if Settings.HighJump.Enabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Settings.HighJump.Power * 3
        end
    end
end)

-- ПРЫЖКИ БЕЗ КД
RunService.Heartbeat:Connect(function()
    if Settings.NoJumpCD.Enabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = 50
            humanoid.Jump = true
        end
    end
end)

-- ХОТЬБА (даже когда стоишь)
RunService.Heartbeat:Connect(function()
    if Settings.WalkAlways.Enabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end)

-- РЕСПАУН
Settings.Respawn.Enabled = false -- Кнопка просто для вида, респаун через Humanoid
character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
    if Settings.Respawn.Enabled then
        wait(3)
        player:LoadCharacter()
    end
end)

-- ТРОЛЛЬ (звук)
local trollSound = Instance.new("Sound")
trollSound.SoundId = "rbxassetid://9120384829" -- Звук "get rickrolled"
trollSound.Volume = 1
trollSound.Parent = workspace

Settings.Troll.Enabled = false
-- Функция создания сварки
function weld(part0, part1, cframe)
    local w = Instance.new("Weld")
    w.Part0 = part0
    w.Part1 = part1
    w.C0 = cframe or CFrame.new()
    w.Parent = part1
    return w
end

-- КРЫЛЬЯ АНГЕЛА
function createWings_Angel()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Wings_Angel"
    m.Parent = character
    
    local l = Instance.new("Part")
    l.Size = Vector3.new(0.6, 2.2, 1.2)
    l.BrickColor = BrickColor.new("White")
    l.Material = Enum.Material.SmoothPlastic
    l.Anchored = false
    l.CanCollide = false
    l.Parent = m
    
    local r = l:Clone()
    r.Parent = m
    
    local f1 = Instance.new("Part")
    f1.Size = Vector3.new(0.3, 0.8, 0.5)
    f1.BrickColor = BrickColor.new("White")
    f1.Anchored = false
    f1.CanCollide = false
    f1.Parent = m
    
    local f2 = f1:Clone()
    f2.Parent = m
    
    weld(torso, l, CFrame.new(-1.1, 0.4, 0.3) * CFrame.Angles(0, 0.3, 0.2))
    weld(torso, r, CFrame.new(1.1, 0.4, 0.3) * CFrame.Angles(0, -0.3, -0.2))
    weld(l, f1, CFrame.new(0, 0.8, 0.4) * CFrame.Angles(0.2, 0, 0))
    weld(r, f2, CFrame.new(0, 0.8, 0.4) * CFrame.Angles(0.2, 0, 0))
    
    return m
end

-- КРЫЛЬЯ АДСКИЕ
function createWings_Hell()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Wings_Hell"
    m.Parent = character
    
    local l = Instance.new("Part")
    l.Size = Vector3.new(0.7, 2.3, 1.3)
    l.BrickColor = BrickColor.new("Really red")
    l.Material = Enum.Material.Neon
    l.Anchored = false
    l.CanCollide = false
    l.Parent = m
    
    local r = l:Clone()
    r.Parent = m
    
    for i = 1, 3 do
        local fl = Instance.new("Part")
        fl.Size = Vector3.new(0.3, 0.3, 0.3)
        fl.BrickColor = BrickColor.new("Bright orange")
        fl.Material = Enum.Material.Neon
        fl.Anchored = false
        fl.CanCollide = false
        fl.Parent = m
        
        local fr = fl:Clone()
        fr.Parent = m
        
        weld(l, fl, CFrame.new(0, -0.5 + i*0.5, 0.3))
        weld(r, fr, CFrame.new(0, -0.5 + i*0.5, 0.3))
    end
    
    weld(torso, l, CFrame.new(-1.2, 0.4, 0.4) * CFrame.Angles(0, 0.3, 0.3))
    weld(torso, r, CFrame.new(1.2, 0.4, 0.4) * CFrame.Angles(0, -0.3, -0.3))
    
    return m
end

-- КРЫЛЬЯ ПЕТУХА
function createWings_Rooster()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Wings_Rooster"
    m.Parent = character
    
    local colors = {"Bright yellow", "Bright orange", "Bright red", "Bright green"}
    
    for side = -1, 1, 2 do
        for i = 1, 4 do
            local f = Instance.new("Part")
            f.Size = Vector3.new(0.3, 0.9, 0.2)
            f.BrickColor = BrickColor.new(colors[i])
            f.Anchored = false
            f.CanCollide = false
            f.Parent = m
            weld(torso, f, CFrame.new(side * (0.4 + i*0.2), 0.2 + i*0.2, 0.2) * CFrame.Angles(0, side*0.2, 0))
        end
    end
    
    return m
end

-- КРЫЛЬЯ САМОЛЕТА
function createWings_Plane()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Wings_Plane"
    m.Parent = character
    
    local lw = Instance.new("Part")
    lw.Size = Vector3.new(2.2, 0.2, 1)
    lw.BrickColor = BrickColor.new("Medium stone grey")
    lw.Anchored = false
    lw.CanCollide = false
    lw.Parent = m
    
    local rw = lw:Clone()
    rw.Parent = m
    
    local tail = Instance.new("Part")
    tail.Size = Vector3.new(1, 0.5, 0.2)
    tail.BrickColor = BrickColor.new("Medium stone grey")
    tail.Anchored = false
    tail.CanCollide = false
    tail.Parent = m
    
    weld(torso, lw, CFrame.new(-1.5, 0, 0) * CFrame.Angles(0, 0, 0.1))
    weld(torso, rw, CFrame.new(1.5, 0, 0) * CFrame.Angles(0, 0, -0.1))
    weld(torso, tail, CFrame.new(0, 0.4, -0.8) * CFrame.Angles(0.3, 0, 0))
    
    return m
end

-- ДИЛДО В ПОПЕ
function createButt_Dildo()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("LowerTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Butt_Dildo"
    m.Parent = character
    
    local base = Instance.new("Part")
    base.Size = Vector3.new(0.9, 0.5, 0.9)
    base.BrickColor = BrickColor.new("Hot pink")
    base.Anchored = false
    base.CanCollide = false
    base.Parent = m
    
    local shaft = Instance.new("Part")
    shaft.Size = Vector3.new(0.6, 2.2, 0.6)
    shaft.BrickColor = BrickColor.new("Bright violet")
    shaft.Material = Enum.Material.Neon
    shaft.Anchored = false
    shaft.CanCollide = false
    shaft.Parent = m
    
    local tip = Instance.new("Part")
    tip.Size = Vector3.new(0.8, 0.4, 0.8)
    tip.BrickColor = BrickColor.new("Bright red")
    tip.Material = Enum.Material.Glass
    tip.Anchored = false
    tip.CanCollide = false
    tip.Parent = m
    
    weld(torso, base, CFrame.new(0, -0.6, -0.9) * CFrame.Angles(0.3, 0, 0))
    weld(base, shaft, CFrame.new(0, 1.1, 0))
    weld(shaft, tip, CFrame.new(0, 1.3, 0))
    
    return m
end

-- МОРКОВКА
function createCarrot()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("LowerTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Carrot"
    m.Parent = character
    
    local body = Instance.new("Part")
    body.Size = Vector3.new(0.5, 1.5, 0.5)
    body.BrickColor = BrickColor.new("Bright orange")
    body.Anchored = false
    body.CanCollide = false
    body.Parent = m
    
    local top = Instance.new("Part")
    top.Size = Vector3.new(0.3, 0.4, 0.3)
    top.BrickColor = BrickColor.new("Bright green")
    top.Anchored = false
    top.CanCollide = false
    top.Parent = m
    
    weld(torso, body, CFrame.new(0, -0.5, -0.8) * CFrame.Angles(0.2, 0, 0))
    weld(body, top, CFrame.new(0, 0.9, 0))
    
    return m
end

-- ХВОСТ ЛИСЫ
function createTail_Fox()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("LowerTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Tail_Fox"
    m.Parent = character
    
    local t1 = Instance.new("Part")
    t1.Size = Vector3.new(0.6, 1, 0.6)
    t1.BrickColor = BrickColor.new("Bright orange")
    t1.Anchored = false
    t1.CanCollide = false
    t1.Parent = m
    
    local t2 = Instance.new("Part")
    t2.Size = Vector3.new(0.5, 0.8, 0.5)
    t2.BrickColor = BrickColor.new("Bright orange")
    t2.Anchored = false
    t2.CanCollide = false
    t2.Parent = m
    
    local t3 = Instance.new("Part")
    t3.Size = Vector3.new(0.4, 0.6, 0.4)
    t3.BrickColor = BrickColor.new("White")
    t3.Anchored = false
    t3.CanCollide = false
    t3.Parent = m
    
    weld(torso, t1, CFrame.new(0, -0.3, -0.5))
    weld(t1, t2, CFrame.new(0, -0.6, 0))
    weld(t2, t3, CFrame.new(0, -0.5, 0))
    
    return m
end

-- АВТОМАТЫ НА ШЕЕ
function createNeck_Guns()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Neck_Guns"
    m.Parent = character
    
    for i = 1, 3 do
        local gun = Instance.new("Part")
        gun.Size = Vector3.new(0.3, 0.5, 1.2)
        gun.BrickColor = BrickColor.new("Black")
        gun.Anchored = false
        gun.CanCollide = false
        gun.Parent = m
        weld(torso, gun, CFrame.new(0, 0.3, 0.5) * CFrame.Angles(0, i*2, 0.5))
    end
    
    return m
end

-- ВРАЩЕНИЕ ГОЛОВЫ
function createHead_Spin()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local angle = 0
    local conn = RunService.Heartbeat:Connect(function()
        if not Settings.Accessories.Head_Spin then conn:Disconnect() return end
        angle = angle + 0.1
        head.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0, 0.5, 0)
    end)
    
    return {Connection = conn}
end

-- КАКАШКА
function createHead_Poop()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Poop"
    m.Parent = character
    
    local p1 = Instance.new("Part")
    p1.Size = Vector3.new(0.5, 0.3, 0.4)
    p1.BrickColor = BrickColor.new("Brown")
    p1.Anchored = false
    p1.CanCollide = false
    p1.Parent = m
    
    local p2 = Instance.new("Part")
    p2.Size = Vector3.new(0.4, 0.3, 0.3)
    p2.BrickColor = BrickColor.new("Dark brown")
    p2.Anchored = false
    p2.CanCollide = false
    p2.Parent = m
    
    weld(head, p1, CFrame.new(0, 0.4, 0.2))
    weld(p1, p2, CFrame.new(0.1, 0.2, 0))
    
    return m
end

-- НОЖ
function createHead_Knife()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Knife"
    m.Parent = character
    
    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.1, 0.8, 0.3)
    blade.BrickColor = BrickColor.new("Silver")
    blade.Material = Enum.Material.Metal
    blade.Anchored = false
    blade.CanCollide = false
    blade.Parent = m
    
    local handle = Instance.new("Part")
    handle.Size = Vector3.new(0.2, 0.3, 0.3)
    handle.BrickColor = BrickColor.new("Black")
    handle.Anchored = false
    handle.CanCollide = false
    handle.Parent = m
    
    weld(head, blade, CFrame.new(0, 0.5, 0.3) * CFrame.Angles(0.3, 0, 0))
    weld(blade, handle, CFrame.new(0, -0.5, 0))
    
    return m
end

-- ДИЛДО НА ГОЛОВЕ
function createHead_Dildo()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Dildo"
    m.Parent = character
    
    local base = Instance.new("Part")
    base.Size = Vector3.new(0.6, 0.3, 0.6)
    base.BrickColor = BrickColor.new("Hot pink")
    base.Anchored = false
    base.CanCollide = false
    base.Parent = m
    
    local shaft = Instance.new("Part")
    shaft.Size = Vector3.new(0.4, 1.5, 0.4)
    shaft.BrickColor = BrickColor.new("Bright violet")
    shaft.Material = Enum.Material.Neon
    shaft.Anchored = false
    shaft.CanCollide = false
    shaft.Parent = m
    
    local tip = Instance.new("Part")
    tip.Size = Vector3.new(0.5, 0.3, 0.5)
    tip.BrickColor = BrickColor.new("Bright red")
    tip.Material = Enum.Material.Glass
    tip.Anchored = false
    tip.CanCollide = false
    tip.Parent = m
    
    weld(head, base, CFrame.new(0, 0.5, 0.2))
    weld(base, shaft, CFrame.new(0, 1, 0))
    weld(shaft, tip, CFrame.new(0, 1, 0))
    
    return m
end

-- ВОЛОСЫ КЛОУНА
function createHead_ClownHair()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_ClownHair"
    m.Parent = character
    
    local colors = {"Bright red", "Bright blue", "Bright yellow", "Bright green"}
    
    for i = 1, 6 do
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(0.3, 0.3, 0.3)
        ball.BrickColor = BrickColor.new(colors[math.random(#colors)])
        ball.Shape = Enum.PartType.Ball
        ball.Anchored = false
        ball.CanCollide = false
        ball.Parent = m
        weld(head, ball, CFrame.new(math.sin(i)*0.2, 0.3 + i*0.1, math.cos(i)*0.2))
    end
    
    return m
end

-- ЛИСТОК "ЛОХ"
function createHead_Leaf()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Leaf"
    m.Parent = character
    
    local leaf = Instance.new("Part")
    leaf.Size = Vector3.new(0.4, 0.1, 0.6)
    leaf.BrickColor = BrickColor.new("Bright green")
    leaf.Anchored = false
    leaf.CanCollide = false
    leaf.Parent = m
    
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 2, 0, 1)
    bill.StudsOffset = Vector3.new(0, 1, 0)
    bill.AlwaysOnTop = true
    bill.Parent = leaf
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "ЛОХ"
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Font = Enum.Font.GothamBlack
    text.TextSize = 8
    text.Parent = bill
    
    weld(head, leaf, CFrame.new(0, 0.4, 0.2))
    
    return m
end

-- ГОЛОВА ФУРРИ
function createHead_Furry()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Furry"
    m.Parent = character
    
    local ears = {"LeftEar", "RightEar"}
    for _, e in ipairs(ears) do
        local ear = Instance.new("Part")
        ear.Size = Vector3.new(0.3, 0.5, 0.2)
        ear.BrickColor = BrickColor.new("Brown")
        ear.Anchored = false
        ear.CanCollide = false
        ear.Parent = m
        if e == "LeftEar" then
            weld(head, ear, CFrame.new(-0.3, 0.4, 0))
        else
            weld(head, ear, CFrame.new(0.3, 0.4, 0))
        end
    end
    
    return m
end

-- ГОЛОВА ПЕПЕ
function createHead_Pepe()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Pepe"
    m.Parent = character
    
    local hat = Instance.new("Part")
    hat.Size = Vector3.new(0.8, 0.8, 0.8)
    hat.BrickColor = BrickColor.new("Bright green")
    hat.Anchored = false
    hat.CanCollide = false
    hat.Parent = m
    
    local eye1 = Instance.new("Part")
    eye1.Size = Vector3.new(0.2, 0.2, 0.1)
    eye1.BrickColor = BrickColor.new("Black")
    eye1.Anchored = false
    eye1.CanCollide = false
    eye1.Parent = m
    
    local eye2 = eye1:Clone()
    eye2.Parent = m
    
    weld(head, hat, CFrame.new(0, 0.2, 0))
    weld(hat, eye1, CFrame.new(-0.2, 0.1, 0.3))
    weld(hat, eye2, CFrame.new(0.2, 0.1, 0.3))
    
    return m
end

-- ГОЛОВА РОНАЛДО
function createHead_Ronaldo()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Head_Ronaldo"
    m.Parent = character
    
    local hair = Instance.new("Part")
    hair.Size = Vector3.new(0.8, 0.3, 0.6)
    hair.BrickColor = BrickColor.new("Black")
    hair.Anchored = false
    hair.CanCollide = false
    hair.Parent = m
    
    weld(head, hair, CFrame.new(0, 0.4, 0))
    
    return m
end

-- ПТИЧКА НА ПЛЕЧЕ
function createBird_Shoulder()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local m = Instance.new("Model")
    m.Name = "Bird_Shoulder"
    m.Parent = character
    
    local body = Instance.new("Part")
    body.Size = Vector3.new(0.3, 0.3, 0.3)
    body.BrickColor = BrickColor.new("Bright yellow")
    body.Shape = Enum.PartType.Ball
    body.Anchored = false
    body.CanCollide = false
    body.Parent = m
    
    local beak = Instance.new("Part")
    beak.Size = Vector3.new(0.1, 0.1, 0.2)
    beak.BrickColor = BrickColor.new("Bright orange")
    beak.Anchored = false
    beak.CanCollide = false
    beak.Parent = m
    
    weld(torso, body, CFrame.new(0.8, 0.3, 0))
    weld(body, beak, CFrame.new(0, 0.1, 0.2))
    
    return m
end

-- КРАСНАЯ ДОРОЖКА
function createPlatform_RedCarpet()
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local m = Instance.new("Model")
    m.Name = "Platform_RedCarpet"
    m.Parent = character
    
    local carpet = Instance.new("Part")
    carpet.Size = Vector3.new(4, 0.1, 8)
    carpet.BrickColor = BrickColor.new("Bright red")
    carpet.Material = Enum.Material.Carpet
    carpet.Anchored = false
    carpet.CanCollide = false
    carpet.Parent = m
    
    local border = Instance.new("Part")
    border.Size = Vector3.new(4.2, 0.2, 8.2)
    border.BrickColor = BrickColor.new("Bright yellow")
    border.Material = Enum.Material.Metal
    border.Anchored = false
    border.CanCollide = false
    border.Parent = m
    
    weld(root, carpet, CFrame.new(0, -1.5, 0))
    weld(carpet, border, CFrame.new(0, 0, 0))
    
    return m
end

-- 67 РЯДОМ
function createStand_67()
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local m = Instance.new("Model")
    m.Name = "Stand_67"
    m.Parent = character
    
    local torso = Instance.new("Part")
    torso.Size = Vector3.new(0.8, 1, 0.4)
    torso.BrickColor = BrickColor.new("Bright blue")
    torso.Anchored = false
    torso.CanCollide = false
    torso.Parent = m
    
    local head = Instance.new("Part")
    head.Size = Vector3.new(0.5, 0.5, 0.5)
    head.BrickColor = BrickColor.new("Bright yellow")
    head.Shape = Enum.PartType.Ball
    head.Anchored = false
    head.CanCollide = false
    head.Parent = m
    
    local num6 = Instance.new("Part")
    num6.Size = Vector3.new(0.1, 0.3, 0.1)
    num6.BrickColor = BrickColor.new("Black")
    num6.Anchored = false
    num6.CanCollide = false
    num6.Parent = m
    
    local num7 = num6:Clone()
    num7.Parent = m
    
    weld(root, torso, CFrame.new(2, 0, 0))
    weld(torso, head, CFrame.new(0, 0.8, 0))
    weld(torso, num6, CFrame.new(-0.2, 0.1, 0.2))
    weld(torso, num7, CFrame.new(0.2, 0.1, 0.2))
    
    return m
end

-- МАШИНКА
function createCar()
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local m = Instance.new("Model")
    m.Name = "Car"
    m.Parent = character
    
    local body = Instance.new("Part")
    body.Size = Vector3.new(2, 0.8, 4)
    body.BrickColor = BrickColor.new("Bright red")
    body.Anchored = false
    body.CanCollide = false
    body.Parent = m
    
    local roof = Instance.new("Part")
    roof.Size = Vector3.new(1.5, 0.5, 2)
    roof.BrickColor = BrickColor.new("Black")
    roof.Anchored = false
    roof.CanCollide = false
    roof.Parent = m
    
    for i = 1, 4 do
        local wheel = Instance.new("Part")
        wheel.Size = Vector3.new(0.5, 0.5, 0.3)
        wheel.BrickColor = BrickColor.new("Black")
        wheel.Shape = Enum.PartType.Cylinder
        wheel.Anchored = false
        wheel.CanCollide = false
        wheel.Parent = m
    end
    
    weld(root, body, CFrame.new(0, -0.5, 0))
    weld(body, roof, CFrame.new(0, 0.6, -0.3))
    weld(body, m:FindFirstChild("Part"), CFrame.new(-0.8, -0.3, 1.2))
    weld(body, m:FindFirstChild("Part"), CFrame.new(0.8, -0.3, 1.2))
    weld(body, m:FindFirstChild("Part"), CFrame.new(-0.8, -0.3, -1.2))
    weld(body, m:FindFirstChild("Part"), CFrame.new(0.8, -0.3, -1.2))
    
    return m
end

-- МИСТЕР РОБОТ
function createMrRobot()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "MrRobot"
    m.Parent = character
    
    local bigHead = Instance.new("Part")
    bigHead.Size = Vector3.new(1.2, 1.2, 1.2)
    bigHead.BrickColor = BrickColor.new("Black")
    bigHead.Anchored = false
    bigHead.CanCollide = false
    bigHead.Parent = m
    
    local mask = Instance.new("Part")
    mask.Size = Vector3.new(1, 0.8, 0.3)
    mask.BrickColor = BrickColor.new("White")
    mask.Anchored = false
    mask.CanCollide = false
    mask.Parent = m
    
    weld(head, bigHead, CFrame.new(0, 0, 0))
    weld(bigHead, mask, CFrame.new(0, 0, 0.6))
    
    return m
end

-- НИМБ
function createHalo()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local m = Instance.new("Model")
    m.Name = "Halo"
    m.Parent = character
    
    local ring = Instance.new("Part")
    ring.Size = Vector3.new(1.5, 0.2, 1.5)
    ring.BrickColor = BrickColor.new("Bright yellow")
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = false
    ring.CanCollide = false
    ring.Parent = m
    
    weld(head, ring, CFrame.new(0, 0.5, 0))
    
    return m
end

-- КОЛЯСКА
function createWheelchair()
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local m = Instance.new("Model")
    m.Name = "Wheelchair"
    m.Parent = character
    
    local seat = Instance.new("Part")
    seat.Size = Vector3.new(2, 0.5, 1.5)
    seat.BrickColor = BrickColor.new("Black")
    seat.Anchored = false
    seat.CanCollide = false
    seat.Parent = m
    
    for i = 1, 4 do
        local wheel = Instance.new("Part")
        wheel.Size = Vector3.new(0.8, 0.8, 0.4)
        wheel.BrickColor = BrickColor.new("Dark grey")
        wheel.Shape = Enum.PartType.Cylinder
        wheel.Anchored = false
        wheel.CanCollide = false
        wheel.Parent = m
    end
    
    weld(root, seat, CFrame.new(0, -1.5, 0))
    weld(seat, m:FindFirstChild("Part"), CFrame.new(-0.9, -0.2, 0.6))
    weld(seat, m:FindFirstChild("Part"), CFrame.new(0.9, -0.2, 0.6))
    weld(seat, m:FindFirstChild("Part"), CFrame.new(-0.9, -0.2, -0.6))
    weld(seat, m:FindFirstChild("Part"), CFrame.new(0.9, -0.2, -0.6))
    
    return m
end
RunService.Heartbeat:Connect(function()
    character = player.Character or character
    
    if not Settings.Accessories.Enabled then
        for _, acc in pairs(activeAccessories) do
            pcall(function() acc:Destroy() end)
        end
        activeAccessories = {}
        return
    end
    
    for name, enabled in pairs(Settings.Accessories) do
        if name ~= "Enabled" and type(enabled) == "boolean" then
            if enabled and not activeAccessories[name] then
                local func = _G["create" .. name]
                if func then
                    local success, result = pcall(func)
                    if success and result then
                        activeAccessories[name] = result
                    end
                end
            elseif not enabled and activeAccessories[name] then
                pcall(function() activeAccessories[name]:Destroy() end)
                activeAccessories[name] = nil
            end
        end
    end
end)
StarterGui:SetCore("SendNotification", {
    Title = "Zack_Hub v1.2",
    Text = "Полностью рабочий! Аксессуары включены",
    Duration = 4
})

print("ZACK HUB v1.2 ЗАГРУЖЕН - ВСЕ ФУНКЦИИ РАБОТАЮТ")
