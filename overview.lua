local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("ColdGangs:GetOverview", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return cb(nil) end

    local identifier = Player.PlayerData.citizenid
    local result = MySQL.single.await("SELECT g.*, (SELECT COUNT(*) FROM cold_gang_turfs WHERE gang_id = g.id) as turf_count FROM cold_gangs g INNER JOIN cold_gang_members m ON g.id = m.gang_id WHERE m.identifier = ?", {identifier})
    if not result then return cb(nil) end

    local income = MySQL.scalar.await("SELECT SUM(income) FROM cold_gang_turfs WHERE gang_id = ?", {result.id}) or 0

    cb({
        name = result.label,
        rep = result.reputation,
        bank = result.bank_money,
        turf_count = result.turf_count,
        income = income,
        color = result.color,
        upgrades = json.decode(result.metadata or "{}"),
        logo = result.logo or nil
    })
end)