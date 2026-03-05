-- Zack_Hub v1.1
-- Автор: @sajkyn

if _G.ZACK_HUB_LOADED then return end
_G.ZACK_HUB_LOADED = true

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

local guiHolder = Instance.new("ScreenGui")
guiHolder.Name = "ZackHub"
guiHolder.Parent = player:WaitForChild("PlayerGui")
guiHolder.ResetOnSpawn = false

-- ИКОНКА МЕНЮ (ПЕТУХ)
local icon = Instance.new("ImageButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 20, 0.5, -30)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.BackgroundTransparency = 0.5
icon.Image = "rbxassetid://6031107863"
icon.Parent = guiHolder

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30)
iconCorner.Parent = icon

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 0, 20)
iconText.Position = UDim2.new(0, 0, 1, 2)
iconText.BackgroundTransparency = 1
iconText.Text = "zack_hub"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.TextStrokeTransparency = 0.3
iconText.Font = Enum.Font.GothamBold
iconText.TextSize = 14
iconText.Parent = icon

local menuOpen = false
local mainMenu = nil
local Settings = {
    Flight = { Enabled = false, Speed = 50, BodyVelocity = nil },
    Noclip = { Enabled = false },
    ESP = { Enabled = false, Objects = {} },
    Invis = { Enabled = false },
    Clicker = { Enabled = false, Target = nil },
    HighJump = { Enabled = false, Power = 50 },
    NoJumpCD = { Enabled = false },
    Walk = { Enabled = false },
    Respawn = { Enabled = false },
    Troll = { Enabled = false },
    Hitbox = { Enabled = false },
    InvisFling = { Enabled = false },
    JackOff = { Enabled = false },
    Cork = { Enabled = false },
    Accessories = {
        Enabled = false,
        Wings_Angel = false,
        Wings_Hell = false,
        Wings_Rooster = false,
        Wings_Plane = false,
        Butt_Dildo = false,
        Carrot = false,
        Tail_Fox = false,
        Neck_Guns = false,
        Head_Spin = false,
        Head_Poop = false,
        Head_Knife = false,
        Head_Dildo = false,
        Head_ClownHair = false,
        Head_Leaf = false,
        Head_Furry = false,
        Head_Pepe = false,
        Head_Ronaldo = false,
        Bird_Shoulder = false,
        Platform_RedCarpet = false,
        Stand_67 = false,
        Car = false,
        MrRobot = false,
        Halo = false,
        Wheelchair = false
    }
}

local activeConnections = {}
local activeAccessories = {}
function createMainMenu()
    mainMenu = Instance.new("Frame")
    mainMenu.Size = UDim2.new(0, 260, 0, 400)
    mainMenu.Position = UDim2.new(0.5, -130, 0.5, -200)
    mainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainMenu.BackgroundTransparency = 0.1
    mainMenu.BorderSizePixel = 0
    mainMenu.Active = true
    mainMenu.Draggable = true
    mainMenu.Visible = true
    mainMenu.Parent = guiHolder

    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 10)
    menuCorner.Parent = mainMenu

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    title.Text = "ZACK HUB v1.1"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainMenu
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = mainMenu
    
    closeBtn.MouseButton1Click:Connect(function()
        mainMenu.Visible = false
        menuOpen = false
    end)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -80)
    container.Position = UDim2.new(0, 5, 0, 40)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 4
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.Parent = mainMenu

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = container

    function createToggle(text, category, key)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.Text = text .. ": Выкл"
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if category == "Accessories" then
                Settings.Accessories[key] = not Settings.Accessories[key]
                btn.Text = text .. ": " .. (Settings.Accessories[key] and "Вкл" or "Выкл")
            else
                Settings[category].Enabled = not Settings[category].Enabled
                btn.Text = text .. ": " .. (Settings[category].Enabled and "Вкл" or "Выкл")
            end
        end)
    end

    function createSlider(text, category, key, min, max, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 50)
        frame.BackgroundTransparency = 1
        frame.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.Parent = frame
        
        local slider = Instance.new("TextButton")
        slider.Size = UDim2.new(1, 0, 0, 25)
        slider.Position = UDim2.new(0, 0, 0, 22)
        slider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        slider.Text = "[" .. string.rep("|", math.floor(default/min)) .. "]"
        slider.TextColor3 = Color3.fromRGB(0, 255, 255)
        slider.Font = Enum.Font.Gotham
        slider.TextSize = 14
        slider.Parent = frame
        
        local val = default
        slider.MouseButton1Click:Connect(function()
            val = val + 1
            if val > max then val = min end
            label.Text = text .. ": " .. val
            slider.Text = "[" .. string.rep("|", val) .. "]"
            if category == "Flight" then
                Settings.Flight.Speed = val * 10
            elseif category == "HighJump" then
                Settings.HighJump.Power = val * 3
            end
        end)
    end

    -- ОСНОВНЫЕ ФУНКЦИИ
    createToggle("Полет", "Flight", "Enabled")
    createToggle("Ноклип", "Noclip", "Enabled")
    createToggle("ЕСП", "ESP", "Enabled")
    createToggle("Невидимость", "Invis", "Enabled")
    createToggle("Нажимка", "Clicker", "Enabled")
    createToggle("Инвис флинг", "InvisFling", "Enabled")
    createToggle("Дрочка", "JackOff", "Enabled")
    createToggle("Коркес", "Cork", "Enabled")
    createToggle("Респаун", "Respawn", "Enabled")
    createToggle("Тролль", "Troll", "Enabled")
    createToggle("Хитбоксы", "Hitbox", "Enabled")
    createToggle("Хотьба", "Walk", "Enabled")
    
    createSlider("Высокие прыжки", "HighJump", "Power", 1, 15, 5)
    createToggle("Прыжки без кд", "NoJumpCD", "Enabled")

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -20, 0, 2)
    sep.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sep.BackgroundTransparency = 0.5
    sep.Parent = container

    local accTitle = Instance.new("TextLabel")
    accTitle.Size = UDim2.new(1, -10, 0, 25)
    accTitle.BackgroundTransparency = 1
    accTitle.Text = "АКСЕССУАРЫ"
    accTitle.TextColor3 = Color3.fromRGB(255, 0, 255)
    accTitle.Font = Enum.Font.GothamBold
    accTitle.TextSize = 16
    accTitle.Parent = container

    createToggle("Крылья ангела", "Accessories", "Wings_Angel")
    createToggle("Крылья адские", "Accessories", "Wings_Hell")
    createToggle("Крылья петуха", "Accessories", "Wings_Rooster")
    createToggle("Крылья самолета", "Accessories", "Wings_Plane")
    createToggle("Дилдо в попе", "Accessories", "Butt_Dildo")
    createToggle("Морковка", "Accessories", "Carrot")
    createToggle("Хвост лисы", "Accessories", "Tail_Fox")
    createToggle("Автоматы на шее", "Accessories", "Neck_Guns")
    createToggle("Вращение головы", "Accessories", "Head_Spin")
    createToggle("Какашка", "Accessories", "Head_Poop")
    createToggle("Нож", "Accessories", "Head_Knife")
    createToggle("Дилдо на голове", "Accessories", "Head_Dildo")
    createToggle("Волосы клоуна", "Accessories", "Head_ClownHair")
    createToggle("Листок ЛОХ", "Accessories", "Head_Leaf")
    createToggle("Голова фурри", "Accessories", "Head_Furry")
    createToggle("Голова Пепе", "Accessories", "Head_Pepe")
    createToggle("Голова Роналдо", "Accessories", "Head_Ronaldo")
    createToggle("Птичка на плече", "Accessories", "Bird_Shoulder")
    createToggle("Красная дорожка", "Accessories", "Platform_RedCarpet")
    createToggle("67 рядом", "Accessories", "Stand_67")
    createToggle("Машинка", "Accessories", "Car")
    createToggle("Мистер Робот", "Accessories", "MrRobot")
    createToggle("Нимб", "Accessories", "Halo")
    createToggle("Коляска", "Accessories", "Wheelchair")

    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, -10, 0, 40)
    footer.BackgroundTransparency = 1
    footer.Text = "О МЕНЮ:\nВерсия 1.1\nРазработчик: @sajkyn"
    footer.TextColor3 = Color3.fromRGB(150, 150, 150)
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 11
    footer.LineHeight = 1.5
    footer.Parent = container
end

createMainMenu()

icon.MouseButton1Click:Connect(function()
    if mainMenu then
        mainMenu.Visible = not mainMenu.Visible
    end
end)
-- ПОЛЕТ
RunService.Heartbeat:Connect(function()
    if not character then return end
    if Settings.Flight.Enabled then
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if root and humanoid then
            if not Settings.Flight.BodyVelocity then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(4000, 4000, 4000)
                bv.Parent = root
                Settings.Flight.BodyVelocity = bv
            end
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir + Vector3.new(0,-1,0) end
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * Settings.Flight.Speed end
            Settings.Flight.BodyVelocity.Velocity = moveDir
            humanoid.PlatformStand = true
        end
    elseif Settings.Flight.BodyVelocity then
        Settings.Flight.BodyVelocity:Destroy()
        Settings.Flight.BodyVelocity = nil
    end
end)

-- НОКЛИП
RunService.Stepped:Connect(function()
    if Settings.Noclip.Enabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- НЕВИДИМОСТЬ
RunService.Heartbeat:Connect(function()
    if Settings.Invis.Enabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 1 end
        end
    elseif character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
    end
end)
-- НАЖИМКА
local function findNearestPlayer()
    local nearest = nil
    local dist = math.huge
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local plrRoot = plr.Character.HumanoidRootPart
            local d = (plrRoot.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                nearest = plr
            end
        end
    end
    return nearest, dist
end

RunService.Heartbeat:Connect(function()
    if not Settings.Clicker.Enabled or not character then return end
    local target, dist = findNearestPlayer()
    if target and dist < 8 then
        local arm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
        if arm then
            local motor = arm:FindFirstChildOfClass("Motor6D")
            if motor then
                motor.C0 = CFrame.new(0.5, 0, -0.5) * CFrame.Angles(1.5, 0, 0)
                task.wait(0.05)
                motor.C0 = CFrame.new(0.5, 0, 0)
            end
        end
    end
end)
-- ВЫСОКИЕ ПРЫЖКИ
local function onJumpRequest()
    if not Settings.HighJump.Enabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = Settings.HighJump.Power * 3
    end
end

UserInputService.JumpRequest:Connect(onJumpRequest)

-- ПРЫЖКИ БЕЗ КД
RunService.Heartbeat:Connect(function()
    if Settings.NoJumpCD.Enabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = 50
            humanoid.Jump = true
        end
    end
end)
function createWingsAngel()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    local model = Instance.new("Model")
    model.Name = "Wings_Angel"
    model.Parent = character
    
    local left = Instance.new("Part")
    left.Size = Vector3.new(0.5, 2, 1)
    left.BrickColor = BrickColor.new("White")
    left.Anchored = false
    left.CanCollide = false
    left.Parent = model
    
    local right = left:Clone()
    right.Parent = model
    
    local w1 = Instance.new("Weld")
    w1.Part0 = torso
    w1.Part1 = left
    w1.C0 = CFrame.new(-1, 0.5, 0.3) * CFrame.Angles(0, 0.2, 0.3)
    w1.Parent = left
    
    local w2 = Instance.new("Weld")
    w2.Part0 = torso
    w2.Part1 = right
    w2.C0 = CFrame.new(1, 0.5, 0.3) * CFrame.Angles(0, -0.2, -0.3)
    w2.Parent = right
    
    return model
end

function createButtDildo()
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("LowerTorso")
    if not torso then return end
    local model = Instance.new("Model")
    model.Name = "Butt_Dildo"
    model.Parent = character
    
    local base = Instance.new("Part")
    base.Size = Vector3.new(0.8, 0.5, 0.8)
    base.BrickColor = BrickColor.new("Hot pink")
    base.Anchored = false
    base.CanCollide = false
    base.Parent = model
    
    local shaft = Instance.new("Part")
    shaft.Size = Vector3.new(0.5, 2, 0.5)
    shaft.BrickColor = BrickColor.new("Bright violet")
    shaft.Anchored = false
    shaft.CanCollide = false
    shaft.Parent = model
    
    local tip = Instance.new("Part")
    tip.Size = Vector3.new(0.7, 0.4, 0.7)
    tip.BrickColor = BrickColor.new("Bright red")
    tip.Anchored = false
    tip.CanCollide = false
    tip.Parent = model
    
    Instance.new("Weld").Parent = base
    Instance.new("Weld").Parent = shaft
    Instance.new("Weld").Parent = tip
    
    base.Weld.Part0 = torso
    base.Weld.Part1 = base
    base.Weld.C0 = CFrame.new(0, -0.5, -0.8) * CFrame.Angles(0.3, 0, 0)
    
    shaft.Weld.Part0 = base
    shaft.Weld.Part1 = shaft
    shaft.Weld.C0 = CFrame.new(0, 1, 0)
    
    tip.Weld.Part0 = shaft
    tip.Weld.Part1 = tip
    tip.Weld.C0 = CFrame.new(0, 1.2, 0)
    
    return model
end

-- ОБНОВЛЕНИЕ АКСЕССУАРОВ
RunService.Heartbeat:Connect(function()
    if not character then return end
    
    if not Settings.Accessories.Enabled then
        for _, acc in pairs(activeAccessories) do
            if acc then acc:Destroy() end
        end
        activeAccessories = {}
        return
    end
    
    for name, enabled in pairs(Settings.Accessories) do
        if name ~= "Enabled" and type(enabled) == "boolean" then
            if enabled and not activeAccessories[name] then
                local func = _G["create" .. name]
                if func then
                    activeAccessories[name] = func()
                end
            elseif not enabled and activeAccessories[name] then
                activeAccessories[name]:Destroy()
                activeAccessories[name] = nil
            end
        end
    end
end)
-- ESP
RunService.Stepped:Connect(function()
    if not Settings.ESP.Enabled then
        for obj, hl in pairs(Settings.ESP.Objects) do
            if hl then hl:Destroy() end
        end
        Settings.ESP.Objects = {}
        return
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and not Settings.ESP.Objects[plr.Character] then
            local hl = Instance.new("Highlight")
            hl.Adornee = plr.Character
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.FillTransparency = 0.5
            hl.Parent = guiHolder
            Settings.ESP.Objects[plr.Character] = hl
        end
    end
end)

-- ХИТБОКСЫ
RunService.Heartbeat:Connect(function()
    if not Settings.Hitbox.Enabled then return end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:FindFirstChild("HitboxHighlight") then
            local hl = Instance.new("Highlight")
            hl.Name = "HitboxHighlight"
            hl.Adornee = v
            hl.FillColor = Color3.fromRGB(0, 255, 0)
            hl.FillTransparency = 0.7
            hl.Parent = v
        end
    end
end)
StarterGui:SetCore("SendNotification", {
    Title = "Zack_Hub v1.1",
    Text = "Загружен! Разработчик: @sajkyn",
    Duration = 3
})

print("Zack_Hub v1.1 активирован")
