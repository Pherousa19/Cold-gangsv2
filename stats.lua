
-- Phase 4D: Export Drug Sales Stats
RegisterNetEvent("cold-gangs:server:getDrugStats", function()
    local src = source
    local results = MySQL.query.await("SELECT * FROM drug_sales ORDER BY total DESC LIMIT 50")
    TriggerClientEvent("cold-gangs:client:sendDrugStats", src, results)
end)
