-- MENU V2 - ФИНАЛ
-- Иконка: ZCKRR на чёрном
-- Полет: Fly GUI V3 (по кнопке)
-- Дрочка: рабочая
-- Chams: космос
-- Аксессуары: 67 + крылья ангела

if _G.ZACK_MENU_V2 then return end
_G.ZACK_MENU_V2 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local lighting = game:GetService("Lighting")

-- ========== ИКОНКА ==========
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
menu.Size = UDim2.new(0, 250, 0, 350)
menu.Position = UDim2.new(0.5, -125, 0.5, -175)
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
for i = 1, 30 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, 2, 0, 2)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BorderSizePixel = 0
    star.Parent = menu
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "ZACK MENU"
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
container.CanvasSize = UDim2.new(0, 0, 0, 400)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- ========== ПЕРЕМЕННЫЕ СОСТОЯНИЙ ==========
local states = {
    fly = false,
    jack = false,
    chams = false,
    accessory67 = false,
    accessoryWings = false
}

local flyWindow = nil
local jackConnection = nil
local chamsConnection = nil
local accessory67Obj = nil
local accessoryWingsObj = nil

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
        
        -- Вызываем соответствующую функцию
        if stateName == "fly" then
            toggleFly()
        elseif stateName == "jack" then
            toggleJack()
        elseif stateName == "chams" then
            toggleChams()
        elseif stateName == "accessory67" then
            toggleAccessory67()
        elseif stateName == "accessoryWings" then
            toggleAccessoryWings()
        end
    end)
end

-- ========== КНОПКИ ==========
createButton("ПОЛЕТ (Fly GUI)", "fly")
createButton("ДРОЧКА", "jack")
createButton("CHAMS (КОСМОС)", "chams")
createButton("АКСЕССУАР: 67", "accessory67")
createButton("АКСЕССУАР: КРЫЛЬЯ", "accessoryWings")

-- ========== ПОЛЕТ (ТВОЙ СКРИПТ) ==========
function toggleFly()
    if states.fly then
        -- Запускаем твой скрипт
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        -- Сохраняем окно чтобы можно было закрыть
        flyWindow = player.PlayerGui:FindFirstChild("main")
    else
        -- Закрываем окно полёта
        if flyWindow then
            flyWindow:Destroy()
            flyWindow = nil
        end
    end
end

-- ========== ДРОЧКА (РАБОЧАЯ) ==========
function toggleJack()
    if states.jack then
        jackConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if not humanoid or not rightArm or not root then return end
            
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

-- ========== CHAMS (КОСМОС) ==========
function toggleChams()
    if states.chams then
        lighting.Ambient = Color3.fromRGB(10, 10, 30)
        lighting.Brightness = 0.3
        lighting.OutdoorAmbient = Color3.fromRGB(5, 5, 20)
        
        local sky = lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = lighting
        end
        sky.SkyboxBk = "rbxassetid://168892382"
        sky.SkyboxDn = "rbxassetid://168892382"
        sky.SkyboxFt = "rbxassetid://168892382"
        sky.SkyboxLf = "rbxassetid://168892382"
        sky.SkyboxRt = "rbxassetid://168892382"
        sky.SkyboxUp = "rbxassetid://168892382"
        sky.StarCount = 3000
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end

-- ========== АКСЕССУАР: 67 ==========
function create67()
    local char = player.Character
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local model = Instance.new("Model")
    model.Name = "Accessory67"
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
    
    -- Цифры
    local num6 = Instance.new("Part")
    num6.Size = Vector3.new(0.1, 0.3, 0.1)
    num6.BrickColor = BrickColor.new("Black")
    num6.Anchored = false
    num6.CanCollide = false
    num6.Parent = model
    
    local num7 = num6:Clone()
    num7.Parent = model
    
    -- Сварка
    local w1 = Instance.new("Weld")
    w1.Part0 = root
    w1.Part1 = torso
    w1.C0 = CFrame.new(2, 0, 0)
    w1.Parent = torso
    
    local w2 = Instance.new("Weld")
    w2.Part0 = torso
    w2.Part1 = head
    w2.C0 = CFrame.new(0, 0.8, 0)
    w2.Parent = head
    
    local w3 = Instance.new("Weld")
    w3.Part0 = torso
    w3.Part1 = num6
    w3.C0 = CFrame.new(-0.2, 0.1, 0.2)
    w3.Parent = num6
    
    local w4 = Instance.new("Weld")
    w4.Part0 = torso
    w4.Part1 = num7
    w4.C0 = CFrame.new(0.2, 0.1, 0.2)
    w4.Parent = num7
    
    return model
end

function toggleAccessory67()
    if states.accessory67 then
        accessory67Obj = create67()
    else
        if accessory67Obj then
            accessory67Obj:Destroy()
            accessory67Obj = nil
        end
    end
end

-- ========== АКСЕССУАР: КРЫЛЬЯ АНГЕЛА ==========
function createWings()
    local char = player.Character
    if not char then return nil end
    
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return nil end
    
    local model = Instance.new("Model")
    model.Name = "AccessoryWings"
    model.Parent = char
    
    -- Левое крыло
    local left = Instance.new("Part")
    left.Size = Vector3.new(0.6, 2, 1.2)
    left.BrickColor = BrickColor.new("White")
    left.Anchored = false
    left.CanCollide = false
    left.Parent = model
    
    -- Правое крыло
    local right = left:Clone()
    right.Parent = model
    
    -- Перья
    for i = 1, 3 do
        local f1 = Instance.new("Part")
        f1.Size = Vector3.new(0.3, 0.8, 0.4)
        f1.BrickColor = BrickColor.new("White")
        f1.Anchored = false
        f1.CanCollide = false
        f1.Parent = model
        
        local f2 = f1:Clone()
        f2.Parent = model
        
        local w1 = Instance.new("Weld")
        w1.Part0 = left
        w1.Part1 = f1
        w1.C0 = CFrame.new(0, -0.3 + i*0.3, 0.3)
        w1.Parent = f1
        
        local w2 = Instance.new("Weld")
        w2.Part0 = right
        w2.Part1 = f2
        w2.C0 = CFrame.new(0, -0.3 + i*0.3, 0.3)
        w2.Parent = f2
    end
    
    -- Крепление к торсу
    local wLeft = Instance.new("Weld")
    wLeft.Part0 = torso
    wLeft.Part1 = left
    wLeft.C0 = CFrame.new(-1, 0.3, 0.3) * CFrame.Angles(0, 0.2, 0.2)
    wLeft.Parent = left
    
    local wRight = Instance.new("Weld")
    wRight.Part0 = torso
    wRight.Part1 = right
    wRight.C0 = CFrame.new(1, 0.3, 0.3) * CFrame.Angles(0, -0.2, -0.2)
    wRight.Parent = right
    
    return model
end

function toggleAccessoryWings()
    if states.accessoryWings then
        accessoryWingsObj = createWings()
    else
        if accessoryWingsObj then
            accessoryWingsObj:Destroy()
            accessoryWingsObj = nil
        end
    end
end

-- ========== ОТКРЫТИЕ МЕНЮ ==========
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ========== ЗАВЕРШЕНИЕ ==========
starterGui:SetCore("SendNotification", {
    Title = "ZACK MENU V2",
    Text = "Все функции по кнопкам",
    Duration = 3
})

print("ZACK MENU V2 ЗАГРУЖЕН")
