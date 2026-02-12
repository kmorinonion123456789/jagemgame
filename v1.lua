local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local RS = game:GetService("ReplicatedStorage")
local indexRemote = RS:FindFirstChild("IndexRemote")

local toggles = {
    ["GOD"] = true,
    ["SECRET"] = true,
    ["MYTHICAL"] = true
}


local rarityGroups = {
    ["GOD"] = {priority = 100, keys = {"GOD", "ゴッド"}},
    ["SECRET"] = {priority = 90, keys = {"SECRET", "シークレット"}},
    ["MYTHICAL"] = {priority = 80, keys = {"MYTHICAL", "ミシカル", "みしかる", "MYTHIC", "MITHIC"}}
}


local function getPriority(model)
    local highest = 0
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("TextLabel") then
            local txt = string.gsub(string.upper(v.Text), "%s+", "")
            for group, data in pairs(rarityGroups) do
                -- スイッチがONのグループだけ判定する
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

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
ScreenGui.Parent = success and coreGui or player:WaitForChild("PlayerGui")
ScreenGui.Name = "MishikaruHunter_V3"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 300) 
Frame.Position = UDim2.new(0.5, -110, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Active = true
Frame.Draggable = true

UIListLayout.Parent = Frame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "kmorinとまうそ様が付き合いましたはーと"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
Title.Font = Enum.Font.GothamBold

-- ON/OFFスイッチボタン
local function createToggleBtn(label, groupName)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    
    local function refresh()
        if toggles[groupName] then
            btn.Text = label .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
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

createToggleBtn("ゴッド級", "GOD")
createToggleBtn("シークレット級", "SECRET")
createToggleBtn("ミシカル/みしかる級", "MYTHICAL")

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

print("✅ UI-Switch Farmer Loaded!")

