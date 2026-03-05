-- ИКОНКА + ПОЛЁТ (проверенный с GitHub)

if _G.ZACK_FLY_COMBO then return end
_G.ZACK_FLY_COMBO = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- ========== ИКОНКА ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHub"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local icon = Instance.new("ImageLabel") -- ImageLabel чтобы видеть картинку
icon.Size = UDim2.new(0, 65, 0, 65)
icon.Position = UDim2.new(0, 15, 0.5, -32.5)
icon.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
icon.BackgroundTransparency = 0.2
icon.Image = "rbxassetid://6223446403" -- Петух
icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 32.5)
iconCorner.Parent = icon

-- КНОПКА ДЛЯ ВКЛЮЧЕНИЯ ПОЛЁТА (прямо на иконке)
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1, 0, 0, 25)
flyToggle.Position = UDim2.new(0, 0, 1, 2)
flyToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
flyToggle.Text = "ПОЛЁТ: ВЫКЛ"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 12
flyToggle.Parent = icon

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = flyToggle

-- ========== ПОЛЁТ ==========
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

-- Функция полёта (украдена с GitHub)
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
        flyToggle.Text = "ПОЛЁТ: ВКЛ"
        flyToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.P = 1250
        bodyVelocity.Parent = root
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.P = 1250
        bodyGyro.D = 500
        bodyGyro.Parent = root
    else
        flyToggle.Text = "ПОЛЁТ: ВЫКЛ"
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

flyToggle.MouseButton1Click:Connect(toggleFly)

-- Цикл полёта
runService.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid or not bodyVelocity or not bodyGyro then return end
    
    local moveDir = humanoid.MoveDirection
    
    if moveDir.Magnitude > 0.1 then
        -- Привязываем к камере
        local cameraCF = camera.CFrame
        local forward = cameraCF.LookVector * Vector3.new(1, 0, 1)
        local right = cameraCF.RightVector * Vector3.new(1, 0, 1)
        
        local worldMove = (forward * moveDir.Z) + (right * moveDir.X)
        
        if worldMove.Magnitude > 0 then
            worldMove = worldMove.Unit * flySpeed
        end
        
        bodyVelocity.Velocity = worldMove
        bodyGyro.CFrame = cameraCF * CFrame.Angles(0, 0, 0)
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

print("Иконка + Полёт загружены")
