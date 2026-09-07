local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui", 10)

-- ========== COLOR THEME ==========
local COLOR = {
    BG = Color3.fromRGB(18, 16, 30),
    SIDE = Color3.fromRGB(28, 25, 45),
    ACCENT = Color3.fromRGB(150, 65, 255),
    ACCENT_GLOW = Color3.fromRGB(180, 110, 255),
    BUTTON = Color3.fromRGB(36, 30, 60),
    BUTTON_HOVER = Color3.fromRGB(46, 38, 75),
    CARD = Color3.fromRGB(26, 22, 42),
    INPUT_BG = Color3.fromRGB(22, 20, 35),
    DRAWER_BG = Color3.fromRGB(20, 18, 34),
    TEXT = Color3.new(1, 1, 1),
    TEXT_DIM = Color3.fromRGB(205, 205, 230),
    ERROR = Color3.fromRGB(255, 80, 80),
    LOAD_BG = Color3.fromRGB(60, 18, 32),
    BORDER_GLOW = Color3.fromRGB(160, 90, 255)
}

local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SLIDE = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local FONT_NORMAL = 18
local FONT_MENU = 17
local FONT_TITLE = 22

-- ========== SLIDER ==========
local function MakeSlider(p, y, txt, def)
    local c = Instance.new("Frame", p)
    c.Size = UDim2.new(1, 0, 0, 56)
    c.Position = UDim2.new(0, 0, 0, y)
    c.BackgroundColor3 = COLOR.INPUT_BG
    c.BorderSizePixel = 1
    c.BorderColor3 = COLOR.ACCENT_GLOW
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)

    local lbl = Instance.new("TextLabel", c)
    lbl.Size = UDim2.new(0.35, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = COLOR.TEXT
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = FONT_NORMAL

    local track = Instance.new("Frame", c)
    track.Size = UDim2.new(0.5, 0, 0, 20)
    track.Position = UDim2.new(0.38, 0, 0.5, -10)
    track.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = COLOR.ACCENT_GLOW
    fill.Size = UDim2.new(0,0,1,0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0,24,0,24)
    knob.Position = UDim2.new(0,-2,0.5,-12)
    knob.BackgroundColor3 = COLOR.ACCENT_GLOW
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local val = Instance.new("TextLabel", c)
    val.Size = UDim2.new(0,30,1,0)
    val.Position = UDim2.new(1,-36,0,0)
    val.BackgroundTransparency = 1
    val.Text = tostring(def)
    val.TextColor3 = COLOR.TEXT
    val.Font = Enum.Font.GothamBold
    val.TextSize = FONT_NORMAL

    local function Set(v)
        v = math.clamp(v,0,200)
        local r = v/200
        fill.Size = UDim2.new(r,0,1,0)
        knob.Position = UDim2.new(r,-12,0.5,-12)
        val.Text = tostring(math.floor(v))
    end
    Set(def)

    local drag = false
    knob.InputBegan:Connect(function(e) if e.UserInputType == Enum.UserInputType.MouseButton1 then drag=true end end)
    knob.InputChanged:Connect(function(e)
        if drag and e.UserInputType == Enum.UserInputType.MouseMovement then
            Set(math.floor(math.clamp((e.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*200))
        end
    end)
    knob.InputEnded:Connect(function() drag=false end)
    return c
end

-- ========== TOGGLE ==========
local function MakeToggle(p,y,txt,cb)
    local c=Instance.new("Frame",p)
    c.Size=UDim2.new(1,-16,0,44)
    c.Position=UDim2.new(0,8,0,y)
    c.BackgroundTransparency=1

    local lbl=Instance.new("TextLabel",c)
    lbl.Size=UDim2.new(1,-62,1,0)
    lbl.BackgroundTransparency=1
    lbl.Text=txt
    lbl.TextColor3=COLOR.TEXT
    lbl.Font=Enum.Font.GothamSemibold
    lbl.TextSize = FONT_NORMAL
    lbl.TextXAlignment=Enum.TextXAlignment.Left

    local sw=Instance.new("Frame",c)
    sw.Size=UDim2.new(0,52,0,26)
    sw.Position=UDim2.new(1,-56,0.5,-13)
    sw.BackgroundColor3=COLOR.BUTTON
    Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)

    local k=Instance.new("Frame",sw)
    k.Size=UDim2.new(0,20,0,20)
    k.Position=UDim2.new(0,3,0.5,-10)
    k.BackgroundColor3=COLOR.TEXT
    Instance.new("UICorner",k).CornerRadius=UDim.new(1,0)

    local b=Instance.new("TextButton",sw)
    b.Size=UDim2.new(1,0,1,0)
    b.BackgroundTransparency=1

    local on=false
    b.MouseButton1Click:Connect(function()
        on=not on
        TweenService:Create(k,TWEEN_FAST,{Position=on and UDim2.new(0,29,0.5,-10) or UDim2.new(0,3,0.5,-10)}):Play()
        TweenService:Create(sw,TWEEN_FAST,{BackgroundColor3=on and COLOR.ACCENT or COLOR.BUTTON}):Play()
        cb(on)
    end)
    return c
end

-- ========== BUTTON / FIELD / INPUT ==========
local function MakeBtn(p,y,txt)
    local b=Instance.new("TextButton",p)
    b.Size=UDim2.new(1,-16,0,44)
    b.Position=UDim2.new(0,8,0,y)
    b.BackgroundColor3=COLOR.BUTTON
    b.Text=txt
    b.TextColor3=COLOR.TEXT
    b.Font=Enum.Font.GothamSemibold
    b.TextSize = FONT_NORMAL
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
    
    b.MouseEnter:Connect(function() TweenService:Create(b,TWEEN_FAST,{BackgroundColor3=COLOR.BUTTON_HOVER}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TWEEN_FAST,{BackgroundColor3=COLOR.BUTTON}):Play() end)
    return b
end

local function MakeField(p,y,title,val,arrow)
    local c=Instance.new("Frame",p)
    c.Size=UDim2.new(1,-16,0,62)
    c.Position=UDim2.new(0,8,0,y)
    c.BackgroundColor3=COLOR.INPUT_BG
    Instance.new("UICorner",c).CornerRadius=UDim.new(0,12)

    local t=Instance.new("TextLabel",c)
    t.Position=UDim2.new(0,14,0,6)
    t.Size=UDim2.new(1,-24,0,22)
    t.BackgroundTransparency=1
    t.Text=title
    t.TextColor3=COLOR.TEXT
    t.Font=Enum.Font.GothamSemibold
    t.TextSize = FONT_NORMAL

    local v=Instance.new("TextLabel",c)
    v.Position=UDim2.new(0,14,0,32)
    v.Size=UDim2.new(1,-28,0,20)
    v.BackgroundTransparency=1
    v.Text=val
    v.TextColor3=COLOR.TEXT_DIM
    v.Font=Enum.Font.Gotham
    v.TextSize = FONT_NORMAL - 2

    if arrow then
        local a=Instance.new("TextLabel",c)
        a.Position=UDim2.new(1,-38,0.5,-11)
        a.Size=UDim2.new(0,26,1,0)
        a.BackgroundTransparency=1
        a.Text="▼"
        a.TextColor3=COLOR.ACCENT_GLOW
        a.Font=Enum.Font.GothamBold
        a.TextSize = FONT_NORMAL
    end
    return c
end

local function MakeInput(p,y,title,def)
    local c=Instance.new("Frame",p)
    c.Size=UDim2.new(1,-16,0,52)
    c.Position=UDim2.new(0,8,0,y)
    c.BackgroundColor3=COLOR.INPUT_BG
    Instance.new("UICorner",c).CornerRadius=UDim.new(0,12)

    local t=Instance.new("TextLabel",c)
    t.Position=UDim2.new(0,12,0,0)
    t.Size=UDim2.new(0.5,0,1,0)
    t.BackgroundTransparency=1
    t.Text=title
    t.TextColor3=COLOR.TEXT
    t.Font=Enum.Font.GothamSemibold
    t.TextSize = FONT_NORMAL

    local tb=Instance.new("TextBox",c)
    tb.AnchorPoint=Vector2.new(1,.5)
    tb.Position=UDim2.new(1,-10,.5,0)
    tb.Size=UDim2.new(0.4,0,0,28)
    tb.BackgroundTransparency=1
    tb.Text=def
    tb.TextColor3=COLOR.TEXT
    tb.Font=Enum.Font.GothamBold
    tb.TextSize = FONT_NORMAL
    tb.ClearTextOnFocus=false
    return c
end

-- ========== NOTIFICATION ==========
local function ShowNotification(parentGui)
    local Notify = Instance.new("Frame")
    Notify.Size = UDim2.new(0, 300, 0, 46)
    Notify.Position = UDim2.new(0.5, -150, -0.15, 0)
    Notify.AnchorPoint = Vector2.new(0.5, 0)
    Notify.BackgroundColor3 = COLOR.SIDE
    Notify.BorderColor3 = COLOR.ACCENT_GLOW
    Notify.BorderSizePixel = 2
    Instance.new("UICorner", Notify).CornerRadius = UDim.new(0, 14)
    
    local Msg = Instance.new("TextLabel", Notify)
    Msg.Size = UDim2.new(1, -20, 1, 0)
    Msg.Position = UDim2.new(0, 10, 0, 0)
    Msg.BackgroundTransparency = 1
    Msg.Text = "✦ Nexus Hub • Ready!"
    Msg.TextColor3 = COLOR.ACCENT_GLOW
    Msg.Font = Enum.Font.GothamBold
    Msg.TextSize = 18
    
    Notify.Parent = parentGui
    TweenService:Create(Notify, TWEEN_SLIDE, {Position = UDim2.new(0.5, -150, 0.08, 0)}):Play()
    task.wait(2)
    Notify:Destroy()
end

-- ========== LOADING BAR: SIMPLE & SMOOTH SLIDE ==========
local function LoadUI()
    local sg=Instance.new("ScreenGui",PlayerGui)
    sg.Name="HubLoad"
    sg.DisplayOrder=9999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local box=Instance.new("Frame",sg)
    box.Size=UDim2.new(0,340,0,80)
    box.Position=UDim2.new(0.5, 0, 0, 12)
    box.AnchorPoint=Vector2.new(0.5, 0)
    box.BackgroundColor3=COLOR.LOAD_BG
    box.BorderColor3=COLOR.BORDER_GLOW
    box.BorderSizePixel=1
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,16)

    local txt=Instance.new("TextLabel",box)
    txt.Size=UDim2.new(1,-20,0.5,0)
    txt.Position=UDim2.new(0,10,0,10)
    txt.BackgroundTransparency=1
    txt.TextColor3=COLOR.TEXT
    txt.Font=Enum.Font.GothamBold
    txt.TextSize=FONT_NORMAL

    local barBg=Instance.new("Frame",box)
    barBg.Size=UDim2.new(1,-24,0,12)
    barBg.Position=UDim2.new(0,12,0.65,0)
    barBg.BackgroundColor3=Color3.fromRGB(30, 15, 25)
    Instance.new("UICorner",barBg).CornerRadius=UDim.new(0,6)

    local bar=Instance.new("Frame",barBg)
    bar.Size=UDim2.new(0,0,1,0)
    bar.BackgroundColor3=COLOR.ACCENT_GLOW
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,6)

    -- Simplified smooth animation
    local stepInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
    
    txt.Text="Loading resources..."
    TweenService:Create(bar, stepInfo, {Size=UDim2.new(1,0,1,0)}):Play()
    task.wait(2)
    
    bar.Size=UDim2.new(0,0,1,0)
    txt.Text="Verifying user: "..plr.Name
    TweenService:Create(bar, stepInfo, {Size=UDim2.new(1,0,1,0)}):Play()
    task.wait(2)
    
    bar.Size=UDim2.new(0,0,1,0)
    txt.Text="Starting interface..."
    TweenService:Create(bar, stepInfo, {Size=UDim2.new(1,0,1,0)}):Play()
    task.wait(2)

    sg:Destroy()
end

-- ========== MAIN UI & MINIMIZE SYSTEM ==========
local function Build()
    local Main=Instance.new("ScreenGui",PlayerGui)
    Main.Name="NexusHub_Main"
    Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Main.ResetOnSpawn=false

    local Win=Instance.new("Frame",Main)
    Win.Size=UDim2.new(0,440,0,330)
    Win.AnchorPoint=Vector2.new(0.5,0.5)
    Win.Position=UDim2.new(0.5,0,0.5,0)
    Win.BackgroundColor3=COLOR.BG
    Win.BorderSizePixel=2
    Win.BorderColor3=COLOR.BORDER_GLOW
    Instance.new("UICorner",Win).CornerRadius=UDim.new(0,18)

    local ShowBtn = Instance.new("TextButton", Main)
    ShowBtn.Name = "ShowNexus"
    ShowBtn.Size = UDim2.new(0, 150, 0, 38)
    ShowBtn.Position = UDim2.new(0, 15, 0, 15)
    ShowBtn.BackgroundColor3 = COLOR.SIDE
    ShowBtn.BorderColor3 = COLOR.ACCENT_GLOW
    ShowBtn.BorderSizePixel = 1
    ShowBtn.Visible = false
    Instance.new("UICorner", ShowBtn).CornerRadius = UDim.new(0, 19)

    local BtnText = Instance.new("TextLabel", ShowBtn)
    BtnText.Size = UDim2.new(1,0,1,0)
    BtnText.BackgroundTransparency=1
    BtnText.Text = "✦ Show Nexus"
    BtnText.TextColor3 = COLOR.ACCENT_GLOW
    BtnText.Font = Enum.Font.GothamBold
    BtnText.TextSize = 16

    local Top=Instance.new("Frame",Win)
    Top.Size=UDim2.new(1,0,0,40)
    Top.BackgroundColor3=COLOR.SIDE
    Instance.new("UICorner",Top).CornerRadius=UDim.new(0,16)

    local Title=Instance.new("TextLabel",Top)
    Title.Size=UDim2.new(1,-90,1,0)
    Title.Position=UDim2.new(0,16,0,0)
    Title.BackgroundTransparency=1
    Title.Text="✦ 🌐 NEXUS HUB ✦"
    Title.TextColor3=COLOR.ACCENT_GLOW
    Title.Font=Enum.Font.GothamBold
    Title.TextSize=FONT_TITLE

    local MinBtn=Instance.new("TextButton",Top)
    MinBtn.Size=UDim2.new(0,28,0,28)
    MinBtn.Position=UDim2.new(1,-64,.5,-14)
    MinBtn.BackgroundColor3=COLOR.BUTTON
    MinBtn.Text="−"
    MinBtn.TextColor3=COLOR.TEXT
    MinBtn.Font=Enum.Font.GothamBold
    Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(0,8)

    local CloseBtn=Instance.new("TextButton",Top)
    CloseBtn.Size=UDim2.new(0,28,0,28)
    CloseBtn.Position=UDim2.new(1,-32,.5,-14)
    CloseBtn.BackgroundColor3=COLOR.BUTTON
    CloseBtn.Text="✕"
    CloseBtn.TextColor3=COLOR.ERROR
    Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,8)

    MinBtn.MouseButton1Click:Connect(function()
        Win.Visible = false
        ShowBtn.Visible = true
    end)
    ShowBtn.MouseButton1Click:Connect(function()
        Win.Visible = true
        ShowBtn.Visible = false
    end)
    CloseBtn.MouseButton1Click:Connect(function() Main:Destroy() end)

    local Side=Instance.new("Frame",Win)
    Side.Size=UDim2.new(0,110,1,-46)
    Side.Position=UDim2.new(0,0,0,40)
    Side.BackgroundColor3=COLOR.SIDE
    Instance.new("UICorner",Side).CornerRadius=UDim.new(0,14)

    local Content=Instance.new("ScrollingFrame",Win)
    Content.Size=UDim2.new(1,-116,1,-46)
    Content.Position=UDim2.new(0,112,0,40)
    Content.CanvasSize=UDim2.new(0,0,2.2,0)
    Content.ScrollBarThickness=6
    Content.ScrollBarImageColor3=COLOR.ACCENT
    Content.BackgroundColor3=COLOR.CARD
    Instance.new("UICorner",Content).CornerRadius=UDim.new(0,14)

    local Pages={}
    local Tabs={"Main","Eggs","Automation","Plants","Loadouts","Pets","Misc"}

    for i,Name in ipairs(Tabs)do
        local Btn=Instance.new("TextButton",Side)
        Btn.Size=UDim2.new(1,-6,0,32)
        Btn.Position=UDim2.new(0,3,0,(i-1)*36+8)
        Btn.BackgroundColor3=Name=="Automation" and COLOR.ACCENT or COLOR.BUTTON
        Btn.Text=Name
        Btn.TextColor3=COLOR.TEXT
        Btn.Font=Enum.Font.GothamSemibold
        Btn.TextSize=FONT_MENU
        Instance.new("UICorner",Btn).CornerRadius=UDim.new(0,10)

        local Page=Instance.new("Frame",Content)
        Page.Size=UDim2.new(1,-10,0,720)
        Page.BackgroundTransparency=1
        Page.Visible=(Name=="Automation")
        Pages[Name]=Page

        if Name=="Main" then
            local Info=Instance.new("Frame",Page)
            Info.Size=UDim2.new(1,-10,0,66)
            Info.Position=UDim2.new(0,0,0,0)
            Info.BackgroundColor3=COLOR.INPUT_BG
            Info.BorderColor3=COLOR.ACCENT_GLOW
            Info.BorderSizePixel=1
            Instance.new("UICorner",Info).CornerRadius=UDim.new(0,14)

            local H=Instance.new("TextLabel",Info)
            H.Text="Player & Shortcuts"
            H.Size=UDim2.new(1,-14,0,20)
            H.Position=UDim2.new(0,10,0,6)
            H.BackgroundTransparency=1
            H.TextColor3=COLOR.ACCENT_GLOW
            H.Font=Enum.Font.GothamSemibold
            H.TextSize=FONT_NORMAL

            local Hint=Instance.new("TextLabel",Info)
            Hint.Text="Shortcut [H]: Toggle UI • User: "..plr.Name
            Hint.Size=UDim2.new(1,-16,0,22)
            Hint.Position=UDim2.new(0,10,0,28)
            Hint.BackgroundTransparency=1
            Hint.TextColor3=COLOR.TEXT_DIM
            Hint.Font=Enum.Font.Gotham
            Hint.TextSize=FONT_NORMAL - 1

            MakeSlider(Page, 84, "Walk Speed", 79)
            MakeSlider(Page, 152, "Jump Power", 100)

        elseif Name=="Automation" then
            MakeField(Pages.Automation,10,"Pickup/Place:","None",false)

            local ContPet=Instance.new("Frame",Pages.Automation)
            ContPet.Size=UDim2.new(1,-16,0,60)
            ContPet.Position=UDim2.new(0,8,0,80)
            ContPet.BackgroundColor3=COLOR.INPUT_BG
            Instance.new("UICorner",ContPet).CornerRadius=UDim.new(0,12)

            local LblPet=Instance.new("TextLabel",ContPet)
            LblPet.Position=UDim2.new(0,12,0,6)
            LblPet.Size=UDim2.new(1,-62,0,22)
            LblPet.BackgroundTransparency=1
            LblPet.Text="Select Pet/s"
            LblPet.TextColor3=COLOR.TEXT
            LblPet.Font=Enum.Font.GothamSemibold
            LblPet.TextSize=FONT_NORMAL

            local ValPet=Instance.new("TextLabel",ContPet)
            ValPet.Position=UDim2.new(0,12,0,32)
            ValPet.Size=UDim2.new(1,-52,0,18)
            ValPet.BackgroundTransparency=1
            ValPet.Text="None"
            ValPet.TextColor3=COLOR.TEXT_DIM

            local Arrow=Instance.new("TextLabel",ContPet)
            Arrow.Position=UDim2.new(1,-36,.5,-11)
            Arrow.Size=UDim2.new(0,26,1,0)
            Arrow.BackgroundTransparency=1
            Arrow.Text="▼"
            Arrow.TextColor3=COLOR.ACCENT_GLOW
            Arrow.ZIndex=2
            Arrow.Font=Enum.Font.GothamBold
            Arrow.TextSize=FONT_NORMAL

            local Drawer=Instance.new("Frame",Pages.Automation)
            Drawer.Size=UDim2.new(1,-16,0,0)
            Drawer.Position=UDim2.new(0,8,0,150)
            Drawer.BackgroundColor3=COLOR.DRAWER_BG
            Drawer.BorderColor3=COLOR.ACCENT
            Drawer.BorderSizePixel=1
            Drawer.ClipsDescendants=true
            Instance.new("UICorner",Drawer).CornerRadius=UDim.new(0,10)

            local Scr=Instance.new("ScrollingFrame",Drawer)
            Scr.Size=UDim2.new(1,-4,1,-4)
            Scr.Position=UDim2.new(0,2,0,2)
            Scr.BackgroundTransparency=1
            Scr.CanvasSize=UDim2.new(0,0,2,0)
            Scr.ScrollBarThickness=5
            Scr.ScrollBarImageColor3=COLOR.ACCENT

            local Toggle=Instance.new("TextButton",ContPet)
            Toggle.Size=UDim2.new(1,0,1,0)
            Toggle.BackgroundTransparency=1
            Toggle.ZIndex=3

            local BtnRef=MakeBtn(Pages.Automation,158,"🔄 Refresh list")
            local BtnClr=MakeBtn(Pages.Automation,212,"❌ Clear Selected")
            local Delay=MakeInput(Pages.Automation,264,"Animation Delay","1")
            local Tog=MakeToggle(Pages.Automation,316,"⚙️ Cancel Animation V3",function() end)

            local Open=false
            local H=160
            Toggle.MouseButton1Click:Connect(function()
                Open=not Open
                local move=Open and (H+10) or -(H+10)
                TweenService:Create(Drawer,TWEEN_FAST,{Size=UDim2.new(1,-16,0,Open and H or 0)}):Play()
                TweenService:Create(Arrow,TWEEN_FAST,{Rotation=Open and 180 or 0}):Play()

                TweenService:Create(BtnRef,TWEEN_FAST,{Position=BtnRef.Position+UDim2.new(0,0,0,move)}):Play()
                TweenService:Create(BtnClr,TWEEN_FAST,{Position=BtnClr.Position+UDim2.new(0,0,0,move)}):Play()
                TweenService:Create(Delay,TWEEN_FAST,{Position=Delay.Position+UDim2.new(0,0,0,move)}):Play()
                TweenService:Create(Tog,TWEEN_FAST,{Position=Tog.Position+UDim2.new(0,0,0,move)}):Play()
            end)

        elseif Name=="Misc" then
            MakeToggle(Page,10,"🥚 Egg ESP",function() end)
            MakeToggle(Page,58,"⚡ Reduce Lag",function() end)
            MakeToggle(Page,106,"🔗 Shortcut Bar",function() end)
        end

        Btn.MouseButton1Click:Connect(function()
            for _,b in ipairs(Side:GetChildren())do if b:IsA("TextButton")then b.BackgroundColor3=COLOR.BUTTON end end
            Btn.BackgroundColor3=COLOR.ACCENT
            for _,p in pairs(Pages)do p.Visible=false end
            Page.Visible=true
        end)
    end
    
    Win.Parent = Main
    Main.Parent = PlayerGui
    
    Win.Position=UDim2.new(0.5,0,-0.5,0)
    TweenService:Create(Win, TWEEN_SLIDE, {Position=UDim2.new(0.5,0,0.5,0)}):Play()
    
    UIS.InputBegan:Connect(function(input,gp)
        if input.KeyCode==Enum.KeyCode.H and not gp then
            Win.Visible=not Win.Visible
            ShowBtn.Visible=not Win.Visible
        end
    end)
end

task.spawn(function()
    LoadUI()
    Build()
    ShowNotification(PlayerGui)
end)
