-- ZACK HUB V8 – ФИНАЛЬНАЯ СБОРКА
-- Иконка: фиолет+облака + серебро
-- Меню: тянка (6744228280)
-- Аниме-небо (126949309)
-- Chams 1: идеальное небо (12371622424 + текстура)
-- InvisFling (чистый, без ссылок)
-- JumpBoost (ползунок до 75x, качественный)

if _G.ZACK_V8_RUN then return end
_G.ZACK_V8_RUN = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local starterGui = game:GetService("StarterGui")

-- ========== ИКОНКА (ФИОЛЕТ + ОБЛАКА + СЕРЕБРЯНЫЙ ТЕКСТ) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubV8"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 85, 0, 85)
icon.Position = UDim2.new(0, 10, 0.5, -42)
icon.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- фиолет
icon.BackgroundTransparency = 0.2
icon.Text = "ZACK"
icon.TextColor3 = Color3.fromRGB(230, 230, 250) -- серебро
icon.TextSize = 22
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = gui

-- Облака на иконке
local iconCloud = Instance.new("ImageLabel")
iconCloud.Size = UDim2.new(1, 0, 1, 0)
iconCloud.BackgroundTransparency = 1
iconCloud.Image = "rbxassetid://13882937829"
iconCloud.ImageTransparency = 0.3
iconCloud.Parent = icon

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 42)
iconCorner.Parent = icon

-- ========== МЕНЮ С ТЯНКОЙ (6744228280) ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 350, 0, 550)
menu.Position = UDim2.new(0.5, -175, 0.5, -275)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local menuBg = Instance.new("ImageLabel")
menuBg.Size = UDim2.new(1, 0, 1, 0)
menuBg.BackgroundTransparency = 1
menuBg.Image = "rbxassetid://6744228280" -- тянка
menuBg.ScaleType = Enum.ScaleType.Crop
menuBg.Parent = menu

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 25)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.BackgroundTransparency = 0.5
title.Text = "ZACK HUB V8"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = menu

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -45, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 24
close.Parent = menu
close.MouseButton1Click:Connect(function() menu.Visible = false end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -80)
container.Position = UDim2.new(0, 10, 0, 70)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 800)
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = container

-- ========== INVISFLING (ЧИСТЫЙ, РАБОЧИЙ) ==========
local flingActive = false
local flingConn = nil

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1, 0, 0, 50)
flingBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
flingBtn.Text = "INVISFLING: ВЫКЛ"
flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 20
flingBtn.Parent = container

local flingCorner = Instance.new("UICorner")
flingCorner.CornerRadius = UDim.new(0, 12)
flingCorner.Parent = flingBtn

flingBtn.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    flingBtn.Text = flingActive and "INVISFLING: ВКЛ" or "INVISFLING: ВЫКЛ"
    flingBtn.BackgroundColor3 = flingActive and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(70, 70, 200)

    if flingActive then
        -- Невидимость
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.Transparency = 1 end
        end
        flingConn = runService.Heartbeat:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Anchored and v ~= root then
                    local dist = (v.Position - root.Position).Magnitude
                    if dist < 25 then
                        v.Velocity = (v.Position - root.Position).Unit * 120 + Vector3.new(0, 60, 0)
                    end
                end
            end
        end)
    else
        if flingConn then flingConn:Disconnect() end
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.Transparency = 0 end
        end
    end
end)

-- ========== JUMP BOOST (ПОЛЗУНОК ДО 75x) ==========
local jumpPower = 50
local jumpMult = 1
local jumpActive = false

local jumpFrame = Instance.new("Frame")
jumpFrame.Size = UDim2.new(1, 0, 0, 70)
jumpFrame.BackgroundTransparency = 1
jumpFrame.Parent = container

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, 0, 0, 30)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "ПРЫЖОК: 1.0x"
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.Font = Enum.Font.GothamBold
jumpLabel.TextSize = 22
jumpLabel.Parent = jumpFrame

local jumpSlider = Instance.new("TextButton")
jumpSlider.Size = UDim2.new(0.4, 0, 0, 35)
jumpSlider.Position = UDim2.new(0.3, 0, 0.5, 0)
jumpSlider.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
jumpSlider.Text = "▶ 1x"
jumpSlider.TextColor3 = Color3.fromRGB(0, 0, 0)
jumpSlider.Font = Enum.Font.GothamBold
jumpSlider.TextSize = 18
jumpSlider.Parent = jumpFrame

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(0, 10)
jumpSliderCorner.Parent = jumpSlider

jumpSlider.MouseButton1Click:Connect(function()
    jumpMult = jumpMult + 1
    if jumpMult > 75 then jumpMult = 1 end
    jumpPower = 50 * jumpMult
    jumpLabel.Text = "ПРЫЖОК: " .. jumpMult .. ".0x"
    jumpSlider.Text = "▶ " .. jumpMult .. "x"
end)

local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0.8, 0, 0, 40)
jumpToggle.Position = UDim2.new(0.1, 0, 0, 0)
jumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
jumpToggle.Text = "ВКЛ/ВЫКЛ ПРЫЖКИ"
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.TextSize = 18
jumpToggle.Parent = container

local jumpToggleCorner = Instance.new("UICorner")
jumpToggleCorner.CornerRadius = UDim.new(0, 12)
jumpToggleCorner.Parent = jumpToggle

jumpToggle.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = jumpActive and jumpPower or 50
    end
    jumpToggle.BackgroundColor3 = jumpActive and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 200)
end)

-- ========== CHAMS 1 (ИДЕАЛЬНОЕ НЕБО) ==========
local chamsBtn = Instance.new("TextButton")
chamsBtn.Size = UDim2.new(1, 0, 0, 50)
chamsBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 150)
chamsBtn.Text = "CHAMS 1 (НЕБО)"
chamsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chamsBtn.Font = Enum.Font.GothamBold
chamsBtn.TextSize = 20
chamsBtn.Parent = container

local chamsCorner = Instance.new("UICorner")
chamsCorner.CornerRadius = UDim.new(0, 12)
chamsCorner.Parent = chamsBtn

chamsBtn.MouseButton1Click:Connect(function()
    lighting.Ambient = Color3.fromRGB(80, 120, 255)
    lighting.Brightness = 0.6
    lighting.OutdoorAmbient = Color3.fromRGB(60, 100, 255)

    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://12371622424"
    sky.SkyboxDn = "rbxassetid://12371622424"
    sky.SkyboxFt = "rbxassetid://12371622424"
    sky.SkyboxLf = "rbxassetid://12371622424"
    sky.SkyboxRt = "rbxassetid://12371622424"
    sky.SkyboxUp = "rbxassetid://12371622424"
    sky.Parent = lighting
end)

-- ========== АНИМЕ-НЕБО (126949309) ==========
local animeBtn = Instance.new("TextButton")
animeBtn.Size = UDim2.new(1, 0, 0, 50)
animeBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 200)
animeBtn.Text = "АНИМЕ-НЕБО"
animeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
animeBtn.Font = Enum.Font.GothamBold
animeBtn.TextSize = 20
animeBtn.Parent = container

local animeCorner = Instance.new("UICorner")
animeCorner.CornerRadius = UDim.new(0, 12)
animeCorner.Parent = animeBtn

animeBtn.MouseButton1Click:Connect(function()
    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://126949309"
    sky.SkyboxDn = "rbxassetid://126949309"
    sky.SkyboxFt = "rbxassetid://126949309"
    sky.SkyboxLf = "rbxassetid://126949309"
    sky.SkyboxRt = "rbxassetid://126949309"
    sky.SkyboxUp = "rbxassetid://126949309"
    sky.Parent = lighting
end)

icon.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

starterGui:SetCore("SendNotification", {
    Title = "ZACK V8",
    Text = "Финальная сборка",
    Duration = 3
})
