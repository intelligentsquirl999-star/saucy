-- Sauce Core.lua – Steal a Brainrot Rare Pet Auto Joiner (Dec 2025)
-- Works on Wave / Solara / Delta / Codex

local PlaceId = 109983668079237
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local running = true
local minValue = 8000000  -- Change this to make it stricter (8M+ = God/Mythic/Secret servers)

local function joinServer(jobId)
    TS:TeleportToPlaceInstance(PlaceId, jobId, player)
end

local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success then return Http:JSONDecode(result).data end
    return {}
end

local function hasRare()
    local total = 0
    for _, p in Players:GetPlayers() do
        if p ~= player and p.Character then
            for _, tool in p.Backpack:GetChildren() do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    local val = tool:FindFirstChild("Value")
                    if val and val:IsA("IntValue") then
                        total = total + val.Value
                    end
                    if name:find("god") or name:find("mythic") or name:find("secret") or name:find("celestial") then
                        return true
                    end
                end
            end
        end
    end
    return total >= minValue
end

spawn(function()
    while running and wait(6) do
        if not hasRare() then
            local servers = getServers()
            for _, server in pairs(servers) do
                if server.playing < 40 and server.id ~= game.JobId then
                    joinServer(server.id)
                    wait(8)
                    break
                end
            end
        end
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Sauce Activated";
    Text = "Hunting rare Brainrot servers...";
    Duration = 6;
})
print("Sauce Core loaded – stealing rares now")
