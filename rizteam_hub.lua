-- file: rizteam_hub.lua
-- signature: RizTeam Cheat Developer
-- game: Violence District

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- KONFIGURASI KEY
-- ==========================================
local KEYS = {
    ["RIZ-FREE-111"] = "free",
    ["RIZ-PRO-222"]  = "pro",
    ["RIZ-OWNER-999"] = "owner",
}

-- ==========================================
-- FUNGSI DRAG
-- ==========================================
local function makeDraggable(frame, dragArea)
    local dragging, dragInput, mousePos, framePos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- SPLASH SCREEN
-- ==========================================
local function createSplash()
    local splash = Instance.new("ScreenGui")
    splash.Name = "RizTeamSplash"
    splash.ResetOnSpawn = false
    splash.Parent = CoreGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    bg.BorderSizePixel = 0
    bg.Parent = splash

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 0, 60)
    logo.Position = UDim2.new(0, 0, 0.4, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "RIZTEAM HUB"
    logo.TextColor3 = Color3.fromRGB(0, 255, 100)
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 40
    logo.TextTransparency = 1
    logo.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 30)
    sub.Position = UDim2.new(0, 0, 0.4, 50)
    sub.BackgroundTransparency = 1
    sub.Text = "Loading Interface..."
    sub.TextColor3 = Color3.fromRGB(200, 200, 200)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 16
    sub.TextTransparency = 1
    sub.Parent = bg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 300, 0, 8)
    barBg.Position = UDim2.new(0.5, -150, 0.5, 80)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg
    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    bar.BorderSizePixel = 0
    bar.Parent = barBg
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    TweenService:Create(logo, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(sub, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(bar, TweenInfo.new(2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    task.wait(2.5)
    
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    splash:Destroy()
end

-- ==========================================
-- KEY SYSTEM GUI
-- ==========================================
local function createKeyGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RizTeamKeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 240)
    frame.Position = UDim2.new(0.5, -190, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 2
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 38)
    title.BackgroundTransparency = 1
    title.Text = "RIZTEAM HUB"
    title.TextColor3 = Color3.fromRGB(0, 255, 100)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 18)
    sub.Position = UDim2.new(0, 0, 0, 36)
    sub.BackgroundTransparency = 1
    sub.Text = "Violence District | by RizTeam"
    sub.TextColor3 = Color3.fromRGB(140, 140, 160)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -40, 0, 42)
    input.Position = UDim2.new(0, 20, 0, 75)
    input.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Masukkan Key..."
    input.PlaceholderColor3 = Color3.fromRGB(90, 90, 110)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.ClearTextOnFocus = false
    input.Parent = frame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 42)
    btn.Position = UDim2.new(0, 20, 0, 130)
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "SUBMIT KEY"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.BackgroundTransparency = 1
    footer.Text = "Cheat Developer RizTeam © 2026"
    footer.TextColor3 = Color3.fromRGB(100, 100, 120)
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 11
    footer.Parent = frame

    return gui, input, btn, footer
end

-- ==========================================
-- FITUR CHEAT
-- ==========================================
local function Fullbright()
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then v:Destroy() end
    end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 3
    Lighting.ClockTime = 12
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = 1e6
    pcall(function() Lighting.EnvironmentDiffuseScale = 1 end)
end

local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "RizTeamESP"

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 100)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 100)
    highlight.FillTransparency = 0.5
    highlight.Parent = espFolder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextStrokeTransparency = 0
    name.Font = Enum.Font.GothamBold
    name.TextSize = 14
    name.Parent = billboard
    
    local distance = Instance.new("TextLabel")
    distance.Size = UDim2.new(1, 0, 0.5, 0)
    distance.Position = UDim2.new(0, 0, 0.5, 0)
    distance.BackgroundTransparency = 1
    distance.TextColor3 = Color3.fromRGB(0, 255, 100)
    distance.TextStrokeTransparency = 0
    distance.Font = Enum.Font.Gotham
    distance.TextSize = 12
    distance.Parent = billboard
    
    RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        if not highlight.Parent then return end
        highlight.Adornee = player.Character
        billboard.Adornee = player.Character:FindFirstChild("Head")
        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
        distance.Text = dist <= 100 and "[" .. dist .. "m]" or ""
    end)
end

local function setupESP()
    for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer then createESP(player) end end
    Players.PlayerAdded:Connect(function(player) if player ~= LocalPlayer then player.CharacterAdded:Wait(); task.wait(1); createESP(player) end end)
end

local function Noclip()
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

local function Fly()
    local flying, bv, bg = false
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F then
            flying = not flying
            if flying then
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bg = Instance.new("BodyGyro", char.HumanoidRootPart)
                bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                bg.CFrame = char.HumanoidRootPart.CFrame
            else
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
        end
    end)
    RunService.RenderStepped:Connect(function()
        if flying and bv and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            bv.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new((UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0), 0, (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0))) * 50
            bg.CFrame = Camera.CFrame
        end
    end)
end

local function SpeedHack() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 50 end end
local function AntiAFK() LocalPlayer.Idled:Connect(function() local vu = game:GetService("VirtualUser"); vu:CaptureController(); vu:ClickButton2(Vector2.new()) end) end
local function HitboxExpander() for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then v.Character.HumanoidRootPart.Size = Vector3.new(10,10,10); v.Character.HumanoidRootPart.Transparency = 0.7 end end end
local function AutoHeal() RunService.Heartbeat:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth end end) end
local function AutoParry() for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do if remote:IsA("RemoteEvent") and string.find(string.lower(remote.Name), "parry") then RunService.Heartbeat:Connect(function() pcall(function() remote:FireServer() end) end) end end end
local function AutoGenerator() for _, obj in pairs(Workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") and (string.find(string.lower(obj.Parent.Name), "gen") or string.find(string.lower(obj.Parent.Name), "generator")) then obj.HoldDuration = 0; obj.Enabled = true; spawn(function() while task.wait(0.1) do if obj:IsDescendantOf(Workspace) then pcall(function() fireproximityprompt(obj) end) end end end) end end end

-- ==========================================
-- MENU UI HORIZONTAL
-- ==========================================
local function openMainMenu(tier)
    local gui = Instance.new("ScreenGui")
    gui.Name = "RizTeamMenu"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    -- WADAH UTAMA
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 500, 0, 300)
    main.Position = UDim2.new(0.5, -250, 0.5, -150)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    main.BorderSizePixel = 0
    main.Parent = gui
    local mainCorner = Instance.new("UICorner"); mainCorner.CornerRadius = UDim.new(0, 10); mainCorner.Parent = main
    local mainStroke = Instance.new("UIStroke"); mainStroke.Color = Color3.fromRGB(0, 255, 100); mainStroke.Thickness = 2; mainStroke.Parent = main
    makeDraggable(main, main)

    -- SIDEBAR KIRI (NAVIGASI)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    local sidebarCorner = Instance.new("UICorner"); sidebarCorner.CornerRadius = UDim.new(0, 10); sidebarCorner.Parent = sidebar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "RIZTEAM"
    title.TextColor3 = Color3.fromRGB(0, 255, 100)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 20
    title.Parent = sidebar

    local function makeTab(name, active)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Position = UDim2.new(0, 10, 0, 60 + (#sidebar:GetChildren() * 40))
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(22, 22, 38)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = sidebar
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
        return btn
    end

    local btnInfo = makeTab("INFO", true)
    local btnMain = makeTab("MAIN", false)

    -- KONTEN KANAN
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -150, 1, 0)
    content.Position = UDim2.new(0, 150, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = main

    -- HALAMAN INFO (Pertama Muncul)
    local pageInfo = Instance.new("Frame")
    pageInfo.Size = UDim2.new(1, -20, 1, -20)
    pageInfo.Position = UDim2.new(0, 10, 0, 10)
    pageInfo.BackgroundTransparency = 1
    pageInfo.Parent = content

    local userTitle = Instance.new("TextLabel")
    userTitle.Size = UDim2.new(1, 0, 0, 30)
    userTitle.BackgroundTransparency = 1
    userTitle.Text = "AKUN ROBLOX KAMU"
    userTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    userTitle.Font = Enum.Font.GothamBold
    userTitle.TextSize = 14
    userTitle.TextXAlignment = Enum.TextXAlignment.Left
    userTitle.Parent = pageInfo

    local userData = Instance.new("TextLabel")
    userData.Size = UDim2.new(1, 0, 0, 100)
    userData.Position = UDim2.new(0, 0, 0, 40)
    userData.BackgroundTransparency = 1
    userData.Text = "Nama: " .. LocalPlayer.Name .. "\nRole: " .. string.upper(tier) .. "\nGame: Violence District\nStatus: Terhubung"
    userData.TextColor3 = Color3.fromRGB(200, 200, 200)
    userData.Font = Enum.Font.Gotham
    userData.TextSize = 13
    userData.TextXAlignment = Enum.TextXAlignment.Left
    userData.Parent = pageInfo

    -- HALAMAN MAIN (Fitur)
    local pageMain = Instance.new("Frame")
    pageMain.Size = UDim2.new(1, -20, 1, -20)
    pageMain.Position = UDim2.new(0, 10, 0, 10)
    pageMain.BackgroundTransparency = 1
    pageMain.Visible = false
    pageMain.Parent = content

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.Parent = pageMain
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 5); layout.Parent = scroll

    -- GANTI TAB
    btnInfo.MouseButton1Click:Connect(function()
        pageInfo.Visible = true; pageMain.Visible = false
        btnInfo.BackgroundColor3 = Color3.fromRGB(0, 180, 90); btnMain.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    end)
    btnMain.MouseButton1Click:Connect(function()
        pageInfo.Visible = false; pageMain.Visible = true
        btnInfo.BackgroundColor3 = Color3.fromRGB(22, 22, 38); btnMain.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    end)

    local function addToggle(name, callback, isPro)
        if isPro and tier ~= "pro" and tier ~= "owner" then return end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Text = " " .. name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = scroll
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
        local toggle = false
        btn.MouseButton1Click:Connect(function()
            toggle = not toggle
            btn.BackgroundColor3 = toggle and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(22, 22, 38)
            if toggle then pcall(callback) end
        end)
    end

    addToggle("Fullbright (Anti Gelap)", Fullbright, false)
    addToggle("ESP Player", setupESP, false)
    addToggle("Noclip", Noclip, false)
    addToggle("Fly [Tekan F]", Fly, false)
    addToggle("Speed 50", SpeedHack, false)
    addToggle("Anti AFK", AntiAFK, false)
    addToggle("Hitbox 10x", HitboxExpander, false)
    addToggle("Auto Heal [PRO]", AutoHeal, true)
    addToggle("Auto Parry [PRO]", AutoParry, true)
    addToggle("Auto Generator [PRO]", AutoGenerator, true)

    -- TOMBOL HIDE & CLOSE
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 50, 0, 24)
    hideBtn.Position = UDim2.new(1, -115, 0, 8)
    hideBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.Text = "HIDE"
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 12
    hideBtn.Parent = main
    local hideC = Instance.new("UICorner"); hideC.CornerRadius = UDim.new(0, 6); hideC.Parent = hideBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 50, 0, 24)
    closeBtn.Position = UDim2.new(1, -60, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.Parent = main
    local closeC = Instance.new("UICorner"); closeC.CornerRadius = UDim.new(0, 6); closeC.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- FLOATING BUTTON (Untuk Buka Lagi)
    local floatBtn = Instance.new("TextButton")
    floatBtn.Size = UDim2.new(0, 45, 0, 45)
    floatBtn.Position = UDim2.new(0, 20, 0.5, -22)
    floatBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatBtn.Text = "R"
    floatBtn.Font = Enum.Font.GothamBlack
    floatBtn.TextSize = 20
    floatBtn.Visible = false
    floatBtn.Parent = gui
    local floatC = Instance.new("UICorner"); floatC.CornerRadius = UDim.new(1, 0); floatC.Parent = floatBtn
    local floatStroke = Instance.new("UIStroke"); floatStroke.Color = Color3.fromRGB(0, 255, 100); floatStroke.Thickness = 2; floatStroke.Parent = floatBtn

    hideBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        floatBtn.Visible = true
    end)

    floatBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        floatBtn.Visible = false
    end)
end

-- ==========================================
-- MAIN LOOP
-- ==========================================
createSplash()
local gui, input, btn, footer = createKeyGUI()

btn.MouseButton1Click:Connect(function()
    local key = input.Text
    local tier = KEYS[key]
    if tier then
        footer.Text = "Key valid (" .. tier .. ") - Loading..."
        footer.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        gui:Destroy()
        openMainMenu(tier)
    else
        footer.Text = "Key tidak valid!"
        footer.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
