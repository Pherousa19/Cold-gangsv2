

-- Phase 3D: Drug Lab Processing System

RegisterNetEvent("cold-gangs:server:processDrug", function(drugType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local drug = Config.Drugs[drugType]

    if not drug or drug.type ~= "synth" then return end

    -- Check required ingredients
    for _, item in pairs(drug.ingredients) do
        if Player.Functions.GetItemByName(item) == nil then
            TriggerClientEvent("chat:addMessage", src, { args = {"Lab", "Missing ingredient: " .. item} })
            return
        end
    end

    -- Remove ingredients
    for _, item in pairs(drug.ingredients) do
        Player.Functions.RemoveItem(item, 1)
    end

    -- Add finished drug
    Player.Functions.AddItem(drug.finalItem, 1)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[drug.finalItem], "add")
    TriggerClientEvent("chat:addMessage", src, { args = {"Lab", "Successfully synthesized: " .. drug.label} })
end)


-- Phase 5A: Lab Access Checks (XP / Turf / Open)

local function IsLabUsable(src, labId)
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = GetPlayerGang(src)
    local xp = exports["cold-gangs"]:GetGangXP(gang) or 0
    local coords = GetEntityCoords(GetPlayerPed(src))
    local lab = Config.Labs[labId]

    if not lab then return false, "Unknown lab." end
    if #(coords - lab.coords) > 50.0 then return false, "You're too far from the lab." end

    if lab.access == "open" then return true end

    if lab.access == "xp" and xp >= (lab.requiredXP or 0) then
        return true
    elseif lab.access == "xp" then
        return false, "Your gang needs more XP to use this lab."
    end

    if lab.access == "turf" then
        local turf = lab.turf
        if turf and TurfOwnership and TurfOwnership[turf] == gang then
            return true
        else
            return false, "This lab is locked to turf: " .. turf
        end
    end

    return false, "Access denied."
end

-- Wrap processDrug with access check
RegisterNetEvent("cold-gangs:server:useLabToProcess", function(labId, drugType)
    local src = source
    local allowed, msg = IsLabUsable(src, labId)
    if not allowed then
        TriggerClientEvent("chat:addMessage", src, { args = {"Lab", msg or "Access denied."} })
        return
    end

    TriggerEvent("cold-gangs:server:processDrug", src, drugType)
end)
