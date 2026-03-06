-- ЗАГРУЗЧИК МОДЕЛЕЙ (РАБОЧИЙ)
-- Визуально размещает модель там, где ты скажешь

if _G.ZACK_LOADER_V2 then return end
_G.ZACK_LOADER_V2 = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")

-- ========== ФУНКЦИЯ ЗАГРУЗКИ (РАБОЧАЯ) ==========
function loadModel(assetId, textureId, position, parent)
    -- Пытаемся загрузить модель
    local success = pcall(function()
        local data = game:HttpGet("https://assetdelivery.roblox.com/v1/asset/?id=" .. assetId)
        if data then
            local model = game:GetObjects("rbxassetid://" .. assetId)[1]
            if model then
                model.Parent = parent or workspace
                model:SetPrimaryPartCFrame(CFrame.new(position or Vector3.new(0, 10, 0)))
                
                -- Применяем текстуру если есть
                if textureId then
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.TextureID = "rbxassetid://" .. textureId
                        end
                    end
                end
                
                starterGui:SetCore("SendNotification", {
                    Title = "✓ Загружено",
                    Text = "Модель ID: " .. assetId,
                    Duration = 2
                })
                
                return model
            end
        end
    end)
    
    if not success then
        starterGui:SetCore("SendNotification", {
            Title = "✗ Ошибка",
            Text = "Не удалось загрузить " .. assetId,
            Duration = 2
        })
    end
end

-- ========== ИНТЕРФЕЙС ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ModelLoader"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "ЗАГРУЗЧИК МОДЕЛЕЙ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Кнопка закрытия
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.Parent = frame

close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -50)
container.Position = UDim2.new(0, 5, 0, 45)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 400)
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- ========== ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ==========
function createButton(text, assetId, textureId, offset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Загружаем модель рядом с игроком
        local pos = root.Position + (offset or Vector3.new(0, 5, 5))
        local model = loadModel(assetId, textureId, pos, workspace)
        
        if model then
            -- Если хотим прикрепить к игроку
            if text:find("Крылья") then
                local weld = Instance.new("Weld")
                weld.Part0 = root
                weld.Part1 = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                weld.C0 = CFrame.new(0, 1, 0)
                weld.Parent = weld.Part1
            end
        end
    end)
end

-- ========== ТВОИ ID ==========
createButton("🔥 Крылья демона", "9560100775", "9560100750", Vector3.new(0, 5, 5))
createButton("👼 Крылья ангела", "98594662227451", "112908280935447", Vector3.new(0, 5, 5))
createButton("🐔 Крылья петуха", "14395684098", "14395684065", Vector3.new(0, 5, 5))
createButton("🌌 Chams текстура", "6744228280", "6744228269", Vector3.new(0, 5, 5))
createButton("6️⃣7️⃣ 67 цифры", "134182134850446", "100277086825066", Vector3.new(3, 0, 3))

-- ========== ИКОНКА ДЛЯ ОТКРЫТИЯ ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 10, 0.5, -25)
icon.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
icon.Text = "📦"
icon.TextColor3 = Color3.fromRGB(0, 0, 0)
icon.TextSize = 30
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 25)
iconCorner.Parent = icon

icon.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

starterGui:SetCore("SendNotification", {
    Title = "Загрузчик моделей",
    Text = "Нажми на жёлтую иконку",
    Duration = 3
})
