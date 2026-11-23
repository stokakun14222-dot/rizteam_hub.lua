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
-- VARIABEL GLOBAL
-- ==========================================
local isAimbotEnabled = false
local isSilentAimEnabled = false
local isCrosshairEnabled = false

local KEYS = {
    ["RIZ-FREE-111"] = "free",
    ["RIZ-PRO-222"]  = "pro",
    ["RIZ-OWNER-999"] = "owner",
}

-- ==========================================
-- DRAG FUNCTION
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
    local splash = Instance.new("ScreenGui"); splash.Name = "RizTeamSplash"; splash.ResetOnSpawn = false; splash.Parent = CoreGui
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(5,5,10); bg.BorderSizePixel = 0; bg.Parent = splash
    local logo = Instance.new("TextLabel"); logo.Size = UDim2.new(1,0,0,60); logo.Position = UDim2.new(0,0,0.4,0); logo.BackgroundTransparency = 1; logo.Text = "RIZTEAM HUB"; logo.TextColor3 = Color3.fromRGB(0,255,100); logo.Font = Enum.Font.GothamBlack; logo.TextSize = 40; logo.TextTransparency = 1; logo.Parent = bg
    local sub = Instance.new("TextLabel"); sub.Size = UDim2.new(1,0,0,30); sub.Position = UDim2.new(0,0,0.4,50); sub.BackgroundTransparency = 1; sub.Text = "Loading Interface..."; sub.TextColor3 = Color3.fromRGB(200,200,200); sub.Font = Enum.Font.Gotham; sub.TextSize = 16; sub.TextTransparency = 1; sub.Parent = bg
    local barBg = Instance.new("Frame"); barBg.Size = UDim2.new(0,300,0,8); barBg.Position = UDim2.new(0.5,-150,0.5,80); barBg.BackgroundColor3 = Color3.fromRGB(30,30,40); barBg.BorderSizePixel = 0; barBg.Parent = bg
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1,0); bc.Parent = barBg
    local bar = Instance.new("Frame"); bar.Size = UDim2.new(0,0,1,0); bar.BackgroundColor3 = Color3.fromRGB(0,255,100); bar.BorderSizePixel = 0; bar.Parent = barBg
    local barc = Instance.new("UICorner"); barc.CornerRadius = UDim.new(1,0); barc.Parent = bar
    TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(sub, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(bar, TweenInfo.new(2), {Size = UDim2.new(1,0,1,0)}):Play()
    task.wait(2.5)
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    splash:Destroy()
end

-- ==========================================
-- KEY GUI
-- ==========================================
local function createKeyGUI()
    local gui = Instance.new("ScreenGui"); gui.Name = "RizTeamKeySystem"; gui.ResetOnSpawn = false; gui.Parent = CoreGui
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0,380,0,240); frame.Position = UDim2.new(0.5,-190,0.5,-120); frame.BackgroundColor3 = Color3.fromRGB(12,12,22); frame.BorderSizePixel = 0; frame.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,14); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(0,255,100); stroke.Thickness = 2; stroke.Parent = frame
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1,0,0,38); title.BackgroundTransparency = 1; title.Text = "RIZTEAM HUB"; title.TextColor3 = Color3.fromRGB(0,255,100); title.Font = Enum.Font.GothamBold; title.TextSize = 24; title.Parent = frame
    local sub = Instance.new("TextLabel"); sub.Size = UDim2.new(1,0,0,18); sub.Position = UDim2.new(0,0,0,36); sub.BackgroundTransparency = 1; sub.Text = "Violence District | by RizTeam"; sub.TextColor3 = Color3.fromRGB(140,140,160); sub.Font = Enum.Font.Gotham; sub.TextSize = 12; sub.Parent = frame
    local input = Instance.new("TextBox"); input.Size = UDim2.new(1,-40,0,42); input.Position = UDim2.new(0,20,0,75); input.BackgroundColor3 = Color3.fromRGB(22,22,38); input.TextColor3 = Color3.fromRGB(255,255,255); input.PlaceholderText = "Masukkan Key..."; input.PlaceholderColor3 = Color3.fromRGB(90,90,110); input.Font = Enum.Font.Gotham; input.TextSize = 14; input.ClearTextOnFocus = false; input.Parent = frame
    local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0,8); ic.Parent = input
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,-40,0,42); btn.Position = UDim2.new(0,20,0,130); btn.BackgroundColor3 = Color3.fromRGB(0,180,90); btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Text = "SUBMIT KEY"; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; btn.Parent = frame
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,8); bc.Parent = btn
    local footer = Instance.new("TextLabel"); footer.Size = UDim2.new(1,0,0,30); footer.Position = UDim2.new(0,0,1,-30); footer.BackgroundTransparency = 1; footer.Text = "Cheat Developer RizTeam © 2026"; footer.TextColor3 = Color3.fromRGB(100,100,120); footer.Font = Enum.Font.Gotham; footer.TextSize = 11; footer.Parent = frame
    return gui, input, btn, footer
end

-- ==========================================
-- FITUR ESP
-- ==========================================
local espFolder = Instance.new("Folder", CoreGui); espFolder.Name = "RizTeamESP"

local function createESP(player, type)
    local color = type == "survivor" and Color3.fromRGB(0, 255, 100) or type == "killer" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 0)
    local highlight = Instance.new("Highlight"); highlight.FillColor = color; highlight.OutlineColor = color; highlight.FillTransparency = 0.5; highlight.Parent = espFolder; highlight.Adornee = player.Character
    local billboard = Instance.new("BillboardGui"); billboard.Size = UDim2.new(0, 200, 0, 50); billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.AlwaysOnTop = true; billboard.Parent = espFolder; billboard.Adornee = player.Character:FindFirstChild("Head")
    local name = Instance.new("TextLabel"); name.Size = UDim2.new(1, 0, 0.5, 0); name.BackgroundTransparency = 1; name.Text = player.Name; name.TextColor3 = color; name.TextStrokeTransparency = 0; name.Font = Enum.Font.GothamBold; name.TextSize = 14; name.Parent = billboard
    RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        highlight.Adornee = player.Character; billboard.Adornee = player.Character:FindFirstChild("Head")
        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
        name.Text = player.Name .. " [" .. dist .. "m]"
    end)
end

local function setupPlayerESP(typeFilter)
    for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer then createESP(player, typeFilter) end end
    Players.PlayerAdded:Connect(function(player) if player ~= LocalPlayer then player.CharacterAdded:Wait(); task.wait(1); createESP(player, typeFilter) end end)
end

local function createObjectESP(name, color)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), string.lower(name)) then
            local highlight = Instance.new("Highlight"); highlight.FillColor = color; highlight.OutlineColor = color; highlight.FillTransparency = 0.5; highlight.Parent = espFolder; highlight.Adornee = obj
        end
    end
end

local function setupObjectESP(target)
    if target == "generator" then createObjectESP("gen", Color3.fromRGB(255, 255, 0)); createObjectESP("generator", Color3.fromRGB(255, 255, 0))
    elseif target == "exit" then createObjectESP("exit", Color3.fromRGB(0, 255, 255)); createObjectESP("door", Color3.fromRGB(0, 255, 255)) end
end

-- ==========================================
-- FITUR LAINNYA
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

local function AutoGenerator()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and (string.find(string.lower(obj.Parent.Name), "gen") or string.find(string.lower(obj.Parent.Name), "generator")) then
            obj.HoldDuration = 0; obj.Enabled = true
            spawn(function() while task.wait(0.1) do if obj:IsDescendantOf(Workspace) then pcall(function() fireproximityprompt(obj) end) end end end)
        end
    end
end

-- ==========================================
-- AIMBOT & CROSSHAIR (Support Android)
-- ==========================================
local function toggleAimbot(state) isAimbotEnabled = state end
local function toggleSilentAim(state) isSilentAimEnabled = state end
local function toggleCrosshair(state) isCrosshairEnabled = state end

-- Logika Loop Aimbot (Buat Android)
RunService.RenderStepped:Connect(function()
    if isAimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local closestDist = 500
        local targetHead = nil
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    targetHead = player.Character.Head
                end
            end
        end
        
        if targetHead then
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetHead.Position)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.3)
        end
    end
end)

-- Logika Silent Aim (Tembakan ngikutin musuh tanpa mindahin kamera)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if isSilentAimEnabled and (method == "Fire" or method == "InvokeServer" or method == "FireServer") then
        local args = {...}
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local closestDist = 500
            local targetHead = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
                    if dist < closestDist then closestDist = dist; targetHead = player.Character.Head end
                end
            end
            if targetHead then
                for i, v in pairs(args) do
                    if typeof(v) == "CFrame" then args[i] = CFrame.new(v.Position, targetHead.Position) end
                    if typeof(v) == "Vector3" then args[i] = targetHead.Position end
                end
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Crosshair GUI
local crosshairGui = Instance.new("ScreenGui"); crosshairGui.Name = "RizTeamCrosshair"; crosshairGui.ResetOnSpawn = false; crosshairGui.Parent = CoreGui
local crosshair = Instance.new("TextLabel"); crosshair.Size = UDim2.new(0, 20, 0, 20); crosshair.Position = UDim2.new(0.5, -10, 0.5, -10); crosshair.BackgroundTransparency = 1; crosshair.Text = "+"; crosshair.TextColor3 = Color3.fromRGB(0, 255, 100); crosshair.Font = Enum.Font.GothamBold; crosshair.TextSize = 24; crosshair.TextStrokeTransparency = 0; crosshair.Visible = false; crosshair.Parent = crosshairGui

RunService.RenderStepped:Connect(function()
    if crosshair then crosshair.Visible = isCrosshairEnabled end
end)

-- ==========================================
-- UI HORIZONTAL
-- ==========================================
local function openMainMenu(tier)
    local gui = Instance.new("ScreenGui"); gui.Name = "RizTeamMenu"; gui.ResetOnSpawn = false; gui.Parent = CoreGui
    
    local main = Instance.new("Frame"); main.Size = UDim2.new(0,500,0,300); main.Position = UDim2.new(0.5,-250,0.5,-150); main.BackgroundColor3 = Color3.fromRGB(12,12,22); main.BorderSizePixel = 0; main.Parent = gui
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0,10); mc.Parent = main
    local ms = Instance.new("UIStroke"); ms.Color = Color3.fromRGB(0,255,100); ms.Thickness = 2; ms.Parent = main
    makeDraggable(main, main)

    local sidebar = Instance.new("Frame"); sidebar.Size = UDim2.new(0,150,1,0); sidebar.BackgroundColor3 = Color3.fromRGB(18,18,30); sidebar.BorderSizePixel = 0; sidebar.Parent = main
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,10); sc.Parent = sidebar

    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1,0,0,50); title.BackgroundTransparency = 1; title.Text = "RIZTEAM"; title.TextColor3 = Color3.fromRGB(0,255,100); title.Font = Enum.Font.GothamBlack; title.TextSize = 20; title.Parent = sidebar

    local btnInfo = Instance.new("TextButton"); btnInfo.Size = UDim2.new(1,-20,0,35); btnInfo.Position = UDim2.new(0,10,0,60); btnInfo.BackgroundColor3 = Color3.fromRGB(0,180,90); btnInfo.TextColor3 = Color3.fromRGB(255,255,255); btnInfo.Text = "INFO"; btnInfo.Font = Enum.Font.GothamBold; btnInfo.TextSize = 12; btnInfo.Parent = sidebar
    local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0,6); ic.Parent = btnInfo

    local btnMain = Instance.new("TextButton"); btnMain.Size = UDim2.new(1,-20,0,35); btnMain.Position = UDim2.new(0,10,0,105); btnMain.BackgroundColor3 = Color3.fromRGB(22,22,38); btnMain.TextColor3 = Color3.fromRGB(255,255,255); btnMain.Text = "MAIN"; btnMain.Font = Enum.Font.GothamBold; btnMain.TextSize = 12; btnMain.Parent = sidebar
    local mc2 = Instance.new("UICorner"); mc2.CornerRadius = UDim.new(0,6); mc2.Parent = btnMain

    local content = Instance.new("Frame"); content.Size = UDim2.new(1,-150,1,0); content.Position = UDim2.new(0,150,0,0); content.BackgroundTransparency = 1; content.Parent = main

    -- PAGE INFO
    local pageInfo = Instance.new("Frame"); pageInfo.Size = UDim2.new(1,-20,1,-20); pageInfo.Position = UDim2.new(0,10,0,10); pageInfo.BackgroundTransparency = 1; pageInfo.Parent = content
    local ut = Instance.new("TextLabel"); ut.Size = UDim2.new(1,0,0,30); ut.BackgroundTransparency = 1; ut.Text = "AKUN ROBLOX KAMU"; ut.TextColor3 = Color3.fromRGB(0,255,100); ut.Font = Enum.Font.GothamBold; ut.TextSize = 14; ut.TextXAlignment = Enum.TextXAlignment.Left; ut.Parent = pageInfo
    local ud = Instance.new("TextLabel"); ud.Size = UDim2.new(1,0,0,100); ud.Position = UDim2.new(0,0,0,40); ud.BackgroundTransparency = 1; ud.Text = "Nama: " .. LocalPlayer.Name .. "\nRole: " .. string.upper(tier) .. "\nGame: Violence District\nStatus: Terhubung"; ud.TextColor3 = Color3.fromRGB(200,200,200); ud.Font = Enum.Font.Gotham; ud.TextSize = 13; ud.TextXAlignment = Enum.TextXAlignment.Left; ud.Parent = pageInfo

    -- PAGE MAIN
    local pageMain = Instance.new("Frame"); pageMain.Size = UDim2.new(1,-20,1,-20); pageMain.Position = UDim2.new(0,10,0,10); pageMain.BackgroundTransparency = 1; pageMain.Visible = false; pageMain.Parent = content
    local scroll = Instance.new("ScrollingFrame"); scroll.Size = UDim2.new(1,0,1,0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = pageMain
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0,5); layout.Parent = scroll

    btnInfo.MouseButton1Click:Connect(function() pageInfo.Visible = true; pageMain.Visible = false; btnInfo.BackgroundColor3 = Color3.fromRGB(0,180,90); btnMain.BackgroundColor3 = Color3.fromRGB(22,22,38) end)
    btnMain.MouseButton1Click:Connect(function() pageInfo.Visible = false; pageMain.Visible = true; btnInfo.BackgroundColor3 = Color3.fromRGB(22,22,38); btnMain.BackgroundColor3 = Color3.fromRGB(0,180,90) end)

    local function addToggle(name, callback, isPro, stateCallback)
        if isPro and tier ~= "pro" and tier ~= "owner" then return end
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,-10,0,32); btn.BackgroundColor3 = Color3.fromRGB(22,22,38); btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.Gotham; btn.TextSize = 12; btn.Text = " " .. name; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.AutoButtonColor = false; btn.Parent = scroll
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
        local toggle = false
        btn.MouseButton1Click:Connect(function()
            toggle = not toggle
            btn.BackgroundColor3 = toggle and Color3.fromRGB(0,140,70) or Color3.fromRGB(22,22,38)
            if stateCallback then stateCallback(toggle) end
            if toggle and callback then pcall(callback) end
        end)
    end

    addToggle("Fullbright (Anti Gelap)", Fullbright, false)
    addToggle("ESP Survivor", function() setupPlayerESP("survivor") end, false)
    addToggle("ESP Killer", function() setupPlayerESP("killer") end, false)
    addToggle("ESP Generator", function() setupObjectESP("generator") end, false)
    addToggle("ESP Exit/Door", function() setupObjectESP("exit") end, false)
    addToggle("Noclip", Noclip, false)
    addToggle("Fly [Tekan F]", Fly, false)
    addToggle("Speed 50", function() SpeedHack(50) end, false)
    addToggle("Flashlight", Flashlight, false)
    addToggle("Crosshair", nil, false, toggleCrosshair)
    addToggle("Aimbot Android [PRO]", nil, true, toggleAimbot)
    addToggle("Silent Aim [PRO]", nil, true, toggleSilentAim)
    addToggle("Auto Generator [PRO]", AutoGenerator, true)
    addToggle("Auto Parry [PRO]", function() --[[ fungsi ]] end, true)
    addToggle("Auto Heal [PRO]", function() RunService.Heartbeat:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth end end) end, true)

    local hideBtn = Instance.new("TextButton"); hideBtn.Size = UDim2.new(0,50,0,24); hideBtn.Position = UDim2.new(1,-115,0,8); hideBtn.BackgroundColor3 = Color3.fromRGB(200,150,0); hideBtn.TextColor3 = Color3.fromRGB(255,255,255); hideBtn.Text = "HIDE"; hideBtn.Font = Enum.Font.GothamBold; hideBtn.TextSize = 12; hideBtn.Parent = main
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = hideBtn

    local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.new(0,50,0,24); closeBtn.Position = UDim2.new(1,-60,0,8); closeBtn.BackgroundColor3 = Color3.fromRGB(180,30,30); closeBtn.TextColor3 = Color3.fromRGB(255,255,255); closeBtn.Text = "X"; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12; closeBtn.Parent = main
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0,6); cc.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    local floatBtn = Instance.new("TextButton"); floatBtn.Size = UDim2.new(0,45,0,45); floatBtn.Position = UDim2.new(0,20,0.5,-22); floatBtn.BackgroundColor3 = Color3.fromRGB(0,180,90); floatBtn.TextColor3 = Color3.fromRGB(255,255,255); floatBtn.Text = "R"; floatBtn.Font = Enum.Font.GothamBlack; floatBtn.TextSize = 20; floatBtn.Visible = false; floatBtn.Parent = gui
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = floatBtn
    local fs = Instance.new("UIStroke"); fs.Color = Color3.fromRGB(0,255,100); fs.Thickness = 2; fs.Parent = floatBtn

    hideBtn.MouseButton1Click:Connect(function() main.Visible = false; floatBtn.Visible = true end)
    floatBtn.MouseButton1Click:Connect(function() main.Visible = true; floatBtn.Visible = false end)
end

-- ==========================================
-- MAIN
-- ==========================================
createSplash()
local gui, input, btn, footer = createKeyGUI()

btn.MouseButton1Click:Connect(function()
    local key = input.Text
    local tier = KEYS[key]
    if tier then
        footer.Text = "Key valid (" .. tier .. ") - Loading..."
        footer.TextColor3 = Color3.fromRGB(0,255,100)
        task.wait(1)
        gui:Destroy()
        openMainMenu(tier)
    else
        footer.Text = "Key tidak valid!"
        footer.TextColor3 = Color3.fromRGB(255,100,100)
    end
end)
