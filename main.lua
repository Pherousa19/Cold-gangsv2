local QBCore = exports['qb-core']:GetCoreObject()

-- Example Event Handler
RegisterNetEvent("cold-gangs:server:example", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        print("[Cold-Gangs] Example event triggered by", Player.PlayerData.citizenid)
    end
end)
