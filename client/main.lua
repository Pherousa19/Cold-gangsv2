
-- Fixed client/main.lua with safe NUI + trigger bindings
RegisterNetEvent('openGangTablet', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openTablet" })
    TriggerServerEvent('cold_gangs:getTabletData')
end)

RegisterNetEvent('cold_gangs:updateTabletData', function(data)
    SendNUIMessage({ action = "updateTabletData", data = data })
end)

RegisterNUICallback("closeTablet", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Admin NUI callbacks
RegisterNUICallback("adminCreateGang", function(data, cb)
    TriggerServerEvent("cold_gangs:adminCreateGang", data)
    cb("ok")
end)

RegisterNUICallback("adminDisbandGang", function(data, cb)
    TriggerServerEvent("cold_gangs:adminDisbandGang", data)
    cb("ok")
end)

RegisterNUICallback("adminSetLeader", function(data, cb)
    TriggerServerEvent("cold_gangs:adminSetLeader", data)
    cb("ok")
end)

-- Ensure tablet closes on resource stop
AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "forceClose" })
    end
end)
