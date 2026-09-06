local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- ========== COLOR THEME ==========
local COLOR = {
    BG = Color3.fromRGB(22, 20, 34),
    SIDE = Color3.fromRGB(32, 29, 48),
    ACCENT = Color3.fromRGB(140, 75, 255),
    BUTTON = Color3.fromRGB(40, 37, 62),
    CARD = Color3.fromRGB(30, 28, 46),
    TEXT = Color3.new(1, 1, 1),
    TEXT_DIM = Color3.fromRGB(200, 200, 220),
    ERROR = Color3.fromRGB(255, 75, 75),
    SUCCESS = Color3.fromRGB(85, 255, 145),
    LOAD_BG = Color3.fromRGB(88, 15, 28)
}
local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad)

-- ========== HELPER: DRAG SLIDER (VISUAL ONLY) ==========
local function CreateVisualSlider(parent, yPos, LabelText, DefaultValue)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, 0, 0, 52)
    Container.Position = UDim2.new(0, 0, 0, yPos)
    Container.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Container)
    Label.Text = LabelText
    Label.Size = UDim2.new(0.32, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 15

    local Track = Instance.new("Frame", Container)
    Track.Size = UDim2.new(0.52, 0, 0, 20)
    Track.Position = UDim2.new(0.35, 0, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(30, 34, 42)
    Track.BorderColor3 = Color3.fromRGB(65, 140, 220)
    Track.BorderSizePixel = 1
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.Position = UDim2.new(0,0,0,0)
    Fill.BackgroundColor3 = Color3.fromRGB(58, 155, 255)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", Track)
    Knob.Size = UDim2.new(0, 26, 1, 4)
    Knob.ZIndex = 10
    Knob.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local ValueLabel = Instance.new("TextLabel", Container)
    ValueLabel.Size = UDim2.new(0, 28, 1, 0)
    ValueLabel.Position = UDim2.new(0.91, -14, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.new(1,1,1)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 16
    ValueLabel.Text = tostring(DefaultValue)

    -- SET INITIAL
    local function SetByValue(v)
        v = math.clamp(v, 0, 200)
        local alpha = v / 200
        Fill.Size = UDim2.new(alpha, 0, 1, 0)
        Knob.Position = UDim2.new(alpha, -13, 0, -2)
        ValueLabel.Text = tostring(math.floor(v))
    end
    SetByValue(DefaultValue)

    -- DRAG HANDLER
    local dragging, startPos, trackAbs
    local function UpdateFromMouse(x)
        local minX = Track.AbsolutePosition.X
        local maxX = minX + Track.AbsoluteSize.X
        local alpha = math.clamp((x - minX)/(maxX - minX), 0, 1)
        local val = math.floor(alpha * 200)
        Fill.Size = UDim2.new(alpha,0,1,0)
        Knob.Position = UDim2.new(alpha, -13, 0, -2)
        ValueLabel.Text = tostring(val)
    end

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    Knob.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromMouse(input.Position.X)
        end
    end)
    Knob.InputEnded:Connect(function() dragging = false end)

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateFromMouse(input.Position.X)
        end
    end)

    return Container
end

-- ========== HELPER TOGGLE ==========
local function CreateToggle(parent, yPos, labelName, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -16, 0, 36)
    Frame.Position = UDim2.new(0, 8, 0, yPos)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -65, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelName
    Label.TextColor3 = COLOR.TEXT
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("Frame", Frame)
    Switch.Size = UDim2.new(0, 50, 0, 24)
    Switch.Position = UDim2.new(1, -54, 0.5, -12)
    Switch.BackgroundColor3 = COLOR.BUTTON
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = COLOR.TEXT
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Clicker = Instance.new("TextButton", Switch)
    Clicker.Size = UDim2.new(1, 0, 1, 0)
    Clicker.BackgroundTransparency = 1

    local IsOn = false
    Clicker.MouseButton1Click:Connect(function()
        IsOn = not IsOn
        TweenService:Create(Knob, TWEEN_FAST, {Position = IsOn and UDim2.new(0, 29, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
        Switch.BackgroundColor3 = IsOn and COLOR.ACCENT or COLOR.BUTTON
        callback(IsOn)
    end)
    return Frame
end

-- ========== LOADING ==========
local function RunLoadingSequence()
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "Hub_Loading"
    LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingGui.DisplayOrder = 9998
    LoadingGui.Parent = PlayerGui

    local LoadingBox = Instance.new("Frame", LoadingGui)
    LoadingBox.Size = UDim2.new(0, 340, 0, 80)
    LoadingBox.AnchorPoint = Vector2.new(0.5, 0)
    LoadingBox.Position = UDim2.new(0.5, 0, 0, 12)
    LoadingBox.BackgroundColor3 = COLOR.LOAD_BG
    Instance.new("UICorner", LoadingBox).CornerRadius = UDim.new(0, 12)

    local LoadText = Instance.new("TextLabel", LoadingBox)
    LoadText.Size = UDim2.new(1, -16, 0.55, 0)
    LoadText.Position = UDim2.new(0, 8, 0, 10)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = "Checking whitelist for user: " .. plr.Name
    LoadText.TextColor3 = COLOR.TEXT
    LoadText.Font = Enum.Font.GothamBold
    LoadText.TextSize = 16

    local BarBg = Instance.new("Frame", LoadingBox)
    BarBg.Size = UDim2.new(1, -20, 0, 14)
    BarBg.Position = UDim2.new(0, 10, 0.65, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(35, 18, 30)
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 7)

    local BarProgress = Instance.new("Frame", BarBg)
    BarProgress.Size = UDim2.new(0, 0, 1, 0)
    BarProgress.BackgroundColor3 = Color3.fromRGB(255, 120, 140)
    Instance.new("UICorner", BarProgress).CornerRadius = UDim.new(0, 7)

    TweenService:Create(BarProgress, TweenInfo.new(5), {Size = UDim2.new(1,0,1,0)}):Play()
    task.wait(5)

    LoadText.Text = "Setting up Nexus Hub"
    BarProgress.Size = UDim2.new(0,0,1,0)
    TweenService:Create(BarProgress, TweenInfo.new(6), {Size = UDim2.new(1,0,1,0)}):Play()
    task.wait(6)

    LoadingGui:Destroy()
end

-- ========== MAIN UI ==========
local function ShowMainUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "NexusHub_Main"
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainGui.Parent = PlayerGui

    local MainWindow = Instance.new("Frame", MainGui)
    MainWindow.Size = UDim2.new(0, 460, 0, 300)
    MainWindow.Position = UDim2.new(0.5, -230, 0.5, -150)
    MainWindow.BackgroundColor3 = COLOR.BG
    MainWindow.BorderSizePixel = 2
    MainWindow.BorderColor3 = COLOR.ACCENT
    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 12)

    local RestoreBtn = Instance.new("TextButton", MainGui)
    RestoreBtn.Size = UDim2.new(0, 40, 0, 40)
    RestoreBtn.Position = UDim2.new(0, 10, 0.5, -20)
    RestoreBtn.BackgroundColor3 = COLOR.ACCENT
    RestoreBtn.Text = "N"
    RestoreBtn.TextColor3 = COLOR.TEXT
    RestoreBtn.Font = Enum.Font.GothamBold
    RestoreBtn.TextSize = 18
    RestoreBtn.Visible = false
    Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(1, 0)

    local TopBar = Instance.new("Frame", MainWindow)
    TopBar.Size = UDim2.new(1, 0, 0, 36)
    TopBar.BackgroundColor3 = COLOR.SIDE
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local MainTitle = Instance.new("TextLabel", TopBar)
    MainTitle.Size = UDim2.new(1, -80, 1, 0)
    MainTitle.Position = UDim2.new(0, 16, 0, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "🌐 NEXUS HUB"
    MainTitle.TextColor3 = COLOR.ACCENT
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.TextSize = 18
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left

    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 26, 0, 26)
    MinBtn.Position = UDim2.new(1, -62, 0.5, -13)
    MinBtn.BackgroundColor3 = COLOR.BUTTON
    MinBtn.Text = "−"
    MinBtn.TextColor3 = COLOR.TEXT
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 20
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -13)
    CloseBtn.BackgroundColor3 = COLOR.BUTTON
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = COLOR.ERROR
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    MinBtn.MouseButton1Click:Connect(function() MainWindow.Visible=false; RestoreBtn.Visible=true end)
    RestoreBtn.MouseButton1Click:Connect(function() MainWindow.Visible=true; RestoreBtn.Visible=false end)
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    local SideBar = Instance.new("Frame", MainWindow)
    SideBar.Size = UDim2.new(0, 110, 1, -44)
    SideBar.Position = UDim2.new(0, 0, 0, 36)
    SideBar.BackgroundColor3 = COLOR.SIDE

    local ContentArea = Instance.new("Frame", MainWindow)
    ContentArea.Size = UDim2.new(1, -120, 1, -44)
    ContentArea.Position = UDim2.new(0, 112, 0, 36)
    ContentArea.BackgroundColor3 = COLOR.CARD
    Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)

    local BottomBar = Instance.new("Frame", MainWindow)
    BottomBar.Size = UDim2.new(1, -16, 0, 32)
    BottomBar.Position = UDim2.new(0, 8, 1, -36)
    BottomBar.BackgroundColor3 = COLOR.SIDE
    BottomBar.Visible = false
    Instance.new("UICorner", BottomBar).CornerRadius = UDim.new(0, 6)

    local ShortcutMode = false
    local function UpdateShortcuts() ShortcutMode=not ShortcutMode; BottomBar.Visible=ShortcutMode end

    local Pages = {}
    local TabNames = {"Main", "Eggs", "Automation", "Plants", "Loadouts", "Pets", "Misc"}

    for index, TabName in ipairs(TabNames) do
        local TabBtn = Instance.new("TextButton", SideBar)
        TabBtn.Size = UDim2.new(1, -6, 0, 30)
        TabBtn.Position = UDim2.new(0, 3, 0, (index-1)*34+8)
        TabBtn.BackgroundColor3 = (TabName=="Automation") and COLOR.ACCENT or COLOR.BUTTON
        TabBtn.Text = TabName
        TabBtn.TextColor3 = COLOR.TEXT
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,5)

        local Page = Instance.new("Frame", ContentArea)
        Page.Size = UDim2.new(1,-12,1,-12)
        Page.Position = UDim2.new(0,6,0,6)
        Page.BackgroundTransparency=1
        Page.Visible=(TabName=="Automation")
        Pages[TabName]=Page

        if TabName=="Main" then
            local PlayerSection = Instance.new("Frame", Page)
            PlayerSection.Size = UDim2.new(1, -5, 0, 190)
            PlayerSection.Position = UDim2.new(0, 0, 0, 0)
            PlayerSection.BackgroundTransparency = 1

            -- SHORTCUT INFO
            local ShortcutBox = Instance.new("Frame", PlayerSection)
            ShortcutBox.Size = UDim2.new(1, 0, 0, 60)
            ShortcutBox.Position = UDim2.new(0, 0, 0, 0)
            ShortcutBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
            ShortcutBox.BorderColor3 = COLOR.ACCENT
            ShortcutBox.BorderSizePixel = 1
            Instance.new("UICorner", ShortcutBox).CornerRadius = UDim.new(0, 8)

            local Title = Instance.new("TextLabel", ShortcutBox)
            Title.Text = "Player"
            Title.Size = UDim2.new(1, -12, 0, 18)
            Title.Position = UDim2.new(0, 8, 0, 5)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Color3.fromRGB(170, 170, 185)
            Title.Font = Enum.Font.GothamSemibold
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Line1 = Instance.new("TextLabel", ShortcutBox)
            Line1.Text = "Shortcut Key = H"
            Line1.Size = UDim2.new(1, -16, 0, 20)
            Line1.Position = UDim2.new(0, 10, 0, 23)
            Line1.BackgroundTransparency = 1
            Line1.TextColor3 = Color3.new(1,1,1)
            Line1.Font = Enum.Font.GothamBold
            Line1.TextSize = 16
            Line1.TextXAlignment = Enum.TextXAlignment.Left

            local Line2 = Instance.new("TextLabel", ShortcutBox)
            Line2.Text = "Press H in keyboard to hide/unhide script interface"
            Line2.Size = UDim2.new(1, -16, 0, 14)
            Line2.Position = UDim2.new(0, 10, 0, 44)
            Line2.BackgroundTransparency = 1
            Line2.TextColor3 = Color3.fromRGB(210,210,220)
            Line2.Font = Enum.Font.GothamSemibold
            Line2.TextSize = 13
            Line2.TextXAlignment = Enum.TextXAlignment.Left

            -- DRAGGABLE SLIDERS (VISUAL ONLY)
            CreateVisualSlider(PlayerSection, 68, "Walk Speed", 79)
            CreateVisualSlider(PlayerSection, 126, "Jump Power", 100)

        elseif TabName=="Automation" then
            local Head=Instance.new("TextLabel", Page)
            Head.Size=UDim2.new(1,0,0,22)
            Head.BackgroundTransparency=1
            Head.Text="🤖 AUTOMATION"
            Head.TextColor3=COLOR.TEXT_DIM
            Head.Font=Enum.Font.GothamBold
            Head.TextSize=16

        elseif TabName=="Misc" then
            local Head=Instance.new("TextLabel", Page)
            Head.Size=UDim2.new(1,0,0,22)
            Head.BackgroundTransparency=1
            Head.Text="⚙️ SETTINGS"
            Head.TextColor3=COLOR.ACCENT
            Head.Font=Enum.Font.GothamBold
            Head.TextSize=16

            CreateToggle(Page,32,"🥚 Egg ESP",function() end)
            CreateToggle(Page,74,"⚡ Reduce Lag",function() end)
            CreateToggle(Page,116,"🔗 Shortcut Bar",UpdateShortcuts)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _,b in ipairs(SideBar:GetChildren())do if b:IsA("TextButton")then b.BackgroundColor3=COLOR.BUTTON end end
            TabBtn.BackgroundColor3=COLOR.ACCENT
            for _,p in pairs(Pages)do p.Visible=false end
            Page.Visible=true
        end)
    end
end

-- START
task.spawn(function()
    RunLoadingSequence()
    ShowMainUI()
end)
