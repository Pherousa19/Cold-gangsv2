local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("ColdGangs:GetMembers", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return cb(nil) end

    local identifier = Player.PlayerData.citizenid
    local gang = MySQL.single.await("SELECT gang_id FROM cold_gang_members WHERE identifier = ?", {identifier})
    if not gang then return cb(nil) end

    local members = MySQL.query.await([[
        SELECT m.identifier, m.rank, m.last_active, p.charinfo, p.job, p.citizenid
        FROM cold_gang_members m
        LEFT JOIN players p ON p.citizenid = m.identifier
        WHERE m.gang_id = ?
    ]], {gang.gang_id})

    cb(members)
end)

-- Phase 2A: Gang Member Management

RegisterNetEvent("cold-gangs:server:inviteMember", function(targetId)
    local src = source
    local gang = GetPlayerGang(src)
    if not gang then return end

    if not CheckGangAccess(src, gang, "officer") then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "You need to be an Officer to invite members."} })
        return
    end

    if GetPlayerGang(targetId) then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "That player is already in a gang."} })
        return
    end

    exports.oxmysql:insert("INSERT INTO player_gangs (citizenid, gang, gang_rank) VALUES (?, ?, ?)", {
        GetPlayerCitizenId(targetId), gang, "recruit"
    })

    TriggerClientEvent("chat:addMessage", src, { args = {"System", "Player invited to your gang."} })
    TriggerClientEvent("chat:addMessage", targetId, { args = {"System", "You’ve been invited to " .. gang} })
end)

RegisterNetEvent("cold-gangs:server:kickMember", function(targetId)
    local src = source
    local gang = GetPlayerGang(src)
    if not gang then return end

    if not CheckGangAccess(src, gang, "officer") then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "You need to be an Officer to kick members."} })
        return
    end

    if GetPlayerGang(targetId) ~= gang then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "They’re not in your gang."} })
        return
    end

    exports.oxmysql:update("DELETE FROM player_gangs WHERE citizenid = ?", { GetPlayerCitizenId(targetId) })
    TriggerClientEvent("chat:addMessage", src, { args = {"System", "Member removed from your gang."} })
    TriggerClientEvent("chat:addMessage", targetId, { args = {"System", "You’ve been kicked from " .. gang} })
end)

RegisterNetEvent("cold-gangs:server:setRank", function(targetId, newRank)
    local src = source
    local gang = GetPlayerGang(src)
    if not gang then return end

    if not CheckGangAccess(src, gang, "leader") then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "Only the Leader can set ranks."} })
        return
    end

    if GetPlayerGang(targetId) ~= gang then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "They’re not in your gang."} })
        return
    end

    exports.oxmysql:update("UPDATE player_gangs SET gang_rank = ? WHERE citizenid = ?", {
        newRank, GetPlayerCitizenId(targetId)
    })

    TriggerClientEvent("chat:addMessage", src, { args = {"System", "Member rank updated."} })
    TriggerClientEvent("chat:addMessage", targetId, { args = {"System", "Your gang rank is now: " .. newRank} })
end)
