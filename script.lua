-- ==========================================
-- KNAM HUB V1 - IMAGE ICON (FIX MOBIL/IPAD)
-- ==========================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- THAY ID ẢNH ROBLEX CỦA BẠN VÀO GIỮA 2 DẤU NGOẶC KÉP DƯỚI ĐÂY:
local ICON_IMAGE_ID = "rbxassetid://14421919280" 

_G.AutoWeight = false
_G.AutoRebirth = false
_G.AutoKill = false
_G.AutoKillKing = false

local KING_POS = Vector3.new(-8626, 14, -5730)
local KING_RADIUS = 700

local ParentUI = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

if ParentUI:FindFirstChild("KNAMHubV8") then
    ParentUI.KNAMHubV8:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KNAMHubV8"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = ParentUI

-- NÚT CHỨA HÌNH LOGO KNAM (BẤM NHẠY TRÊN IPAD)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleKNAM"
ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
ToggleBtn.Position = UDim2.new(0, 15, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = ICON_IMAGE_ID
ToggleBtn.Active = true
ToggleBtn.Selectable = true
ToggleBtn.ZIndex = 999999
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim2.new(0, 16)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(0, 170, 255)
ToggleStroke.Thickness = 2.5

-- FRAME MENU CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 360)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.ZIndex = 100000
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim2.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 2.5

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)
ToggleBtn.Activated:Connect(toggleMenu)

-- TIÊU ĐỀ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "KNAM HUB V8"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 100001
Title.Parent = MainFrame

-- NÚT ĐÓNG (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.ZIndex = 100001
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim2.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
CloseBtn.Activated:Connect(function() MainFrame.Visible = false end)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0.9, 0, 0.83, 0)
Container.Position = UDim2.new(0.05, 0, 0.14, 0)
Container.BackgroundTransparency = 1
Container.ZIndex = 100001
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 90, 90)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.ZIndex = 100002
    btn.Active = true
    btn.Parent = Container

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim2.new(0, 8)

    local state = false
    local function onClick()
        state = not state
        if state then
            btn.Text = text .. ": ON"
            btn.TextColor3 = Color3.fromRGB(80, 255, 120)
            btn.BackgroundColor3 = Color3.fromRGB(25, 60, 35)
        else
            btn.Text = text .. ": OFF"
            btn.TextColor3 = Color3.fromRGB(255, 90, 90)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        end
        callback(state)
    end

    btn.MouseButton1Click:Connect(onClick)
    btn.Activated:Connect(onClick)
    return btn
end

local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.ZIndex = 100002
    btn.Active = true
    btn.Parent = Container

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim2.new(0, 8)

    btn.MouseButton1Click:Connect(callback)
    btn.Activated:Connect(callback)
    return btn
end

createToggle("Auto Weight (Tập tạ)", function(s) _G.AutoWeight = s end)
createToggle("Auto Rebirth Nhanh", function(s) _G.AutoRebirth = s end)
createToggle("Auto Kill (Đấm gần)", function(s) _G.AutoKill = s end)
createToggle("Auto Kill đảo King Muscle", function(s) _G.AutoKillKing = s end)

createButton("Teleport tới King Muscle", Color3.fromRGB(0, 140, 230), function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8626, 14, -5730)
        end
    end)
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

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

print("KNAM HUB V8 LOADED!")
