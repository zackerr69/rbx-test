-- Zack Hub - Jerk Off (управление через функцию)
-- Предмет появляется только когда функция включена

local speaker = game.Players.LocalPlayer
repeat task.wait() until speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
local backpack = speaker:FindFirstChildWhichIsA("Backpack")

local tool = nil
local jorkin = false
local track = nil
local function r15()
    return speaker.Character.Humanoid.RigType == Enum.HumanoidRigType.R15
end

local function stopJorkin()
    jorkin = false
    if track then
        track:Stop()
        track = nil
    end
    if tool and tool.Parent then
        tool:Destroy()
        tool = nil
    end
end

-- Эту функцию будешь вызывать из меню (вкл/выкл)
function toggleJerkOff(state)
    if state then
        if tool then return end
        tool = Instance.new("Tool")
        tool.Name = "Zack Hub"
        tool.ToolTip = "💦"
        tool.RequiresHandle = false
        tool.Parent = backpack

        tool.Equipped:Connect(function() jorkin = true end)
        tool.Unequipped:Connect(function() jorkin = false end)
        humanoid.Died:Connect(stopJorkin)
    else
        stopJorkin()
    end
end

-- Основной цикл анимации (работает только когда jorkin true)
while task.wait() do
    if not jorkin then continue end

    local isR15 = r15()
    if not track then
        local anim = Instance.new("Animation")
        anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
        track = humanoid:LoadAnimation(anim)
    end

    track:Play()
    track:AdjustSpeed(isR15 and 0.7 or 0.65)
    track.TimePosition = 0.6
    task.wait(0.1)
    while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do task.wait(0.1) end
    if track then
        track:Stop()
        track = nil
    end
end
