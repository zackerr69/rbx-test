-- ============================================
-- ZACK HUB v2.0 - ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ
-- ============================================

if _G.ZACK_HUB_V2 then return end
_G.ZACK_HUB_V2 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local Settings = {
    Fly = { Enabled = false, Speed = 50 },
    JackOff = { Enabled = false },
    Chams = { Enabled = false }
}

-- ============================================
-- ИКОНКА ПЕТУХА
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHub"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local icon = Instance.new("ImageButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 10, 0.5, -30)
icon.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
icon.BackgroundTransparency = 0.2
icon.Image = "rbxassetid://6031107863"
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30)
iconCorner.Parent = icon

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 0, 20)
iconText.Position = UDim2.new(0, 0, 1, 2)
iconText.BackgroundTransparency = 1
iconText.Text = "ZH"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.Font = Enum.Font.GothamBold
iconText.TextSize = 14
iconText.Parent = icon

-- ============================================
-- МЕНЮ (КОСМОС)
-- ============================================
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0.5, -125, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
menu.BackgroundTransparency = 0.1
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

-- ЗВЁЗДЫ
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
title.Text = "ZACK HUB v2.0"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = menu

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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
container.CanvasSize = UDim2.new(0, 0, 0, 150)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

function createButton(text, setting)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. ": Выкл"
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings[setting].Enabled = not Settings[setting].Enabled
        btn.Text = text .. ": " .. (Settings[setting].Enabled and "Вкл" or "Выкл")
        btn.BackgroundColor3 = Settings[setting].Enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 60)
    end)
end

createButton("Полет", "Fly")
createButton("Дрочка", "JackOff")
createButton("Chams (небо)", "Chams")

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ============================================
-- ПОЛЁТ (РАБОЧИЙ)
-- ============================================
local flyConnection
local function setupFly()
    local function flyLoop()
        if not Settings.Fly.Enabled then
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not humanoid then return end
        
        -- Отключаем гравитацию
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        -- Получаем ввод с джойстика
        local moveDir = humanoid.MoveDirection
        
        if moveDir.Magnitude > 0 then
            -- Привязываем к камере
            local cameraCF = camera.CFrame
            local forward = cameraCF.LookVector * Vector3.new(1, 0, 1)
            local right = cameraCF.RightVector * Vector3.new(1, 0, 1)
            
            -- moveDir.X = влево/вправо, moveDir.Z = вперёд/назад
            local worldMove = (forward * moveDir.Z) + (right * moveDir.X)
            
            if worldMove.Magnitude > 0 then
                worldMove = worldMove.Unit * Settings.Fly.Speed
            end
            
            root.Velocity = worldMove
        else
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    flyConnection = RunService.Heartbeat:Connect(flyLoop)
end

-- Включаем/выключаем полёт
local function onFlyToggle()
    if Settings.Fly.Enabled then
        setupFly()
    end
end

-- Следим за изменением настроек
game:GetService("RunService").Heartbeat:Connect(function()
    if Settings.Fly.Enabled and not flyConnection then
        setupFly()
    end
end)

-- ============================================
-- ДРОЧКА (РАБОЧАЯ)
-- ============================================
local jackOffConnection
RunService.Heartbeat:Connect(function()
    if not Settings.JackOff.Enabled then
        if jackOffConnection then
            jackOffConnection:Disconnect()
            jackOffConnection = nil
        end
        return
    end
    
    local char = player.Character
    if not char then return end
    
    local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    local leftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if not rightArm or not humanoid then return end
    
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    
    local motor = rightArm:FindFirstChildOfClass("Motor6D")
    if motor then
        local t = tick() * 8
        motor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(math.sin(t) * 1.5, 0, 0)
    end
    
    if leftArm then
        local leftMotor = leftArm:FindFirstChildOfClass("Motor6D")
        if leftMotor then
            leftMotor.C0 = CFrame.new(-0.5, 0, 0) * CFrame.Angles(-0.5, 0, 0)
        end
    end
end)

-- ============================================
-- CHAMS (НЕБО)
-- ============================================
RunService.Heartbeat:Connect(function()
    if Settings.Chams.Enabled then
        Lighting.Ambient = Color3.fromRGB(20, 20, 40)
        Lighting.Brightness = 0.5
        Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 30)
        
        -- Звёзды
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = Lighting
        end
        sky.StarCount = 3000
        sky.SkyboxBk = "rbxassetid://160349229"
        sky.SkyboxDn = "rbxassetid://160349229"
        sky.SkyboxFt = "rbxassetid://160349229"
        sky.SkyboxLf = "rbxassetid://160349229"
        sky.SkyboxRt = "rbxassetid://160349229"
        sky.SkyboxUp = "rbxassetid://160349229"
    else
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end)

-- ============================================
-- ЗАВЕРШЕНИЕ
-- ============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZACK HUB v2.0",
    Text = "ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ",
    Duration = 3
})

print("ZACK HUB v2.0 ЗАГРУЖЕН")
