-- Sauce Core.lua – ONLY 17M+ PER SECOND SERVERS (Dec 2025)
local PlaceId = 109983668079237
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local MIN_RATE = 17000000  -- 17 million+ per second
local running = true

local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(game.HttpGet, game, url)
    if s then return Http:JSONDecode(r).data end
    return {}
end

local function has17MPlus()
    for _, p in Players:GetPlayers() do
        if p ~= player and p.Character then
            for _, tool in p.Backpack:GetChildren() do
                if tool:IsA("Tool") then
                    local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                    if rate and rate:IsA("IntValue") and rate.Value >= MIN_RATE then
                        return true
                    end
                end
            end
        end
    end
    return false
end

spawn(function()
    while running and wait(5) do
        if not has17MPlus() then
            local servers = getServers()
            for _, srv in servers do
                if srv.playing < 45 and srv.id ~= game.JobId then
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, player)
                    wait(9)
                    break
                end
            end
        end
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Sauce 17M+ Active",
    Text = "Only joining servers with 17M+/s pets",
    Duration = 8
})

print("Sauce 17M+ per second hunter running")
