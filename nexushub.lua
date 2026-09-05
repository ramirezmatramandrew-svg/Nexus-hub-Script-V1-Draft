local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local gui = plr:WaitForChild("PlayerGui")

-- SETTINGS
local ShopFrameName = "PetsShopUI"
local MapCenter = Vector3.new(0, 10, 0)
local TweenFast = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenIntro = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- MAIN GUI
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "NexusHub"
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.DisplayOrder = 999
MainUI.ResetOnSpawn = false
MainUI.Enabled = false
MainUI.Parent = gui

-- MAIN WINDOW
local Win = Instance.new("Frame")
Win.ZIndex = 10
Win.Size = UDim2.new(0, 500, 0, 350)
Win.Position = UDim2.new(0.5, -250, 0.3, -175)
Win.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
Win.BackgroundTransparency = 0
Win.BorderSizePixel = 0
Win.Parent = MainUI
Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 12)

-- TOP BAR
local TopBar = Instance.new("Frame", Win)
TopBar.ZIndex = 15
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.ZIndex = 16
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NEXUS HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZE & CLOSE
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.ZIndex = 20
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -56, 0, 6)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 53, 65)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.AutoLocalize = false
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.ZIndex = 20
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -28, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 53, 65)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoLocalize = false
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- MINIMIZE FLOAT BUTTON
local FloatBtn = Instance.new("TextButton", MainUI)
FloatBtn.ZIndex = 999
FloatBtn.Size = UDim2.new(0, 42, 0, 42)
FloatBtn.Position = UDim2.new(0, 12, 0.5, -21)
FloatBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
FloatBtn.BorderSizePixel = 2
FloatBtn.BorderColor3 = Color3.fromRGB(255, 145, 0)
FloatBtn.Visible = false
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

local FloatLabel = Instance.new("TextLabel", FloatBtn)
FloatLabel.ZIndex = 1
FloatLabel.Size = UDim2.new(1, 0, 1, 0)
FloatLabel.BackgroundTransparency = 1
FloatLabel.Text = "N"
FloatLabel.TextColor3 = Color3.new(1, 1, 1)
FloatLabel.Font = Enum.Font.GothamBold
FloatLabel.TextSize = 18

-- NAVIGATION SIDEBAR
local NavBar = Instance.new("Frame", Win)
NavBar.ZIndex = 11
NavBar.Size = UDim2.new(0, 120, 1, -38)
NavBar.Position = UDim2.new(0, 0, 0, 38)
NavBar.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
NavBar.BorderSizePixel = 0

-- CONTENT AREA
local ContentArea = Instance.new("Frame", Win)
ContentArea.ZIndex = 11
ContentArea.Size = UDim2.new(1, -124, 1, -46)
ContentArea.Position = UDim2.new(0, 124, 0, 42)
ContentArea.BackgroundColor3 = Color3.fromRGB(65, 68, 80)
ContentArea.BorderSizePixel = 0
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)

-- BOTTOM SHORTCUT BAR
local ShortcutBar = Instance.new("Frame", Win)
ShortcutBar.Name = "ShortcutBar"
ShortcutBar.ZIndex = 15
ShortcutBar.Size = UDim2.new(1, -20, 0, 40)
ShortcutBar.Position = UDim2.new(0, 10, 1, -50)
ShortcutBar.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
ShortcutBar.BorderSizePixel = 0
ShortcutBar.Visible = true
Instance.new("UICorner", ShortcutBar).CornerRadius = UDim.new(0, 8)

-- HELPERS
local function CreateShortcut(name, posX, callback)
    local B = Instance.new("TextButton", ShortcutBar)
    B.ZIndex = 16
    B.Size = UDim2.new(0.19, -4, 0.8, 0)
    B.Position = UDim2.new(posX, 0, 0.1, 0)
    B.BackgroundColor3 = Color3.fromRGB(50, 53, 65)
    B.BorderSizePixel = 0
    B.Text = name
    B.TextColor3 = Color3.new(1, 1, 1)
    B.Font = Enum.Font.GothamSemibold
    B.TextSize = 13
    B.AutoLocalize = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(callback or function() end)
    return B
end

local function CreateToggle(parent, yPos, label, callback)
    local Container = Instance.new("Frame", parent)
    Container.ZIndex = parent.ZIndex + 1
    Container.Size = UDim2.new(1, -20, 0, 36)
    Container.Position = UDim2.new(0, 10, 0, yPos)
    Container.BackgroundTransparency = 0

    local Lbl = Instance.new("TextLabel", Container)
    Lbl.ZIndex = 1
    Lbl.Size = UDim2.new(1, -50, 1, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = label
    Lbl.TextColor3 = Color3.new(1, 1, 1)
    Lbl.Font = Enum.Font.GothamSemibold
    Lbl.TextSize = 15
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Container)
    Switch.ZIndex = 2
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -46, 0.5, -11)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 63, 75)
    Switch.BorderSizePixel = 0
    Switch.Text = "OFF"
    Switch.TextColor3 = Color3.new(1, 1, 1)
    Switch.Font = Enum.Font.GothamBold
    Switch.TextSize = 11
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Active = false
    Switch.MouseButton1Click:Connect(function()
        Active = not Active
        TweenService:Create(Switch, TweenFast, {
            BackgroundColor3 = Active and Color3.fromRGB(255, 145, 0) or Color3.fromRGB(60, 63, 75)
        }):Play()
        Switch.Text = Active and "ON" or "OFF"
        if callback then callback(Active) end
    end)
    return Container
end

local function CreateBtn(parent, yPos, text)
    local B = Instance.new("TextButton", parent)
    B.ZIndex = parent.ZIndex + 1
    B.Size = UDim2.new(1, -20, 0, 30)
    B.Position = UDim2.new(0, 10, 0, yPos)
    B.BackgroundColor3 = Color3.fromRGB(50, 53, 65)
    B.BorderSizePixel = 0
    B.Text = text
    B.TextColor3 = Color3.new(1, 1, 1)
    B.Font = Enum.Font.GothamSemibold
    B.TextSize = 15
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    return B
end

-- ✅ DARKER INFO ROWS: Walang masyadong puti
local function AddInfoRow(parent, yPos, label, value)
    local Row = Instance.new("Frame", parent)
    Row.ZIndex = parent.ZIndex + 1
    Row.Size = UDim2.new(1, -30, 0, 30)
    Row.Position = UDim2.new(0, 15, 0, yPos)
    Row.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
    Row.BorderSizePixel = 0
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

    local L = Instance.new("TextLabel", Row)
    L.ZIndex = 1
    L.Size = UDim2.new(0.47, 0, 1, 0)
    L.BackgroundTransparency = 1
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = label
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.TextColor3 = Color3.fromRGB(210, 210, 220)
    L.Font = Enum.Font.GothamSemibold

    local V = Instance.new("TextLabel", Row)
    V.ZIndex = 1
    V.Size = UDim2.new(0.47, 0, 1, 0)
    V.BackgroundTransparency = 1
    V.Position = UDim2.new(0.53, -10, 0, 0)
    V.Text = value
    V.TextXAlignment = Enum.TextXAlignment.Right
    V.TextColor3 = Color3.new(1, 1, 1)
    V.Font = Enum.Font.GothamBold
end

-- LOGIC
local function OpenShop()
    pcall(function()
        if plr.PlayerGui:FindFirstChild(ShopFrameName) then
            plr.PlayerGui[ShopFrameName].Visible = true
        end
    end)
end

local function GoCenter()
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(MapCenter)
    end
end

local Shortcuts = {}
local ShortcutMode = false
local function UpdateShortcuts()
    for _,b in pairs(Shortcuts) do if b then b:Destroy() end end
    Shortcuts = {}
    if ShortcutMode then
        Shortcuts[1] = CreateShortcut("Pets", 0/5, OpenShop)
        Shortcuts[2] = CreateShortcut("Seeds", 1/5)
        Shortcuts[3] = CreateShortcut("Garden", 2/5)
        Shortcuts[4] = CreateShortcut("Sell", 3/5)
        Shortcuts[5] = CreateShortcut("Event", 4/5, GoCenter)
    else
        Shortcuts[1] = CreateShortcut("Seeds", 0/3)
        Shortcuts[2] = CreateShortcut("Garden", 1/3)
        Shortcuts[3] = CreateShortcut("Sell", 2/3)
    end
end
UpdateShortcuts()

-- BUILD TABS
local Pages = {}
local TabNames = {"Main","Eggs","Automation","Plants","Loadouts","Pets","Misc"}
local CurrentTab = 1

for idx, name in ipairs(TabNames) do
    local TabBtn = Instance.new("TextButton", NavBar)
    TabBtn.ZIndex = 12
    TabBtn.Size = UDim2.new(1, -10, 0, 34)
    TabBtn.Position = UDim2.new(0, 5, 0, (idx-1)*36 + 5)
    TabBtn.BackgroundColor3 = idx==CurrentTab and Color3.fromRGB(255, 145, 0) or Color3.fromRGB(40, 43, 52)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.new(1, 1, 1)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("Frame", ContentArea)
    Page.ZIndex = 12
    Page.Size = UDim2.new(1, -12, 1, -12)
    Page.Position = UDim2.new(0, 6, 0, 6)
    Page.BackgroundColor3 = Color3.fromRGB(65, 68, 80)
    Page.BorderSizePixel = 0
    Page.Visible = (idx == CurrentTab)

    if name == "Main" then
        local Header = Instance.new("TextLabel", Page)
        Header.ZIndex = 2
        Header.Size = UDim2.new(1, 0, 0, 28)
        Header.BackgroundTransparency = 1
        Header.Position = UDim2.new(0, 0, 0, 10)
        Header.Text = "👤 SCRIPT PROFILE"
        Header.TextColor3 = Color3.fromRGB(255, 145, 0)
        Header.Font = Enum.Font.GothamBold
        Header.TextSize = 16

        AddInfoRow(Page, 50, "Username", plr.Name)
        AddInfoRow(Page, 90, "Display Name", plr.DisplayName)
        AddInfoRow(Page, 130, "License Valid", "[Days/Months Here]")
        AddInfoRow(Page, 170, "Lifetime", "Free for now")
    elseif name == "Automation" then
        local Scroll = Instance.new("ScrollingFrame", Page)
        Scroll.ZIndex = 2
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.BackgroundColor3 = Page.BackgroundColor3
        Scroll.BorderSizePixel = 0
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 320)
        Scroll.ScrollBarThickness = 5
        Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 145, 0)
        Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local H = Instance.new("TextLabel", Scroll)
        H.ZIndex = 3
        H.Size = UDim2.new(1, -10, 0, 22)
        H.BackgroundTransparency = 1
        H.Text = "🤖 AUTOMATION"
        H.TextColor3 = Color3.fromRGB(200, 200, 220)
        H.Font = Enum.Font.GothamBold
        H.TextSize = 15

        local Sub = Instance.new("TextLabel", Scroll)
        Sub.ZIndex = 3
        Sub.Size = UDim2.new(1, -20, 0, 18)
        Sub.Position = UDim2.new(0, 10, 0, 28)
        Sub.BackgroundTransparency = 1
        Sub.Text = "📌 Pick / Place"
        Sub.TextColor3 = Color3.fromRGB(180, 180, 200)
        Sub.Font = Enum.Font.GothamSemibold
        Sub.TextSize = 13

        local DropBtn = Instance.new("TextButton", Scroll)
        DropBtn.ZIndex = 3
        DropBtn.Size = UDim2.new(1, -20, 0, 34)
        DropBtn.Position = UDim2.new(0, 10, 0, 50)
        DropBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
        DropBtn.BorderSizePixel = 0
        DropBtn.Text = "Select pet ▾"
        DropBtn.TextColor3 = Color3.new(1, 1, 1)
        DropBtn.Font = Enum.Font.GothamSemibold
        DropBtn.TextXAlignment = Enum.TextXAlignment.Left
        local Pad = Instance.new("UIPadding", DropBtn)
        Pad.PaddingLeft = UDim.new(0, 12)
        Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 8)

        local DropList = Instance.new("ScrollingFrame", Scroll)
        DropList.ZIndex = 3
        DropList.Size = UDim2.new(1, -20, 0, 85)
        DropList.Position = UDim2.new(0, 10, 0, 90)
        DropList.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
        DropList.BorderSizePixel = 0
        DropList.Visible = false
        DropList.ScrollBarThickness = 0
        Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)

        local Refresh = CreateBtn(Scroll, 94, "🔄 Refresh Selected Pets")
        local Clear = CreateBtn(Scroll, 126, "✖ Clear")
        local AutoToggle = CreateToggle(Scroll, 158, "Automation Status")

        local Expanded = false
        DropBtn.MouseButton1Click:Connect(function()
            Expanded = not Expanded
            DropList.Visible = Expanded
            DropBtn.Text = Expanded and "Select pet ▴" or "Select pet ▾"
            local offset = Expanded and 85 or 0
            Refresh.Position = UDim2.new(0, 10, 0, 94 + offset)
            Clear.Position = UDim2.new(0, 10, 0, 126 + offset)
            AutoToggle.Position = UDim2.new(0, 10, 0, 158 + offset)
        end)
    elseif name == "Misc" then
        local H = Instance.new("TextLabel", Page)
        H.ZIndex = 2
        H.Size = UDim2.new(1, 0, 0, 24)
        H.BackgroundTransparency = 1
        H.Position = UDim2.new(0, 0, 0, 5)
        H.Text = "⚙️ MISCELLANEOUS"
        H.TextColor3 = Color3.fromRGB(200, 200, 220)
        H.Font = Enum.Font.GothamBold

        CreateToggle(Page, 42, "🥚 Egg Esp")
        CreateToggle(Page, 82, "⚡ Reduce Lag")
        CreateToggle(Page, 122, "🔗 Shortcut Icon", function(val)
            ShortcutMode = val
            UpdateShortcuts()
        end)
    end

    -- ✅ FAST TAB SWITCH: Walang delay, walang puti
    TabBtn.MouseButton1Click:Connect(function()
        if idx == CurrentTab then return end
        CurrentTab = idx

        for _,b in ipairs(NavBar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenFast, {BackgroundColor3=Color3.fromRGB(40,43,52)}):Play()
            end
        end
        TweenService:Create(TabBtn, TweenFast, {BackgroundColor3=Color3.fromRGB(255,145,0)}):Play()

        for i,p in ipairs(Pages) do
            if i ~= idx then
                p.Visible = false
            end
        end
        Page.Visible = true
    end)

    table.insert(Pages, Page)
end

-- Minimize / Close
MinBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Win, TweenFast, {
        Position = UDim2.new(0.5, -250, 0, -500),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.25)
    Win.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible = false
    Win.Visible = true
    TweenService:Create(Win, TweenIntro, {
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundTransparency = 0
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Win, TweenFast, {BackgroundTransparency=1}):Play()
    task.wait(0.25)
    MainUI:Destroy()
end)

-- INTRO ANIM
MainUI.Enabled = true
TweenService:Create(Win, TweenIntro, {
    Position = UDim2.new(0.5, -250, 0.5, -175),
    BackgroundTransparency = 0
}):Play()
