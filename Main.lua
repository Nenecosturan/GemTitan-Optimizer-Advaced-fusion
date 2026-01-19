--[[
    GemTitanOptimizer: Advanced fusion
    Kodlayan: Zenith(bizkizlar)
    Sürüm: 4.2 Ultimate
]]

--// 1. KÜTÜPHANE VE HİZMETLER
-- Rayfield kütüphanesi yükleniyor
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MaterialService = game:GetService("MaterialService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// 2. DEĞİŞKEN YÖNETİMİ
local GemTitan = {
    Loops = {},
    Config = {
        SmartCulling = false,
        BackFPS = false,
        NoRender = false
    }
}

--// 3. UI PENCERESİ (Rayfield)
local Window = Rayfield:CreateWindow({
   Name = "•GemTitanOptimizer•|•Adcanced fusion v2.1• ✓",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "Finding Latest version...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GemBoostConfig", 
      FileName = "TitaniumSettings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite", 
      RememberJoins = true 
   },
   KeySystem = false, 
})

--// 4. YARDIMCI FONKSİYONLAR
local function SendNotif(title, text)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = 3,
        Image = 4483345998,
   })
end

local function DoSafe(func)
    local s, e = pcall(func)
    if not s then warn("GemTitan Error: " .. tostring(e)) end
end

--------------------------------------------------------------------------------
--// MANTIK MODÜLLERİ (LOGIC)
--------------------------------------------------------------------------------
local GemLogic = {}
local TitanLogic = {}
local GodLogic = {}

-- GemLogic (Visuals)
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
        SendNotif("GemBoost", "Textures Removed.")
    end)
end

function GemLogic.RemoveEffects()
    DoSafe(function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end
        SendNotif("GemBoost", "Effects removed.")
    end)
end

function GemLogic.UnlockFPS()
    DoSafe(function() setfpscap(10000) end)
end

-- TitanLogic (System)
function TitanLogic.FullBright()
    DoSafe(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        SendNotif("Titanium", "Fullbright on.")
    end)
end

function TitanLogic.SmartCulling(state)
    GemTitan.Config.SmartCulling = state
    if state then
        SendNotif("Titanium", "Smart Culling: On")
        GemTitan.Loops.Cull = RunService.RenderStepped:Connect(function()
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
        SendNotif("Titanium", "Smart Culling: Off")
    end
end

function TitanLogic.InvisibleWalls()
    DoSafe(function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 1 then
                v.CanCollide = false
            end
        end
        SendNotif("Titanium", "Invisible walls removed.")
    end)
end

-- GodLogic (Destruction)
function GodLogic.NukeParticles()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then
                v:Destroy()
            end
        end
        SendNotif("Hyper aggressive ⚡", "Particles removed.")
    end)
end

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
        SendNotif("Hyper aggresive⚡", "Animations disabled.")
    end)
end

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
        SendNotif("Hyper aggresive⚡", "accessories disabled.")
    end)
end

function GodLogic.KillSounds()
    DoSafe(function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Sound") then
                v:Stop()
                v.Volume = 0
                v:Destroy()
            end
        end
        SendNotif("Hyper aggresive⚡", "Sound system disabled.")
    end)
end

function GodLogic.AnchorAll()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Parent.Name ~= LocalPlayer.Name then
                v.Anchored = true
            end
        end
        SendNotif("Hyper aggresive⚡", "Freezed all.")
    end)
end

function GodLogic.RemoveGUI3D()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v:Destroy()
            end
        end
        SendNotif("Hyper aggresive⚡", "unnecessary texts removed.")
    end)
end

function GodLogic.DeleteTerrain()
    DoSafe(function()
        Workspace.Terrain:Clear()
        Workspace.WaterWaveSize = 0
        Workspace.WaterReflectance = 0
        Workspace.WaterTransparency = 0
        SendNotif("Hyper aggresive⚡", "Terrain removed.")
    end)
end

function GodLogic.ToggleNoRender(state)
    GemTitan.Config.NoRender = state
    RunService:Set3dRenderingEnabled(not state)
    if state then
        SendNotif("Utils", "3D Render Off")
    else
        SendNotif("Utils", "3D Render On")
    end
end

function GodLogic.StreamerMode()
    DoSafe(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                v.DisplayName = "Player"
                v.Name = "Player"
            end
        end
        SendNotif("Utils", "Streamer mode on.")
    end)
end

function GodLogic.DowngradeLight()
    DoSafe(function()
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.GlobalShadows = false
        SendNotif("Hyper aggresive⚡", "lightning lowered.")
    end)
end

function GodLogic.RemoveConstraints()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Constraint") or v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("Beam") then
                v:Destroy()
            end
        end
        SendNotif("Hyper aggresive⚡", "Constraints removed.")
    end)
end

function GodLogic.StripMeshes()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("MeshPart") then v.TextureID = "" end
        end
        SendNotif("Hyper aggresive⚡", "Mesh textures removed.")
    end)
end

function GodLogic.KillStates()
    DoSafe(function()
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then
            h:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
        SendNotif("Hyper aggresive⚡", "unnecessary humanoid parts disabled.")
    end)
end

function GodLogic.DisableTouch()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanTouch = false
                v.CanQuery = false
            end
        end
        SendNotif("Hyper aggresive", "Touch disabled.")
    end)
end

function GodLogic.RemoveVehicles()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Seat") or v:IsA("VehicleSeat") then v:Destroy() end
        end
        SendNotif("Hyper aggresive", "Vehicle/Seats removed.")
    end)
end

function GodLogic.VoidClean()
    DoSafe(function()
        Workspace.FallenPartsDestroyHeight = -10
        SendNotif("Hyper aggresive⚡", "Void cleaning accelerated.")
    end)
end

function GodLogic.OverrideMaterials()
    DoSafe(function()
        for _, mat in pairs(MaterialService:GetChildren()) do
            mat:Destroy()
        end
        SendNotif("Hyper aggresive⚡", "MaterialService got reseted.")
    end)
end

function GodLogic.CleanScripts()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("LocalScript") and not v:IsDescendantOf(LocalPlayer.Character) then
                v:Destroy()
            end
        end
        SendNotif("Hyper aggressive⚡", "Map Scripts cleaned.")
    end)
end

function GodLogic.SleepParts()
    DoSafe(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored then
                v.Velocity = Vector3.new(0,0,0)
                v.RotVelocity = Vector3.new(0,0,0)
            end
        end
        SendNotif("Hyper aggresive⚡", "Moving parts disabled.")
    end)
end

function GodLogic.CleanLogs()
    DoSafe(function()
         if rconsoleclear then rconsoleclear() end
         SendNotif("Utils", "Console/Logs cleaned.")
    end)
end

--------------------------------------------------------------------------------
--// RAYFIELD UI ELEMENTLERİ
--------------------------------------------------------------------------------

-- TAB 1: GEMBOOST (Temel)
local TabGem = Window:CreateTab("Light🪶", 4483362458)
TabGem:CreateSection("Main Graphics")

TabGem:CreateButton({
   Name = "remove Textures🧱",
   Callback = function() GemLogic.LowTextures() end,
})

TabGem:CreateButton({
   Name = "Remove Effects✨ (Fog/Blur)",
   Callback = function() GemLogic.RemoveEffects() end,
})

TabGem:CreateToggle({
   Name = "Unlock FPS👾",
   CurrentValue = false,
   Flag = "UnlockFPS",
   Callback = function(Value)
       if Value then GemLogic.UnlockFPS() else setfpscap(60) end
   end,
})

-- TAB 2: TITANIUM (Logic)
local TabTitan = Window:CreateTab("Basics", 4483362458)
TabTitan:CreateSection("Smart functions")

TabTitan:CreateButton({
   Name = "FullBright☀️",
   Callback = function() TitanLogic.FullBright() end,
})

TabTitan:CreateButton({
   Name = "Remove Invisible Walls🧱",
   Callback = function() TitanLogic.InvisibleWalls() end,
})

TabTitan:CreateToggle({
   Name = "Smart View Culling (BETA)",
   CurrentValue = false,
   Flag = "SmartCull",
   Callback = function(Value)
       TitanLogic.SmartCulling(Value)
   end,
})

TabTitan:CreateToggle({
   Name = "Background FPS Saver🔋",
   CurrentValue = false,
   Flag = "BackFPS",
   Callback = function(Value)
        GemTitan.Config.BackFPS = Value
        if Value then
            GemTitan.Loops.Focus = UserInputService.WindowFocusReleased:Connect(function() setfpscap(5) end)
            GemTitan.Loops.Unfocus = UserInputService.WindowFocused:Connect(function() setfpscap(10000) end)
            SendNotif("Titanium", "Pencere inaktifken FPS 5 olacak.")
        else
            if GemTitan.Loops.Focus then GemTitan.Loops.Focus:Disconnect() end
            if GemTitan.Loops.Unfocus then GemTitan.Loops.Unfocus:Disconnect() end
            setfpscap(10000)
        end
   end,
})

-- TAB 3: GOD MODE (Objects)
local TabGod1 = Window:CreateTab("Aggresive🔥", 4483362458)
TabGod1:CreateSection("Yıkım I: Objeler")

TabGod1:CreateButton({ Name = "1. RemoveParticles/Smoke", Callback = GodLogic.NukeParticles })
TabGod1:CreateButton({ Name = "2. Stop Animations", Callback = GodLogic.StopAnims })
TabGod1:CreateButton({ Name = "3. Remove Accessories", Callback = GodLogic.RemoveAccessories })
TabGod1:CreateButton({ Name = "4. Kill Sound Engine", Callback = GodLogic.KillSounds })
TabGod1:CreateButton({ Name = "5. Strip Mesh Textures", Callback = GodLogic.StripMeshes })
TabGod1:CreateButton({ Name = "6. Remove Billboard GUIs", Callback = GodLogic.RemoveGUI3D })
TabGod1:CreateButton({ Name = "7. Remove Seats/Vehicles", Callback = GodLogic.RemoveVehicles })
TabGod1:CreateButton({ Name = "8. Delete Terrain & Water (Risky)", Callback = GodLogic.DeleteTerrain })

-- TAB 4: GOD MODE (Tech)
local TabGod2 = Window:CreateTab("Hyper aggresive⚡", 4483362458)
TabGod2:CreateSection("Yıkım II: Teknik")

TabGod2:CreateButton({ Name = "9. Freeze All (Rejoin to fix)", Callback = GodLogic.AnchorAll })
TabGod2:CreateButton({ Name = "10. Downgrade Lighting", Callback = GodLogic.DowngradeLight })
TabGod2:CreateButton({ Name = "11. Remove Physics Constraints (risky)", Callback = GodLogic.RemoveConstraints })
TabGod2:CreateButton({ Name = "12. Disable CanTouch", Callback = GodLogic.DisableTouch })
TabGod2:CreateButton({ Name = "13. Kill Humanoid States", Callback = GodLogic.KillStates })
TabGod2:CreateButton({ Name = "14. Sleep Physics (Vel 0)", Callback = GodLogic.SleepParts })
TabGod2:CreateButton({ Name = "15. Delete Map Scripts", Callback = GodLogic.CleanScripts })
TabGod2:CreateButton({ Name = "16. Override Materials", Callback = GodLogic.OverrideMaterials })
TabGod2:CreateButton({ Name = "17. Fast Void Clean", Callback = GodLogic.VoidClean })

-- TAB 5: UTILS
local TabUtils = Window:CreateTab("Utils", 4483362458)
TabUtils:CreateSection("Araçlar")

TabUtils:CreateToggle({
   Name = "No Render (Cool device)",
   CurrentValue = false,
   Flag = "NoRender",
   Callback = function(Value) GodLogic.ToggleNoRender(Value) end,
})

TabUtils:CreateButton({ Name = "Streamer Mode (Hide names)", Callback = GodLogic.StreamerMode })
TabUtils:CreateButton({ Name = "Clean Console/Logs", Callback = GodLogic.CleanLogs })

-- Rayfield'da "Destroy" işlemi kendi içinde yönetilir ama UI'ı kapatmak için bir buton:
TabUtils:CreateButton({ 
    Name = "Destroy UI", 
    Callback = function() 
        Rayfield:Destroy() 
    end 
})

TabUtils:CreateLabel("Script by Zenith")
