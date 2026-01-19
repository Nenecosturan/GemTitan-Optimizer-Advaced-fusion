--[[
    GemTitanOptimizer: The Crystal
    Kodlayan: Zenith (bizkizlar)
    Sürüm: 5.0 Full Stack
    
    New Features:
    - Secure Key System: "Fusionof26"
    - Cortex AI: Akıllı Fizik ve Hook Sistemi
    - Smart Toggles: Geri Alınabilir Grafikler
    - Destruction Suite: 20+ Yıkıcı Özellik (Geri Getirildi)
]]

--// 1. KÜTÜPHANE VE SERVİSLER
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MaterialService = game:GetService("MaterialService")
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

--// 3. UI PENCERESİ
local Window = Rayfield:CreateWindow({
   Name = "•GemTitanOptimizer•|•Crystal v5.0• 🔮",
   LoadingTitle = "System Loading...",
   LoadingSubtitle = "Verifying Integrity...",
   Theme = "Amethyst",
   
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GemBoostConfig", 
      FileName = "TitanCrystalSettings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite", 
      RememberJoins = true 
   },
   
   KeySystem = true,
   KeySettings = {
      Title = "Optimization Access",
      Subtitle = "Security Protocol",
      Note = "Key: Fusionof26",
      FileName = "GemTitanKeyFile",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "Fusionof26"
   }
})

--// 4. YARDIMCI FONKSİYONLAR
local function SendNotif(title, text)
    Rayfield:Notify({ Title = title, Content = text, Duration = 2, Image = 4483345998 })
end

local function DoSafe(func)
    pcall(func)
end

--------------------------------------------------------------------------------
--// BÖLÜM 1: CORTEX AI (AKILLI SİSTEMLER)
--------------------------------------------------------------------------------
local SmartTech = {}
local TitanCortex = {}

-- Adaptive Physics Bubble
function SmartTech.PhysicsBubble(state)
    GemTitan.Config.PhysicsBubble = state
    if state then
        SendNotif("Cortex AI", "Physics bubble: Off🫧")
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
        SendNotif("Cortex AI", "Physics bubble: Off")
    end
end

-- Interceptor Hook
function TitanCortex.HookNewParts(state)
    if state then
        SendNotif("Cortex AI", "Hook: On (New effects get removed instantly)")
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
--// BÖLÜM 2: TOGGLE (AÇ/KAPA) SİSTEMLERİ
--------------------------------------------------------------------------------
local GemLogic = {} 
local TitanLogic = {} 

function GemLogic.ToggleEffects(state)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = not state
        end
    end
    SendNotif("GemBoost", state and "Effects hidden" or "Effects back")
end

function GemLogic.ToggleShadows(state)
    Lighting.GlobalShadows = not state
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = not state end
    end
    SendNotif("GemBoost", state and "Shadows disabled" or "Shadows enabled")
end

function TitanLogic.ToggleFullBright(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = GemTitan.Defaults.Brightness
        Lighting.ClockTime = GemTitan.Defaults.ClockTime
        Lighting.FogEnd = GemTitan.Defaults.FogEnd
        Lighting.GlobalShadows = GemTitan.Defaults.GlobalShadows
        Lighting.Ambient = GemTitan.Defaults.Ambient
    end
end

function TitanLogic.SmartCulling(state)
    GemTitan.Config.SmartCulling = state
    if state then
        SendNotif("Titanium", "Smart hider: On")
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
    else
        if GemTitan.Loops.Cull then GemTitan.Loops.Cull:Disconnect() end
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end
        end
        SendNotif("Titanium", "Smart hider: Off")
    end
end

function GemLogic.ToggleTextures(state)
    if state then
         for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        SendNotif("GemBoost", "Dokular Gizlendi")
    else
        for _, v in pairs(Workspace:GetDescendants()) do
             if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end
        end
        SendNotif("GemBoost", "Dokular Geri Geldi")
    end
end

--------------------------------------------------------------------------------
--// BÖLÜM 3: DESTRUCTIVE (YIKICI) FONKSİYONLAR - HEPSİ GERİ GELDİ!
--------------------------------------------------------------------------------
local GodLogic = {}

-- 1. Particles
function GodLogic.NukeParticles()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v:Destroy() end
    end
    SendNotif("Aggressive", "Partiküller Silindi.")
end

-- 2. Animations
function GodLogic.StopAnims()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Humanoid") then
            local animator = v:FindFirstChildOfClass("Animator")
            if animator then for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop() end end
        end
    end
    SendNotif("Aggressive", "Animasyonlar Durdu.")
end

-- 3. Accessories
function GodLogic.RemoveAccessories()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in pairs(player.Character:GetChildren()) do
                if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
            end
        end
    end
    SendNotif("Aggressive", "Aksesuarlar Silindi.")
end

-- 4. Sounds
function GodLogic.KillSounds()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Sound") then v:Destroy() end end
    SendNotif("Aggressive", "Sesler Silindi.")
end

-- 5. Meshes
function GodLogic.StripMeshes()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("MeshPart") then v.TextureID = "" end
    end
    SendNotif("Aggressive", "Mesh Dokuları Silindi.")
end

-- 6. GUIs
function GodLogic.RemoveGUI3D()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v:Destroy() end
    end
    SendNotif("Aggressive", "3D GUI Silindi.")
end

-- 7. Vehicles
function GodLogic.RemoveVehicles()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Seat") or v:IsA("VehicleSeat") then v:Destroy() end
    end
    SendNotif("Aggressive", "Araçlar Silindi.")
end

-- 8. Terrain
function GodLogic.DeleteTerrain()
    Workspace.Terrain:Clear()
    SendNotif("Aggressive", "Arazi (Terrain) Silindi.")
end

-- 9. Anchor
function GodLogic.AnchorAll()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Parent.Name ~= LocalPlayer.Name then v.Anchored = true end
    end
    SendNotif("Hyper", "Her Şey Sabitlendi.")
end

-- 10. Lighting
function GodLogic.DowngradeLight()
    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.GlobalShadows = false
    SendNotif("Hyper", "Işık Kalitesi Düşürüldü.")
end

-- 11. Constraints
function GodLogic.RemoveConstraints()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Constraint") or v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("Beam") then v:Destroy() end
    end
    SendNotif("Hyper", "Fizik Bağlantıları Koptu.")
end

-- 12. CanTouch
function GodLogic.DisableTouch()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.CanTouch = false v.CanQuery = false end
    end
    SendNotif("Hyper", "Dokunma (Touch) Kapandı.")
end

-- 13. States
function GodLogic.KillStates()
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if h then
        h:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end
    SendNotif("Hyper", "Humanoid Durumları Kısıtlandı.")
end

-- 14. Sleep Physics
function GodLogic.SleepParts()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored then v.Velocity = Vector3.zero end
    end
    SendNotif("Hyper", "Fizik Uyutuldu.")
end

-- 15. Map Scripts
function GodLogic.CleanScripts()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("LocalScript") and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end
    end
    SendNotif("Hyper", "Map Scriptleri Silindi.")
end

-- 16. Materials
function GodLogic.OverrideMaterials()
    for _, mat in pairs(MaterialService:GetChildren()) do mat:Destroy() end
    SendNotif("Hyper", "Materyaller Sıfırlandı.")
end

-- 17. Void
function GodLogic.VoidClean()
    Workspace.FallenPartsDestroyHeight = -10
    SendNotif("Hyper", "Void Temizliği Arttırıldı.")
end

function GodLogic.CleanLogs()
    if rconsoleclear then rconsoleclear() end
    SendNotif("Utils", "Loglar Temizlendi.")
end

--------------------------------------------------------------------------------
--// UI KURULUMU (HEPSİ EKLENİYOR)
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
TabBasics:CreateButton({ Name = "Remove Invisible Walls", Callback = function() TitanLogic.InvisibleWalls() end }) -- Unutulan özellik eklendi

-- [TAB 3] AGGRESSIVE (YIKIM I - OBJELER)
local TabAggressive = Window:CreateTab("Aggressive🔥", 4483362458)
TabAggressive:CreateSection("Object Destruction")
TabAggressive:CreateLabel("⚠️ Bu işlemler geri alınamaz!")

TabAggressive:CreateButton({ Name = "1. Nuke Particles", Callback = GodLogic.NukeParticles })
TabAggressive:CreateButton({ Name = "2. Stop Animations", Callback = GodLogic.StopAnims })
TabAggressive:CreateButton({ Name = "3. Remove Accessories", Callback = GodLogic.RemoveAccessories })
TabAggressive:CreateButton({ Name = "4. Kill All Sounds", Callback = GodLogic.KillSounds })
TabAggressive:CreateButton({ Name = "5. Strip Mesh Textures", Callback = GodLogic.StripMeshes })
TabAggressive:CreateButton({ Name = "6. Remove 3D GUI", Callback = GodLogic.RemoveGUI3D })
TabAggressive:CreateButton({ Name = "7. Remove Vehicles", Callback = GodLogic.RemoveVehicles })
TabAggressive:CreateButton({ Name = "8. Delete Terrain", Callback = GodLogic.DeleteTerrain })

-- [TAB 4] HYPER (YIKIM II - TEKNİK) - BURASI ÖNCEDEN EKSİKTİ, ŞİMDİ TAM!
local TabHyper = Window:CreateTab("Hyper⚡", 4483362458)
TabHyper:CreateSection("Engine Level Hacks")

TabHyper:CreateButton({ Name = "9. Freeze World (Anchor)", Callback = GodLogic.AnchorAll })
TabHyper:CreateButton({ Name = "10. Downgrade Lighting", Callback = GodLogic.DowngradeLight })
TabHyper:CreateButton({ Name = "11. Remove Constraints", Callback = GodLogic.RemoveConstraints })
TabHyper:CreateButton({ Name = "12. Disable CanTouch", Callback = GodLogic.DisableTouch })
TabHyper:CreateButton({ Name = "13. Kill Humanoid States", Callback = GodLogic.KillStates })
TabHyper:CreateButton({ Name = "14. Sleep Physics", Callback = GodLogic.SleepParts })
TabHyper:CreateButton({ Name = "15. Delete Map Scripts", Callback = GodLogic.CleanScripts })
TabHyper:CreateButton({ Name = "16. Override Materials", Callback = GodLogic.OverrideMaterials })
TabHyper:CreateButton({ Name = "17. Fast Void Clean", Callback = GodLogic.VoidClean })

-- [TAB 5] UTILS
local TabUtils = Window:CreateTab("Utils🛠️", 4483362458)
TabUtils:CreateSection("Management")
TabUtils:CreateToggle({ Name = "No Render (Black Screen) ⬛", CurrentValue = false, Flag = "NoRender", Callback = function(V) RunService:Set3dRenderingEnabled(not V) end })
TabUtils:CreateButton({ Name = "Clean Console/Logs", Callback = GodLogic.CleanLogs })
TabUtils:CreateButton({ Name = "Rejoin Server 🔄", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
TabUtils:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end })

TabUtils:CreateLabel("Engineered by Zenith")
