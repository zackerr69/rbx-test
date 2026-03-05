-- ZACK HUB FINAL
-- Полет: Fly GUI V3 (твой скрипт)
-- Дрочка: с GitHub
-- Иконка: ZCKRR на черном

if _G.ZACK_FINAL then return end
_G.ZACK_FINAL = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")

-- ========== ИКОНКА ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHub"
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

-- ========== ТВОЙ ПОЛЕТ (ПОЛНОСТЬЮ) ==========
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

-- ========== ДРОЧКА С GITHUB ==========
loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/roblox-scripts/main/jackoff.lua"))()

-- ========== МЕНЮ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 200, 0, 100)
menu.Position = UDim2.new(0.8, -200, 0.5, -50)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menu.BackgroundTransparency = 0.2
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "ZACK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = menu

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = menu

closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

starterGui:SetCore("SendNotification", {
    Title = "ZACK HUB",
    Text = "ZCKRR на черном фоне",
    Duration = 3
})
