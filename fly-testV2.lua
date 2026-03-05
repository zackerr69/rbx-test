-- FLY TEST V2 - ИСПРАВЛЕННАЯ ВЕРСИЯ
-- Летает в любом направлении (вверх, вниз, прямо)

if _G.ZACK_FLY_TEST then return end
_G.ZACK_FLY_TEST = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

-- СОЗДАЁМ ИНТЕРФЕЙС
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTest"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.8, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "FLY TEST V2"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- КНОПКА ВКЛ/ВЫКЛ ПОЛЁТА
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0.9, 0, 0, 40)
flyToggle.Position = UDim2.new(0.05, 0, 0.35, 0)
flyToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
flyToggle.Text = "ВКЛ ПОЛЁТ"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 16
flyToggle.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = flyToggle

-- КНОПКА ВВЕРХ (для телефона)
local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0.4, 0, 0, 35)
upButton.Position = UDim2.new(0.05, 0, 0.8, 0)
upButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
upButton.Text = "⬆️ ВВЕРХ"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.Font = Enum.Font.GothamBold
upButton.TextSize = 14
upButton.Parent = mainFrame

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 8)
upCorner.Parent = upButton

-- КНОПКА ВНИЗ (для телефона)
local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0.4, 0, 0, 35)
downButton.Position = UDim2.new(0.55, 0, 0.8, 0)
downButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
downButton.Text = "⬇️ ВНИЗ"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.Font = Enum.Font.GothamBold
downButton.TextSize = 14
downButton.Parent = mainFrame

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 8)
downCorner.Parent = downButton

-- ПЕРЕМЕННЫЕ ПОЛЁТА
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local upPressed = false
local downPressed = false

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
        
        -- ЗАПУСКАЕМ ЦИКЛ ПОЛЁТА
        runService.Heartbeat:Connect(function()
            if not flying or not character or not root then return end
            if not bodyVelocity or not bodyGyro then return end
            
            -- ПОЛУЧАЕМ НАПРАВЛЕНИЕ КАМЕРЫ (ПОЛНОЕ, С ВЕРТИКАЛЬЮ)
            local cameraCFrame = camera.CFrame
            local moveDirection = cameraCFrame.LookVector  -- Теперь летим куда смотрит камера!
            
            -- Добавляем вертикальное движение от кнопок
            if upPressed then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if downPressed then
                moveDirection = moveDirection + Vector3.new(0, -1, 0)
            end
            
            -- Нормализуем и применяем скорость
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end
            
            bodyVelocity.Velocity = moveDirection
            bodyGyro.CFrame = cameraCFrame * CFrame.Angles(math.rad(-5), 0, 0)
        end)
        
    else
        -- ВЫКЛЮЧАЕМ ПОЛЁТ
        flyToggle.Text = "ВКЛ ПОЛЁТ"
        flyToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
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

-- ОБРАБОТКА КНОПОК
flyToggle.MouseButton1Click:Connect(toggleFly)

upButton.MouseButton1Down:Connect(function()
    upPressed = true
    upButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end)

upButton.MouseButton1Up:Connect(function()
    upPressed = false
    upButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end)

downButton.MouseButton1Down:Connect(function()
    downPressed = true
    downButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

downButton.MouseButton1Up:Connect(function()
    downPressed = false
    downButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end)

-- ОБНОВЛЯЕМ ПЕРСОНАЖА ПРИ РЕСПАВНЕ
player.CharacterAdded:Connect(function()
    if flying then
        toggleFly() -- Выключаем полёт при смерти
    end
end)

-- Уведомление
starterGui:SetCore("SendNotification", {
    Title = "Fly Test V2",
    Text = "Полёт работает! Используй кнопки",
    Duration = 3
})

print("Fly Test V2 загружен - теперь летает ВВЕРХ и ВНИЗ!")
