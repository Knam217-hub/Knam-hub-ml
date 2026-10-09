-- KN HUB - Universal Roblox Script
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "KN HUB | Universal Game Script",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "KN HUB Loading..."
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Biến lưu trạng thái
local speedVal = 16
local jumpVal = 50
local flyVal = 50
local bypassEnabled = false
local noclipEnabled = false
local flyEnabled = false
local fixLagEnabled = false

-- 1. FIX LAG (Occlusion Culling & Low Render)
local hiddenParts = {}
local function startFixLag()
    task.spawn(function()
        while fixLagEnabled do
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) and part.Transparency < 1 then
                    local _, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if not onScreen then
                        if hiddenParts[part] == nil then
                            hiddenParts[part] = part.LocalTransparencyModifier
                        end
                        part.LocalTransparencyModifier = 1
                    else
                        if hiddenParts[part] ~= nil then
                            part.LocalTransparencyModifier = hiddenParts[part]
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

local function stopFixLag()
    for part, origTrans in pairs(hiddenParts) do
        if part and part.Parent then
            part.LocalTransparencyModifier = origTrans
        end
    end
    table.clear(hiddenParts)
end

-- 2. NOCLIP (Đã chỉnh sửa: Không xuyên qua mặt đất dưới chân)
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = true
                else
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 3, 4, 5. SPEED, JUMP & BYPASS ANTI-CHEAT
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if bypassEnabled then
            hum.WalkSpeed = speedVal
            hum.UseJumpPower = true
            hum.JumpPower = jumpVal
            
            if hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * (speedVal / 50) * 0.1)
            end
        else
            hum.WalkSpeed = speedVal
            hum.UseJumpPower = true
            hum.JumpPower = jumpVal
        end
    end
end)

-- 6. TELEPORT TOOL
local function giveTPTool()
    local tool = Instance.new("Tool")
    tool.Name = "Teleport Tool (KN HUB)"
    tool.RequiresHandle = false
    
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    
    tool.Parent = LocalPlayer.Backpack
end

-- 7. FLY (BAY)
local bv, bg
local function toggleFly(state)
    flyEnabled = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flyEnabled then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 9e4
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        task.spawn(function()
            while flyEnabled and char and hrp do
                local hum = char:FindFirstChildOfClass("Humanoid")
                local moveDir = hum and hum.MoveDirection or Vector3.zero
                
                bg.CFrame = Camera.CFrame
                if moveDir.Magnitude > 0 then
                    bv.Velocity = (Camera.CFrame.LookVector * -moveDir.Z + Camera.CFrame.RightVector * moveDir.X).Unit * flyVal
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

---------------------------------------------------------
-- GIAO DIỆN MENUS (TABS)
---------------------------------------------------------

-- TAB 1: PLAYER & MOVEMENT
local MainTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddSlider({
    Name = "Speed Boost",
    Min = 1, Max = 1000, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed",
    Callback = function(Value) speedVal = Value end
})

MainTab:AddSlider({
    Name = "Jump Boost",
    Min = 1, Max = 1000, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Power",
    Callback = function(Value) jumpVal = Value end
})

MainTab:AddToggle({
    Name = "Bypass Anti Speed/Jump",
    Default = false,
    Callback = function(Value) bypassEnabled = Value end
})

MainTab:AddToggle({
    Name = "Noclip (Đi xuyên tường)",
    Default = false,
    Callback = function(Value) noclipEnabled = Value end
})

-- TAB 2: FLY & TELEPORT
local FlyTab = Window:MakeTab({Name = "Fly & TP", Icon = "rbxassetid://4483345998", PremiumOnly = false})

FlyTab:AddToggle({
    Name = "Bật/Tắt Bay (Fly)",
    Default = false,
    Callback = function(Value) toggleFly(Value) end
})

FlyTab:AddSlider({
    Name = "Tốc độ Bay",
    Min = 1, Max = 1000, Default = 50, Color = Color3.fromRGB(0,255,255), Increment = 1, ValueName = "Fly Speed",
    Callback = function(Value) flyVal = Value end
})

FlyTab:AddButton({
    Name = "Lấy Tool Teleport vào Balo",
    Callback = function()
        giveTPTool()
        OrionLib:MakeNotification({Name = "KN HUB", Content = "Đã thêm Teleport Tool vào kho đồ!", Image = "rbxassetid://4483345998", Time = 3})
    end
})

-- TAB 3: OPTIMIZATION
local OptTab = Window:MakeTab({Name = "Fix Lag", Icon = "rbxassetid://4483345998", PremiumOnly = false})

OptTab:AddToggle({
    Name = "Fix Lag (Ẩn công trình ngoài màn hình)",
    Default = false,
    Callback = function(Value)
        fixLagEnabled = Value
        if fixLagEnabled then startFixLag() else stopFixLag() end
    end
})

OrionLib:Init()
