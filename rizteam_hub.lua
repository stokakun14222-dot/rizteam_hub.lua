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
-- FUNGSI DRAG (Buat Hub Mengambang)
-- ==========================================
local function makeDraggable(frame, dragArea)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
-- SPLASH SCREEN (LOADING)
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
    sub.Text = "Loading..."
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

    -- Animasi Muncul
    TweenService:Create(logo, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(sub, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(bar, TweenInfo.new(2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    task.wait(2.5)
    
    -- Animasi Hilang
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    splash:Destroy()
end

-- ==========================================
-- WATERMARK
-- ==========================================
local function createWatermark()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RizTeamWatermark"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 45)
    frame.Position = UDim2.new(0, 15, 0, 15)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 1.5
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 22)
    title.Position = UDim2.new(0, 5, 0, 3)
    title.BackgroundTransparency = 1
    title.Text = "RIZTEAM | Violence District"
    title.TextColor3 = Color3.fromRGB(0, 255, 100)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -10, 0, 16)
    sub.Position = UDim2.new(0, 5, 0, 24)
    sub.BackgroundTransparency = 1
    sub.Text = "Cheat Developer RizTeam"
    sub.TextColor3 = Color3.fromRGB(160, 160, 160)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = frame
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
-- FITUR: FULLBRIGHT (Anti Gelap)
-- ==========================================
local function Fullbright()
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            v:Destroy()
        end
    end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 3
    Lighting.ClockTime = 12
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = 1e6
    Lighting.FogStart = 0
    pcall(function() Lighting.EnvironmentDiffuseScale = 1 end)
    pcall(function() Lighting.EnvironmentSpecularScale = 1 end)
end

-- ==========================================
-- FITUR: ESP (Player)
-- ==========================================
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "RizTeamESP"

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.FillColor = Color3.fromRGB(0, 255, 100)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 100)
    highlight.FillTransparency = 0.5
    highlight.Parent = espFolder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_BB"
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
        
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        local targetPos = player.Character.HumanoidRootPart.Position
        local dist = math.floor((myPos - targetPos).Magnitude)
        
        if dist <= 100 then
            distance.Text = "[" .. dist .. "m]"
        else
            distance.Text = ""
        end
    end)
end

local function setupESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then createESP(player) end
    end
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Wait()
            task.wait(1)
            createESP(player)
        end
    end)
end

-- ==========================================
-- FITUR: NOCLIP
-- ==========================================
local function Noclip()
    local noclipConn
    noclipConn = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
    return noclipConn
end

-- ==========================================
-- FITUR: FLY (Keyboard: F untuk toggle)
-- ==========================================
local function Fly()
    local flying = false
    local bodyVelocity, bodyGyro
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F then
            flying = not flying
            if flying then
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = char.HumanoidRootPart
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                bodyGyro.CFrame = char.HumanoidRootPart.CFrame
                bodyGyro.Parent = char.HumanoidRootPart
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end
        end
    end)
    RunService.RenderStepped:Connect(function()
        if flying and bodyVelocity and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local moveDir = workspace.CurrentCamera.CFrame:VectorToWorldSpace(
                Vector3.new(
                    (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                    0,
                    (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
                )
            )
            bodyVelocity.Velocity = moveDir * 50
            bodyGyro.CFrame = Camera.CFrame
        end
    end)
end

-- ==========================================
-- FITUR: SPEED HACK
-- ==========================================
local function SpeedHack(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed or 50
    end
end

-- ==========================================
-- FITUR: ANTI AFK
-- ==========================================
local function AntiAFK()
    LocalPlayer.Idled:Connect(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end

-- ==========================================
-- FITUR: HITBOX EXPANDER
-- ==========================================
local function HitboxExpander(size)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(size or 10, size or 10, size or 10)
            v.Character.HumanoidRootPart.Transparency = 0.7
            v.Character.HumanoidRootPart.CanCollide = false
        end
    end
end

-- ==========================================
-- FITUR: AUTO HEAL (Pro)
-- ==========================================
local function AutoHeal()
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
        end
    end)
end

-- ==========================================
-- FITUR: AUTO PARRY (Pro)
-- ==========================================
local function AutoParry()
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") and string.find(string.lower(remote.Name), "parry") then
            RunService.Heartbeat:Connect(function()
                pcall(function()
                    remote:FireServer()
                end)
            end)
        end
    end
end

-- ==========================================
-- FITUR: AUTO GENERATOR (Pro)
-- ==========================================
local function AutoGenerator()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and (string.find(string.lower(obj.Parent.Name), "gen") or string.find(string.lower(obj.Parent.Name), "generator")) then
            if obj.HoldDuration > 0 then
                obj.HoldDuration = 0
            end
            if not obj.Enabled then
                obj.Enabled = true
            end
            spawn(function()
                while task.wait(0.1) do
                    if obj:IsDescendantOf(Workspace) then
                        pcall(function()
                            fireproximityprompt(obj)
                        end)
                    end
                end
            end)
        end
    end
end

-- ==========================================
-- MENU UI (Hub Mengambang)
-- ==========================================
local function openMainMenu(tier)
    createWatermark()

    local gui = Instance.new("ScreenGui")
    gui.Name = "RizTeamMenu"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 420)
    frame.Position = UDim2.new(0.5, -160, 0.5, -210)
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
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "RIZTEAM | " .. string.upper(tier)
    title.TextColor3 = Color3.fromRGB(0, 255, 100)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 18)
    sub.Position = UDim2.new(0, 0, 0, 40)
    sub.BackgroundTransparency = 1
    sub.Text = "Cheat Developer RizTeam"
    sub.TextColor3 = Color3.fromRGB(150, 150, 160)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.Parent = frame

    -- Bikin Frame bisa digeser (mengambang)
    makeDraggable(frame, title)

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -20, 0, 330)
    list.Position = UDim2.new(0, 10, 0, 70)
    list.BackgroundTransparency = 1
    list.ScrollBarThickness = 4
    list.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = list

    local function addToggle(name, callback, isPro)
        if isPro and tier ~= "pro" and tier ~= "owner" then return end
        if name == "Instant Win" and tier ~= "owner" then return end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Text = name
        btn.AutoButtonColor = false
        btn.Parent = list

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

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
    addToggle("Fly [F]", Fly, false)
    addToggle("Speed 50", function() SpeedHack(50) end, false)
    addToggle("Anti AFK", AntiAFK, false)
    addToggle("Hitbox 10x", function() HitboxExpander(10) end, false)
    addToggle("Auto Heal [PRO]", AutoHeal, true)
    addToggle("Auto Parry [PRO]", AutoParry, true)
    addToggle("Auto Generator [PRO]", AutoGenerator, true)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 50, 0, 24)
    closeBtn.Position = UDim2.new(1, -58, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

-- ==========================================
-- LOAD SCRIPT
-- ==========================================
local function loadScript(tier)
    if tier == "free" then
        openMainMenu("free")
    elseif tier == "pro" then
        openMainMenu("pro")
    elseif tier == "owner" then
        openMainMenu("owner")
    end
end

-- ==========================================
-- MAIN - START
-- ==========================================
createSplash() -- Panggil Splash Screen pertama
local gui, input, btn, footer = createKeyGUI()

btn.MouseButton1Click:Connect(function()
    local key = input.Text
    local tier = KEYS[key]
    if tier then
        footer.Text = "Key valid (" .. tier .. ") - Loading..."
        footer.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        gui:Destroy()
        loadScript(tier)
    else
        footer.Text = "Key tidak valid!"
        footer.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
