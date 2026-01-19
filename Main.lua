--[[
    GemTitan-Optimizer | Advanced Fusion (Ultimate Edition)
    Kodlayan: Kodlama Desteği (AI)
    Versiyon: 2.1 (Smart Culling & AI Added)
    
    Özellikler:
    - GEMBOOST X Entegrasyonu
    - Titanium Gen2 (Smart Render & AI Mode)
    - Görüş Alanı Renderlama (Frustum Culling)
    - Dinamik FPS Yönetimi
]]

--// 1. KÜTÜPHANE VE DEĞİŞKENLER
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera

--// Pencere Ayarları
local Window = OrionLib:MakeWindow({
    Name = "GemTitan: Ultimate Fusion",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GemTitanUltimate",
    IntroEnabled = true,
    IntroText = "Initializing AI Logic..."
})

--// Bildirim Fonksiyonu
local function SendNotif(title, content)
    OrionLib:MakeNotification({
        Name = title,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

--------------------------------------------------------------------------------
--// BÖLÜM 1: GEMBOOST X MANTIKLARI (Statik Optimizasyon)
--------------------------------------------------------------------------------
local GemLogic = {}

function GemLogic.LowTextures()
    pcall(function()
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

function GemLogic.FPSUnlocker()
    pcall(function() setfpscap(999) end)
end

--------------------------------------------------------------------------------
--// BÖLÜM 2: TITANIUM GEN2 GELİŞMİŞ MANTIKLAR (AI & Smart Render)
--------------------------------------------------------------------------------
local TitaniumLogic = {}
local SmartRenderLoop = nil
local AIOptimizerLoop = nil

-- [ÖNEMLİ] Sadece Bakılan Yeri Renderlama (Frustum Culling)
function TitaniumLogic.ToggleSmartRender(state)
    if state then
        SendNotif("Titanium AI", "Smart View Culling Enabled")
        SmartRenderLoop = RunService.RenderStepped:Connect(function()
            -- Her karede çalışmak yerine performansı korumak için her 10 karede bir tam tarama yapılabilir
            -- Ancak anlık etki için basit bir döngü kuruyoruz:
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    local _, onScreen = Camera:WorldToScreenPoint(part.Position)
                    if onScreen then
                        part.LocalTransparencyModifier = 0 -- Görünür yap
                    else
                        -- Kameranın arkasında veya dışında ise gizle
                        part.LocalTransparencyModifier = 1 
                    end
                end
            end
        end)
    else
        if SmartRenderLoop then SmartRenderLoop:Disconnect() end
        -- Her şeyi tekrar görünür yap
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
        SendNotif("Titanium AI", "Smart View Disabled")
    end
end

-- [ÖNEMLİ] Akıllı FPS Analizi (FPS Düşerse Optimizasyonu Artırır)
function TitaniumLogic.ToggleAIMode(state)
    if state then
        SendNotif("Titanium AI", "Auto-FPS Monitor Active")
        AIOptimizerLoop = RunService.Heartbeat:Connect(function()
            local fps = Workspace:GetRealPhysicsFPS()
            if fps < 30 then
                -- FPS kritik seviyeye düşerse gölgeleri kapat ve texture kalitesini düşür
                Lighting.GlobalShadows = false
                settings().Rendering.QualityLevel = 1
            elseif fps > 55 then
                -- FPS iyiyse biraz kaliteye izin ver (Denge modu)
                Lighting.GlobalShadows = true
            end
        end)
    else
        if AIOptimizerLoop then AIOptimizerLoop:Disconnect() end
        SendNotif("Titanium AI", "AI Monitor Stopped")
    end
end

function TitaniumLogic.InvisibleWalls()
    pcall(function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 1 then
                v.CanCollide = false
            end
        end
    end)
end

--------------------------------------------------------------------------------
--// UI YAPILANDIRMASI
--------------------------------------------------------------------------------

--// TAB 1: GEMBOOST X (Temel)
local GemTab = Window:MakeTab({ Name = "GEMBOOST X", Icon = "rbxassetid://4483345998", PremiumOnly = false })

GemTab:AddSection({ Name = "Texture & Visuals" })
GemTab:AddButton({
    Name = "Apply Low Textures",
    Callback = function() GemLogic.LowTextures() end    
})
GemTab:AddToggle({
    Name = "Unlock FPS",
    Default = false,
    Callback = function(Value) 
        if Value then GemLogic.FPSUnlocker() else setfpscap(60) end
    end    
})

--// TAB 2: TITANIUM GEN2 (Gelişmiş)
local TitanTab = Window:MakeTab({ Name = "Titanium Gen2", Icon = "rbxassetid://4483345998", PremiumOnly = false })

TitanTab:AddSection({ Name = "AI & Smart Rendering" })

TitanTab:AddParagraph("Warning", "Smart Render may cause flickering on objects behind you but saves massive FPS.")

TitanTab:AddToggle({
    Name = "Smart View Culling (Render Only Visible)",
    Default = false,
    Callback = function(Value)
        TitaniumLogic.ToggleSmartRender(Value)
    end    
})

TitanTab:AddToggle({
    Name = "AI FPS Monitor (Auto-Adjust)",
    Default = false,
    Callback = function(Value)
        TitaniumLogic.ToggleAIMode(Value)
    end    
})

TitanTab:AddSection({ Name = "Physics Optimization" })
TitanTab:AddButton({
    Name = "Disable Invisible Walls (No Col)",
    Callback = function()
        TitaniumLogic.InvisibleWalls()
        SendNotif("Titanium", "Invisible Walls Disabled")
    end    
})

--// TAB 3: INFO
local InfoTab = Window:MakeTab({ Name = "Credits", Icon = "rbxassetid://4483345998", PremiumOnly = false })
InfoTab:AddParagraph("Dev", "Kodlama Desteği AI")
InfoTab:AddButton({ Name = "Close GUI", Callback = function() OrionLib:Destroy() end })

OrionLib:Init()
