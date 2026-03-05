-- MENU V5 - ФИНАЛ
-- Все твои ID вставлены:
-- Крылья демона: 9560100775 + 9560100750
-- Крылья ангела: 98594662227451 + 112908280935447  
-- Крылья петуха: 14395684098 + 14395684065
-- Chams: 6744228280 + 6744228269
-- 67: 134182134850446 + 100277086825066

if _G.ZACK_MENU_V5 then return end
_G.ZACK_MENU_V5 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local lighting = game:GetService("Lighting")

-- ========== ИКОНКА ZCKRR ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackMenu"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 70, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = "ZCKRR"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 16
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 35)
iconCorner.Parent = icon

-- ========== МЕНЮ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 450)
menu.Position = UDim2.new(0.5, -140, 0.5, -225)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
menu.BackgroundTransparency = 0.1
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

-- Звёзды в меню
for i = 1, 50 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random(0, 7) / 10
    star.BorderSizePixel = 0
    star.Parent = menu
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "ZACK MENU V5"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = menu

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
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
container.ScrollBarThickness = 5
container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
container.CanvasSize = UDim2.new(0, 0, 0, 500)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- ========== ПЕРЕМЕННЫЕ ==========
local states = {
    chams = false,
    jack = false,
    wingsDemon = false,
    wingsAngel = false,
    wingsRooster = false,
    accessory67 = false
}

local accessories = {}

-- ========== ФУНКЦИЯ КНОПКИ ==========
function createButton(text, stateName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. ": ▢"
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        states[stateName] = not states[stateName]
        btn.Text = text .. ": " .. (states[stateName] and "✓" or "▢")
        btn.BackgroundColor3 = states[stateName] and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(40, 40, 60)
        
        if stateName == "chams" then
            toggleChams()
        elseif stateName == "jack" then
            toggleJack()
        elseif stateName:find("wings") then
            toggleWings(stateName)
        elseif stateName == "accessory67" then
            toggle67()
        end
    end)
end

-- ========== КНОПКИ ==========
createButton("CHAMS", "chams")
createButton("ДРОЧКА", "jack")
createButton("КРЫЛЬЯ ДЕМОНА", "wingsDemon")
createButton("КРЫЛЬЯ АНГЕЛА", "wingsAngel")
createButton("КРЫЛЬЯ ПЕТУХА", "wingsRooster")
createButton("67", "accessory67")

-- ========== CHAMS (ТВОЙ ID) ==========
function toggleChams()
    if states.chams then
        lighting.Ambient = Color3.fromRGB(30, 30, 50)
        lighting.Brightness = 0.4
        lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
        
        local sky = lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = lighting
        end
        sky.SkyboxBk = "rbxassetid://6744228280"
        sky.SkyboxDn = "rbxassetid://6744228280"
        sky.SkyboxFt = "rbxassetid://6744228280"
        sky.SkyboxLf = "rbxassetid://6744228280"
        sky.SkyboxRt = "rbxassetid://6744228280"
        sky.SkyboxUp = "rbxassetid://6744228280"
        sky.StarCount = 3000
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end

-- ========== ДРОЧКА (АККУРАТНАЯ) ==========
local jackConnection = nil

function toggleJack()
    if states.jack then
        jackConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
            
            if not root or not humanoid or not rightArm then return end
            
            -- Фиксируем персонажа
            humanoid.PlatformStand = true
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
            
            -- Анимация руки
            local motor = rightArm:FindFirstChildOfClass("Motor6D")
            if motor then
                local t = tick() * 8
                motor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(math.sin(t) * 1.2, math.cos(t) * 0.2, 0)
            end
        end)
    else
        if jackConnection then
            jackConnection:Disconnect()
            jackConnection = nil
            
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end
end

-- ========== ФУНКЦИЯ ЗАГРУЗКИ МОДЕЛИ ==========
function loadAsset(assetId, textureId, parent, cframe)
    local success, model = pcall(function()
        return game:GetObjects("rbxassetid://" .. assetId)[1]
    end)
    
    if success and model then
        model.Parent = parent
        
        -- Применяем текстуру если есть
        if textureId then
            for _, child in ipairs(model:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.TextureID = "rbxassetid://" .. textureId
                end
            end
        end
        
        -- Создаём крепление
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart and cframe then
            local weld = Instance.new("Weld")
            weld.Part0 = rootPart
            weld.Part1 = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            weld.C0 = cframe
            weld.Parent = weld.Part1
        end
        
        return model
    end
    return nil
end

-- ========== КРЫЛЬЯ ==========
function toggleWings(type)
    local key = "wings" .. type
    if states[key] then
        if not accessories[key] then
            local assetId, textureId, cframe
            
            if type == "Demon" then
                assetId = "9560100775"
                textureId = "9560100750"
                cframe = CFrame.new(-1.5, 0.5, 0)
            elseif type == "Angel" then
                assetId = "98594662227451"
                textureId = "112908280935447"
                cframe = CFrame.new(-1.5, 0.5, 0)
            elseif type == "Rooster" then
                assetId = "14395684098"
                textureId = "14395684065"
                cframe = CFrame.new(-1.5, 0.5, 0)
            end
            
            accessories[key] = loadAsset(assetId, textureId, player.Character, cframe)
        end
    else
        if accessories[key] then
            accessories[key]:Destroy()
            accessories[key] = nil
        end
    end
end

-- ========== 67 (ЦИФРЫ С ГЛАЗАМИ) ==========
function toggle67()
    if states.accessory67 then
        if not accessories["67"] then
            local assetId = "134182134850446"
            local textureId = "100277086825066"
            local cframe = CFrame.new(3, 0, 0) -- Справа от игрока
            
            accessories["67"] = loadAsset(assetId, textureId, player.Character, cframe)
        end
    else
        if accessories["67"] then
            accessories["67"]:Destroy()
            accessories["67"] = nil
        end
    end
end

-- ========== ОТКРЫТИЕ МЕНЮ ==========
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ========== ЗАВЕРШЕНИЕ ==========
starterGui:SetCore("SendNotification", {
    Title = "ZACK MENU V5",
    Text = "Все твои ID загружены",
    Duration = 3
})

print("ZACK MENU V5 - ФИНАЛ")
print("Крылья демона: 9560100775")
print("Крылья ангела: 98594662227451") 
print("Крылья петуха: 14395684098")
print("Chams: 6744228280")
print("67: 134182134850446")
