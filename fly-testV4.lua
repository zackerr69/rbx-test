-- FLY TEST V4 - ОБЫЧНЫЙ ДЖОЙСТИК + КАМЕРА
-- Тянешь джойстик вверх = летишь туда, куда смотрит камера
-- Тянешь вниз = летишь назад (от камеры)
-- Влево/вправо = летишь в стороны относительно камеры

if _G.ZACK_FLY_V4 then return end
_G.ZACK_FLY_V4 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local userInput = game:GetService("UserInputService")

-- ПЕРЕМЕННЫЕ ПОЛЁТА
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

-- ПЕРЕМЕННЫЕ ДЖОЙСТИКА
local moveX = 0
local moveY = 0
local joystickActive = false

-- СОЗДАЁМ ИНТЕРФЕЙС
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTestV4"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- КНОПКА ВКЛ/ВЫКЛ (внизу по центру)
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0.5, -100, 0.9, -25)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
flyButton.Text = "ВКЛ ПОЛЁТ"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 18
flyButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = flyButton

-- ТЕКСТ СКОРОСТИ (над кнопкой)
local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(0, 100, 0, 30)
speedText.Position = UDim2.new(0.5, -50, 0.8, -15)
speedText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedText.BackgroundTransparency = 0.3
speedText.Text = "Скорость: 50"
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.Font = Enum.Font.GothamBold
speedText.TextSize = 14
speedText.Parent = screenGui

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedText

-- КНОПКИ +/-
local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0, 40, 0, 40)
plusButton.Position = UDim2.new(0.5, 60, 0.8, -20)
plusButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.Font = Enum.Font.GothamBold
plusButton.TextSize = 24
plusButton.Parent = screenGui

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0, 40, 0, 40)
minusButton.Position = UDim2.new(0.5, -100, 0.8, -20)
minusButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.Font = Enum.Font.GothamBold
minusButton.TextSize = 24
minusButton.Parent = screenGui

for _, btn in ipairs({plusButton, minusButton}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
end

-- ФУНКЦИЯ ИЗМЕНЕНИЯ СКОРОСТИ
plusButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    speedText.Text = "Скорость: " .. flySpeed
end)

minusButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(20, flySpeed - 10)
    speedText.Text = "Скорость: " .. flySpeed
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
        flyButton.Text = "ВЫКЛ ПОЛЁТ"
        flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
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
        flyButton.Text = "ВКЛ ПОЛЁТ"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
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

flyButton.MouseButton1Click:Connect(toggleFly)

-- ОТСЛЕЖИВАНИЕ ДЖОЙСТИКА (стандартного Roblox)
-- В мобильном Roblox джойстик создаётся автоматически
-- Мы просто считываем движение персонажа

local function updateJoystickInput()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Получаем направление движения от стандартного джойстика
    -- В Roblox это работает через MoveDirection
    local moveDirection = humanoid.MoveDirection
    
    if moveDirection.Magnitude > 0 then
        moveX = moveDirection.X
        moveY = moveDirection.Z -- Z в мире = Y в джойстике
        joystickActive = true
    else
        moveX = 0
        moveY = 0
        joystickActive = false
    end
end

-- ОСНОВНОЙ ЦИКЛ ПОЛЁТА
runService.Heartbeat:Connect(function()
    -- Обновляем данные с джойстика
    updateJoystickInput()
    
    if not flying then return end
    
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or not bodyVelocity or not bodyGyro then return end
    
    -- Получаем направления камеры
    local cameraCFrame = camera.CFrame
    local lookVector = cameraCFrame.LookVector  -- Вперёд
    local rightVector = cameraCFrame.RightVector -- Вправо
    
    -- Создаём вектор движения на основе джойстика
    -- moveY > 0 (вверх по джойстику) = летим по lookVector
    -- moveY < 0 (вниз по джойстику) = летим назад (-lookVector)
    -- moveX = вправо/влево по rightVector
    local moveDirection = (lookVector * moveY) + (rightVector * moveX)
    
    -- Добавляем вертикальное движение (пока отключим, но можно добавить)
    -- moveDirection = moveDirection + Vector3.new(0, verticalInput, 0)
    
    -- Применяем скорость
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flySpeed
        bodyVelocity.Velocity = moveDirection
        
        -- Поворачиваем игрока в направлении движения
        bodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + moveDirection)
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- Обновление при смене персонажа
player.CharacterAdded:Connect(function()
    if flying then
        toggleFly() -- Выключаем полёт при смерти
    end
end)

-- Уведомление
starterGui:SetCore("SendNotification", {
    Title = "Fly Test V4",
    Text = "Джойстик + камера. Тяни джойстик!",
    Duration = 3
})

print("Fly Test V4 загружен - джойстик управляет полётом относительно камеры")
