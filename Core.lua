-- Sauce Core.lua – NAME + RATE DETECTION (17M+/s Rares, Dec 2025)
local PlaceId = 109983668079237
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local MIN_RATE = 17000000  -- 17M+ fallback

-- HIGH-VALUE PET NAMES (from game data – add yours here)
local rare_names = {
    "money money man", "money money puggy", "las sis", "las capuchinas",
    "la vacca saturno saturnita", "la vacca staturno saturnita", "blackhole goat",
    "bisonte giuppitere", "chachechi", "trenostruzzo turbo", "los matteos",
    "chimpanzini spiderini", "graipuss medussi", "noo my hotspot",
    "sahur combinasion", "pot hotspot", "chicleteira bicicleteira",
    "los nooo my hotspotsitos", "la grande combinasion", "los combinasionas",
    "nuclearo dinossauro", "karkerkar combinasion", "los hotspotsitos",
    "tralaledon", "strawberry elephant", "dragon cannelloni",
    "spaghetti tualetti", "garama and madundung", "ketchuru and masturu",
    "la supreme combinasion", "los bros", "coco elefanto", "cocofanto elefanto",
    "piccione macchina", "bombombini gusini", "bombardiro crocodilo",
    -- ADD YOUR PET NAMES HERE (lowercase)
}

local running = true

local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(game.HttpGet, game, url)
    if s then return Http:JSONDecode(r).data end
    return {}
end

local function hasRare()
    for _, p in Players:GetPlayers() do
        if p ~= player then
            -- Backpack
            for _, tool in p.Backpack:GetChildren() do
                if tool:IsA("Tool") then
                    local name_lower = tool.Name:lower()
                    -- Name check
                    for _, rare in rare_names do
                        if string.find(name_lower, rare) then return true end
                    end
                    -- Rate check fallback
                    local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                    if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                        return true
                    end
                end
            end
            -- Equipped (Character)
            if p.Character then
                for _, tool in p.Character:GetChildren() do
                    if tool:IsA("Tool") then
                        local name_lower = tool.Name:lower()
                        for _, rare in rare_names do
                            if string.find(name_lower, rare) then return true end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= MIN_RATE then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

spawn(function()
    while running and wait(4) do  -- Faster scan
        if not hasRare() then
            local servers = getServers()
            for _, srv in servers do
                if srv.playing < 40 and srv.id ~= game.JobId then
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, player)
                    wait(8)
                    break
                end
            end
        end
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Sauce Name Hunter v3",
    Text = "Scanning names + rates for rares...",
    Duration = 8
})

print("Sauce name + rate hunter ACTIVE")
