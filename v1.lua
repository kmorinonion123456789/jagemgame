local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local RS = game:GetService("ReplicatedStorage")
local indexRemote = RS:FindFirstChild("IndexRemote")
local RunService = game:GetService("RunService")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

local toggles = {
    ["GOD"] = true,
    ["SECRET"] = true,
    ["MYTHICAL"] = true,
    ["NOCLIP"] = false
}

local rarityGroups = {
    ["GOD"] = {priority = 100, keys = {"GOD", "ゴッド"}},
    ["SECRET"] = {priority = 90, keys = {"SECRET", "シークレット"}},
    ["MYTHICAL"] = {priority = 80, keys = {"MYTHICAL", "ミシカル", "みしかる", "MYTHIC", "MITHIC"}}
}

-- NOCLIP処理
RunService.Stepped:Connect(function()
    if toggles["NOCLIP"] then
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- UI構築
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
ScreenGui.Parent = success and coreGui or player:WaitForChild("PlayerGui")
ScreenGui.Name = "JagemuGomi_KumorinKami_Mod"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 480)
Frame.Position = UDim2.new(0.5, -110, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true -- 最小化時に中身をはみ出させない

UIListLayout.Parent = Frame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ジァゲムはごみ！くもりんは神！"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- 最小化ボタンの作成
local isMinimized = false
local originalHeight = Frame.Size.Y.Offset
local minimizeBtn = Instance.new("TextButton", Frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -32, 0, 2)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.ZIndex = 10 -- 常に最前面

-- 最小化ロジック
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeBtn.Text = "+"
        Frame:TweenSize(UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.2, true)
        for _, child in pairs(Frame:GetChildren()) do
            if child ~= Title and child ~= minimizeBtn and not child:IsA("UIListLayout") then
                if child:IsA("GuiObject") then child.Visible = false end
            end
        end
    else
        minimizeBtn.Text = "-"
        Frame:TweenSize(UDim2.new(0, 220, 0, originalHeight), "Out", "Quad", 0.2, true)
        task.wait(0.1) -- アニメーションに合わせて表示
        for _, child in pairs(Frame:GetChildren()) do
            if child ~= Title and child ~= minimizeBtn and not child:IsA("UIListLayout") then
                if child:IsA("GuiObject") then child.Visible = true end
            end
        end
    end
end)

local function createToggleBtn(label, groupName, color)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    
    local function refresh()
        if toggles[groupName] then
            btn.Text = label .. " : ON"
            btn.BackgroundColor3 = color or Color3.fromRGB(0, 150, 0)
        else
            btn.Text = label .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        toggles[groupName] = not toggles[groupName]
        refresh()
    end)
    refresh()
end

createToggleBtn("ゴッド", "GOD")
createToggleBtn("シークレット", "SECRET")
createToggleBtn("ミシカル", "MYTHICAL")
createToggleBtn("ノーリップ", "NOCLIP", Color3.fromRGB(0, 120, 255))

-- スピード調整
local SpeedFrame = Instance.new("Frame", Frame)
SpeedFrame.Size = UDim2.new(0, 200, 0, 60)
SpeedFrame.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Text = "Speed: " .. humanoid.WalkSpeed
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.Gotham

local MinusBtn = Instance.new("TextButton", SpeedFrame)
MinusBtn.Size = UDim2.new(0, 95, 0, 30)
MinusBtn.Position = UDim2.new(0, 0, 0, 25)
MinusBtn.Text = "-10"
MinusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinusBtn.TextColor3 = Color3.new(1, 1, 1)

local PlusBtn = Instance.new("TextButton", SpeedFrame)
PlusBtn.Size = UDim2.new(0, 95, 0, 30)
PlusBtn.Position = UDim2.new(0, 105, 0, 25)
PlusBtn.Text = "+10"
PlusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PlusBtn.TextColor3 = Color3.new(1, 1, 1)

local function updateSpeed(amt)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local h = player.Character.Humanoid
        h.WalkSpeed = math.clamp(h.WalkSpeed + amt, 0, 500)
        SpeedLabel.Text = "Speed: " .. h.WalkSpeed
    end
end

MinusBtn.MouseButton1Click:Connect(function() updateSpeed(-10) end)
PlusBtn.MouseButton1Click:Connect(function() updateSpeed(10) end)

-- ファームロジック
local function getPriority(model)
    local highest = 0
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("TextLabel") then
            local txt = string.gsub(string.upper(v.Text), "%s+", "")
            for group, data in pairs(rarityGroups) do
                if toggles[group] then
                    for _, key in ipairs(data.keys) do
                        if string.find(txt, string.upper(key)) then
                            if data.priority > highest then highest = data.priority end
                        end
                    end
                end
            end
        end
    end
    return highest
end

local isFarming = false
local function findBestTarget()
    local bestTarget = nil
    local minDistance = math.huge
    local maxPriority = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            local model = obj:FindFirstAncestorOfClass("Model")
            if model and model ~= player.Character then
                local priority = getPriority(model)
                if priority >= 80 then
                    local part = model:FindFirstChildWhichIsA("MeshPart") or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local dist = (rootPart.Position - part.Position).Magnitude
                        if priority > maxPriority or (priority == maxPriority and dist < minDistance) then
                            maxPriority = priority
                            minDistance = dist
                            bestTarget = {m = model, p = part, r = priority}
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

local function startFarming()
    if isFarming then return end
    isFarming = true
    while isFarming do
        local target = findBestTarget()
        if target then
            rootPart.CFrame = target.p.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.3)
            pcall(function()
                firetouchinterest(rootPart, target.p, 0)
                local prompt = target.m:FindFirstChildOfClass("ProximityPrompt") or target.p:FindFirstChildOfClass("ProximityPrompt")
                if not prompt then
                    for _, d in pairs(target.m:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then prompt = d break end
                    end
                end
                if prompt then
                    if fireproximityprompt then fireproximityprompt(prompt)
                    else
                        prompt:InputHoldBegin()
                        task.wait(0.1)
                        prompt:InputHoldEnd()
                    end
                end
                if indexRemote then indexRemote:FireServer(target.m.Name) end
                task.wait(0.1)
                firetouchinterest(rootPart, target.p, 1)
            end)
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end

local startBtn = Instance.new("TextButton", Frame)
startBtn.Size = UDim2.new(0, 200, 0, 45)
startBtn.Text = "開始"
startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold

startBtn.MouseButton1Click:Connect(function()
    if not isFarming then
        startBtn.Text = "停止"
        startBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        task.spawn(startFarming)
    else
        isFarming = false
        startBtn.Text = "開始"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)
