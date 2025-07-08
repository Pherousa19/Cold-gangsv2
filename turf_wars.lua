
-- Phase 2B: Turf War System

local TurfOwnership = {}  -- zone_id = gang
local TurfCooldowns = {}  -- cooldowns to prevent spam

CreateThread(function()
    local result = MySQL.query.await("SELECT zone_id, owner_gang FROM turf_control")
    for _, row in pairs(result) do
        TurfOwnership[row.zone_id] = row.owner_gang
    end
end)

RegisterNetEvent("cold-gangs:server:startTurfCapture", function(zoneId)
    local src = source
    local gang = GetPlayerGang(src)
    if not gang or not Config.GangZones[zoneId] then return end

    if TurfCooldowns[zoneId] then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "This turf is on cooldown."} })
        return
    end

    if TurfOwnership[zoneId] == gang then
        TriggerClientEvent("chat:addMessage", src, { args = {"System", "Your gang already owns this turf."} })
        return
    end

    TurfCooldowns[zoneId] = true
    TriggerClientEvent("chat:addMessage", -1, { args = {"Turf Alert", gang .. " is attempting to capture " .. zoneId} })

    SetTimeout(300000, function()
        TurfOwnership[zoneId] = gang
        TurfCooldowns[zoneId] = nil

        MySQL.query.await("REPLACE INTO turf_control (zone_id, owner_gang) VALUES (?, ?)", {
            zoneId, gang
        })

        TriggerClientEvent("cold-gangs:client:updateTurf", -1, zoneId, gang)
        TriggerClientEvent("chat:addMessage", -1, { args = {"Turf Alert", gang .. " now owns " .. zoneId} })
    end)
end)


-- Phase 2C: Passive Turf Rewards (Income + XP)
CreateThread(function()
    while true do
        Wait(10 * 60 * 1000)  -- every 10 minutes

        for zoneId, gang in pairs(TurfOwnership) do
            if gang then
                -- Give turf income
                exports["qb-management"]:AddMoney(gang, 5000)

                -- Give XP
                exports["cold-gangs"]:AddGangXP(gang, 25)

                print("[TURF] $" .. 5000 .. " +25 XP given to " .. gang .. " for controlling " .. zoneId)
            end
        end
    end
end)

-- Phase 2C: Gang XP + Perks Core
local GangXP = {}

function GetGangXP(gang)
    return GangXP[gang] or 0
end

function AddGangXP(gang, amount)
    GangXP[gang] = GetGangXP(gang) + amount
    print("[XP] " .. gang .. " gained " .. amount .. " XP (Total: " .. GangXP[gang] .. ")")
end

exports("AddGangXP", AddGangXP)
exports("GetGangXP", GetGangXP)

-- Optional Perks Table
local GangPerks = {
    [100] = "Stash Size +10",
    [250] = "Weapon Crafting Speed Boost",
    [500] = "Dispatch Jammer",
    [1000] = "Passive Income x2",
}

-- Optional: Unlock Notification
function CheckPerks(gang)
    local xp = GetGangXP(gang)
    for threshold, perk in pairs(GangPerks) do
        if xp >= threshold then
            -- Optional: Notify players in gang
            print("[PERK] " .. gang .. " unlocked: " .. perk)
        end
    end
end


-- XP Persistence Logic

-- Load XP on startup
CreateThread(function()
    local result = MySQL.query.await("SELECT gang, xp FROM gang_xp")
    for _, row in pairs(result) do
        GangXP[row.gang] = row.xp
    end
end)

-- Save XP on resource stop
AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for gang, xp in pairs(GangXP) do
        MySQL.query.await("REPLACE INTO gang_xp (gang, xp) VALUES (?, ?)", { gang, xp })
    end
end)



-- Turf Zones (example)
TurfZones = {
    ["grove_street"] = { name = "Grove Street", x = 12, y = 76, width = 5, height = 8 },
    ["ballas_alley"] = { name = "Ballas Alley", x = 20, y = 60, width = 4, height = 6 },
    ["docks"] = { name = "South Docks", x = 80, y = 90, width = 10, height = 10 }
}

-- Example gang color map
GangColors = {
    ["Grove"] = "#4CAF50",
    ["Ballas"] = "#9C27B0",
    ["Vagos"] = "#FFC107",
    ["Aztecas"] = "#2196F3",
    ["LostMC"] = "#795548",
    ["Triads"] = "#F44336"
}

-- Turf Ownership
TurfOwnership = {
    ["grove_street"] = "Grove",
    ["ballas_alley"] = "Ballas",
    ["docks"] = "Vagos"
}

function GetTurfOverlayData()
    local overlay = {}
    for id, zone in pairs(TurfZones) do
        local owner = TurfOwnership[id] or "Unclaimed"
        table.insert(overlay, {
            name = zone.name,
            x = zone.x,
            y = zone.y,
            width = zone.width,
            height = zone.height,
            color = GangColors[owner] or "#cccccc",
            owner = owner
        })
    end
    return overlay
end
