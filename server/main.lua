local QBCore = exports[Config.Core]:GetCoreObject()
local PlayerList = {}

local discordWebhook = "https://discord.com/api/webhooks/"

local function Debug(a, b)
    if Config.Debug then
        print("["..a.."] "..b)
    end
end

local function SendToDiscord(title, message, color, name)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S") 

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({
        username = name or "PappuPlayerList",
        embeds = {{
            title = title,
            description = message,
            color = color,
            footer = {
                text = "This | " .. currentTime 
            }
        }}
    }), { ['Content-Type'] = 'application/json' })
end



local function GetDiscordTag(player)
    for _, identifier in ipairs(GetPlayerIdentifiers(player)) do
        if identifier:sub(1, 8) == "discord:" then
            local discordId = identifier:sub(9)
            return "<@" .. discordId .. ">"
        end
    end
    return "N/A"
end

local function GetSteamID(player)
    for _, identifier in ipairs(GetPlayerIdentifiers(player)) do
        if identifier:sub(1, 6) == "steam:" then
            return identifier:sub(7) 
        end
    end
    return "N/A"
end

local function AddPlayer(source)
    local player = QBCore.Functions.GetPlayer(source)
    if player then
        local identifier = player.PlayerData[Config.UseIdentifier] or player.PlayerData.steam
        local discordTag = GetDiscordTag(source)
        local citizenId = player.PlayerData.citizenid
        local license = player.PlayerData.license
        local steamId = GetSteamID(source)

        PlayerList[source] = {
            src = source,
            identifier = identifier,
            name = player.PlayerData.name,
            discordTag = discordTag,
            citizenid = citizenId,
            license = license,
            steamId = steamId,
        }

        SendToDiscord("Player Joined", 
            "Name: " .. player.PlayerData.name ..
            "\nPlayer ID: " .. source ..
            "\nDiscord Tag: " .. discordTag ..
            "\nCitizen ID: " .. citizenId ..
            "\nLicense: " .. license ..
            "\nSteam ID: " .. steamId, 
            3066993)

        TriggerClientEvent("scoreboard:AddPlayer", -1, PlayerList[source])
        Debug("PappuServer", "Added ["..source.."] to Playerlist")
    end
end

Citizen.CreateThread(function()
    local resourceName = "^2 P4ScriptsFivem Started ("..GetCurrentResourceName()..")"
    print("\n^1----------------------------------------------------------------------------------^7")
    print(resourceName)
    print("^1----------------------------------------------------------------------------------^7")
end)

local function RemovePlayer(source)
    if PlayerList[source] then
        local playerData = PlayerList[source]


        SendToDiscord("Player Left", 
            "Name: " .. playerData.name ..
            "\nPlayer ID: " .. playerData.src ..
            "\nDiscord Tag: " .. playerData.discordTag ..
            "\nCitizen ID: " .. playerData.citizenid ..
            "\nLicense: " .. playerData.license ..
            "\nSteam ID: " .. playerData.steamId,
            15158332)

        PlayerList[source] = nil
        TriggerClientEvent("scoreboard:RemovePlayer", -1, { src = source })
        Debug("PappuServer", "Removed ["..source.."] from Playerlist")
    end
end

local function GetAllPlayers()
    local players = {}
    for src, data in pairs(PlayerList) do
        players[#players + 1] = data
    end
    return players
end

RegisterNetEvent('scoreboard:AddPlayer', function()
    local src = source
    AddPlayer(src)
end)

RegisterNetEvent('scoreboard:RemovePlayer', function()
    local src = source
    RemovePlayer(src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    RemovePlayer(src)
end)

QBCore.Functions.CreateCallback('scoreboard:GetTotalPlayers', function(source, cb)
    local players = GetAllPlayers()
    cb(#players)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Wait(1000)
    for _, playerId in ipairs(GetPlayers()) do
        AddPlayer(playerId)
    end
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    AddPlayer(src)
end)
