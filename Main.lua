--[[
    GemTitan: TITAN EDITION (The Final Fusion)
    Kodlayan: Kodlama Desteği (AI)
    Sürüm: 4.0 Ultimate
    
    ÖZET:
    - GemBoost X (Görsel Düşürme)
    - Titanium Gen2 (Akıllı Mantık & Işık)
    - God Mode (20+ Ağır Optimizasyon)
    
    UYARI: "God Mode" özellikleri geri alınamaz değişiklikler yapabilir.
]]

--// 1. KÜTÜPHANE VE HİZMETLER
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MaterialService = game:GetService("MaterialService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// 2. DEĞİŞKEN YÖNETİMİ
local GemTitan = {
    Loops = {},
    Config = {
        SmartCulling = false,
        AIMode = false,
        BackFPS = false,
        DebrisLoop = false,
        NoRender = false
    }
}

--// 3. UI PENCERESİ
local Window = OrionLib:MakeWindow({
    Name = "GemTitan: TITAN EDITION",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GemTitanFinal",
    IntroEnabled = true,
    IntroText = "Initializing Full Optimization..."
})

--// 4. YARDIMCI FONKSİYONLAR
local function SendNotif(title, text)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

local function DoSafe(func)
    local s, e = pcall(func)
    if not s then warn("GemTitan Error: " .. tostring(e)) end
end

--------------------------------------------------------------------------------
--// BÖLÜM 1: GEMBOOST (Görsel & Temel)
--------------------------------------------------------------------------------
local GemLogic = {}

function GemLogic.LowTextures()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end)
end

function GemLogic.RemoveEffects()
    DoSafe(function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end
    end)
end

function GemLogic.UnlockFPS()
    DoSafe(function() setfpscap(999) end)
end

--------------------------------------------------------------------------------
--// BÖLÜM 2: TITANIUM (Akıllı Sistemler & Render)
--------------------------------------------------------------------------------
local TitanLogic = {}

function TitanLogic.FullBright()
    DoSafe(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    end)
end

function TitanLogic.SmartCulling(state)
    GemTitan.Config.SmartCulling = state
    if state then
        SendNotif("Titanium", "Smart Culling Active")
        GemTitan.Loops.Cull = RunService.RenderStepped:Connect(function()
            -- Her 10 karede bir çalışarak işlemciyi yormayalım
            if os.clock() % 0.1 < 0.01 then
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
    end
end

function TitanLogic.InvisibleWalls()
    DoSafe(function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 1 then
                v.CanCollide = false
            end
        end
    end)
end

--------------------------------------------------------------------------------
--// BÖLÜM 3: GOD MODE (Advanced & Risky)
--------------------------------------------------------------------------------
local GodLogic = {}

-- 1. Particle Annihilator
function GodLogic.NukeParticles()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then
                v:Destroy()
            end
        end
        SendNotif("God Mode", "Particles/Effects Nuked.")
    end)
end

-- 2. Global Animation Disabler
function GodLogic.StopAnims()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Humanoid") then
                local animator = v:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
                end
            end
        end
        SendNotif("God Mode", "Animations Stopped.")
    end)
end

-- 3. Accessory & Hat Remover
function GodLogic.RemoveAccessories()
    DoSafe(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                for _, obj in pairs(player.Character:GetChildren()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") then
                        obj:Destroy()
                    end
                end
            end
        end
        SendNotif("God Mode", "Accessories Removed.")
    end)
end

-- 4. 3D Resolution Scaler (Viewport)
function GodLogic.ReduceResolution()
    -- Bu özellik bazı executorlarda farklı çalışabilir, güvenli yöntem:
    DoSafe(function() 
         -- Sadece desteklenen executorlarda çalışır
         if setrenderingresolution then setrenderingresolution(0.5) end
         SendNotif("God Mode", "Resolution Scaled Down (If Supported).")
    end)
end

-- 5. Sound & Audio Killer
function GodLogic.KillSounds()
    DoSafe(function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Sound") then
                v:Stop()
                v.Volume = 0
                v:Destroy()
            end
        end
        SendNotif("God Mode", "Audio System Killed.")
    end)
end

-- 6. Anchor All
function GodLogic.AnchorAll()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Parent.Name ~= LocalPlayer.Name then
                v.Anchored = true
            end
        end
        SendNotif("God Mode", "Physics Frozen (Anchored).")
    end)
end

-- 7. Billboard GUI Remover
function GodLogic.RemoveGUI3D()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v:Destroy()
            end
        end
    end)
end

-- 8. Terrain/Water Deleter
function GodLogic.DeleteTerrain()
    DoSafe(function()
        Workspace.Terrain:Clear()
        Workspace.WaterWaveSize = 0
        Workspace.WaterReflectance = 0
        Workspace.WaterTransparency = 0
    end)
end

-- 9. Debris Garbage Collector (Loop)
function GodLogic.DebrisLoop(state)
    GemTitan.Config.DebrisLoop = state
    if state then
        GemTitan.Loops.Debris = RunService.Heartbeat:Connect(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == "Debris" or v.Name == "Bullet" or v.Name == "Blood" then -- Örnek isimler
                    v:Destroy()
                end
            end
        end)
    else
        if GemTitan.Loops.Debris then GemTitan.Loops.Debris:Disconnect() end
    end
end

-- 10. No-Render (Black Screen)
function GodLogic.ToggleNoRender(state)
    GemTitan.Config.NoRender = state
    if state then
        RunService:Set3dRenderingEnabled(false)
        SendNotif("God Mode", "3D Rendering Disabled (Black Screen)")
    else
        RunService:Set3dRenderingEnabled(true)
    end
end

-- 11. Streamer Mode
function GodLogic.StreamerMode()
    DoSafe(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                v.DisplayName = "Player"
                v.Name = "Player"
            end
        end
    end)
end

-- 12. Lighting Downgrade
function GodLogic.DowngradeLight()
    DoSafe(function()
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.GlobalShadows = false
    end)
end

-- 13. Physics Constraints Remover
function GodLogic.RemoveConstraints()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Constraint") or v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("Beam") then
                v:Destroy()
            end
        end
    end)
end

-- 14. MeshPart Texture Stripper
function GodLogic.StripMeshes()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("MeshPart") then v.TextureID = "" end
        end
    end)
end

-- 15. Humanoid State Killer
function GodLogic.KillStates()
    DoSafe(function()
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then
            h:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end)
end

-- 16. CanTouch Disabler
function GodLogic.DisableTouch()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanTouch = false
                v.CanQuery = false
            end
        end
    end)
end

-- 17. Seat/Vehicle Remover
function GodLogic.RemoveVehicles()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Seat") or v:IsA("VehicleSeat") then v:Destroy() end
        end
    end)
end

-- 18. Falling Parts Destroyer
function GodLogic.VoidClean()
    DoSafe(function()
        Workspace.FallenPartsDestroyHeight = -10 -- Hemen sil
    end)
end

-- 19. MaterialService Override
function GodLogic.OverrideMaterials()
    DoSafe(function()
        for _, mat in pairs(MaterialService:GetChildren()) do
            mat:Destroy()
        end
    end)
end

-- 20. Script Cleaner (Riskli)
function GodLogic.CleanScripts()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("LocalScript") and not v:IsDescendantOf(LocalPlayer.Character) then
                v:Destroy()
            end
        end
        SendNotif("God Mode", "Map Scripts Deleted.")
    end)
end

-- 21. Aggressive Sleeper
function GodLogic.SleepParts()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored then
                v.Velocity = Vector3.new(0,0,0)
                v.RotVelocity = Vector3.new(0,0,0)
            end
        end
    end)
end

-- 22. Log Cleaner
function GodLogic.CleanLogs()
    DoSafe(function()
         -- Konsol temizliği executor'a bağlıdır, burada client hafızasını temizlemeye çalışıyoruz
         if rconsoleclear then rconsoleclear() end
         SendNotif("God Mode", "Console Logs Cleared.")
    end)
end

--------------------------------------------------------------------------------
--// UI ELEMENTLERİ
--------------------------------------------------------------------------------

-- TAB 1: GEMBOOST (Temel)
local TabGem = Window:MakeTab({ Name = "Visuals (GemBoost)", Icon = "rbxassetid://4483345998" })
TabGem:AddSection({ Name = "Main Graphics" })
TabGem:AddButton({ Name = "Low Textures (Plastic)", Callback = GemLogic.LowTextures })
TabGem:AddButton({ Name = "Remove Effects (Fog/Blur)", Callback = GemLogic.RemoveEffects })
TabGem:AddToggle({ Name = "Unlock FPS (999)", Default = false, Callback = function(v) if v then GemLogic.UnlockFPS() else setfpscap(60) end end })

-- TAB 2: TITANIUM (Logic)
local TabTitan = Window:MakeTab({ Name = "System (Titanium)", Icon = "rbxassetid://4483345998" })
TabTitan:AddSection({ Name = "Advanced Logic" })
TabTitan:AddButton({ Name = "FullBright (See in Dark)", Callback = TitanLogic.FullBright })
TabTitan:AddButton({ Name = "Remove Invisible Walls", Callback = TitanLogic.InvisibleWalls })
TabTitan:AddToggle({ Name = "Smart View Culling", Default = false, Callback = TitanLogic.SmartCulling })
TabTitan:AddToggle({ Name = "Background FPS Saver", Default = false, Callback = function(v) 
    GemTitan.Config.BackFPS = v
    if v then
        GemTitan.Loops.Focus = UserInputService.WindowFocusReleased:Connect(function() setfpscap(5) end)
        GemTitan.Loops.Unfocus = UserInputService.WindowFocused:Connect(function() setfpscap(999) end)
    else
        if GemTitan.Loops.Focus then GemTitan.Loops.Focus:Disconnect() end
        if GemTitan.Loops.Unfocus then GemTitan.Loops.Unfocus:Disconnect() end
        setfpscap(999)
    end
end})

-- TAB 3: GOD MODE (Objects & Physics)
local TabGod1 = Window:MakeTab({ Name = "God Mode (Obj)", Icon = "rbxassetid://4483345998" })
TabGod1:AddSection({ Name = "Destruction I" })
TabGod1:AddButton({ Name = "1. Nuke Particles/Smoke", Callback = GodLogic.NukeParticles })
TabGod1:AddButton({ Name = "2. Stop Animations", Callback = GodLogic.StopAnims })
TabGod1:AddButton({ Name = "3. Remove Accessories/Hats", Callback = GodLogic.RemoveAccessories })
TabGod1:AddButton({ Name = "4. Kill Sound Engine", Callback = GodLogic.KillSounds })
TabGod1:AddButton({ Name = "5. Strip Mesh Textures", Callback = GodLogic.StripMeshes })
TabGod1:AddButton({ Name = "6. Remove Billboard GUIs", Callback = GodLogic.RemoveGUI3D })
TabGod1:AddButton({ Name = "7. Remove Seats/Vehicles", Callback = GodLogic.RemoveVehicles })
TabGod1:AddButton({ Name = "8. Delete Terrain & Water", Callback = GodLogic.DeleteTerrain })

-- TAB 4: GOD MODE (Engine & Tech)
local TabGod2 = Window:MakeTab({ Name = "God Mode (Tech)", Icon = "rbxassetid://4483345998" })
TabGod2:AddSection({ Name = "Destruction II" })
TabGod2:AddButton({ Name = "9. Anchor All (Freeze World)", Callback = GodLogic.AnchorAll })
TabGod2:AddButton({ Name = "10. Downgrade Lighting", Callback = GodLogic.DowngradeLight })
TabGod2:AddButton({ Name = "11. Remove Physics Constraints", Callback = GodLogic.RemoveConstraints })
TabGod2:AddButton({ Name = "12. Disable CanTouch/Raycast", Callback = GodLogic.DisableTouch })
TabGod2:AddButton({ Name = "13. Kill Humanoid States", Callback = GodLogic.KillStates })
TabGod2:AddButton({ Name = "14. Sleep Physics (Vel 0)", Callback = GodLogic.SleepParts })
TabGod2:AddButton({ Name = "15. Delete Map Scripts (Risk)", Callback = GodLogic.CleanScripts })
TabGod2:AddButton({ Name = "16. Override Materials", Callback = GodLogic.OverrideMaterials })
TabGod2:AddButton({ Name = "17. Fast Void Clean", Callback = GodLogic.VoidClean })

-- TAB 5: UTILS
local TabUtils = Window:MakeTab({ Name = "Utils", Icon = "rbxassetid://4483345998" })
TabUtils:AddToggle({ Name = "No Render (Black Screen)", Default = false, Callback = GodLogic.ToggleNoRender })
TabUtils:AddButton({ Name = "Streamer Mode (Hide Names)", Callback = GodLogic.StreamerMode })
TabUtils:AddButton({ Name = "Clean Console/Logs", Callback = GodLogic.CleanLogs })
TabUtils:AddButton({ Name = "Destroy UI", Callback = function() OrionLib:Destroy() end })

-- Bitiş
OrionLib:Init()
SendNotif("GemTitan Ultimate", "All Systems Operational.")
