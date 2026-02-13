local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpdateNoticeGui"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75) -- 画面中央
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.6, 0)
label.Text = "アップデートが入りました！\n最新バージョンをお楽しみください。"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.TextSize = 20
label.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.8, 0, 0.25, 0)
closeButton.Position = UDim2.new(0.1, 0, 0.65, 0)
closeButton.Text = "了解！"
closeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
