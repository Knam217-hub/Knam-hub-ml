-- ==========================================
-- KNAM HUB V3 - MUSCLE LEGENDS (CORE CODE)
-- ==========================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo các trạng thái
_G.AutoWeight = false
_G.AutoRebirth = false
_G.AutoKill = false
_G.AutoKillKing = false

-- Vị trí & Bán kính Đảo King Muscle
local KING_POS = Vector3.new(-8626, 14, -5730)
local KING_RADIUS = 700

-- Thư viện UI Core
local ParentUI = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

if ParentUI:FindFirstChild("KNAMHubGui") then
    ParentUI.KNAMHubGui:Destroy()
end

-- 1. Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KNAMHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentUI

-- 2. Hàm kéo thả UI (Draggable)
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 3. ICON HUB THU NHỎ (KNAM 2 màu Đỏ/Xanh)
local IconBtn = Instance.new("ImageButton")
IconBtn.Name = "KNAMIcon"
IconBtn.Size = UDim2.new(0, 50, 0, 50)
IconBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IconBtn.BorderSizePixel = 0
IconBtn.Parent = ScreenGui

local IconCorner = Instance.new("UICorner", IconBtn)
IconCorner.CornerRadius = UDim2.new(0, 12)

local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(0, 170, 255)
IconStroke.Thickness = 2

local IconText = Instance.new("TextLabel")
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.BackgroundTransparency = 1
IconText.RichText = true
IconText.Text = '<font color="#FF3333">KN</font><font color="#00AAFF">AM</font>'
IconText.Font = Enum.Font.FredokaOne
IconText.TextSize = 15
IconText.Parent = IconBtn

makeDraggable(IconBtn)

-- 4. MENU CỬA SỔ HÌNH VUÔNG
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 390)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim2.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 50, 50)
MainStroke.Thickness = 2.5

makeDraggable(MainFrame)

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = '<font color="#FF3333">KN</font><font color="#00AAFF">AM</font> HUB - MUSCLE'
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Nút thu nhỏ (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 8)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 22
MinimizeBtn.Parent = MainFrame

local MiniCorner = Instance.new("UICorner", MinimizeBtn)
MiniCorner.CornerRadius = UDim2.new(0, 6)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Khung chứa danh sách nút
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0.9, 0, 0.83, 0)
Container.Position = UDim2.new(0.05, 0, 0.13, 0)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Hàm tạo Toggle Button
local function createToggleButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Container

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim2.new(0, 8)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. ": ON"
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
            btn.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
        else
            btn.Text = text .. ": OFF"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        callback(state)
    end)
    return btn
end

-- Hàm tạo Click Button
local function createClickButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Container

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim2.new(0, 8)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 5. DANH SÁCH TÍNH NĂNG
createToggleButton("Auto Weight (Tập tạ)", function(state) _G.AutoWeight = state end)
createToggleButton("Auto Rebirth Nhanh", function(state) _G.AutoRebirth = state end)
createToggleButton("Auto Kill (Đấm gần)", function(state) _G.AutoKill = state end)
createToggleButton("Auto Kill đảo King Muscle", function(state) _G.AutoKillKing = state end)

createClickButton("Teleport tới King Muscle", Color3.fromRGB(0, 135, 220), function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8626, 14, -5730)
        end
    end)
end)

-- 6. LOGIC TỰ ĐỘNG CHẠY NGẦM

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

-- Auto Weight
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoWeight then
            pcall(function()
                local weight = LocalPlayer.Backpack:FindFirstChild("Weight") or LocalPlayer.Character:FindFirstChild("Weight")
                if weight then
                    LocalPlayer.Character.Humanoid:EquipTool(weight)
                    weight:Activate()
                end
                local weightEvent = ReplicatedStorage:FindFirstChild("rEvents") and ReplicatedStorage.rEvents:FindFirstChild("weightEvent")
                if weightEvent then weightEvent:FireServer() end
            end)
        end
    end
end)

-- Auto Rebirth
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoRebirth then
            pcall(function()
                local rebirthEvent = ReplicatedStorage:FindFirstChild("rEvents") and ReplicatedStorage.rEvents:FindFirstChild("rebirthRemote")
                if rebirthEvent then rebirthEvent:InvokeServer("rebirthRequest") end
            end)
        end
    end
end)

-- Auto Kill thường
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoKill then
            pcall(function()
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
                if punch then
                    LocalPlayer.Character.Humanoid:EquipTool(punch)
                    punch:Activate()
                end
                local punchEvent = ReplicatedStorage:FindFirstChild("rEvents") and ReplicatedStorage.rEvents:FindFirstChild("punchEvent")
                if punchEvent then punchEvent:FireServer("punchClick") end
            end)
        end
    end
end)

-- Auto Kill đảo King Muscle (Tự dò và kết liễu người ở đảo King)
task.spawn(function()
    while task.wait(0.05) do
        if _G.AutoKillKing then
            pcall(function()
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                        local targetPos = target.Character.HumanoidRootPart.Position
                        local distanceToKing = (targetPos - KING_POS).Magnitude
                        
                        if distanceToKing <= KING_RADIUS then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
                            if punch then
                                LocalPlayer.Character.Humanoid:EquipTool(punch)
                                punch:Activate()
                            end
                            local punchEvent = ReplicatedStorage:FindFirstChild("rEvents") and ReplicatedStorage.rEvents:FindFirstChild("punchEvent")
                            if punchEvent then punchEvent:FireServer("punchClick") end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

print("KNAM Hub V3 Loaded Successfully!")
