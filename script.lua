-- KNAM HUB v1.0
-- Roblox Studio - LocalScript
-- StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local purple = Color3.fromRGB(145, 65, 255)
local background = Color3.fromRGB(10, 8, 24)
local panelColor = Color3.fromRGB(24, 19, 45)
local white = Color3.fromRGB(245, 240, 255)

local old = player.PlayerGui:FindFirstChild("KNAM_HUB")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "KNAM_HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(720, 490)
main.Position = UDim2.new(0.5, -360, 0.5, -245)
main.BackgroundColor3 = background
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius =
    UDim.new(0, 16)

local stroke = Instance.new("UIStroke")
stroke.Color = purple
stroke.Thickness = 2
stroke.Parent = main

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -60, 0, 55)
header.Position = UDim2.fromOffset(16, 5)
header.BackgroundTransparency = 1
header.Text = "👑 KNAM HUB"
header.TextColor3 = white
header.TextSize = 26
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 38)
close.Position = UDim2.new(1, -48, 0, 12)
close.Text = "X"
close.TextSize = 18
close.TextColor3 = white
close.BackgroundColor3 = panelColor
close.Parent = main

Instance.new("UICorner", close).CornerRadius =
    UDim.new(0, 8)

close.Activated:Connect(function()
    gui:Destroy()
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 165, 1, -75)
sidebar.Position = UDim2.fromOffset(12, 65)
sidebar.BackgroundColor3 = panelColor
sidebar.BorderSizePixel = 0
sidebar.Parent = main

Instance.new("UICorner", sidebar).CornerRadius =
    UDim.new(0, 12)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -195, 1, -80)
content.Position = UDim2.fromOffset(185, 65)
content.BackgroundColor3 = panelColor
content.BackgroundTransparency = 0.15
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = purple
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = main

Instance.new("UICorner", content).CornerRadius =
    UDim.new(0, 12)

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 6)
navLayout.Parent = sidebar

local navPadding = Instance.new("UIPadding")
navPadding.PaddingTop = UDim.new(0, 10)
navPadding.PaddingLeft = UDim.new(0, 8)
navPadding.PaddingRight = UDim.new(0, 8)
navPadding.Parent = sidebar

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.Parent = content

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingLeft = UDim.new(0, 10)
contentPadding.PaddingRight = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.Parent = content

local function makeButton(parent, text, height)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, height or 40)
    button.BackgroundColor3 = background
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = white
    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 8)

    return button
end

local function makeTitle(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = purple
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    return label
end

local function makeToggle(text, callback)
    local enabled = false
    local button = makeButton(
        content,
        text .. "   [OFF]",
        42
    )

    button.Activated:Connect(function()
        enabled = not enabled
        button.Text = text ..
            (enabled and "   [ON]" or "   [OFF]")

        button.BackgroundColor3 =
            enabled and Color3.fromRGB(54, 35, 100)
            or background

        callback(enabled)
    end)

    return button
end

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= contentLayout
            and child ~= contentPadding then
            child:Destroy()
        end
    end
end

local pages = {
    "Main",
    "Auto Steal",
    "Auto Sell",
    "Auto Place Egg",
    "Train & Upgrade",
    "Combat",
    "Boss",
    "Event",
    "Anti AFK",
    "Settings",
    "Information"
}

local descriptions = {
    Main = {
        "AUTO TREADMILL",
        "AUTO UPGRADE ALL",
        "AUTO FUSE BEST PETS"
    },
    ["Auto Steal"] = {
        "EGG RADAR",
        "Ưu tiên trứng hiếm",
        "Hiển thị trứng gần nhất"
    },
    ["Auto Sell"] = {
        "Tự động bán pet yếu",
        "Giữ lại pet hiếm"
    },
    ["Auto Place Egg"] = {
        "Tự động đặt trứng",
        "Ưu tiên vị trí trống"
    },
    ["Train & Upgrade"] = {
        "AUTO TREADMILL",
        "AUTO UPGRADE ALL"
    },
    Combat = {
        "COMBAT TRAINING",
        "NPC TRAINING"
    },
    Boss = {
        "BOSS ASSISTANT",
        "Theo dõi máu boss",
        "Hiển thị mục tiêu"
    },
    Event = {
        "EVENT TRACKER",
        "Theo dõi sự kiện",
        "Thông tin phần thưởng"
    },
    ["Anti AFK"] = {
        "ANTI AFK",
        "Trạng thái hoạt động"
    },
    Settings = {
        "Giao diện màu tím",
        "Đóng menu"
    },
    Information = {
        "KNAM HUB v1.0",
        "Roblox Studio Edition"
    }
}

local function showPage(page)
    clearContent()
    makeTitle("✦  " .. page:upper())

    local items = descriptions[page] or {}

    for _, item in ipairs(items) do
        if item == "Đóng menu" then
            local closeButton = makeButton(
                content, item, 40
            )
            closeButton.Activated:Connect(function()
                gui:Destroy()
            })
        elseif item == "AUTO FUSE BEST PETS" then
            makeTitle("🧬 FUSE")
            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(1, 0, 0, 38)
            info.BackgroundTransparency = 1
            info.Text = "Chỉ Fuse khi bạn chọn và xác nhận."
            info.TextColor3 = white
            info.TextWrapped = true
            info.Parent = content

            local fuseButton = makeButton(
                content, "CHỌN PET ĐỂ FUSE", 42
            )
            fuseButton.Activated:Connect(function()
                warn("Hãy kết nối nút này với hệ thống Fuse của game bạn.")
            end)
        else
            makeToggle(item, function(enabled)
                print(item, enabled and "ON" or "OFF")
            end)
        end
    end
end

for _, page in ipairs(pages) do
    local nav = makeButton(sidebar, page, 34)

    nav.Activated:Connect(function()
        showPage(page)
    end)
end

showPage("Main")
