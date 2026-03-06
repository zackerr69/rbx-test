-- ЧАСТЬ 1: ИКОНКА ZACK_HUB (серебро)
if _G.ZACK_PART1 then return end
_G.ZACK_PART1 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ZackPart1"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 140, 0, 50)  -- широкий, под текст
icon.Position = UDim2.new(0, 15, 0.5, -25)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
icon.BackgroundTransparency = 0.2
icon.Text = "ZACK_HUB"
icon.TextColor3 = Color3.fromRGB(230, 230, 250) -- серебро
icon.TextSize = 24
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 25)
iconCorner.Parent = icon

print("Часть 1: иконка готова")
