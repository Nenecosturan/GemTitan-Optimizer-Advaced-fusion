--[[
    GemTitanOptimizer: Ultimate Crystal
    Kodlayan: Zenith (bizkizlar)
    Sürüm: 6.0
    
    ÖZELLİKLER:
    - Secure Key: "Fusionof26"
    - Cortex AI & Physics Bubble
    - Alternatives Tab (Legacy Scripts)
    - Dynamic FPS Counter & Config System
]]

--// 1. KÜTÜPHANE VE SERVİSLER
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// 2. BELLEK VE SNAPSHOT
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
        PhysicsBubble = false
    }
}

--// 3. UI PENCERESİ (CONFIG KAYDETME AKTİF)
local Window = Rayfield:CreateWindow({
   Name = "•GemTitanOptimizer•|•Ultimate Crystal v6.0• 🔮",
   LoadingTitle = "GemTitan is Loading...",
   LoadingSubtitle = "Finding the katest version for user...",
   Theme = "Amethyst",
   
   -- CONFIG SİSTEMİ (Auto-Load Mantığı Burada)
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
      Note = "get key by adding and messaging gojonunyaragi on discord",
      FileName = "GemTitanKeyFile",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "Crystal"
   }
})

--// 4. YARDIMCI FONKSİYONLAR & FPS GUI
local function SendNotif(title, text)
    Rayfield:Notify({ Title = title, Content = text, Duration = 2, Image = 4483345998 })
end

-- Dinamik FPS Sayacı (ScreenGui)
local FPSGui = nil
local function ToggleFPSCounter(state)
    if state then
        if FPSGui then FPSGui:Destroy() end
        FPSGui = Instance.new("ScreenGui")
        FPSGui.Name = "FPS monitor"
        FPSGui.Parent = CoreGui -- UI'ın üstünde dursun
        
        local Label = Instance.new("TextLabel")
        Label.Parent = FPSGui
        Label.Size = UDim2.new(0, 100, 0, 30)
        Label.Position = UDim2.new(0.5, -50, 0, 10) -- Üst Orta
        Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Label.TextColor3 = Color3.fromRGB(170, 0, 255) -- Mor
        Label.BackgroundTransparency = 0.3
        Label.BorderSizePixel = 0
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 18
        Label.Text = "FPS: .."
        
        -- Sürükleme Özelliği
        local dragging, dragInput, dragStart, startPos
        Label.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Label.Position
            end
        end)
        Label.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Label.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        Label.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)

        -- FPS Güncelleme
        RunService.RenderStepped:Connect(function(dt)
            if Label and Label.Parent then
                Label.Text = "FPS: " .. math.floor(1/dt)
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
        SendNotif("Cortex AI", "Dinamik Fizik Balonu: AKTİF 🫧")
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
        SendNotif("Cortex AI", "Fizik Balonu: KAPALI")
    end
end

function TitanCortex.HookNewParts(state)
    if state then
        SendNotif("Cortex AI", "Hook: AKTİF (Yeni Efektler Silinecek)")
        GemTitan.Connections.Added = Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ParticleEmitter") or obj:IsA("Explosion") or obj:IsA("Smoke") or obj:IsA("Debris") then
                RunService.Heartbeat:Wait()
                obj:Destroy()
            end
        end)
    else
        if GemTitan.Connections.Added then GemTitan.Connections.Added:Disconnect() end
        SendNotif("Cortex AI", "Hook: DURDURULDU")
    end
end

--------------------------------------------------------------------------------
--// TOGGLE & DESTRUCTIVE LOGIC (KISA ÖZET)
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
        SendNotif("GemBoost", "Dokular Gizlendi")
    else
        for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end end
        SendNotif("GemBoost", "Dokular Geri Geldi")
    end
end

function GemLogic.ToggleEffects(state)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = not state end
    end
    SendNotif("GemBoost", state and "Efektler Gizlendi" or "Efektler Geri Geldi")
end

function GemLogic.ToggleShadows(state)
    Lighting.GlobalShadows = not state
    for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow = not state end end
    SendNotif("GemBoost", state and "Gölgeler Kapandı" or "Gölgeler Açıldı")
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
        SendNotif("Titanium", "Gizleme Açık")
    else
        if GemTitan.Loops.Cull then GemTitan.Loops.Cull:Disconnect() end
        for _, part in pairs(Workspace:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end end
        SendNotif("Titanium", "Gizleme Kapalı")
    end
end

-- (Destructive Functions)
function GodLogic.NukeParticles() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v:Destroy() end end SendNotif("Aggressive", "Partiküller Silindi.") end
function GodLogic.StopAnims() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Humanoid") then local a = v:FindFirstChildOfClass("Animator") if a then for _, t in pairs(a:GetPlayingAnimationTracks()) do t:Stop() end end end end SendNotif("Aggressive", "Animasyonlar Durdu.") end
function GodLogic.RemoveAccessories() for _, p in pairs(Players:GetPlayers()) do if p.Character then for _, o in pairs(p.Character:GetChildren()) do if o:IsA("Accessory") or o:IsA("Hat") or o:IsA("Shirt") or o:IsA("Pants") then o:Destroy() end end end end SendNotif("Aggressive", "Aksesuarlar Silindi.") end
function GodLogic.KillSounds() for _, v in pairs(game:GetDescendants()) do if v:IsA("Sound") then v:Destroy() end end SendNotif("Aggressive", "Sesler Silindi.") end
function GodLogic.StripMeshes() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("MeshPart") then v.TextureID = "" end end SendNotif("Aggressive", "Mesh Dokuları Silindi.") end
function GodLogic.RemoveGUI3D() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v:Destroy() end end SendNotif("Aggressive", "3D GUI Silindi.") end
function GodLogic.RemoveVehicles() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Seat") or v:IsA("VehicleSeat") then v:Destroy() end end SendNotif("Aggressive", "Araçlar Silindi.") end
function GodLogic.DeleteTerrain() Workspace.Terrain:Clear() SendNotif("Aggressive", "Arazi Silindi.") end
function GodLogic.AnchorAll() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Parent.Name ~= LocalPlayer.Name then v.Anchored = true end end SendNotif("Hyper", "Sabitlendi.") end
function GodLogic.DowngradeLight() Lighting.Technology = Enum.Technology.Compatibility; Lighting.GlobalShadows = false; SendNotif("Hyper", "Işık Düşürüldü.") end
function GodLogic.RemoveConstraints() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Constraint") or v:IsA("Weld") or v:IsA("Motor6D") then v:Destroy() end end SendNotif("Hyper", "Constraint Silindi.") end
function GodLogic.DisableTouch() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false v.CanQuery = false end end SendNotif("Hyper", "Touch Kapandı.") end
function GodLogic.KillStates() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if h then h:SetStateEnabled(Enum.HumanoidStateType.Climbing, false); h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end SendNotif("Hyper", "Durumlar Kısıtlandı.") end
function GodLogic.SleepParts() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and not v.Anchored then v.Velocity = Vector3.zero end end SendNotif("Hyper", "Fizik Uyutuldu.") end
function GodLogic.CleanScripts() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("LocalScript") and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end end SendNotif("Hyper", "Scriptler Temizlendi.") end
function GodLogic.OverrideMaterials() for _, m in pairs(MaterialService:GetChildren()) do m:Destroy() end SendNotif("Hyper", "Materyaller Silindi.") end
function GodLogic.VoidClean() Workspace.FallenPartsDestroyHeight = -10 SendNotif("Hyper", "Void Temizliği.") end
function GodLogic.CleanLogs() if rconsoleclear then rconsoleclear() end SendNotif("Utils", "Loglar Temizlendi.") end

--------------------------------------------------------------------------------
--// RAYFIELD UI ELEMENTLERİ
--------------------------------------------------------------------------------

-- [TAB 0] CORTEX AI
local TabAI = Window:CreateTab("Cortex AI🧠", 4483362458)
TabAI:CreateSection("Active Intelligence")
TabAI:CreateToggle({ Name = "Adaptive Physics Bubble 🫧", CurrentValue = false, Flag = "PhysBubble", Callback = SmartTech.PhysicsBubble })
TabAI:CreateLabel("Hızlandıkça balon genişler, durunca küçülür.")
TabAI:CreateToggle({ Name = "Interceptor Hook (Auto-Delete) 🎣", CurrentValue = false, Flag = "AutoHook", Callback = TitanCortex.HookNewParts })

-- [TAB 1] VISUALS (TOGGLE)
local TabLight = Window:CreateTab("Visuals👁️", 4483362458)
TabLight:CreateSection("Toggleable Graphics")
TabLight:CreateToggle({ Name = "Hide Textures (Plastik) 🧱", CurrentValue = false, Flag = "TexTog", Callback = GemLogic.ToggleTextures })
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

-- [TAB 5] ALTERNATIVES (YENİ TAB)
local TabAlt = Window:CreateTab("Scripts📂", 4483362458)
TabAlt:CreateSection("Legacy & Modules")
TabAlt:CreateLabel("Zenith'in diğer projeleri.")

TabAlt:CreateButton({
    Name = "▶ Titanium Optimizer Gen2 (AI)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/Titanium-Optimizer-Gen2-AI/main/Main.lua"))()
    end,
})

TabAlt:CreateButton({
    Name = "▶ GEMBOOST X 2026 Module",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/GEMBOOST-X-2026/main/Main.lua"))()
    end,
})

-- [TAB 6] UTILS
local TabUtils = Window:CreateTab("Utils🛠️", 4483362458)
TabUtils:CreateSection("Management")
-- YENİ FPS COUNTER TOGGLE
TabUtils:CreateToggle({ Name = "Dynamic FPS HUD (Moveable)", CurrentValue = false, Flag = "DynFPS", Callback = ToggleFPSCounter })
TabUtils:CreateToggle({ Name = "No Render (Black Screen) ⬛", CurrentValue = false, Flag = "NoRender", Callback = function(V) RunService:Set3dRenderingEnabled(not V) end })
TabUtils:CreateButton({ Name = "Clean Console/Logs", Callback = GodLogic.CleanLogs })
TabUtils:CreateButton({ Name = "Rejoin Server 🔄", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
TabUtils:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end })

TabUtils:CreateLabel("Engineered by Zenith")
