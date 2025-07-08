local QBCore = exports['qb-core']:GetCoreObject()


-- Phase 5C: /gangadmin Command Suite for QBCore Admins

local function IsAdmin(src)
    return QBCore.Functions.HasPermission(src, "admin")
end

-- /gangadmin create <gang>
RegisterCommand("gangadmin", function(src, args)
    if not IsAdmin(src) then
        TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "No permission." } })
        return
    end

    local sub = args[1]
    if not sub then
        TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "/gangadmin [create/disband/setleader/list]" } })
        return
    end

    if sub == "create" then
        local gang = args[2]
        if not gang then
            TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Usage: /gangadmin create <gangName>" } })
            return
        end
        MySQL.query("INSERT INTO player_gangs (gang) VALUES (?) ON DUPLICATE KEY UPDATE gang = gang", { gang })
        TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Gang created: " .. gang } })

    elseif sub == "disband" then
        local gang = args[2]
        if not gang then
            TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Usage: /gangadmin disband <gangName>" } })
            return
        end
        MySQL.query("DELETE FROM player_gangs WHERE gang = ?", { gang })
        TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Gang disbanded: " .. gang } })

    elseif sub == "setleader" then
        local id = tonumber(args[2])
        local gang = args[3]
        if not id or not gang then
            TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Usage: /gangadmin setleader <playerId> <gangName>" } })
            return
        end

        local target = QBCore.Functions.GetPlayer(id)
        if not target then
            TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Invalid player ID." } })
            return
        end

        target.Functions.SetMetaData("gang", { name = gang, rank = "Boss" })
        TriggerClientEvent("chat:addMessage", id, { args = { "GangAdmin", "You are now Boss of " .. gang } })
        TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Set " .. GetPlayerName(id) .. " as Boss of " .. gang } })

    elseif sub == "list" then
        local results = MySQL.query.await("SELECT * FROM player_gangs")
        for _, row in pairs(results) do
            local line = string.format("[%s] %s (%s)", row.gang, row.citizenid or "none", row.gang_rank or "unranked")
            TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", line } })
        end
    else
        TriggerClientEvent("chat:addMessage", src, { args = { "GangAdmin", "Unknown subcommand." } })
    end
end, false)
