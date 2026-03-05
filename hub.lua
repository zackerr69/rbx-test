--[[
    DEV-MASTER MOBILE HUB v5.0
    Для Delta, Arceus X, Hydrogen и других инжекторов на Android
    Функции: Flight, Noclip, ESP, Speed, Chams, Visual Accessories (Wheelchair + 4 других)
]]

-- Защита от повторного запуска
if _G.DEV_MASTER_LOADED then return end
_G.DEV_MASTER_LOADED = true

-- Ожидание загрузки игры
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Основные переменные
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = Workspace.CurrentCamera

-- ======================== НАСТРОЙКИ ========================
local Settings = {
    Flight = { Enabled = false, Speed = 50, BodyVelocity = nil },
    Noclip = { Enabled = false, Connection = nil },
    ESP = { Enabled = false, Players = true, Mobs = true, Items = true, Objects = {} },
    Speed = { Enabled = false, WalkSpeed = 24, JumpPower = 50 },
    Chams = { Enabled = false, Color = Color3.fromRGB(0, 255, 255), Transparency = 0.5 },
    Accessories = {
        Enabled = false,
        Wheelchair = false,
        Halo = false,
        Wings = false,
        Horns = false,
        Cape = false
    }
}

-- ======================== СОЗДАНИЕ GUI (Mobile Optimized) ========================
local gui = Instance.new("ScreenGui")
gui.Name = "DEV_MASTER_MOBILE"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Главное окно (перетаскиваемое)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 400)
main.Position = UDim2.new(0.5, -110, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Скругление
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "DEV-MASTER MOBILE"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Контейнер для кнопок (скролл)
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -45)
container.Position = UDim2.new(0, 5, 0, 40)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 4
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = container

-- Функция создания кнопки-переключателя
local function createToggle(text, var)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Settings[var] and Settings[var].Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(120, 0, 0)
    btn.Text = text .. ": " .. tostring(Settings[var] and Settings[var].Enabled or false)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if Settings[var] then
            Settings[var].Enabled = not Settings[var].Enabled
            btn.BackgroundColor3 = Settings[var].Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(120, 0, 0)
            btn.Text = text .. ": " .. tostring(Settings[var].Enabled)
        end
    end)
end

-- Создаем основные кнопки
createToggle("Flight", "Flight")
createToggle("Noclip", "Noclip")
createToggle("ESP", "ESP")
createToggle("Speed Hack", "Speed")
createToggle("Chams", "Chams")
createToggle("Accessories", "Accessories")

-- Поле для скорости полета
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -10, 0, 70)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = container

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Flight Speed: " .. Settings.Flight.Speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = speedFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, 0, 0, 35)
speedBox.PlaceholderText = "Enter speed"
speedBox.Text = tostring(Settings.Flight.Speed)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 16
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedFrame
local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = speedBox

speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then
        Settings.Flight.Speed = num
        speedLabel.Text = "Flight Speed: " .. num
    else
        speedBox.Text = tostring(Settings.Flight.Speed)
    end
end)

-- Аксессуары (индивидуальные кнопки)
local accTitle = Instance.new("TextLabel")
accTitle.Size = UDim2.new(1, -10, 0, 30)
accTitle.BackgroundTransparency = 1
accTitle.Text = "ACCESSORIES:"
accTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
accTitle.Font = Enum.Font.GothamBold
accTitle.TextSize = 16
accTitle.Parent = container

local accList = {"Wheelchair", "Halo", "Wings", "Horns", "Cape"}
for _, name in ipairs(accList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings.Accessories[name] = not Settings.Accessories[name]
        btn.BackgroundColor3 = Settings.Accessories[name] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 80, 80)
        btn.Text = name .. ": " .. (Settings.Accessories[name] and "ON" or "OFF")
    end)
end

-- ======================== ОСНОВНЫЕ ФУНКЦИИ ========================

-- Обновление персонажа при респавне
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- ПОЛЕТ (с мобильным управлением через GUI)
local flightLoop
flightLoop = RunService.Heartbeat:Connect(function()
    if not character or not Settings.Flight.Enabled then
        if Settings.Flight.BodyVelocity then
            Settings.Flight.BodyVelocity:Destroy()
            Settings.Flight.BodyVelocity = nil
        end
        return
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    
    if not Settings.Flight.BodyVelocity then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000, 4000, 4000)
        bv.P = 1250
        bv.Parent = root
        Settings.Flight.BodyVelocity = bv
    end
    
    -- Управление: используем камеру + клавиши (если есть клавиатура) или просто летим вперед
    local moveDir = Vector3.new()
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDir = moveDir + camera.CFrame.LookVector * Vector3.new(1,0,1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDir = moveDir - camera.CFrame.LookVector * Vector3.new(1,0,1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDir = moveDir - camera.CFrame.RightVector * Vector3.new(1,0,1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDir = moveDir + camera.CFrame.RightVector * Vector3.new(1,0,1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDir = moveDir + Vector3.new(0,1,0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        moveDir = moveDir + Vector3.new(0,-1,0)
    end
    
    -- Если нет нажатий, просто парим
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit * Settings.Flight.Speed
    end
    
    Settings.Flight.BodyVelocity.Velocity = moveDir
    humanoid.PlatformStand = true
end)

-- NOCLIP
local noclipLoop
noclipLoop = RunService.Stepped:Connect(function()
    if not character or not Settings.Noclip.Enabled then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end)

-- SPEED HACK
local speedLoop
speedLoop = RunService.Heartbeat:Connect(function()
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if Settings.Speed.Enabled then
            humanoid.WalkSpeed = Settings.Speed.WalkSpeed
            humanoid.JumpPower = Settings.Speed.JumpPower
        else
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end)

-- ESP (упрощенная версия для мобил)
local function createESP(instance, color)
    if not instance or Settings.ESP.Objects[instance] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = instance
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = gui
    
    Settings.ESP.Objects[instance] = highlight
    
    instance.AncestryChanged:Connect(function()
        if not instance.Parent and Settings.ESP.Objects[instance] then
            Settings.ESP.Objects[instance]:Destroy()
            Settings.ESP.Objects[instance] = nil
        end
    end)
end

local espLoop
espLoop = RunService.Stepped:Connect(function()
    if not Settings.ESP.Enabled then
        for obj, hl in pairs(Settings.ESP.Objects) do
            hl:Destroy()
        end
        Settings.ESP.Objects = {}
        return
    end
    
    -- Игроки
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            createESP(plr.Character, Color3.fromRGB(255, 0, 0))
        end
    end
    
    -- Мобы (любой объект с Humanoid без Player)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
            createESP(obj, Color3.fromRGB(255, 165, 0))
        end
    end
    
    -- Предметы
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Name:lower():find("item")) then
            createESP(obj, Color3.fromRGB(0, 255, 0))
        end
    end
end)

-- CHAMS
local chamsLoop
chamsLoop = RunService.Heartbeat:Connect(function()
    if not Settings.Chams.Enabled then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            -- Удаляем старые чamсы
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Highlight") and child.Name == "DEV_Chams" then
                    child:Destroy()
                end
            end
            
            local chams = Instance.new("Highlight")
            chams.Name = "DEV_Chams"
            chams.Adornee = char
            chams.FillColor = Settings.Chams.Color
            chams.FillTransparency = Settings.Chams.Transparency
            chams.OutlineTransparency = 0
            chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            chams.Parent = char
        end
    end
end)

-- АКСЕССУАРЫ
local function createWheelchair()
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local model = Instance.new("Model")
    model.Name = "Wheelchair"
    
    local seat = Instance.new("Part")
    seat.Size = Vector3.new(2, 0.5, 1.5)
    seat.BrickColor = BrickColor.new("Black")
    seat.Anchored = false
    seat.CanCollide = false
    seat.Parent = model
    
    local wheelPositions = {
        Vector3.new(-1, 0, 0.8),
        Vector3.new(1, 0, 0.8),
        Vector3.new(-1, 0, -0.8),
        Vector3.new(1, 0, -0.8)
    }
    
    for _, pos in ipairs(wheelPositions) do
        local wheel = Instance.new("Part")
        wheel.Size = Vector3.new(0.8, 0.8, 0.4)
        wheel.BrickColor = BrickColor.new("Dark grey")
        wheel.Anchored = false
        wheel.CanCollide = false
        wheel.Parent = model
        
        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = wheel
        weld.C0 = CFrame.new(pos)
        weld.Parent = wheel
    end
    
    local weld = Instance.new("Weld")
    weld.Part0 = root
    weld.Part1 = seat
    weld.C0 = CFrame.new(0, -1.5, 0)
    weld.Parent = seat
    
    model.Parent = character
    return model
end

local function createHalo()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local halo = Instance.new("Part")
    halo.Name = "Halo"
    halo.Size = Vector3.new(1.5, 0.2, 1.5)
    halo.BrickColor = BrickColor.new("Bright yellow")
    halo.Shape = Enum.PartType.Cylinder
    halo.Anchored = false
    halo.CanCollide = false
    halo.Parent = character
    
    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = halo
    weld.C0 = CFrame.new(0, 0.5, 0)
    weld.Parent = halo
    
    return halo
end

local function createWings()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local wings = Instance.new("Model")
    wings.Name = "Wings"
    
    local left = Instance.new("Part")
    left.Size = Vector3.new(0.5, 1.5, 2)
    left.BrickColor = BrickColor.new("White")
    left.Anchored = false
    left.CanCollide = false
    left.Parent = wings
    
    local right = left:Clone()
    right.Parent = wings
    
    local weldLeft = Instance.new("Weld")
    weldLeft.Part0 = torso
    weldLeft.Part1 = left
    weldLeft.C0 = CFrame.new(-1, 0, 0.5) * CFrame.Angles(0, 0.5, 0)
    weldLeft.Parent = left
    
    local weldRight = Instance.new("Weld")
    weldRight.Part0 = torso
    weldRight.Part1 = right
    weldRight.C0 = CFrame.new(1, 0, 0.5) * CFrame.Angles(0, -0.5, 0)
    weldRight.Parent = right
    
    wings.Parent = character
    return wings
end

local function createHorns()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local horns = Instance.new("Model")
    horns.Name = "Horns"
    
    local left = Instance.new("Part")
    left.Size = Vector3.new(0.4, 1, 0.4)
    left.BrickColor = BrickColor.new("Really red")
    left.Anchored = false
    left.CanCollide = false
    left.Parent = horns
    
    local right = left:Clone()
    right.Parent = horns
    
    local weldLeft = Instance.new("Weld")
    weldLeft.Part0 = head
    weldLeft.Part1 = left
    weldLeft.C0 = CFrame.new(-0.5, 0.3, -0.3) * CFrame.Angles(0.3, 0, 0)
    weldLeft.Parent = left
    
    local weldRight = Instance.new("Weld")
    weldRight.Part0 = head
    weldRight.Part1 = right
    weldRight.C0 = CFrame.new(0.5, 0.3, -0.3) * CFrame.Angles(0.3, 0, 0)
    weldRight.Parent = right
    
    horns.Parent = character
    return horns
end

local function createCape()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local cape = Instance.new("Part")
    cape.Name = "Cape"
    cape.Size = Vector3.new(2, 3, 0.2)
    cape.BrickColor = BrickColor.new("Dark purple")
    cape.Anchored = false
    cape.CanCollide = false
    cape.Parent = character
    
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = cape
    weld.C0 = CFrame.new(0, 0, -0.5)
    weld.Parent = cape
    
    return cape
end

-- Обновление аксессуаров
local accessories = {}
local accLoop
accLoop = RunService.Heartbeat:Connect(function()
    if not character then return end
    
    -- Удаляем старые аксессуары если выключено
    if not Settings.Accessories.Enabled then
        for _, acc in ipairs(accessories) do
            if acc and acc.Parent then
                acc:Destroy()
            end
        end
        accessories = {}
        return
    end
    
    -- Проверяем какие аксессуары нужно создать
    local needed = {}
    for name, enabled in pairs(Settings.Accessories) do
        if type(enabled) == "boolean" and enabled and name ~= "Enabled" then
            table.insert(needed, name)
        end
    end
    
    -- Удаляем лишние
    for i = #accessories, 1, -1 do
        local acc = accessories[i]
        if acc and acc.Parent then
            local keep = false
            for _, name in ipairs(needed) do
                if acc.Name == name then
                    keep = true
                    break
                end
            end
            if not keep then
                acc:Destroy()
                table.remove(accessories, i)
            end
        else
            table.remove(accessories, i)
        end
    end
    
    -- Создаем недостающие
    for _, name in ipairs(needed) do
        local exists = false
        for _, acc in ipairs(accessories) do
            if acc and acc.Parent and acc.Name == name then
                exists = true
                break
            end
        end
        
        if not exists then
            local func = _G["create" .. name]
            if func then
                local acc = func()
                if acc then
                    table.insert(accessories, acc)
                end
            end
        end
    end
end)

-- Уведомление
StarterGui:SetCore("SendNotification", {
    Title = "DEV-MASTER",
    Text = "Mobile Hub загружен!",
    Duration = 3
})

print("DEV-MASTER MOBILE HUB v5.0 активирован")
