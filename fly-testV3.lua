-- FLY TEST V3 - УПРАВЛЕНИЕ ДЖОЙСТИКОМ
-- Для телефона: летишь туда, куда тянешь стик

if _G.ZACK_FLY_V3 then return end
_G.ZACK_FLY_V3 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- СОЗДАЁМ ИНТЕРФЕЙС
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTestV3"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ГЛАВНАЯ ПАНЕЛЬ
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.8, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.Text = "FLY TEST V3 - ДЖОЙСТИК"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- КНОПКА ВКЛ/ВЫКЛ
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0.9, 0, 0, 45)
flyToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
flyToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
flyToggle.Text = "ВКЛ ПОЛЁТ"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 18
flyToggle.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = flyToggle

-- ПОЛЗУНОК СКОРОСТИ
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 40)
speedFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.3, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 20
speedLabel.Parent = speedFrame

local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.25, 0, 1, 0)
speedUp.Position = UDim2.new(0.35, 0, 0, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 24
speedUp.Parent = speedFrame

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.25, 0, 1, 0)
speedDown.Position = UDim2.new(0.65, 0, 0, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 24
speedDown.Parent = speedFrame

for _, btn in ipairs({speedUp, speedDown}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
end

-- ДЖОЙСТИК (левый нижний угол)
local joystickFrame = Instance.new("Frame")
joystickFrame.Size = UDim2.new(0, 120, 0, 120)
joystickFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
joystickFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
joystickFrame.BackgroundTransparency = 0.3
joystickFrame.Active = true
joystickFrame.Visible = false
joystickFrame.Parent = screenGui

local joystickCorner = Instance.new("UICorner")
joystickCorner.CornerRadius = UDim.new(0, 60)
joystickCorner.Parent = joystickFrame

local joystickKnob = Instance.new("Frame")
joystickKnob.Size = UDim2.new(0, 50, 0, 50)
joystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
joystickKnob.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
joystickKnob.BackgroundTransparency = 0.2
joystickKnob.Parent = joystickFrame

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(0, 25)
knobCorner.Parent = joystickKnob

-- КНОПКИ ВВЕРХ/ВНИЗ
local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0, 70, 0, 70)
upButton.Position = UDim2.new(0.85, -35, 0.4, -35)
upButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
upButton.Text = "▲"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.Font = Enum.Font.GothamBold
upButton.TextSize = 30
upButton.Visible = false
upButton.Parent = screenGui

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 35)
upCorner.Parent = upButton

local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0, 70, 0, 70)
downButton.Position = UDim2.new(0.85, -35, 0.6, -35)
downButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
downButton.Text = "▼"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.Font = Enum.Font.GothamBold
downButton.TextSize = 30
downButton.Visible = false
downButton.Parent = screenGui

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 35)
downCorner.Parent = downButton

-- ПЕРЕМЕННЫЕ ПОЛЁТА
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local joystickActive = false
local joystickDirection = Vector2.new(0, 0)
local verticalInput = 0 -- -1 (вниз), 0, 1 (вверх)

-- ФУНКЦИЯ ОБНОВЛЕНИЯ СКОРОСТИ
local function updateSpeedDisplay()
    speedLabel.Text = tostring(flySpeed)
end

speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    updateSpeedDisplay()
end)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(20, flySpeed - 10)
    updateSpeedDisplay()
end)

-- ФУНКЦИЯ ВКЛ/ВЫКЛ ПОЛЁТА
local function toggleFly()
    local character = player.Character
    if not character then 
        character = player.CharacterAdded:Wait()
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return end
    
    flying = not flying
    
    if flying then
        -- ВКЛЮЧАЕМ ПОЛЁТ
        flyToggle.Text = "ВЫКЛ ПОЛЁТ"
        flyToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Показываем элементы управления
        joystickFrame.Visible = true
        upButton.Visible = true
        downButton.Visible = true
        
        -- Отключаем гравитацию
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        -- Создаём BodyVelocity
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.P = 1250
        bodyVelocity.Parent = root
        
        -- Создаём BodyGyro для стабилизации
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.P = 1250
        bodyGyro.D = 500
        bodyGyro.Parent = root
        
    else
        -- ВЫКЛЮЧАЕМ ПОЛЁТ
        flyToggle.Text = "ВКЛ ПОЛЁТ"
        flyToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        -- Прячем элементы управления
        joystickFrame.Visible = false
        upButton.Visible = false
        downButton.Visible = false
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
        end
    end
end

flyToggle.MouseButton1Click:Connect(toggleFly)

-- ОБРАБОТКА ДЖОЙСТИКА
joystickFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
    end
end)

joystickFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = false
        joystickDirection = Vector2.new(0, 0)
        -- Возвращаем джойстик в центр
        local tween = tweenService:Create(joystickKnob, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
            {Position = UDim2.new(0.5, -25, 0.5, -25)}
        )
        tween:Play()
    end
end)

userInput.TouchMoved:Connect(function(input, processed)
    if not joystickActive then return end
    
    local joystickCenter = joystickFrame.AbsolutePosition + joystickFrame.AbsoluteSize / 2
    local touchPos = input.Position
    local delta = touchPos - joystickCenter
    
    -- Ограничиваем радиус
    local maxRadius = 40
    local length = math.min(delta.Magnitude, maxRadius)
    local direction = delta.Unit * length
    
    if delta.Magnitude > 0 then
        joystickDirection = Vector2.new(direction.X, direction.Y).Unit * (length / maxRadius)
    else
        joystickDirection = Vector2.new(0, 0)
    end
    
    -- Двигаем ручку джойстика
    local newPos = UDim2.new(0.5, direction.X - 25, 0.5, direction.Y - 25)
    local tween = tweenService:Create(joystickKnob, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad), 
        {Position = newPos}
    )
    tween:Play()
end)

-- ОБРАБОТКА КНОПОК ВВЕРХ/ВНИЗ
upButton.MouseButton1Down:Connect(function()
    verticalInput = 1
    upButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
end)

upButton.MouseButton1Up:Connect(function()
    verticalInput = 0
    upButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
end)

downButton.MouseButton1Down:Connect(function()
    verticalInput = -1
    downButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
end)

downButton.MouseButton1Up:Connect(function()
    verticalInput = 0
    downButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
end)

-- ОСНОВНОЙ ЦИКЛ ПОЛЁТА
runService.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or not bodyVelocity or not bodyGyro then return end
    
    -- Получаем направление от джойстика
    local moveX = joystickDirection.X
    local moveZ = joystickDirection.Y  -- Y джойстика = Z в мире
    
    -- Создаём вектор движения
    local moveDirection = Vector3.new(moveX, verticalInput, moveZ)
    
    -- Нормализуем и применяем скорость
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flySpeed
    end
    
    bodyVelocity.Velocity = moveDirection
    
    -- Поворачиваем игрока в направлении движения (если есть горизонтальное движение)
    if math.abs(moveX) > 0.1 or math.abs(moveZ) > 0.1 then
        local lookDirection = Vector3.new(moveX, 0, moveZ)
        if lookDirection.Magnitude > 0 then
            bodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + lookDirection)
        end
    end
end)

-- ОБНОВЛЯЕМ ПЕРСОНАЖА ПРИ РЕСПАВНЕ
player.CharacterAdded:Connect(function()
    if flying then
        toggleFly()
    end
end)

-- Уведомление
starterGui:SetCore("SendNotification", {
    Title = "Fly Test V3",
    Text = "Управление джойстиком!",
    Duration = 3
})

print("Fly Test V3 загружен - используй джойстик для полёта")
