-- ЗАГРУЗЧИК V2 (ПРОВЕРЕННЫЙ) + ИСПРАВЛЕННАЯ ДРОЧКА
-- ID: 9560100775, 98594662227451, 14395684098, 6744228280, 134182134850446

if _G.LOADER_V2_RUN then return end
_G.LOADER_V2_RUN = true

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

-- ========== ЗАГРУЗЧИК (РАБОЧИЙ, ИЗВЕСТНЫЙ) ==========
local function loadAsset(id, textureId, position, parent, weldToChar)
    local model = nil
    local success = pcall(function()
        local data = game:HttpGet("https://assetdelivery.roblox.com/v1/asset/?id=" .. id)
        if data then
            model = game:GetObjects("rbxassetid://" .. id)[1]
        end
    end)

    if not success or not model then
        success, model = pcall(function()
            return game:GetObjects("rbxassetid://" .. id)[1]
        end)
    end

    if not success or not model then
        warn("Не удалось загрузить ID:", id)
        return nil
    end

    model.Parent = parent or workspace

    if textureId then
        for _, v in ipairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                v.TextureID = "rbxassetid://" .. textureId
            end
        end
    end

    if position then
        model:SetPrimaryPartCFrame(CFrame.new(position))
    end

    if weldToChar and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if primary then
                local weld = Instance.new("Weld")
                weld.Part0 = root
                weld.Part1 = primary
                weld.C0 = weldToChar
                weld.Parent = primary
            end
        end
    end

    return model
end

-- ========== ИНТЕРФЕЙС ==========
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderV2"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 400)
frame.Position = UDim2.new(0.5, -140, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "ЗАГРУЗЧИК V2"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

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
container.CanvasSize = UDim2.new(0, 0, 0, 500)
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- ========== КНОПКИ ==========
function createButton(text, id, texId, weldCF)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local pos = root.Position + Vector3.new(0, 5, 5)
        local model = loadAsset(id, texId, pos, workspace, weldCF)

        if model then
            starterGui:SetCore("SendNotification", {
                Title = "✓ Загружено",
                Text = text,
                Duration = 2
            })
        else
            starterGui:SetCore("SendNotification", {
                Title = "✗ Ошибка",
                Text = text .. " не загрузился",
                Duration = 2
            })
        end
    end)
end

-- ТВОИ ID
createButton("Крылья демона", "9560100775", "9560100750", CFrame.new(-1.5, 1, 0))
createButton("Крылья ангела", "98594662227451", "112908280935447", CFrame.new(-1.5, 1, 0))
createButton("Крылья петуха", "14395684098", "14395684065", CFrame.new(-1.5, 1, 0))
createButton("Chams текстура", "6744228280", "6744228269", nil)
createButton("67 цифры", "134182134850446", "100277086825066", CFrame.new(3, 1, 0))

-- ========== ДРОЧКА (ИСПРАВЛЕННАЯ) ==========
local jackActive = false
local jackBtn = Instance.new("TextButton")
jackBtn.Size = UDim2.new(1, -10, 0, 45)
jackBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 80)
jackBtn.Text = "ДРОЧКА: ВЫКЛ"
jackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jackBtn.Font = Enum.Font.GothamBold
jackBtn.TextSize = 16
jackBtn.Parent = container

local jackCorner = Instance.new("UICorner")
jackCorner.CornerRadius = UDim.new(0, 8)
jackCorner.Parent = jackBtn

local jackConnection = nil

jackBtn.MouseButton1Click:Connect(function()
    jackActive = not jackActive
    jackBtn.Text = jackActive and "ДРОЧКА: ВКЛ" or "ДРОЧКА: ВЫКЛ"
    jackBtn.BackgroundColor3 = jackActive and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(80, 20, 80)

    if jackActive then
        jackConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end

            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")

            if not root or not humanoid or not rightArm then return end

            -- Фиксируем персонажа (БЕЗ ПРОВАЛА)
            humanoid.PlatformStand = true
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)

            local motor = rightArm:FindFirstChildOfClass("Motor6D")
            if motor then
                local t = tick() * 8
                motor.C0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(math.sin(t) * 1.3, 0, 0)
            end
        end)
    else
        if jackConnection then
            jackConnection:Disconnect()
            jackConnection = nil
        end
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end)

-- ========== ИКОНКА ==========
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 15, 0.5, -30)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = "📦"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 30
icon.Draggable = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30)
iconCorner.Parent = icon

icon.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

starterGui:SetCore("SendNotification", {
    Title = "ЗАГРУЗЧИК V2",
    Text = "Жми на иконку 📦",
    Duration = 3
})
