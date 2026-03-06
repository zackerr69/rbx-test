-- ZACK HUB V9 – ОСНОВА + INVISFLING ОКНО
-- Часть 1: Иконка + меню с тянкой
-- Часть 2: InvisFling + отдельное окно "ACTIVATED"

if _G.ZACK_V9_RUN then return end
_G.ZACK_V9_RUN = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local userInput = game:GetService("UserInputService")

-- ========== ИКОНКА (ФИОЛЕТ + ОБЛАКА + СЕРЕБРО) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubV9"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

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

local iconCloud = Instance.new("ImageLabel")
iconCloud.Size = UDim2.new(1, 0, 1, 0)
iconCloud.BackgroundTransparency = 1
iconCloud.Image = "rbxassetid://13882937829" -- облака
iconCloud.ImageTransparency = 0.3
iconCloud.Parent = icon

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 42)
iconCorner.Parent = icon

-- ========== МЕНЮ С ТЯНКОЙ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 350, 0, 500)
menu.Position = UDim2.new(0.5, -175, 0.5, -250)
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
title.Text = "ZACK HUB V9"
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

-- ========== INVISFLING + ОКНО ACTIVATED ==========
local flingActive = false
local flingWindow = nil
local groot = nil

function createFlingWindow()
    if flingWindow then return end
    
    flingWindow = Instance.new("Frame")
    flingWindow.Size = UDim2.new(0, 250, 0, 150)
    flingWindow.Position = UDim2.new(0.5, -125, 0.4, -75)
    flingWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    flingWindow.BackgroundTransparency = 0.1
    flingWindow.Active = true
    flingWindow.Draggable = true
    flingWindow.Parent = gui
    
    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 20)
    winCorner.Parent = flingWindow
    
    local winTitle = Instance.new("TextLabel")
    winTitle.Size = UDim2.new(1, 0, 0, 40)
    winTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    winTitle.Text = "INVISFLING"
    winTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    winTitle.Font = Enum.Font.GothamBold
    winTitle.TextSize = 24
    winTitle.Parent = flingWindow
    
    local activateBtn = Instance.new("TextButton")
    activateBtn.Size = UDim2.new(0.7, 0, 0, 60)
    activateBtn.Position = UDim2.new(0.15, 0, 0.5, -30)
    activateBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    activateBtn.Text = "ACTIVATED"
    activateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    activateBtn.Font = Enum.Font.GothamBlack
    activateBtn.TextSize = 28
    activateBtn.Parent = flingWindow
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = activateBtn
    
    activateBtn.MouseButton1Click:Connect(function()
        flingActive = false
        if flingWindow then
            flingWindow:Destroy()
            flingWindow = nil
        end
        starterGui:SetCore("SendNotification", {
            Title = "Zack Hub",
            Text = "InvisFling деактивирован",
            Duration = 2
        })
    end)
end

function toggleInvisFling(state)
    if state then
        if flingActive then return end
        flingActive = true
        createFlingWindow()
        
        -- Твой invisfling код (вставлю сюда позже, чтобы не раздувать сейчас)
        starterGui:SetCore("SendNotification", {
            Title = "Zack Hub",
            Text = "zack_fling активирован",
            Duration = 2
        })
        
    else
        flingActive = false
        if flingWindow then
            flingWindow:Destroy()
            flingWindow = nil
        end
    end
end

-- ========== КНОПКИ В МЕНЮ ==========
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1, 0, 0, 50)
flingBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
flingBtn.Text = "INVISFLING: ВЫКЛ"
flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 22
flingBtn.Parent = container

local flingCorner = Instance.new("UICorner")
flingCorner.CornerRadius = UDim.new(0, 12)
flingCorner.Parent = flingBtn

local flingState = false
flingBtn.MouseButton1Click:Connect(function()
    flingState = not flingState
    flingBtn.Text = flingState and "INVISFLING: ВКЛ" or "INVISFLING: ВЫКЛ"
    flingBtn.BackgroundColor3 = flingState and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(200, 0, 0)
    toggleInvisFling(flingState)
end)

icon.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

starterGui:SetCore("SendNotification", {
    Title = "ZACK V9",
    Text = "Основа + окно ACTIVATED",
    Duration = 3
})
