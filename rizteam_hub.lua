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
local VirtualUser = game:GetService("VirtualUser")

-- ==========================================
-- VARIABEL GLOBAL & CONFIG
-- ==========================================
local KEYS = {
    ["RIZ-FREE-111"] = "free",
    ["RIZ-PRO-222"]  = "pro",
    ["RIZ-OWNER-999"] = "owner",
}

local isAimbotEnabled = false
local isSilentAimEnabled = false
local isCrosshairEnabled = false
local isAutoGenEnabled = false
local activeESP = nil -- "survivor", "killer", atau nil

-- Warna Tema (Dark Mode)
local C_BG = Color3.fromRGB(15, 15, 15)
local C_Sidebar = Color3.fromRGB(20, 20, 20)
local C_Card = Color3.fromRGB(25, 25, 25)
local C_Border = Color3.fromRGB(45, 45, 45)
local C_Text = Color3.fromRGB(255, 255, 255)
local C_TextDim = Color3.fromRGB(150, 150, 150)
local C_Accent = Color3.fromRGB(255, 255, 255)

-- ==========================================
-- FUNGSI BANTUAN UI
-- ==========================================
local function makeDraggable(frame, dragArea)
    local dragging, dragInput, mousePos, framePos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; mousePos = input.Position; framePos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

local function createToggle(parent, text, defaultState, callback)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, 0, 0, 30); frame.BackgroundTransparency = 1; frame.Parent = parent
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, -50, 1, 0); label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = C_Text; label.Font = Enum.Font.Gotham; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = frame
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0, 40, 0, 20); btn.Position = UDim2.new(1, -40, 0.5, -10); btn.BackgroundColor3 = defaultState and C_Text or C_Card; btn.Text = ""; btn.AutoButtonColor = false; btn.Parent = frame
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1, 0); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = C_Border; stroke.Parent = btn
    local circle = Instance.new("Frame"); circle.Size = UDim2.new(0, 16, 0, 16); circle.Position = defaultState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); circle.BackgroundColor3 = defaultState and C_BG or C_TextDim; circle.Parent = btn
    local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(1, 0); cCorner.Parent = circle
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and C_Text or C_Card
        circle.BackgroundColor3 = state and C_BG or C_TextDim
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        if callback then callback(state) end
    end)
    return frame
end

local function createSection(parent, title)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, 0, 0, 35); frame.BackgroundColor3 = C_Card; frame.Parent = parent
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = C_Border; stroke.Parent = frame
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, -10, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.Text = title; label.TextColor3 = C_Text; label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = frame
    return frame
end

-- ==========================================
-- FITUR ESP (FILTER UPDATE)
-- ==========================================
local espFolder = Instance.new("Folder", CoreGui); espFolder.Name = "RizTeamESP"
local espTargets = {}

local function clearESP()
    for _, item in pairs(espTargets) do
        if item.Highlight then item.Highlight:Destroy() end
        if item.Billboard then item.Billboard:Destroy() end
    end
    espTargets = {}
end

local function renderESP()
    clearESP()
    if not activeESP then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isTarget = false
            -- Logika Filter Role
            if activeESP == "killer" and player.Team and string.find(string.lower(player.Team.Name), "killer") then isTarget = true
            elseif activeESP == "survivor" and player.Team and string.find(string.lower(player.Team.Name), "survivor") then isTarget = true
            -- Cadangan kalau game gak pakai Team (deteksi dari nama)
            elseif activeESP == "killer" and string.find(string.lower(player.Name), "killer") then isTarget = true
            elseif activeESP == "survivor" and string.find(string.lower(player.Name), "survivor") then isTarget = true
            end

            if isTarget and player.Character:FindFirstChild("HumanoidRootPart") then
                local color = activeESP == "killer" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 100)
                
                local highlight = Instance.new("Highlight")
                highlight.FillColor = color; highlight.OutlineColor = color; highlight.FillTransparency = 0.5; highlight.Parent = espFolder; highlight.Adornee = player.Character
                
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 200, 0, 50); billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.AlwaysOnTop = true; billboard.Parent = espFolder; billboard.Adornee = player.Character:FindFirstChild("Head")
                
                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, 0, 0.5, 0); name.BackgroundTransparency = 1; name.Text = player.Name; name.TextColor3 = color; name.TextStrokeTransparency = 0; name.Font = Enum.Font.GothamBold; name.TextSize = 14; name.Parent = billboard
                
                table.insert(espTargets, {Highlight = highlight, Billboard = billboard, Name = name, Player = player})
            end
        end
    end
end

-- Update jarak tiap frame
RunService.RenderStepped:Connect(function()
    for _, data in pairs(espTargets) do
        if data.Player.Character and data.Player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - data.Player.Character.HumanoidRootPart.Position).Magnitude)
            data.Name.Text = data.Player.Name .. " [" .. dist .. "m]"
        else
            if data.Highlight then data.Highlight:Destroy() end
            if data.Billboard then data.Billboard:Destroy() end
        end
    end
end)

local function setupESP(type)
    activeESP = type
    renderESP()
end

local function createObjectESP(name, color)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), string.lower(name)) then
            local highlight = Instance.new("Highlight"); highlight.FillColor = color; highlight.OutlineColor = color; highlight.FillTransparency = 0.5; highlight.Parent = espFolder; highlight.Adornee = obj
        end
    end
end

-- ==========================================
-- FITUR CHEAT LOGIC
-- ==========================================
local function Fullbright()
    for _, v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then v:Destroy() end end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.Brightness = 3; Lighting.ClockTime = 12; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.FogEnd = 1e6
end

local function Noclip()
    RunService.Stepped:Connect(function() if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
end

local function SpeedHack(speed) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = speed or 50 end end

local function Fly()
    local flying, bv, bg = false
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F then
            flying = not flying
            if flying then
                local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                bv = Instance.new("BodyVelocity", char.HumanoidRootPart); bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bg = Instance.new("BodyGyro", char.HumanoidRootPart); bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bg.CFrame = char.HumanoidRootPart.CFrame
            else if bv then bv:Destroy() end; if bg then bg:Destroy() end end
        end
    end)
    RunService.RenderStepped:Connect(function()
        if flying and bv and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            bv.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new((UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0), 0, (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0))) * 50
            bg.CFrame = Camera.CFrame
        end
    end)
end

local function Flashlight()
    local light = Instance.new("PointLight"); light.Brightness = 5; light.Range = 50; light.Color = Color3.fromRGB(255, 255, 255); light.Parent = LocalPlayer.Character.HumanoidRootPart
end

-- Aimbot Logic
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isAimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local closestDist = 500
            local targetHead = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
                    if dist < closestDist then closestDist = dist; targetHead = player.Character.Head end
                end
            end
            if targetHead then
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetHead.Position)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.15)
            end
        end
    end
end)

-- Auto Gen Logic
RunService.RenderStepped:Connect(function()
    if isAutoGenEnabled then
        for _, obj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if obj:IsA("ImageLabel") or obj:IsA("Frame") or obj:IsA("TextButton") then
                if string.find(string.lower(obj.Name), "gen") or string.find(string.lower(obj.Name), "pointer") or string.find(string.lower(obj.Name), "target") then
                    if obj.Visible and obj.AbsolutePosition.X > 0 then
                        local center = obj.AbsolutePosition + (obj.AbsoluteSize / 2)
                        VirtualUser:Button1Down(Vector2.new(center.X, center.Y))
                        task.wait(0.05)
                        VirtualUser:Button1Up(Vector2.new(center.X, center.Y))
                    end
                end
            end
        end
    end
end)

-- Crosshair Logic
local crosshairGui = Instance.new("ScreenGui"); crosshairGui.Name = "RizTeamCrosshair"; crosshairGui.ResetOnSpawn = false; crosshairGui.Parent = CoreGui
local crosshair = Instance.new("TextLabel"); crosshair.Size = UDim2.new(0, 20, 0, 20); crosshair.Position = UDim2.new(0.5, -10, 0.5, -10); crosshair.BackgroundTransparency = 1; crosshair.Text = "+"; crosshair.TextColor3 = Color3.fromRGB(0, 255, 100); crosshair.Font = Enum.Font.GothamBold; crosshair.TextSize = 24; crosshair.TextStrokeTransparency = 0; crosshair.Visible = false; crosshair.Parent = crosshairGui
RunService.RenderStepped:Connect(function() if crosshair then crosshair.Visible = isCrosshairEnabled end end)


-- ==========================================
-- MAIN UI (Dashboard Style)
-- ==========================================
local function openDashboard(tier)
    local gui = Instance.new("ScreenGui"); gui.Name = "RizTeamMenu"; gui.ResetOnSpawn = false; gui.Parent = CoreGui
    local main = Instance.new("Frame"); main.Size = UDim2.new(0, 650, 0, 400); main.Position = UDim2.new(0.5, -325, 0.5, -200); main.BackgroundColor3 = C_BG; main.BorderSizePixel = 0; main.Parent = gui
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 12); mc.Parent = main
    local ms = Instance.new("UIStroke"); ms.Color = C_Border; ms.Thickness = 1; ms.Parent = main
    makeDraggable(main, main)

    local topBar = Instance.new("Frame"); topBar.Size = UDim2.new(1, 0, 0, 45); topBar.BackgroundTransparency = 1; topBar.Parent = main
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -60, 1, 0); title.Position = UDim2.new(0, 20, 0, 0); title.BackgroundTransparency = 1; title.Text = "RizTeam Hub"; title.TextColor3 = C_Text; title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = topBar
    local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -40, 0.5, -15); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "✕"; closeBtn.TextColor3 = C_TextDim; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 16; closeBtn.Parent = topBar
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    local sidebar = Instance.new("Frame"); sidebar.Size = UDim2.new(0, 160, 1, -60); sidebar.Position = UDim2.new(0, 10, 0, 50); sidebar.BackgroundColor3 = C_Sidebar; sidebar.Parent = main
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 8); sc.Parent = sidebar
    local profile = Instance.new("Frame"); profile.Size = UDim2.new(1, -20, 0, 50); profile.Position = UDim2.new(0, 10, 1, -60); profile.BackgroundColor3 = C_Card; profile.Parent = sidebar
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 6); pc.Parent = profile
    local pName = Instance.new("TextLabel"); pName.Size = UDim2.new(1, 0, 0.5, 0); pName.Position = UDim2.new(0, 0, 0, 5); pName.BackgroundTransparency = 1; pName.Text = LocalPlayer.Name; pName.TextColor3 = C_Text; pName.Font = Enum.Font.GothamBold; pName.TextSize = 12; pName.Parent = profile
    local pRole = Instance.new("TextLabel"); pRole.Size = UDim2.new(1, 0, 0.5, 0); pRole.Position = UDim2.new(0, 0, 0.5, 0); pRole.BackgroundTransparency = 1; pRole.Text = string.upper(tier) .. " | Violence District"; pRole.TextColor3 = C_TextDim; pRole.Font = Enum.Font.Gotham; pRole.TextSize = 10; pRole.Parent = profile

    local contentArea = Instance.new("Frame"); contentArea.Size = UDim2.new(1, -180, 1, -60); contentArea.Position = UDim2.new(0, 170, 0, 50); contentArea.BackgroundTransparency = 1; contentArea.Parent = main
    local contentLayout = Instance.new("UIListLayout"); contentLayout.Padding = UDim.new(0, 10); contentLayout.Parent = contentArea

    local pages = {}
    local function switchPage(pageName)
        for name, frame in pairs(pages) do frame.Visible = (name == pageName) end
    end

    local function createSidebarBtn(name, icon, pageName)
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = C_Sidebar; btn.Text = ""; btn.AutoButtonColor = false; btn.Parent = sidebar
        local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, -10, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.Text = icon .. "   " .. name; label.TextColor3 = C_TextDim; label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = btn
        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = C_Sidebar
                    local l = b:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C_TextDim end
                end
            end
            btn.BackgroundColor3 = C_Card
            label.TextColor3 = C_Text
            switchPage(pageName)
        end)
        return btn
    end

    -- PAGE ESP
    local pageESP = Instance.new("ScrollingFrame"); pageESP.Size = UDim2.new(1, 0, 1, 0); pageESP.BackgroundTransparency = 1; pageESP.ScrollBarThickness = 2; pageESP.Visible = false; pageESP.Parent = contentArea; pages["ESP"] = pageESP
    local espLayout = Instance.new("UIListLayout"); espLayout.Padding = UDim.new(0, 10); espLayout.Parent = pageESP
    local secESP = createSection(pageESP, "ESP Players"); secESP.LayoutOrder = 1
    
    -- Toggle Survivor
    createToggle(pageESP, "ESP Survivor Only", false, function(s) 
        if s then setupESP("survivor") else if activeESP == "survivor" then setupESP(nil) end end 
    end).LayoutOrder = 2

    -- Toggle Killer
    createToggle(pageESP, "ESP Killer Only", false, function(s) 
        if s then setupESP("killer") else if activeESP == "killer" then setupESP(nil) end end 
    end).LayoutOrder = 3

    local secObjESP = createSection(pageESP, "ESP Objects"); secObjESP.LayoutOrder = 4
    createToggle(pageESP, "ESP Generator", false, function(s) if s then createObjectESP("gen", Color3.fromRGB(255,255,0)) end end).LayoutOrder = 5
    createToggle(pageESP, "ESP Exit / Door", false, function(s) if s then createObjectESP("exit", Color3.fromRGB(0,255,255)) end end).LayoutOrder = 6

    -- PAGE MAIN
    local pageMain = Instance.new("ScrollingFrame"); pageMain.Size = UDim2.new(1, 0, 1, 0); pageMain.BackgroundTransparency = 1; pageMain.ScrollBarThickness = 2; pageMain.Parent = contentArea; pages["Main"] = pageMain
    local mainLayout = Instance.new("UIListLayout"); mainLayout.Padding = UDim.new(0, 10); mainLayout.Parent = pageMain
    local secVis = createSection(pageMain, "Visuals"); secVis.LayoutOrder = 1
    createToggle(pageMain, "Fullbright (Anti Gelap)", false, function(s) if s then Fullbright() end end).LayoutOrder = 2
    createToggle(pageMain, "Flashlight", false, function(s) if s then Flashlight() end end).LayoutOrder = 3
    local secMove = createSection(pageMain, "Movement"); secMove.LayoutOrder = 4
    createToggle(pageMain, "Noclip", false, function(s) if s then Noclip() end end).LayoutOrder = 5
    createToggle(pageMain, "Speed 50", false, function(s) if s then SpeedHack(50) end end).LayoutOrder = 6
    createToggle(pageMain, "Fly [Tekan F]", false, function(s) if s then Fly() end end).LayoutOrder = 7
    local secCombat = createSection(pageMain, "Combat & Tools"); secCombat.LayoutOrder = 8
    createToggle(pageMain, "Auto Generator", false, function(s) isAutoGenEnabled = s end).LayoutOrder = 9

    -- PAGE PRO
    if tier == "pro" or tier == "owner" then
        local pagePro = Instance.new("ScrollingFrame"); pagePro.Size = UDim2.new(1, 0, 1, 0); pagePro.BackgroundTransparency = 1; pagePro.ScrollBarThickness = 2; pagePro.Visible = false; pagePro.Parent = contentArea; pages["Pro"] = pagePro
        local proLayout = Instance.new("UIListLayout"); proLayout.Padding = UDim.new(0, 10); proLayout.Parent = pagePro
        local secAim = createSection(pagePro, "Aimbot System"); secAim.LayoutOrder = 1
        createToggle(pagePro, "Enable Aimbot (Pistol)", false, function(s) isAimbotEnabled = s end).LayoutOrder = 2
        createToggle(pagePro, "Crosshair", false, function(s) isCrosshairEnabled = s end).LayoutOrder = 3
        createToggle(pagePro, "Auto Heal", false, function(s) if s then RunService.Heartbeat:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth end end) end end).LayoutOrder = 4
        createSidebarBtn("Pro Features", "⚔️", "Pro")
    end

    createSidebarBtn("Main Menu", "🏠", "Main")
    createSidebarBtn("ESP", "👁️", "ESP")
    
    switchPage("Main")
end

-- ==========================================
-- LOADING SPLASH & START
-- ==========================================
local function createSplash()
    local splash = Instance.new("ScreenGui"); splash.Name = "RizTeamSplash"; splash.ResetOnSpawn = false; splash.Parent = CoreGui
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = C_BG; bg.Parent = splash
    local logo = Instance.new("TextLabel"); logo.Size = UDim2.new(1,0,0,60); logo.Position = UDim2.new(0,0,0.4,0); logo.BackgroundTransparency = 1; logo.Text = "RIZTEAM HUB"; logo.TextColor3 = C_Text; logo.Font = Enum.Font.GothamBlack; logo.TextSize = 40; logo.Parent = bg
    local sub = Instance.new("TextLabel"); sub.Size = UDim2.new(1,0,0,30); sub.Position = UDim2.new(0,0,0.4,50); sub.BackgroundTransparency = 1; sub.Text = "Loading..."; sub.TextColor3 = C_TextDim; sub.Font = Enum.Font.Gotham; sub.TextSize = 16; sub.Parent = bg
    task.wait(2)
    splash:Destroy()
end

local function createKeyGUI()
    local gui = Instance.new("ScreenGui"); gui.Name = "RizTeamKeySystem"; gui.ResetOnSpawn = false; gui.Parent = CoreGui
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0,380,0,240); frame.Position = UDim2.new(0.5,-190,0.5,-120); frame.BackgroundColor3 = C_BG; frame.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,14); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = C_Border; stroke.Thickness = 2; stroke.Parent = frame
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1,0,0,38); title.BackgroundTransparency = 1; title.Text = "RIZTEAM AUTH"; title.TextColor3 = C_Text; title.Font = Enum.Font.GothamBlack; title.TextSize = 22; title.Parent = frame
    local input = Instance.new("TextBox"); input.Size = UDim2.new(1,-40,0,42); input.Position = UDim2.new(0,20,0,80); input.BackgroundColor3 = C_Card; input.TextColor3 = C_Text; input.PlaceholderText = "Masukkan Key..."; input.PlaceholderColor3 = C_TextDim; input.Font = Enum.Font.Gotham; input.TextSize = 14; input.Parent = frame
    local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0,8); ic.Parent = input
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,-40,0,42); btn.Position = UDim2.new(0,20,0,135); btn.BackgroundColor3 = C_Text; btn.TextColor3 = C_BG; btn.Text = "LOGIN"; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; btn.Parent = frame
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,8); bc.Parent = btn
    return gui, input, btn
end

createSplash()
local keyGui, keyInput, keyBtn = createKeyGUI()

keyBtn.MouseButton1Click:Connect(function()
    local tier = KEYS[keyInput.Text]
    if tier then
        keyBtn.Text = "SUCCESS"
        task.wait(1)
        keyGui:Destroy()
        openDashboard(tier)
    else
        keyBtn.Text = "INVALID KEY"
        keyBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
