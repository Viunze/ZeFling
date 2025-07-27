-- LOCK MAP SYSTEM
if game.GameId ~= 10449761463 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ZeFling Script";
        Text = "Only works in The Strongest Battlegrounds!";
        Duration = 5;
    })
    task.wait(3)
    game:Shutdown()
    return
end

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("❌ Failed to load Rayfield UI")
    return
end

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- // Variables
local flingActive = false
local flingConn
local autoRespawnLoop
local targetName = nil

-- // Stop fling
local function stopFling()
    flingActive = false
    if flingConn then flingConn:Disconnect() end
    if autoRespawnLoop then autoRespawnLoop:Disconnect() end
end

-- // Fling function
local function fling(player)
    local char = LocalPlayer.Character
    local targetChar = player.Character
    if not (char and char:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart")) then return end

    flingConn = RunService.Heartbeat:Connect(function()
        if not flingActive then return end
        if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local t_hrp = targetChar:FindFirstChild("HumanoidRootPart")

        hrp.CFrame = t_hrp.CFrame * CFrame.new(0, 3, 0) -- Slightly above
        hrp.RotVelocity = Vector3.new(9999, 9999, 9999)

        if t_hrp.Position.Y < -100 then
            stopFling()
        end
    end)
end

-- // Auto refire if target respawns
local function autoFlingLoop(player)
    autoRespawnLoop = RunService.Heartbeat:Connect(function()
        if not flingActive then return end
        if not Players:FindFirstChild(player.Name) then
            Rayfield:Notify({
                Title = "✅ Target Left",
                Content = player.Name .. " has left the game.",
                Duration = 4
            })
            stopFling()
            return
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            fling(player)
        end
    end)
end

-- // GUI Window
local Window = Rayfield:CreateWindow({
   Name = "💥 ZeFling Tsb",
   LoadingTitle = "Launching ZeFling...",
   LoadingSubtitle = "By Vinzee",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- // Tab: Fling
local FlingTab = Window:CreateTab("🎯 Fling Target", 4483362458)

FlingTab:CreateInput({
   Name = "👤 Enter Target Username",
   PlaceholderText = "Example: toxickid123",
   RemoveTextAfterFocusLost = false,
   Callback = function(txt)
       targetName = txt
   end
})

FlingTab:CreateButton({
   Name = "🚀 Execute Fling Target",
   Callback = function()
       local target = Players:FindFirstChild(targetName)
       if target then
           flingActive = true
           fling(target)
           autoFlingLoop(target)
       else
           Rayfield:Notify({
               Title = "❌ Error",
               Content = "Username not found!",
               Duration = 3
           })
       end
   end
})

-- // Tab: Tools
local ToolsTab = Window:CreateTab("🛠️ Tools", 4483362458)

ToolsTab:CreateButton({
    Name = "🔁 Rejoin Current Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

ToolsTab:CreateButton({
    Name = "🌐 Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local servers = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local decoded = HttpService:JSONDecode(servers)
        for _, server in pairs(decoded.data) do
            if server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
})

-- Create Credits Tab
local CreditsTab = Window:CreateTab("📜 Credits", 4483362458)

-- Discord Button
local DiscordButton = CreditsTab:CreateButton({
    Name = "Discord",
    Callback = function()
        setclipboard("https://discord.gg/QjsgcpFDDr")
        Rayfield:Notify({
            Title = "📋Link Successfully Saved  ",
            Duration = 3
        })
    end,
})

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local PingLabel = Instance.new("TextLabel")
PingLabel.Position = UDim2.new(1, -120, 0, 5)
PingLabel.Size = UDim2.new(0, 100, 0, 20)
PingLabel.BackgroundTransparency = 1
PingLabel.TextColor3 = Color3.new(1, 1, 1)
PingLabel.TextStrokeTransparency = 0.5
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.Font = Enum.Font.SourceSansBold
PingLabel.TextSize = 14
PingLabel.Text = "Ping: ..."
PingLabel.Parent = game.CoreGui

RunService.RenderStepped:Connect(function()
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	PingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
end)
