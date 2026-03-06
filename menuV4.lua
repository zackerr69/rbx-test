-- МЕНЮ С ТВОИМИ МОДЕЛЯМИ
-- Просто загружает то, что ты дал

if _G.ZACK_LOADER then return end
_G.ZACK_LOADER = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")

-- ========== ИКОНКА ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ZackLoader"
gui.Parent = player:WaitForChild("PlayerGui")

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 70, 0, 70)
icon.Position = UDim2.new(0, 15, 0.5, -35)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = "ЗАГР"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 16
icon.Font = Enum.Font.GothamBold
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 35)
iconCorner.Parent = icon

-- ========== МЕНЮ ==========
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0.5, -125, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ЗАГРУЗЧИК МОДЕЛЕЙ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = menu

local function createLoaderButton(text, assetId, textureId)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 50 + (#menu:GetChildren() * 45))
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = menu
    
    btn.MouseButton1Click:Connect(function()
        local success, model = pcall(function()
            return game:GetObjects("rbxassetid://" .. assetId)[1]
        end)
        
        if success and model then
            model.Parent = player.Character or workspace
            
            if textureId then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.TextureID = "rbxassetid://" .. textureId
                    end
                end
            end
            
            -- Прикрепить к игроку если нужно
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and model.PrimaryPart then
                local weld = Instance.new("Weld")
                weld.Part0 = root
                weld.Part1 = model.PrimaryPart
                weld.C0 = CFrame.new(0, 2, 0)
                weld.Parent = model.PrimaryPart
            end
            
            starterGui:SetCore("SendNotification", {
                Title = "Загружено",
                Text = text,
                Duration = 2
            })
        else
            starterGui:SetCore("SendNotification", {
                Title = "Ошибка",
                Text = "Не удалось загрузить " .. text,
                Duration = 2
            })
        end
    end)
end

-- ТВОИ ID
createLoaderButton("Крылья демона", "9560100775", "9560100750")
createLoaderButton("Крылья ангела", "98594662227451", "112908280935447")
createLoaderButton("Крылья петуха", "14395684098", "14395684065")
createLoaderButton("Chams текстура", "6744228280", "6744228269")
createLoaderButton("67 цифры", "134182134850446", "100277086825066")

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)
