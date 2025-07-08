local QBCore = exports['qb-core']:GetCoreObject()

-- Check if admin using ACE
local function IsAdmin(src)
    return IsPlayerAceAllowed(src, "group.admin")
end

-- /gangadmin create <gangName>
-- /gangadmin disband <gangName>
-- /gangadmin setleader <id> <gangName>
-- /gangadmin list

RegisterCommand("gangadmin", function(source, args)
    if not IsAdmin(source) then
        TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "No permission." } })
        return
    end

    local sub = args[1]
    if not sub then
        TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "/gangadmin [create/disband/setleader/list]" } })
        return
    end

    if sub == "create" then
        local gang = args[2]
        if not gang then
            TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Usage: /gangadmin create <gangName>" } })
            return
        end
        MySQL.query("INSERT INTO player_gangs (gang) VALUES (?) ON DUPLICATE KEY UPDATE gang = gang", { gang })
        TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Gang created: " .. gang } })

    elseif sub == "disband" then
        local gang = args[2]
        if not gang then
            TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Usage: /gangadmin disband <gangName>" } })
            return
        end
        MySQL.query("DELETE FROM player_gangs WHERE gang = ?", { gang })
        TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Gang disbanded: " .. gang } })

    elseif sub == "setleader" then
        local id = tonumber(args[2])
        local gang = args[3]
        if not id or not gang then
            TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Usage: /gangadmin setleader <playerId> <gangName>" } })
            return
        end

        local target = QBCore.Functions.GetPlayer(id)
        if not target then
            TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Invalid player ID." } })
            return
        end

        target.Functions.SetMetaData("gang", { name = gang, rank = "Boss" })
        TriggerClientEvent("chat:addMessage", id, { args = { "GangAdmin", "You are now Boss of " .. gang } })
        TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Set " .. GetPlayerName(id) .. " as Boss of " .. gang } })

    elseif sub == "list" then
        local results = MySQL.query.await("SELECT * FROM player_gangs")
        for _, row in pairs(results) do
            local line = string.format("[%s] %s (%s)", row.gang or "-", row.citizenid or "-", row.gang_rank or "-")
            TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", line } })
        end
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "GangAdmin", "Unknown subcommand." } })
    end
end, false)
