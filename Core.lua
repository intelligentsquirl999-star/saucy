-- SAUCE Core.lua – FIXED RESTRICTED PLACE ERROR (Dec 2025)
if getgenv().SAUCE_HUNTER then return end
getgenv().SAUCE_HUNTER = true

local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local SG = game:GetService("StarterGui")
local PL = game.Players.LocalPlayer
local PlaceId = 109983668079237

-- Force HttpService
pcall(function() Http:SetHttpEnabled(true) end)

local rares = {
    "money money man","money money puggy","las sis","las capuchinas",
    "la vacca saturno saturnita","la vacca staturno saturnita","blackhole goat",
    "bisonte giuppitere","chachechi","trenostruzzo turbo","los matteos",
    "chimpanzini spiderini","graipuss medussi","noo my hotspot","sahur combinasion",
    "pot hotspot","chicleteira bicicleteira","los nooo my hotspotsitos",
    "la grande combinasion","los combinasionas","nuclearo dinossauro",
    "karkerkar combinasion","los hotspotsitos","tralaledon","strawberry elephant",
    "dragon cannelloni","spaghetti tualetti","garama and madundung",
    "ketchuru and masturu","la supreme combinasion","los bros","coco elefanto",
    "cocofanto elefanto","piccione macchina","bombombini gusini","bombardiro crocodilo",
    "noobini pizzanini","brainrot god","magiani tankiani","dojonini assassini"
}

local function hasRare()
    for _, p in game.Players:GetPlayers() do
        if p ~= PL then
            local function check(container)
                for _, tool in container:GetChildren() do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        for _, r in rares do
                            if n:find(r) then
                                SG:SetCore("SendNotification",{Title="SAUCE FOUND!",Text=tool.Name.." (17M+)",Duration=30})
                                return true
                            end
                        end
                        local rate = tool:FindFirstChild("Rate") or tool:FindFirstChild("PerSecond") or tool:FindFirstChild("Value")
                        if rate and rate:IsA("NumberValue") and rate.Value >= 17000000 then
                            SG:SetCore("SendNotification",{Title="SAUCE FOUND!",Text=tool.Name.." → "..rate.Value.." /s",Duration=30})
                            return true
                        end
                    end
                end
            end
            check(p.Backpack)
            if p.Character then check(p.Character) end
        end
    end
    return false
end

task.spawn(function()
    local hopRetries = 0
    while task.wait(3) do
        if hasRare() then
            SG:SetCore("SendNotification",{Title="SAUCE",Text="17M+ FOUND – STAYING HERE",Duration=15})
            break
        end

        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local ok, res = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if not ok or not res or not res.data then
            SG:SetCore("SendNotification",{Title="Sauce",Text="API error – retrying...",Duration=5})
            task.wait(5)
            continue
        end

        local hopped = false
        for _, srv in res.data do
            if srv.playing < 70 and srv.playing > 0 and srv.id ~= game.JobId then
                local success, err = pcall(function()
                    TS:TeleportToPlaceInstance(PlaceId, srv.id, PL)
                end)
                if success then
                    SG:SetCore("SendNotification",{Title="Sauce",Text="Hopping to "..srv.playing.." player server",Duration=5})
                    hopped = true
                    hopRetries = 0
                    break
                else
                    if err:find("restricted") then
                        print("Skipped restricted server:", srv.id)  -- Debug in F9
                        continue  -- Skip this server, try next
                    end
                    print("Teleport error:", err)  -- Debug in F9
                end
            end
        end

        if not hopped then
            hopRetries = hopRetries + 1
            if hopRetries > 5 then
                SG:SetCore("SendNotification",{Title="Sauce",Text="No good servers – waiting 30s",Duration=5})
                task.wait(30)
                hopRetries = 0
            else
                task.wait(10)
            end
        else
            task.wait(15)  -- Wait for teleport to complete
        end
    end
end)

SG:SetCore("SendNotification",{Title="Sauce 17M+",Text="Hunter ACTIVE – skips restricted servers",Duration=8})
print("Sauce hunter running – open F9 for debug")
