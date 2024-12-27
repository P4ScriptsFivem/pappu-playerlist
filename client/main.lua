local QBCore = exports[Config.Core]:GetCoreObject()
local IsPlayerListOpen = false
local PlayerList = {}

local function Debug(a, b)
    if Config.Debug then
        print("["..a.."] "..b)
    end
end

local function PlayAnimation(isPlay, animDict, animName, duration)
    if Config.PlayEmote then
        if isPlay then
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Wait(0)
            end
            TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
            RemoveAnimDict(animDict)
        else
            StopAnimTask(PlayerPedId(), animDict, animName, 1.0)
        end
    end
end

local function TextDraw(data)
    local onScreen, screenX, screenY = World3dToScreen2d(data.coords.x, data.coords.y, data.coords.z)
    if onScreen then
        local camCoords = GetGameplayCamCoords()
        local distance = #(data.coords - camCoords)
        local fov = (1 / GetGameplayCamFov()) * 75
        local scale = (1 / distance) * (4) * fov * (data.fontsize)     
        local r, g, b = data.r, data.b, data.b
        SetTextScale(0.0, scale)
        SetTextFont(data.fontstyle)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(data.text)
        DrawText(screenX, screenY)
    end
end

local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

	coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or  5.0

    for i = 1, #players do
        local player = players[i]
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

local function ShowID()
    if Config.EnableIDAboveHead then
        local show = true
        CreateThread(function()
            while show do
                local sleep = 100
                if IsPlayerListOpen then
                    for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                        sleep = 0
                        local playerId = GetPlayerServerId(player)
                        local playerPed = GetPlayerPed(player)
                        local playerCoords = GetEntityCoords(playerPed)                
                        TextDraw({coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z+1.0), fontsize = 0.5, fontstyle = 2, r = 255, g = 255, b = 255, text = playerId})
                    end
                    if Config.PlayEmote then
                        if not IsEntityPlayingAnim(PlayerPedId(), Config.AnimDict, Config.AnimEmote, 3) then
                            PlayAnimation(true, Config.AnimDict, Config.AnimEmote, -1)
                        end
                    end
                else
                    show = false
                end
                Wait(sleep)
            end
        end)
    end
end

local function InitializeList()
    local list = {}
    for k, v in pairs(PlayerList) do
        list[k] = {iden = v.identifier, src = v.src}
    end    
    Debug("PappuSingle", json.encode(list))
    SendNUIMessage({
        action = "setup",
        items = list
    })
end

local function DisableControls()
    if Config.DisableControls then
        local isdisabled = true
        CreateThread(function()
            while isdisabled do
                if IsPlayerListOpen then
                    DisablePlayerFiring(PlayerPedId(), true)
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 38, true)
                    DisableControlAction(0, 45, true)
                    DisableControlAction(0, 46, true)
                    DisableControlAction(0, 245, true)
                    DisableControlAction(0, 249, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 264, true)
                    DisableControlAction(0, 257, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 143, true)
                    DisableControlAction(0, 322, true)
                else
                    isdisabled = false
                end
                Wait(4)
            end
        end)
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()        
    TriggerServerEvent("scoreboard:AddPlayer")
    Wait(1000)
    InitializeList()
    Debug("PappuSingle", "Loaded Playerlist Data")
end)

RegisterNetEvent("scoreboard:RemovePlayer", function(data)
    PlayerList[data.src] = nil
    Debug("PappuSingle", "Removed ["..data.src.."] from Playerlist")
end)

RegisterNetEvent("scoreboard:AddPlayer", function(data)
    PlayerList[data.src] = data
    Debug("PappuSingle", "Added ["..data.src.."] to Playerlist")
end)

RegisterNetEvent("scoreboard:AddAllPlayers", function(data)    
    PlayerList[data.src] = data 
    Debug("PappuMultiple", "Added ["..data.src.."] to Playerlist")
end)

RegisterNUICallback('closelist', function(_, cb)
    if not IsPlayerListOpen then return end
    PlayAnimation(false, Config.AnimDict, Config.AnimEmote, -1)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    IsPlayerListOpen = false
    Debug("PappuSingle", "Closed Playerlist")
    cb('ok')
end)

if Config.Debug then
    CreateThread(function()        
        while true do
            Wait(1)
            if NetworkIsSessionStarted() then
                TriggerServerEvent("scoreboard:AddPlayer")
                Wait(1000)
                InitializeList()
                Debug("PappuSingle", "Loaded Playerlist Data")
                return
            end
        end
    end)
end

RegisterCommand('+scoreboard', function()
    if IsPlayerListOpen and not Config.CloseInstantly then
        SendNUIMessage({action = "close"})
    else
        InitializeList()
        PlayAnimation(true, Config.AnimDict, Config.AnimEmote, -1)
        QBCore.Functions.TriggerCallback('scoreboard:GetTotalPlayers', function(players)
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(true)
            SendNUIMessage({
                action = "open",
                players = players,
                maxPlayers = Config.MaxPlayers,
            })
            IsPlayerListOpen = true
            DisableControls()
            ShowID()
            Debug("PappuSingle", "Opened Playerlist")
        end)
        return 
    end
end, false)

if Config.CloseInstantly then
    RegisterCommand('-scoreboard', function()
        SendNUIMessage({action = "close"})
        Debug("PappuSingle", "Closed Playerlist")
    end, false)
end

RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)