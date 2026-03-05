-- ZACK HUB v4.0 - ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ
-- Иконка: настоящий петух (2888916676)
-- Полет: Fly GUI V3 (проверенный)
-- Дрочка: анимация рук

if _G.ZACK_HUB_V4 then return end
_G.ZACK_HUB_V4 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")

-- ========== ИКОНКА С ПЕТУХОМ (ТВОЙ ID) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubV4"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local icon = Instance.new("ImageButton") -- ImageButton чтобы нажималось
icon.Size = UDim2.new(0, 70, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
icon.BackgroundTransparency = 0.2
icon.Image = "rbxassetid://2888916676" -- ТВОЙ ПЕТУХ
icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 35)
iconCorner.Parent = icon

-- Текст состояния
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Position = UDim2.new(0, 0, 1, 2)
statusText.BackgroundTransparency = 1
statusText.Text = "FLY: OFF | JK: OFF"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 10
statusText.Parent = icon

-- ========== МЕНЮ УПРАВЛЕНИЯ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 220, 0, 150)
menu.Position = UDim2.new(0.8, -220, 0.5, -75)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.2
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.Text = "ZACK HUB v4.0"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = menu

-- Кнопки меню
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9, 0, 0, 35)
flyBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
flyBtn.Text = "ПОЛЕТ: ВЫКЛ"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 14
flyBtn.Parent = menu

local jackBtn = Instance.new("TextButton")
jackBtn.Size = UDim2.new(0.9, 0, 0, 35)
jackBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
jackBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
jackBtn.Text = "ДРОЧКА: ВЫКЛ"
jackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jackBtn.Font = Enum.Font.GothamBold
jackBtn.TextSize = 14
jackBtn.Parent = menu

local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(0.5, 0, 0, 25)
speedText.Position = UDim2.new(0.05, 0, 0.75, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "СКОР: 50"
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.Font = Enum.Font.GothamBold
speedText.TextSize = 12
speedText.Parent = menu

local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.15, 0, 0, 25)
speedUp.Position = UDim2.new(0.6, 0, 0.75, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 16
speedUp.Parent = menu

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.15, 0, 0, 25)
speedDown.Position = UDim2.new(0.8, 0, 0.75, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 16
speedDown.Parent = menu

for _, btn in ipairs({flyBtn, jackBtn, speedUp, speedDown}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
end

-- ========== ПЕРЕМЕННЫЕ ==========
local flying = false
local jacking = false
local flySpeed = 50
local flyConnection = nil
local jackConnection = nil

-- ========== ПОЛЁТ (ИЗ ТВОЕГО СКРИПТА) ==========
local function toggleFly()
    flying = not flying
    flyBtn.Text = flying and "ПОЛЕТ: ВКЛ" or "ПОЛЕТ: ВЫКЛ"
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(0, 100, 200)
    statusText.Text = "FLY: " .. (flying and "ON" or "OFF") .. " | JK: " .. (jacking and "ON" or "OFF")
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then return end
    
    if flying then
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        -- BodyGyro для стабилизации
        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        
        -- BodyVelocity для движения
        local bv = Instance.new("BodyVelocity", root)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        flyConnection = runService.Heartbeat:Connect(function()
            if not flying or not character or not root then 
                if flyConnection then flyConnection:Disconnect() end
                return 
            end
            
            local moveDir = humanoid.MoveDirection
            local cameraCF = camera.CFrame
            
            if moveDir.Magnitude > 0 then
                local forward = cameraCF.LookVector * Vector3.new(1, 0, 1)
                local right = cameraCF.RightVector * Vector3.new(1, 0, 1)
                local worldMove = (forward * moveDir.Z) + (right * moveDir.X)
                
                if worldMove.Magnitude > 0 then
                    worldMove = worldMove.Unit * flySpeed
                end
                bv.Velocity = worldMove
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            
            bg.cframe = cameraCF * CFrame.Angles(0, 0, 0)
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
    end
end

-- ========== ДРОЧКА ==========
local function toggleJack()
    jacking = not jacking
    jackBtn.Text = jacking and "ДРОЧКА: ВКЛ" or "ДРОЧКА: ВЫКЛ"
    jackBtn.BackgroundColor3 = jacking and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 200)
    statusText.Text = "FLY: " .. (flying and "ON" or "OFF") .. " | JK: " .. (jacking and "ON" or "OFF")
    
    if jacking then
        jackConnection = runService.Heartbeat:Connect(function()
            local character = player.Character
            if not character or not jacking then 
                if jackConnection then jackConnection:Disconnect() end
                return 
            end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
            
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
        end
    end
end

-- ========== УПРАВЛЕНИЕ СКОРОСТЬЮ ==========
speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    speedText.Text = "СКОР: " .. flySpeed
end)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(20, flySpeed - 10)
    speedText.Text = "СКОР: " .. flySpeed
end)

-- ========== КЛИКИ ПО КНОПКАМ ==========
flyBtn.MouseButton1Click:Connect(toggleFly)
jackBtn.MouseButton1Click:Connect(toggleJack)

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ========== ЗАВЕРШЕНИЕ ==========
starterGui:SetCore("SendNotification", {
    Title = "ZACK HUB v4.0",
    Text = "Петух: 2888916676 | Полёт + Дрочка",
    Duration = 3
})

print([[

════════════════════════════════
   ZACK HUB v4.0 ЗАГРУЖЕН
   ✅ Петух: 2888916676
   ✅ Полёт: Fly GUI V3
   ✅ Дрочка: Анимация
   Нажми на петуха для меню
════════════════════════════════
]])
