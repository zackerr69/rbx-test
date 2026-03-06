-- ZACK HUB V7 (АНИМЕ-ВЕРСИЯ)
-- Полет (Fly Gui V3), Noclip, ESP уже были
-- Добавлено: InvisFling, JumpBoost (до 75x), новый Chams, красивый фон

if _G.ZACK_V7_RUN then return end
_G.ZACK_V7_RUN = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local starterGui = game:GetService("StarterGui")
local userInput = game:GetService("UserInputService")

-- ========== ИКОНКА (ФИОЛЕТОВЫЙ ФОН + ОБЛАКА) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubV7"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 80, 0, 80)
icon.Position = UDim2.new(0, 10, 0.5, -40)
icon.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- фиолетовый
icon.BackgroundTransparency = 0.2
icon.Text = "ZACK"
icon.TextColor3 = Color3.fromRGB(230, 230, 250) -- ярко-серебряный
icon.TextSize = 20
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = gui

-- Текстура облаков на иконке
local iconCloud = Instance.new("ImageLabel")
iconCloud.Size = UDim2.new(1, 0, 1, 0)
iconCloud.BackgroundTransparency = 1
iconCloud.Image = "rbxassetid://13882937829" -- облака
iconCloud.ImageColor3 = Color3.fromRGB(255, 255, 255)
iconCloud.ImageTransparency = 0.3
iconCloud.Parent = icon

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 40)
iconCorner.Parent = icon

-- ========== МЕНЮ (ГОЛУБОЕ НЕБО + ОБЛАКА) ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 500)
menu.Position = UDim2.new(0.5, -150, 0.5, -250)
menu.BackgroundColor3 = Color3.fromRGB(135, 206, 250) -- голубое небо
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuClouds = Instance.new("ImageLabel")
menuClouds.Size = UDim2.new(1, 0, 1, 0)
menuClouds.BackgroundTransparency = 1
menuClouds.Image = "rbxassetid://14871650383" -- аниме-облака
menuClouds.ImageTransparency = 0.2
menuClouds.Parent = menu

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
title.BackgroundTransparency = 0.3
title.Text = "ZACK HUB V7"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = menu

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.Parent = menu
close.MouseButton1Click:Connect(function() menu.Visible = false end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -60)
container.Position = UDim2.new(0, 5, 0, 55)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 800)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = container

-- ========== ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ==========
function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- ========== INVISFLING (РАБОЧИЙ) ==========
local flingActive = false
local flingConnection = nil

createButton("🔥 INVISFLING", function()
    flingActive = not flingActive
    if flingActive then
        -- Делаем игрока невидимым
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 1 end
        end
        flingConnection = runService.Heartbeat:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            -- Находим ближайшие объекты и кидаем
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Anchored == false and v ~= root then
                    local dist = (v.Position - root.Position).Magnitude
                    if dist < 20 then
                        v.Velocity = (v.Position - root.Position).Unit * 100 + Vector3.new(0, 50, 0)
                    end
                end
            end
        end)
    else
        if flingConnection then flingConnection:Disconnect() end
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
    end
end)

-- ========== JUMP BOOST (ПОЛЗУНОК ДО 75x) ==========
local jumpPower = 50
local jumpActive = false
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0.6, 0, 0, 30)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "ПРЫЖОК: 1.0x"
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.Font = Enum.Font.GothamBold
jumpLabel.TextSize = 16
jumpLabel.Parent = container

local jumpSlider = Instance.new("TextButton")
jumpSlider.Size = UDim2.new(0.3, 0, 0, 30)
jumpSlider.Position = UDim2.new(0.65, 0, 0, 0)
jumpSlider.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
jumpSlider.Text = "▶"
jumpSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpSlider.Font = Enum.Font.GothamBold
jumpSlider.Parent = container

local sliderValue = 1
jumpSlider.MouseButton1Click:Connect(function()
    sliderValue = sliderValue + 1
    if sliderValue > 75 then sliderValue = 1 end
    jumpPower = 50 * sliderValue
    jumpLabel.Text = "ПРЫЖОК: " .. sliderValue .. ".0x"
end)

createButton("ВКЛ/ВЫКЛ ПРЫЖКИ", function()
    jumpActive = not jumpActive
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = jumpActive and jumpPower or 50
    end
end)

-- ========== CHAMS (АНИМЕ-НЕБО + ПЕТУШОК) ==========
createButton("🐓 CHAMS (АНИМЕ)", function()
    lighting.Ambient = Color3.fromRGB(100, 150, 255)
    lighting.Brightness = 0.5
    lighting.OutdoorAmbient = Color3.fromRGB(80, 120, 255)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://14871650383"
    sky.SkyboxDn = "rbxassetid://14871650383"
    sky.SkyboxFt = "rbxassetid://14871650383"
    sky.SkyboxLf = "rbxassetid://14871650383"
    sky.SkyboxRt = "rbxassetid://14871650383"
    sky.SkyboxUp = "rbxassetid://14871650383"
    sky.StarCount = 0
    sky.Parent = lighting

    -- Петушок на небе (картинка)
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 100, 0, 100)
    bill.StudsOffset = Vector3.new(0, 50, 0)
    bill.AlwaysOnTop = true
    bill.Parent = player.Character and player.Character:FindFirstChild("Head")

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://2888916676" -- петушок
    img.Parent = bill
end)

icon.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

starterGui:SetCore("SendNotification", {Title="ZACK V7", Text="Аниме-версия", Duration=3})
