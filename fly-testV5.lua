-- ПОЛЁТ С ДЖОЙСТИКОМ (ВОРОВАННЫЙ ИЗ DELTA HUB)
-- Работает на телефоне, меню перетаскивается

if _G.ZACK_FLY_V5 then return end
_G.ZACK_FLY_V5 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- СОЗДАЁМ ПЛАВАЮЩЕЕ МЕНЮ (можно перетаскивать)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 160, 0, 80)
menuFrame.Position = UDim2.new(0.05, 0, 0.3, 0)  -- Слева, не снизу
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menuFrame.BackgroundTransparency = 0.2
menuFrame.Active = true
menuFrame.Draggable = true  -- МОЖНО ПЕРЕТАСКИВАТЬ
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menuFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.Text = "FLY V5"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = menuFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- КНОПКА ПОЛЁТА
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 35)
flyButton.Position = UDim2.new(0.05, 0, 0.4, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
flyButton.Text = "ВКЛ"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 16
flyButton.Parent = menuFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = flyButton

-- ТЕКСТ СКОРОСТИ
local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(0.4, 0, 0, 25)
speedText.Position = UDim2.new(0.05, 0, 0.75, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "50"
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.Font = Enum.Font.GothamBold
speedText.TextSize = 16
speedText.Parent = menuFrame

local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.2, 0, 0, 25)
speedUp.Position = UDim2.new(0.5, 0, 0.75, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 18
speedUp.Parent = menuFrame

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.2, 0, 0, 25)
speedDown.Position = UDim2.new(0.75, 0, 0.75, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 18
speedDown.Parent = menuFrame

for _, btn in ipairs({speedUp, speedDown}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
end

-- ПЕРЕМЕННЫЕ ПОЛЁТА
local flying = false
local flySpeed = 50
local bodyVelocity = nil

-- УПРАВЛЕНИЕ СКОРОСТЬЮ
speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    speedText.Text = tostring(flySpeed)
end)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(20, flySpeed - 10)
    speedText.Text = tostring(flySpeed)
end)

-- ФУНКЦИЯ ВКЛ/ВЫКЛ
local function toggleFly()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return end
    
    flying = not flying
    
    if flying then
        flyButton.Text = "ВЫКЛ"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.P = 1250
        bodyVelocity.Parent = root
        
        -- ИНСТРУКЦИЯ
        print("=== УПРАВЛЕНИЕ ===")
        print("Тяни джойстик: вперёд/назад/в стороны")
        print("Камера: поворачивай экран")
        print("Летишь туда, куда тянешь джойстик ОТНОСИТЕЛЬНО КАМЕРЫ")
        
    else
        flyButton.Text = "ВКЛ"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
        end
    end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- ОСНОВНОЙ ЦИКЛ ПОЛЁТА
runService.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid or not bodyVelocity then return end
    
    -- ПОЛУЧАЕМ НАПРАВЛЕНИЕ ОТ ДЖОЙСТИКА (штатного)
    local moveDir = humanoid.MoveDirection
    
    if moveDir.Magnitude > 0.1 then
        -- ЕСЛИ ДЖОЙСТИК НАЖАТ
        -- Привязываем направление к КАМЕРЕ
        local cameraCF = camera.CFrame
        local forward = cameraCF.LookVector * Vector3.new(1, 0, 1)
        local right = cameraCF.RightVector * Vector3.new(1, 0, 1)
        
        -- moveDir.X = влево/вправо от джойстика
        -- moveDir.Z = вперёд/назад от джойстика (Z в мире = Y в джойстике)
        local worldMove = (forward * moveDir.Z + right * moveDir.X)
        
        if worldMove.Magnitude > 0 then
            worldMove = worldMove.Unit * flySpeed
        end
        
        bodyVelocity.Velocity = worldMove
    else
        -- ЕСЛИ ДЖОЙСТИК НЕ НАЖАТ - ЗАВИСАЕМ НА МЕСТЕ
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly Test V5",
    Text = "Меню можно перетаскивать",
    Duration = 2
})

print("Fly V5 загружен - джойстик + камера")
