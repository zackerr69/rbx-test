-- MENU V3 - РАБОЧИЕ АКСЕССУАРЫ + ДРОЧКА + CHAMS

if _G.ZACK_MENU_V3 then return end
_G.ZACK_MENU_V3 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local lighting = game:GetService("Lighting")

-- ========== ИКОНКА ZCKRR ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackMenu"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

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
menu.Size = UDim2.new(0, 260, 0, 400)
menu.Position = UDim2.new(0.5, -130, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
menu.BackgroundTransparency = 0.1
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

-- Звёзды
for i = 1, 40 do
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
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "ZACK MENU V3"
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
container.CanvasSize = UDim2.new(0, 0, 0, 500)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- ========== ПЕРЕМЕННЫЕ ==========
local states = {
    chams = false,
    jack = false,
    wingsAngel = false,
    wingsDemon = false,
    wingsRooster = false,
    accessory67 = false
}

local chamsConnection = nil
local jackConnection = nil
local accessories = {}

-- ========== ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ==========
function createButton(text, stateName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. ": ▢"
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        states[stateName] = not states[stateName]
        btn.Text = text .. ": " .. (states[stateName] and "✓" or "▢")
        btn.BackgroundColor3 = states[stateName] and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(40, 40, 60)
        
        if stateName == "chams" then
            toggleChams()
        elseif stateName == "jack" then
            toggleJack()
        elseif stateName == "wingsAngel" then
            toggleWings("Angel")
        elseif stateName == "wingsDemon" then
            toggleWings("Demon")
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
createButton("КРЫЛЬЯ АНГЕЛА", "wingsAngel")
createButton("КРЫЛЬЯ ДЕМОНА", "wingsDemon")
createButton("КРЫЛЬЯ ПЕТУХА", "wingsRooster")
createButton("67 РЯДОМ", "accessory67")

-- ========== CHAMS (КОСМОС) ==========
function toggleChams()
    if states.chams then
        lighting.Ambient = Color3.fromRGB(5, 5, 25)
        lighting.Brightness = 0.2
        lighting.OutdoorAmbient = Color3.fromRGB(3, 3, 15)
        
        local sky = lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = lighting
        end
        sky.SkyboxBk = "rbxassetid://159451323"
        sky.SkyboxDn = "rbxassetid://159451323"
        sky.SkyboxFt = "rbxassetid://159451323"
        sky.SkyboxLf = "rbxassetid://159451323"
        sky.SkyboxRt = "rbxassetid://159451323"
        sky.SkyboxUp = "rbxassetid://159451323"
        sky.StarCount = 5000
        sky.SunAngularSize = 0
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end

-- ========== ДРОЧКА (РАБОЧАЯ) ==========
function toggleJack()
    if states.jack then
        jackConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
            
            if not root or not humanoid or not rightArm then return end
            
            humanoid.PlatformStand = true
            root.Velocity = Vector3.new(0, 0, 0)
            
            local motor = rightArm:FindFirstChildOfClass("Motor6D")
            if motor then
                local t = tick() * 6
                motor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(math.sin(t) * 1.2, 0, 0)
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

-- ========== ФУНКЦИЯ ДЛЯ УДАЛЕНИЯ АКСЕССУАРА ==========
function removeAccessory(name)
    if accessories[name] then
        accessories[name]:Destroy()
        accessories[name] = nil
    end
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
    local left = Instance.new("Part")
    left.Size = Vector3.new(0.6, 2.2, 1.2)
    left.BrickColor = BrickColor.new("White")
    left.Material = Enum.Material.SmoothPlastic
    left.Anchored = false
    left.CanCollide = false
    left.Parent = model
    
    -- Правое крыло
    local right = left:Clone()
    right.Parent = model
    
    -- Перья
    for i = 1, 4 do
        local f1 = Instance.new("Part")
        f1.Size = Vector3.new(0.3, 0.9, 0.4)
        f1.BrickColor = BrickColor.new("White")
        f1.Anchored = false
        f1.CanCollide = false
        f1.Parent = model
        
        local f2 = f1:Clone()
        f2.Parent = model
        
        local w1 = Instance.new("Weld")
        w1.Part0 = left
        w1.Part1 = f1
        w1.C0 = CFrame.new(0, -0.6 + i*0.3, 0.3) * CFrame.Angles(0.2, 0, 0)
        w1.Parent = f1
        
        local w2 = Instance.new("Weld")
        w2.Part0 = right
        w2.Part1 = f2
        w2.C0 = CFrame.new(0, -0.6 + i*0.3, 0.3) * CFrame.Angles(0.2, 0, 0)
        w2.Parent = f2
    end
    
    -- Крепление
    local wLeft = Instance.new("Weld")
    wLeft.Part0 = torso
    wLeft.Part1 = left
    wLeft.C0 = CFrame.new(-1.1, 0.4, 0.3) * CFrame.Angles(0, 0.2, 0.2)
    wLeft.Parent = left
    
    local wRight = Instance.new("Weld")
    wRight.Part0 = torso
    wRight.Part1 = right
    wRight.C0 = CFrame.new(1.1, 0.4, 0.3) * CFrame.Angles(0, -0.2, -0.2)
    wRight.Parent = right
    
    return model
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
    local left = Instance.new("Part")
    left.Size = Vector3.new(0.7, 2.4, 1.3)
    left.BrickColor = BrickColor.new("Really red")
    left.Material = Enum.Material.Neon
    left.Anchored = false
    left.CanCollide = false
    left.Parent = model
    
    -- Правое крыло
    local right = left:Clone()
    right.Parent = model
    
    -- Огненные эффекты
    for i = 1, 5 do
        local f1 = Instance.new("Part")
        f1.Size = Vector3.new(0.3, 0.3, 0.3)
        f1.BrickColor = BrickColor.new("Bright orange")
        f1.Material = Enum.Material.Neon
        f1.Anchored = false
        f1.CanCollide = false
        f1.Parent = model
        
        local f2 = f1:Clone()
        f2.Parent = model
        
        local w1 = Instance.new("Weld")
        w1.Part0 = left
        w1.Part1 = f1
        w1.C0 = CFrame.new(0, -0.8 + i*0.3, 0.4)
        w1.Parent = f1
        
        local w2 = Instance.new("Weld")
        w2.Part0 = right
        w2.Part1 = f2
        w2.C0 = CFrame.new(0, -0.8 + i*0.3, 0.4)
        w2.Parent = f2
    end
    
    -- Крепление
    local wLeft = Instance.new("Weld")
    wLeft.Part0 = torso
    wLeft.Part1 = left
    wLeft.C0 = CFrame.new(-1.2, 0.5, 0.4) * CFrame.Angles(0, 0.3, 0.3)
    wLeft.Parent = left
    
    local wRight = Instance.new("Weld")
    wRight.Part0 = torso
    wRight.Part1 = right
    wRight.C0 = CFrame.new(1.2, 0.5, 0.4) * CFrame.Angles(0, -0.3, -0.3)
    wRight.Parent = right
    
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
            local f = Instance.new("Part")
            f.Size = Vector3.new(0.3, 1, 0.2)
            f.BrickColor = BrickColor.new(colors[i])
            f.Anchored = false
            f.CanCollide = false
            f.Parent = model
            
            local w = Instance.new("Weld")
            w.Part0 = torso
            w.Part1 = f
            w.C0 = CFrame.new(side * (0.4 + i*0.15), 0.2 + i*0.15, 0.2) * CFrame.Angles(0, side*0.2, 0)
            w.Parent = f
        end
    end
    
    return model
end

-- ========== 67 РЯДОМ ==========
function create67()
    local char = player.Character
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local model = Instance.new("Model")
    model.Name = "SixtySeven"
    model.Parent = char
    
    -- Торс
    local torso = Instance.new("Part")
    torso.Size = Vector3.new(0.8, 1, 0.4)
    torso.BrickColor = BrickColor.new("Bright blue")
    torso.Anchored = false
    torso.CanCollide = false
    torso.Parent = model
    
    -- Голова
    local head = Instance.new("Part")
    head.Size = Vector3.new(0.5, 0.5, 0.5)
    head.BrickColor = BrickColor.new("Bright yellow")
    head.Shape = Enum.PartType.Ball
    head.Anchored = false
    head.CanCollide = false
    head.Parent = model
    
    -- Руки
    local armL = Instance.new("Part")
    armL.Size = Vector3.new(0.3, 0.8, 0.3)
    armL.BrickColor = BrickColor.new("Bright yellow")
    armL.Anchored = false
    armL.CanCollide = false
    armL.Parent = model
    
    local armR = armL:Clone()
    armR.Parent = model
    
    -- Ноги
    local legL = Instance.new("Part")
    legL.Size = Vector3.new(0.3, 0.8, 0.3)
    legL.BrickColor = BrickColor.new("Bright yellow")
    legL.Anchored = false
    legL.CanCollide = false
    legL.Parent = model
    
    local legR = legL:Clone()
    legR.Parent = model
    
    -- Цифры
    local n6 = Instance.new("Part")
    n6.Size = Vector3.new(0.1, 0.3, 0.1)
    n6.BrickColor = BrickColor.new("Black")
    n6.Anchored = false
    n6.CanCollide = false
    n6.Parent = model
    
    local n7 = n6:Clone()
    n7.Parent = model
    
    -- Сварка к игроку
    local wRoot = Instance.new("Weld")
    wRoot.Part0 = root
    wRoot.Part1 = torso
    wRoot.C0 = CFrame.new(2, 0, 0)
    wRoot.Parent = torso
    
    -- Сварка частей
    local wHead = Instance.new("Weld")
    wHead.Part0 = torso
    wHead.Part1 = head
    wHead.C0 = CFrame.new(0, 0.8, 0)
    wHead.Parent = head
    
    local wArmL = Instance.new("Weld")
    wArmL.Part0 = torso
    wArmL.Part1 = armL
    wArmL.C0 = CFrame.new(-0.6, 0.3, 0)
    wArmL.Parent = armL
    
    local wArmR = Instance.new("Weld")
    wArmR.Part0 = torso
    wArmR.Part1 = armR
    wArmR.C0 = CFrame.new(0.6, 0.3, 0)
    wArmR.Parent = armR
    
    local wLegL = Instance.new("Weld")
    wLegL.Part0 = torso
    wLegL.Part1 = legL
    wLegL.C0 = CFrame.new(-0.3, -0.7, 0)
    wLegL.Parent = legL
    
    local wLegR = Instance.new("Weld")
    wLegR.Part0 = torso
    wLegR.Part1 = legR
    wLegR.C0 = CFrame.new(0.3, -0.7, 0)
    wLegR.Parent = legR
    
    local w6 = Instance.new("Weld")
    w6.Part0 = torso
    w6.Part1 = n6
    w6.C0 = CFrame.new(-0.2, 0.1, 0.2)
    w6.Parent = n6
    
    local w7 = Instance.new("Weld")
    w7.Part0 = torso
    w7.Part1 = n7
    w7.C0 = CFrame.new(0.2, 0.1, 0.2)
    w7.Parent = n7
    
    return model
end

-- ========== УПРАВЛЕНИЕ КРЫЛЬЯМИ ==========
function toggleWings(type)
    local name = "wings" .. type
    if states["wings" .. type] then
        if type == "Angel" then
            accessories[name] = createWingsAngel()
        elseif type == "Demon" then
            accessories[name] = createWingsDemon()
        elseif type == "Rooster" then
            accessories[name] = createWingsRooster()
        end
    else
        if accessories[name] then
            accessories[name]:Destroy()
            accessories[name] = nil
        end
    end
end

-- ========== УПРАВЛЕНИЕ 67 ==========
function toggle67()
    if states.accessory67 then
        accessories["67"] = create67()
    else
        if accessories["67"] then
            accessories["67"]:Destroy()
            accessories["67"] = nil
        end
    end
end

-- ========== ОТКРЫТИЕ МЕНЮ ==========
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ========== ЗАВЕРШЕНИЕ ==========
starterGui:SetCore("SendNotification", {
    Title = "ZACK MENU V3",
    Text = "Аксессуары + Дрочка + Chams",
    Duration = 3
})

print("ZACK MENU V3 ЗАГРУЖЕН - ВСЕ АКСЕССУАРЫ РАБОТАЮТ")
