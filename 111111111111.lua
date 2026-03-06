-- ЧАСТЬ 1: ТОЛЬКО МЕНЮ (проверяем фон)
if _G.ZACK_TEST_1 then return end
_G.ZACK_TEST_1 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "Test1"
gui.Parent = player:WaitForChild("PlayerGui")

-- Иконка (временная, для открытия)
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 20, 0.5, -30)
icon.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
icon.Text = "M"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 30
icon.Parent = gui

-- Меню с твоей тянкой
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 400)
menu.Position = UDim2.new(0.5, -150, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menu.Visible = false
menu.Parent = gui

-- Картинка тянки
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = "rbxassetid://6744228280"
bg.Parent = menu

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)
