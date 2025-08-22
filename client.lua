SetNuiFocus(true, true)
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)


local showC = 0
local cnm = 0
local vehHud = 0

RegisterCommand('cinematic', function()
    showC = 1 - showC
    if showC == 1 then
        DisplayRadar(false)
    else
        DisplayRadar(true)
    end
    cnm = showC
    SendNuiMessage(json.encode({
        action = "cinema",
        showC = showC,
    }))

end)


CreateThread(function()
    
    local minimap = RequestScaleformMovie("minimap") 
    SetMinimapComponentPosition("minimap", "L", "B", -0.01, -0.022, 0.160, 0.220)
    SetMinimapComponentPosition("minimap_mask", "L", "B", -0.01, -0.022, 0.160, 0.220)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.039, 0.002, 0.286, 0.267)

    SetRadarBigmapEnabled(true, false)
    Wait(500)
    SetRadarBigmapEnabled(false, false)
    while true do
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()


        local playerPed = PlayerPedId()
        local health = GetEntityHealth(playerPed) -100
        local armour = GetPedArmour(playerPed)
        local hunger = 0
        local thirst = 0
        local stm = GetPlayerSprintStaminaRemaining(PlayerId())
        TriggerEvent('esx_status:getStatus', 'hunger', function(h)
            hunger = h.getPercent()
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(t)
            thirst = t.getPercent()
        end)
        SendNuiMessage(json.encode({
            action = "update",
            healthGlobal = health,
            armourGlobal = armour,
            hungerGlobal = hunger,
            thirstGlobal = thirst,
            stm = stm,
        }))
        local x, y, z = table.unpack(GetEntityCoords(playerPed))
        local streetHash, crossingHash = GetStreetNameAtCoord(x, y, z)
        local streetName = GetStreetNameFromHashKey(streetHash)
        local crossingName = GetStreetNameFromHashKey(crossingHash)
        local job = ESX.PlayerData.job.name
        local grade = ESX.PlayerData.job.grade_name

        local bankmoney = 0
        for _, account in pairs(ESX.PlayerData.accounts) do
            if account.name == 'bank' then
                bankmoney = account.money
            end
        end
        SendNuiMessage(json.encode({
            action = "hud2",
            street = streetName,
            job = job,
            grade = grade,
            money = bankmoney
        }))

        TriggerEvent('vehMap')
        TriggerEvent('vehSpeed')
        Wait(100)
    end
end)



RegisterNetEvent('vehMap')
AddEventHandler('vehMap', function()
    local playerPed = PlayerPedId()
    Wait(100)
    if IsPedInAnyVehicle(playerPed, false) and cnm==0 then
        DisplayRadar(true)
        vehHud = 1
    else
        DisplayRadar(false)
        vehHud = 0
    end
    SendNuiMessage(json.encode({
        action = 'playerVeh',
        vehHud = vehHud,
    }))
end)
RegisterNetEvent('vehSpeed')
AddEventHandler('vehSpeed', function()
    local ped = PlayerPedId()
    local speed = 0
    local fuel = 0
    local eng = 0

    if IsPedInAnyVehicle(ped, false) then
        veh = GetVehiclePedIsIn(ped, false)
        speed = GetEntitySpeed(veh) * 2.236936
        fuel = GetVehicleFuelLevel(veh)
        eng = GetVehicleEngineHealth(veh)
    end

    SendNuiMessage(json.encode({
        action = "vehSp",
        speed = speed,
        fuel = fuel,
        eng = eng,
    }))
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    for i=1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == account.name then
            ESX.PlayerData.accounts[i] = account
        end
    end
end)
