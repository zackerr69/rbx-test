-- Zack_Hub - ТЕСТОВАЯ ВЕРСИЯ (только полёт)
-- Запусти это ОТДЕЛЬНО, без всего остального

-- Защита
if _G.ZACK_FLY_TEST then return end
_G.ZACK_FLY_TEST = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- СОЗДАЁМ КНОПКУ ДЛЯ ТЕЛЕФОНА
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTest"
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0.5, -100, 0.8, -25)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
flyButton.Text = "ВКЛ ПОЛЁТ"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 18
flyButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = flyButton

-- ПЕРЕМЕННЫЕ ПОЛЁТА
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

-- ФУНКЦИЯ ВКЛ/ВЫКЛ ПОЛЁТА
local function toggleFly()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return end
    
    flying = not flying
    
    if flying then
        -- ВКЛЮЧАЕМ ПОЛЁТ
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
        bodyGyro.Parent = root
        
        -- Запускаем цикл полёта
        runService.Heartbeat:Connect(function()
            if not flying or not character or not root then return end
            
            -- Получаем направление камеры
            local moveDirection = Vector3.new()
            local cameraCFrame = camera.CFrame
            
            -- Для телефона: используем кнопки на экране
            -- (но пока просто летим вперёд по направлению камеры)
            moveDirection = cameraCFrame.LookVector * Vector3.new(1, 0, 1)
            
            -- Поднимаем/опускаем (можно добавить кнопки позже)
            if userInput:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection + Vector3.new(0, -1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end
            
            bodyVelocity.Velocity = moveDirection
            bodyGyro.CFrame = cameraCFrame * CFrame.Angles(math.rad(-10), 0, 0)
        end)
        
    else
        -- ВЫКЛЮЧАЕМ ПОЛЁТ
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

-- Обработка нажатия на кнопку
flyButton.MouseButton1Click:Connect(toggleFly)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Тест полёта",
    Text = "Нажми кнопку для полёта",
    Duration = 3
})

print("Тест полёта загружен - нажми кнопку на экране")
