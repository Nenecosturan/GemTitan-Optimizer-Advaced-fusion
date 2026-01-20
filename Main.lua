--[[
    GemTitanOptimizer | Omega v.8
    Language: English
    Key: Crystal
]]

--// 1. LIBRARY LOADER (STABLE LINK)
local Rayfield 
local success, result = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end)

if success then
    Rayfield = result
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error";
        Text = "Rayfield failed to load. Check your internet.";
        Duration = 5;
    })
    return
end

--// SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 
local MaterialService = game:GetService("MaterialService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// 2. MEMORY & SETTINGS
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

--// 3. UI WINDOW CONFIGURATION
local Window = Rayfield:CreateWindow({
   Name = "GemTitanOptimizer | Omega v.8",
   LoadingTitle = "GemTitan loading...",
   LoadingSubtitle = "Finding the latest version...",
   Theme = "Amethyst",
   
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GemTitanOmegaConfig", 
      FileName = "UserConfigV8"
   },
   
   Discord = { Enabled = false, Invite = "noinvite", RememberJoins = true },
   
   KeySystem = true,
   KeySettings = {
      Title = "Optimization Access",
      Subtitle = "Security Protocol",
      Note = "The Key Is Crystal", 
      FileName = "GemTitanKeyV8", 
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "Crystal" 
   }
})

--// 4. NOTIFICATION & FPS SYSTEM
local function SendNotif(title, text)
    Rayfield:Notify({ Title = title, Content = text, Duration = 2, Image = 4483345998 })
end

-- FPS Counter
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
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8) 
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Parent = Frame
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 18
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Text = "FPS: ..."
        
        RunService.RenderStepped:Connect(function(dt)
            if Label and Label.Parent then
                local fps = math.floor(1/dt)
                Label.Text = "FPS: " .. fps
                Label.TextColor3 = fps < 30 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
            end
        end)
    else
        if FPSGui then FPSGui:Destroy() FPSGui = nil end
    end
end

--------------------------------------------------------------------------------
--// LOGIC FUNCTIONS (ENGLISH)
--------------------------------------------------------------------------------
local SmartTech = {}
local TitanCortex = {}
local GemLogic = {} 
local TitanLogic = {} 
local GodLogic = {}
local UtilsLogic = {}

-- Smart Tech
function SmartTech.PhysicsBubble(state)
    GemTitan.Config.PhysicsBubble = state
    if state then
        SendNotif("System", "Physics Bubble: ACTIVE")
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
        SendNotif("System", "Physics Bubble: DISABLED")
    end
end

function TitanCortex.HookNewParts(state)
    if state then
        SendNotif("System", "Hook: ACTIVE (Blocking New Effects)")
        GemTitan.Connections.Added = Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ParticleEmitter") or obj:IsA("Explosion") or obj:IsA("Smoke") or obj:IsA("Debris") then
                RunService.Heartbeat:Wait()
                obj:Destroy()
            end
        end)
    else
        if GemTitan.Connections.Added then GemTitan.Connections.Added:Disconnect() end
        SendNotif("System", "Hook: STOPPED")
    end
end

-- Visuals
function GemLogic.ToggleTextures(state)
    if state then
         for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
        SendNotif("Visuals", "Textures Hidden")
    else
        for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end end
        SendNotif("Visuals", "Textures Restored")
    end
end

function GemLogic.ToggleEffects(state)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = not state end
    end
    SendNotif("Visuals", state and "Effects Disabled" or "Effects Enabled")
end

function GemLogic.ToggleShadows(state)
    Lighting.GlobalShadows = not state
    for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow = not state end end
    SendNotif("Visuals", state and "Shadows Disabled" or "Shadows Enabled")
end

-- Basics
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
        SendNotif("Optimizer", "Smart Culling Enabled")
    else
        if GemTitan.Loops.Cull then GemTitan.Loops.Cull:Disconnect() end
        for _, part in pairs(Workspace:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end end
        SendNotif("Optimizer", "Smart Culling Disabled")
    end
end

function TitanLogic.InvisibleWalls()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency == 1 and v.CanCollide then
            v:Destroy()
        end
    end
    SendNotif("Cleaner", "Invisible Walls Removed")
end

-- Destructive
function GodLogic.NukeParticles() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v:Destroy() end end SendNotif("Cleaner", "Particles Nuked.") end
function GodLogic.StopAnims() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Humanoid") then local a = v:FindFirstChildOfClass("Animator") if a then for _, t in pairs(a:GetPlayingAnimationTracks()) do t:Stop() end end end end SendNotif("Cleaner", "Animations Stopped.") end
function GodLogic.RemoveAccessories() for _, p in pairs(Players:GetPlayers()) do if p.Character then for _, o in pairs(p.Character:GetChildren()) do if o:IsA("Accessory") or o:IsA("Hat") or o:IsA("Shirt") or o:IsA("Pants") then o:Destroy() end end end end SendNotif("Cleaner", "Accessories Removed.") end
function GodLogic.KillSounds() for _, v in pairs(game:GetDescendants()) do if v:IsA("Sound") then v:Destroy() end end SendNotif("Cleaner", "Sounds Killed.") end
function GodLogic.StripMeshes() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("MeshPart") then v.TextureID = "" end end SendNotif("Cleaner", "Mesh Textures Stripped.") end
function GodLogic.RemoveGUI3D() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v:Destroy() end end SendNotif("Cleaner", "3D GUI Removed.") end
function GodLogic.RemoveVehicles() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Seat") or v:IsA("VehicleSeat") then v:Destroy() end end SendNotif("Cleaner", "Vehicles Removed.") end
function GodLogic.DeleteTerrain() Workspace.Terrain:Clear() SendNotif("Cleaner", "Terrain Deleted.") end

-- Hyper Functions
function GodLogic.AnchorAll() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Parent.Name ~= LocalPlayer.Name then v.Anchored = true end end SendNotif("Hyper", "World Anchored.") end
function GodLogic.DowngradeLight() Lighting.Technology = Enum.Technology.Compatibility; Lighting.GlobalShadows = false; SendNotif("Hyper", "Lighting Downgraded.") end
function GodLogic.RemoveConstraints() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Constraint") or v:IsA("Weld") or v:IsA("Motor6D") then v:Destroy() end end SendNotif("Hyper", "Constraints Removed.") end
function GodLogic.DisableTouch() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false v.CanQuery = false end end SendNotif("Hyper", "Touch Disabled.") end
function GodLogic.CleanScripts() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("LocalScript") and not v:IsDescendantOf(LocalPlayer.Character) then v:Destroy() end end SendNotif("Hyper", "External Scripts Cleaned.") end
function GodLogic.OverrideMaterials() for _, m in pairs(MaterialService:GetChildren()) do m:Destroy() end SendNotif("Hyper", "Materials Destroyed.") end
function GodLogic.VoidClean() Workspace.FallenPartsDestroyHeight = -10 SendNotif("Hyper", "Void Cleaned.") end

-- Utils (Mobile)
function UtilsLogic.AntiAFK()
    if getgenv().AntiAFKRunning then return end
    getgenv().AntiAFKRunning = true
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    SendNotif("System", "Anti-AFK Active")
end

local WhiteScreenGui = nil
function UtilsLogic.WhiteScreen(state)
    if state then
        RunService:Set3dRenderingEnabled(false)
        WhiteScreenGui = Instance.new("ScreenGui")
        WhiteScreenGui.Parent = CoreGui
        WhiteScreenGui.Name = "GemTitanWhiteScreen"
        WhiteScreenGui.IgnoreGuiInset = true
        WhiteScreenGui.DisplayOrder = 9999
        
        local Frame = Instance.new("Frame")
        Frame.Parent = WhiteScreenGui
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame.BorderSizePixel = 0
        SendNotif("GPU Saver", "White Screen: ON")
    else
        RunService:Set3dRenderingEnabled(true)
        if WhiteScreenGui then WhiteScreenGui:Destroy() end
        SendNotif("GPU Saver", "Normal View Restored")
    end
end

function UtilsLogic.CleanRAM()
    local startMem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
    collectgarbage("collect")
    local endMem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
    SendNotif("Memory", "Cleaned: " .. (startMem - endMem) .. " MB")
end

--------------------------------------------------------------------------------
--// RAYFIELD UI ELEMENTS
--------------------------------------------------------------------------------

-- [TAB 0] AI
local TabAI = Window:CreateTab("Smart AI", 4483362458)
TabAI:CreateSection("Active Intelligence")
TabAI:CreateToggle({ Name = "Physics Bubble (Optimize) 🫧", CurrentValue = false, Flag = "PhysBubble", Callback = SmartTech.PhysicsBubble })
TabAI:CreateToggle({ Name = "Auto Hook (Deleter) 🎣", CurrentValue = false, Flag = "AutoHook", Callback = TitanCortex.HookNewParts })

-- [TAB 1] VISUALS
local TabLight = Window:CreateTab("Visuals", 4483362458)
TabLight:CreateSection("Graphic Settings")
TabLight:CreateToggle({ Name = "Hide Textures (Plastic) 🧱", CurrentValue = false, Flag = "TexTog", Callback = GemLogic.ToggleTextures })
TabLight:CreateToggle({ Name = "Disable Effects ✨", CurrentValue = false, Flag = "EffTog", Callback = GemLogic.ToggleEffects })
TabLight:CreateToggle({ Name = "Disable Shadows 🌑", CurrentValue = false, Flag = "ShadTog", Callback = GemLogic.ToggleShadows })
TabLight:CreateToggle({ Name = "Show FPS Counter", CurrentValue = false, Flag = "FPSShow", Callback = ToggleFPSCounter })

-- [TAB 2] BASICS
local TabBasics = Window:CreateTab("Basics", 4483362458)
TabBasics:CreateSection("Environment")
TabBasics:CreateToggle({ Name = "FullBright Mode ☀️", CurrentValue = false, Flag = "FullBright", Callback = TitanLogic.ToggleFullBright })
TabBasics:CreateToggle({ Name = "Smart Culling 👁️", CurrentValue = false, Flag = "SmartCull", Callback = TitanLogic.SmartCulling })
TabBasics:CreateToggle({ Name = "Unlock FPS 👾", CurrentValue = false, Flag = "UnlockFPS", Callback = function(V) setfpscap(V and 10000 or 60) end })
TabBasics:CreateButton({ Name = "Remove Invisible Walls", Callback = function() TitanLogic.InvisibleWalls() end })

-- [TAB 3] AGGRESSIVE
local TabAggressive = Window:CreateTab("Aggressive", 4483362458)
TabAggressive:CreateSection("Destruction Tools")
TabAggressive:CreateButton({ Name = "1. Nuke Particles", Callback = GodLogic.NukeParticles })
TabAggressive:CreateButton({ Name = "2. Stop Animations", Callback = GodLogic.StopAnims })
TabAggressive:CreateButton({ Name = "3. Remove Accessories", Callback = GodLogic.RemoveAccessories })
TabAggressive:CreateButton({ Name = "4. Kill All Sounds", Callback = GodLogic.KillSounds })
TabAggressive:CreateButton({ Name = "5. Strip Mesh Textures", Callback = GodLogic.StripMeshes })
TabAggressive:CreateButton({ Name = "6. Remove 3D GUI", Callback = GodLogic.RemoveGUI3D })
TabAggressive:CreateButton({ Name = "7. Remove Vehicles", Callback = GodLogic.RemoveVehicles })
TabAggressive:CreateButton({ Name = "8. Delete Terrain", Callback = GodLogic.DeleteTerrain })

-- [TAB 4] HYPER
local TabHyper = Window:CreateTab("Hyper", 4483362458)
TabHyper:CreateSection("Extreme Cleaning")
TabHyper:CreateButton({ Name = "Anchor Everything", Callback = GodLogic.AnchorAll })
TabHyper:CreateButton({ Name = "Downgrade Lighting", Callback = GodLogic.DowngradeLight })
TabHyper:CreateButton({ Name = "Remove Constraints (Weld)", Callback = GodLogic.RemoveConstraints })
TabHyper:CreateButton({ Name = "Disable Touch", Callback = GodLogic.DisableTouch })
TabHyper:CreateButton({ Name = "Clean External Scripts", Callback = GodLogic.CleanScripts })
TabHyper:CreateButton({ Name = "Destroy Materials", Callback = GodLogic.OverrideMaterials })
TabHyper:CreateButton({ Name = "Clean Void", Callback = GodLogic.VoidClean })

-- [TAB 5] UTILS
local TabUtils = Window:CreateTab("Utils", 4483362458)
TabUtils:CreateSection("Mobile & Performance")
TabUtils:CreateButton({ Name = "Activate Anti-AFK", Callback = UtilsLogic.AntiAFK })
TabUtils:CreateToggle({ Name = "White Screen (GPU Saver)", CurrentValue = false, Flag = "WhiteScr", Callback = UtilsLogic.WhiteScreen })
TabUtils:CreateButton({ Name = "Clean RAM", Callback = UtilsLogic.CleanRAM })

Rayfield:LoadConfiguration()
SendNotif("Success", "Script Loaded!")
