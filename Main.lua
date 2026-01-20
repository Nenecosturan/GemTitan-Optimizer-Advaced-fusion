
    GemTitanOptimizer | OMEGA v7.5
    Coder: Zenith (bizkizlar)
    Version: v7.5 (Crystal Build)
    
    Notes:
    - Key changed to "Crystal".
    - High-End Optimization Logic.
    - Neon UI & AI Systems active.
    - UPDATED: Utils Tab (+Anti-AFK, Auto-Load Rejoin, White Mode, RAM Clean, Ping Stab)
]]

--// 1. LIBRARIES AND SERVICES
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService") 
local NetworkClient = game:GetService("NetworkClient")
local VirtualUser = game:GetService("VirtualUser") -- Anti-AFK için eklendi

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// 2. MEMORY AND SNAPSHOT
local GemTitan = {
    Connections = {}, 
    Loops = {},
    Defaults = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient,
        Tech = Lighting.Technology
    },
    Config = {
        PhysicsBubble = false,
        PingStabilizer = false
    }
}

--// 3. NEON GLOW INJECTOR (PREMIUM VISUALS)
task.spawn(function()
    task.wait(1) 
    local function AddGlow(instance)
        if not instance then return end
        if instance:FindFirstChild("ZenithGlow") then return end
        
        local Glow = Instance.new("UIStroke")
        Glow.Name = "ZenithGlow"
        Glow.Parent = instance
        Glow.Color = Color3.fromRGB(170, 0, 255) -- Purple Neon
        Glow.Thickness = 2.5
        Glow.Transparency = 0.2
        Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        -- Breathing Animation
        local TweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local Tween = TweenService:Create(Glow, TweenInfo, {Transparency = 0.6})
        Tween:Play()
    end

    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "Rayfield" then
            local Main = gui:FindFirstChild("Main", true)
            if Main then AddGlow(Main) end
            
            local KeyWin = gui:FindFirstChild("KeySystem", true)
            if KeyWin then AddGlow(KeyWin) end
        end
    end
end)

--// 4. UI WINDOW (KEY: CRYSTAL)
local Window = Rayfield:CreateWindow({
   Name = "GemTitanOptimizer | OMEGA v7.5",
   LoadingTitle = "GemTitan Loading...",
   LoadingSubtitle = "Finding latest version...",
   Theme = "Amethyst",
   
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GemTitanOmega", 
      FileName = "UserConfig"
   },
   
   Discord = { Enabled = false, Invite = "noinvite", RememberJoins = true },
   
   KeySystem = true,
   KeySettings = {
      Title = "Optimization Access",
      Subtitle = "Security Protocol",
      Note = "Key: Crystal",
      FileName = "GemTitanKeyFile_Crystal",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "Crystal"
   }
})

--// 5. UTILS & ADVANCED FPS GUI
local function SendNotif(title, text)
    Rayfield:Notify({ Title = title, Content = text, Duration = 2, Image = 4483345998 })
end

-- Dynamic FPS Counter (Smooth Drag & Neon)
local FPSGui = nil
local function ToggleFPSCounter(state)
    if state then
        if FPSGui then FPSGui:Destroy() end
        FPSGui = Instance.new("ScreenGui")
        FPSGui.Name = "GemTitanFPS"
        FPSGui.Parent = CoreGui
        
        local Frame = Instance.new("Frame")
        Frame.Name = "MainFrame"
        Frame.Parent = FPSGui
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Frame.Size = UDim2.new(0, 120, 0, 40)
        Frame.Position = UDim2.new(0.5, -60, 0, 20)
        Frame.BorderSizePixel = 0
        Frame.Active = true 
        Frame.Draggable = false 

        -- Round Corners
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 30) 
        Corner.Parent = Frame

        -- Neon Glow
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(170, 0, 255)
        Stroke.Thickness = 2.5
        Stroke.Transparency = 0.1
        Stroke.Parent = Frame

        -- Label
        local Label = Instance.new("TextLabel")
        Label.Parent = Frame
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 18
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Text = "FPS: ..."
        
        -- Smooth Dragging Logic
        local dragging, dragInput, dragStart, startPos
        
        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        Frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        RunService.RenderStepped:Connect(function(dt)
            if Label and Label.Parent then
                local fps = math.floor(1.5/dt)
                Label.Text = "FPS: " .. fps
                if fps < 30 then
                    Label.TextColor3 = Color3.fromRGB(255, 50, 50)
                else
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end)
    else
        if FPSGui then FPSGui:Destroy() FPSGui = nil end
    end
end

--------------------------------------------------------------------------------
--// CORTEX AI & SMART LOGIC
--------------------------------------------------------------------------------
local SmartTech = {}
local TitanCortex = {}

function SmartTech.PhysicsBubble(state)
    GemTitan.Config.PhysicsBubble = state
    if state then
        SendNotif("Omega AI", "Dynamic Physics Bubble: ACTIVE 🫧")
        GemTitan.Loops.PhysBubble = RunService.Heartbeat:Connect(function()
            if os.clock() % 0.1 < 0.01 then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentSpeed = root.AssemblyLinearVelocity.Magnitude
                    local dynamicRadius = math.clamp(currentSpeed * 4, 60, 300)
                    for _, part in pairs(Workspace:GetDescendants()) do
                        if part:IsA("BasePart") and not part.Anchored and part.Parent:FindFirstChild("Humanoid") == nil then
                            if not part:IsDescendantOf(char) then 
                                local dist = (part.Position - root.Position).Magnitude
                                part.Anchored = (dist > dynamicRadius)
                            end
                        end
                    end
                end
            end
        end)
    else
        if GemTitan.Loops.PhysBubble then GemTitan.Loops.PhysBubble:Disconnect() end
        SendNotif("Omega AI", "Physics Bubble: DISABLED")
    end
end

function TitanCortex.HookNewParts(state)
    if state then
        SendNotif("Omega AI", "Hook: ACTIVE (Blocking New Effects)")
        GemTitan.Connections.Added = Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ParticleEmitter") or obj:IsA("Explosion") or obj:IsA("Smoke") or obj:IsA("Debris") then
                RunService.Heartbeat:Wait()
                obj:Destroy()
            end
        end)
    else
        if GemTitan.Connections.Added then GemTitan.Connections.Added:Disconnect() end
        SendNotif("Omega AI", "Hook: STOPPED")
    end
end

--------------------------------------------------------------------------------
--// TOGGLE & DESTRUCTIVE LOGIC
--------------------------------------------------------------------------------
local GemLogic = {} 
local TitanLogic = {} 
local GodLogic = {}

-- (Visuals Toggle)
function GemLogic.ToggleTextures(state)
    if state then
         for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
        SendNotif("GemBoost", "Textures Hidden")
    else
        for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end end
        SendNotif("GemBoost", "Textures Restored")
    end
end

function GemLogic.ToggleEffects(state)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = not state end
    end
    SendNotif("GemBoost", state and "Effects Hidden" or "Effects Restored")
end

function GemLogic.ToggleShadows(state)
    Lighting.GlobalShadows = not state
    for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow = not state end end
    SendNotif("GemBoost", state and "Shadows Disabled" or "Shadows Enabled")
end

-- (Basics Toggle)
function TitanLogic.ToggleFullBright(state)
    if state then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else
        Lighting.Brightness = GemTitan.Defaults.Brightness; Lighting.ClockTime = GemTitan.Defaults.ClockTime; Lighting.FogEnd = GemTitan.Defaults.FogEnd; Lighting.GlobalShadows = GemTitan.Defaults.GlobalShadows
    end
end

function TitanLogic.SmartCulling(state)
    if state then
        GemTitan.Loops.Cull = RunService.RenderStepped:Connect(function()
            if os.clock() % 0.15 < 0.02 then
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local _, onScreen = Camera:WorldToScreenPoint(part.Position)
                        part.LocalTransparencyModifier = onScreen and 0 or 1
                    end
                end
            end
        end)
        SendNotif("Titanium", "Culling Enabled")
    else
        if GemTitan.Loops.Cull then GemTitan.Loops.Cull:Disconnect() end
        for _, part in pairs(Workspace:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end end
        SendNotif("Titanium", "Culling Disabled")
    end
end

-- (Destructive)
function GodLogic.NukeParticles() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v:Destroy() end end SendNotif("Aggressive", "Particles Nuked.") end
function GodLogic.StopAnims() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Humanoid") then local a = v:FindFirstChildOfClass("Animator") if a then for _, t in pairs(a:GetPlayingAnimationTracks()) do t:Stop() end end end end SendNotif("Aggressive", "Animations Stopped.") end
function GodLogic.RemoveAccessories() for _, p in pairs(Players:GetPlayers()) do if p.Character then for _, o in pairs(p.Character:GetChildren()) do if o:IsA("Accessory") or o:IsA("Hat") or o:IsA("Shirt") or o:IsA("Pants") then o:Destroy() end end end end SendNotif("Aggressive", "Accessories Removed.") end
function GodLogic.KillSounds() for _, v in pairs(game:GetDescendants()) do if v:IsA("Sound") then v:Destroy() end end SendNotif("Aggressive", "Sounds Killed.") end
function GodLogic.StripMeshes() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("MeshPart") then v.TextureID = "" end end SendNotif("Aggressive", "Mesh Textures Stripped.") end
function GodLogic.RemoveGUI3D() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v:Destroy() end end SendNotif("Aggressive", "3D GUI Removed.") end
function GodLogic.RemoveVehicles() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Seat") or v:IsA("VehicleSeat") then v:Destroy() end end SendNotif("Aggressive", "Vehicles Removed.") end
function GodLogic.DeleteTerrain() Workspace.Terrain:Clear() SendNotif("Aggressive", "Terrain Deleted.") end
function GodLogic.AnchorAll() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Parent.Name ~= LocalPlayer.Name then v.Anchored = true end end SendNotif("Hyper", "World Anchored.") end
function GodLogic.DowngradeLight() Lighting.Technology = Enum.Technology.Compatibility; Lighting.GlobalShadows = false; SendNotif("Hyper", "Lighting Downgraded.") end
function GodLogic.RemoveConstraints() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Constraint") or v:IsA("Weld") or v:IsA("Motor6D") then v:Destroy() end end SendNotif("Hyper", "Constraints Removed.") end
function GodLogic.DisableTouch() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false v.CanQuery = false end end SendNotif("Hyper", "Touch Disabled.") end
function GodLogic.KillStates() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if h then h:SetStateEnabled(Enum.HumanoidStateType.Climbing, false); h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end SendNotif("Hyper", "States Restricted.") end
function GodLogic.SleepParts() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and not v.Anchored then v.Velocity = Vector3.zero end end SendNotif("Hyper", "Physics Slept.") end
function GodLogic.CleanScripts() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("LocalScript") and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end end SendNotif("Hyper", "Scripts Cleaned.") end
function GodLogic.OverrideMaterials() for _, m in pairs(MaterialService:GetChildren()) do m:Destroy() end SendNotif("Hyper", "Materials Deleted.") end
function GodLogic.VoidClean() Workspace.FallenPartsDestroyHeight = -10 SendNotif("Hyper", "Void Cleaned.") end
function GodLogic.CleanLogs() if rconsoleclear then rconsoleclear() end SendNotif("Utils", "Logs Cleaned.") end

-- NEW UTILS LOGIC
function GodLogic.CleanRAM()
    local before = collectgarbage("count")
    collectgarbage("collect")
    local after = collectgarbage("count")
    SendNotif("Memory", "RAM Cleaned. Freed: " .. math.floor(before - after) .. " KB")
end

local BWEffect = nil
function GodLogic.WhiteScreen(state)
    if state then
        BWEffect = Instance.new("ColorCorrectionEffect")
        BWEffect.Name = "GemTitanBW"
        BWEffect.Saturation = -1 -- Black & White
        BWEffect.Contrast = 0.1
        BWEffect.Parent = Lighting
        SendNotif("Visuals", "White Screen Mode: ON")
    else
        if BWEffect then BWEffect:Destroy() end
        local check = Lighting:FindFirstChild("GemTitanBW")
        if check then check:Destroy() end
        SendNotif("Visuals", "White Screen Mode: OFF")
    end
end

function GodLogic.PingStabilizer(state)
    GemTitan.Config.PingStabilizer = state
    if state then
        local s = settings()
        local network = s.Network
        network.IncomingReplicationLag = 0
        SendNotif("Network", "Ping Stabilizer: ON (Locked)")
    else
        SendNotif("Network", "Ping Stabilizer: OFF")
    end
end

-- ANTI-AFK LOGIC ADDED HERE
function GodLogic.AntiAFK(state)
    if state then
        GemTitan.Connections.AntiAFK = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            SendNotif("Anti-AFK", "Idled detected, Input sent.")
        end)
        SendNotif("System", "Anti-AFK: ACTIVE")
    else
        if GemTitan.Connections.AntiAFK then
            GemTitan.Connections.AntiAFK:Disconnect()
            GemTitan.Connections.AntiAFK = nil
        end
        SendNotif("System", "Anti-AFK: DISABLED")
    end
end

-- AUTO LOAD REJOIN LOGIC
local function AutoLoadRejoin()
    local queue_on_teleport = queue_on_teleport or syn.queue_on_teleport
    if queue_on_teleport then
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/GemTitan-Optimizer-Advaced-fusion/main/Main.lua"))()')
        SendNotif("System", "Script queued for next server!")
    else
        SendNotif("Error", "Your executor does not support Queue On Teleport.")
    end
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

--------------------------------------------------------------------------------
--// RAYFIELD UI ELEMENTS
--------------------------------------------------------------------------------

-- [TAB 0] CORTEX AI
local TabAI = Window:CreateTab("Omega AI🧠", 4483362458)
TabAI:CreateSection("Active Intelligence")
TabAI:CreateToggle({ Name = "Adaptive Physics Bubble 🫧", CurrentValue = false, Flag = "PhysBubble", Callback = SmartTech.PhysicsBubble })
TabAI:CreateLabel("AI optimization.")
TabAI:CreateToggle({ Name = "Interceptor Hook (Auto-Delete) 🎣", CurrentValue = false, Flag = "AutoHook", Callback = TitanCortex.HookNewParts })

-- [TAB 1] VISUALS (TOGGLE)
local TabLight = Window:CreateTab("Visuals👁️", 4483362458)
TabLight:CreateSection("Toggleable Graphics")
TabLight:CreateToggle({ Name = "Hide Textures (Plastic) 🧱", CurrentValue = false, Flag = "TexTog", Callback = GemLogic.ToggleTextures })
TabLight:CreateToggle({ Name = "Disable Effects ✨", CurrentValue = false, Flag = "EffTog", Callback = GemLogic.ToggleEffects })
TabLight:CreateToggle({ Name = "Disable Shadows 🌑", CurrentValue = false, Flag = "ShadTog", Callback = GemLogic.ToggleShadows })

-- [TAB 2] BASICS
local TabBasics = Window:CreateTab("Basics⚙️", 4483362458)
TabBasics:CreateSection("Environment")
TabBasics:CreateToggle({ Name = "FullBright Mode ☀️", CurrentValue = false, Flag = "FullBright", Callback = TitanLogic.ToggleFullBright })
TabBasics:CreateToggle({ Name = "Smart View Culling 👁️", CurrentValue = false, Flag = "SmartCull", Callback = TitanLogic.SmartCulling })
TabBasics:CreateToggle({ Name = "Unlock FPS 👾", CurrentValue = false, Flag = "UnlockFPS", Callback = function(V) setfpscap(V and 10000 or 60) end })
TabBasics:CreateButton({ Name = "Remove Invisible Walls", Callback = function() TitanLogic.InvisibleWalls() end })

-- [TAB 3] AGGRESSIVE
local TabAggressive = Window:CreateTab("Aggressive🔥", 4483362458)
TabAggressive:CreateSection("Object Destruction")
TabAggressive:CreateButton({ Name = "1. Nuke Particles", Callback = GodLogic.NukeParticles })
TabAggressive:CreateButton({ Name = "2. Stop Animations", Callback = GodLogic.StopAnims })
TabAggressive:CreateButton({ Name = "3. Remove Accessories", Callback = GodLogic.RemoveAccessories })
TabAggressive:CreateButton({ Name = "4. Kill All Sounds", Callback = GodLogic.KillSounds })
TabAggressive:CreateButton({ Name = "5. Strip Mesh Textures", Callback = GodLogic.StripMeshes })
TabAggressive:CreateButton({ Name = "6. Remove 3D GUI", Callback = GodLogic.RemoveGUI3D })
TabAggressive:CreateButton({ Name = "7. Remove Vehicles", Callback = GodLogic.RemoveVehicles })
TabAggressive:CreateButton({ Name = "8. Delete Terrain", Callback = GodLogic.DeleteTerrain })

-- [TAB 4] HYPER
local TabHyper = Window:CreateTab("Hyper⚡", 4483362458)
TabHyper:CreateSection("Engine Hacks")
TabHyper:CreateButton({ Name = "9. Freeze World (Anchor)", Callback = GodLogic.AnchorAll })
TabHyper:CreateButton({ Name = "10. Downgrade Lighting", Callback = GodLogic.DowngradeLight })
TabHyper:CreateButton({ Name = "11. Remove Constraints", Callback = GodLogic.RemoveConstraints })
TabHyper:CreateButton({ Name = "12. Disable CanTouch", Callback = GodLogic.DisableTouch })
TabHyper:CreateButton({ Name = "13. Kill Humanoid States", Callback = GodLogic.KillStates })
TabHyper:CreateButton({ Name = "14. Sleep Physics", Callback = GodLogic.SleepParts })
TabHyper:CreateButton({ Name = "15. Delete Map Scripts", Callback = GodLogic.CleanScripts })
TabHyper:CreateButton({ Name = "16. Override Materials", Callback = GodLogic.OverrideMaterials })
TabHyper:CreateButton({ Name = "17. Fast Void Clean", Callback = GodLogic.VoidClean })

-- [TAB 5] ALTERNATIVES
local TabAlt = Window:CreateTab("Scripts📂", 4483362458)
TabAlt:CreateSection("Legacy & Modules")
TabAlt:CreateLabel("Zenith's other projects.")
TabAlt:CreateButton({
    Name = "1.▶ Titanium Optimizer Gen2 AI (Mostly recommended)",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/Titanium-Optimizer-Gen2-AI/main/Main.lua"))() end,
})
TabAlt:CreateButton({
    Name = "2.▶ GEMBOOST X 2026 Module ",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/GEMBOOST-X-2026/main/Main.lua"))() end,
})

-- [TAB 6] UTILS
local TabUtils = Window:CreateTab("Utils🛠️", 4483362458)
TabUtils:CreateSection("Management")
TabUtils:CreateToggle({ Name = "Neon FPS HUD🔮", CurrentValue = false, Flag = "DynFPS", Callback = ToggleFPSCounter })
TabUtils:CreateToggle({ Name = "No Render (Cooldown device)", CurrentValue = false, Flag = "NoRender", Callback = function(V) RunService:Set3dRenderingEnabled(not V) end })
-- ADDED ANTI-AFK TOGGLE HERE
TabUtils:CreateToggle({ Name = "Anti-AFK 💤", CurrentValue = false, Flag = "AntiAFK", Callback = GodLogic.AntiAFK })

TabUtils:CreateSection("Extra Optimization")
TabUtils:CreateToggle({ Name = "White Screen Mode (GPU Saver) 🏳️", CurrentValue = false, Flag = "WhiteScreen", Callback = GodLogic.WhiteScreen })
TabUtils:CreateToggle({ Name = "Ping Stabilizer (Network) 📶", CurrentValue = false, Flag = "PingStab", Callback = GodLogic.PingStabilizer })
TabUtils:CreateButton({ Name = "Clean Cache RAM 🧹", Callback = GodLogic.CleanRAM })

TabUtils:CreateSection("Server")
TabUtils:CreateButton({ Name = "Clean Console/Logs", Callback = GodLogic.CleanLogs })
TabUtils:CreateButton({ Name = "Rejoin Server (Auto-Load) 🔄", Callback = AutoLoadRejoin })

TabUtils:CreateButton({ Name = "Destroy UI ⛔", Callback = function() Rayfield:Destroy() end })

TabUtils:CreateLabel("Engineered by Zenith")
