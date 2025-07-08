
RegisterServerEvent("cold_gangs:adminCreateGang", function(name)
    local src = source
    print(("^3[ADMIN]^0 %s is creating gang: %s"):format(GetPlayerName(src), name))
end)

RegisterServerEvent("cold_gangs:adminDisbandGang", function(name)
    local src = source
    print(("^3[ADMIN]^0 %s is disbanding gang: %s"):format(GetPlayerName(src), name))
end)

RegisterServerEvent("cold_gangs:adminSetLeader", function(name)
    local src = source
    print(("^3[ADMIN]^0 %s is setting leader to: %s"):format(GetPlayerName(src), name))
end)

RegisterServerEvent("cold_gangs:adminListGangs", function()
    local src = source
    print(("^3[ADMIN]^0 %s requested a gang list."):format(GetPlayerName(src)))
end)
