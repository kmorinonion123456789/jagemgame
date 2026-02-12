local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local indexRemote = RS:FindFirstChild("IndexRemote")

-- 変数管理
local function getCharacterData()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    return char, root, hum
end

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

-- ノークリップ
RunService.Stepped:Connect(function()
    if toggles["NOCLIP"] and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- UI作成
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
ScreenGui.Parent = success and coreGui or player:WaitForChild("PlayerGui")
ScreenGui.Name = "JagemuGomi_Mod_V2"

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 220, 0, 350) 
MainFrame.Position = UDim2.new(0.5, -110, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ジァゲムはごみ！くもりんは神！"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.BorderSizePixel = 0

UIListLayout.Parent = ScrollFrame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 最小化
local isMinimized = false
local minimizeBtn = Instance.new("TextButton", MainFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -32, 0, 2)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.ZIndex = 10

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeBtn.Text = "+"
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.2, true)
        ScrollFrame.Visible = false
    else
        minimizeBtn.Text = "-"
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 350), "Out", "Quad", 0.2, true)
        task.wait(0.1)
        ScrollFrame.Visible = true
    end
end)

local function createToggleBtn(label, groupName, color)
    local btn = Instance.new("TextButton", ScrollFrame)
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
local SpeedFrame = Instance.new("Frame", ScrollFrame)
SpeedFrame.Size = UDim2.new(0, 200, 0, 60)
SpeedFrame.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Text = "Speed: 16"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local function updateSpeed(amt)
    local _, _, hum = getCharacterData()
    if hum then
        hum.WalkSpeed = math.clamp(hum.WalkSpeed + amt, 0, 500)
        SpeedLabel.Text = "Speed: " .. hum.WalkSpeed
    end
end

local MinusBtn = Instance.new("TextButton", SpeedFrame)
MinusBtn.Size = UDim2.new(0, 95, 0, 30)
MinusBtn.Position = UDim2.new(0, 0, 0, 25)
MinusBtn.Text = "-10"
MinusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinusBtn.TextColor3 = Color3.new(1, 1, 1)
MinusBtn.MouseButton1Click:Connect(function() updateSpeed(-10) end)

local PlusBtn = Instance.new("TextButton", SpeedFrame)
PlusBtn.Size = UDim2.new(0, 95, 0, 30)
PlusBtn.Position = UDim2.new(0, 105, 0, 25)
PlusBtn.Text = "+10"
PlusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PlusBtn.TextColor3 = Color3.new(1, 1, 1)
PlusBtn.MouseButton1Click:Connect(function() updateSpeed(10) end)

local function createActionBtn(text, color, remoteName)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.MouseButton1Click:Connect(function()
        local r = RS:FindFirstChild(remoteName)
        if r then r:FireServer() end
    end)
end

createActionBtn("+5 スピード購入", Color3.fromRGB(255, 170, 0), "BuySpeed")
createActionBtn("+1 Luck 購入", Color3.fromRGB(0, 200, 255), "LuckSpeed")
createActionBtn("売る (Delete Brainrot)", Color3.fromRGB(0, 85, 255), "DeleteHeldBrainrot")

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

local function findBestTarget()
    local char, root = getCharacterData()
    if not root then return nil end
    
    local bestTarget = nil
    local minDistance = math.huge
    local maxPriority = 0
    local minZThreshold = 113.9
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            local model = obj:FindFirstAncestorOfClass("Model")
            if model and model ~= char then
                local priority = getPriority(model)
                if priority >= 80 then
                    local part = model:FindFirstChildWhichIsA("MeshPart") or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                    if part and part.Position.Z >= minZThreshold then
                        local dist = (root.Position - part.Position).Magnitude
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

local isFarming = false
local function startFarmingLoop()
    while isFarming do
        local char, root = getCharacterData()
        if not root then task.wait(1) continue end

        local target = findBestTarget()
        if target then
            root.CFrame = target.p.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.2)
            pcall(function()
                firetouchinterest(root, target.p, 0)
                local prompt = target.m:FindFirstChildOfClass("ProximityPrompt") or target.p:FindFirstChildOfClass("ProximityPrompt")
                if not prompt then
                    for _, d in pairs(target.m:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then prompt = d break end
                    end
                end
                if prompt then
                    if fireproximityprompt then fireproximityprompt(prompt)
                    else prompt:InputHoldBegin() task.wait(0.1) prompt:InputHoldEnd() end
                end
                if indexRemote then indexRemote:FireServer(target.m.Name) end
                task.wait(0.1)
                firetouchinterest(root, target.p, 1)
            end)
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end

local startBtn = Instance.new("TextButton", ScrollFrame)
startBtn.Size = UDim2.new(0, 200, 0, 45)
startBtn.Text = "開始"
startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold

startBtn.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    if isFarming then
        startBtn.Text = "停止"
        startBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        task.spawn(startFarmingLoop)
    else
        startBtn.Text = "開始"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)
