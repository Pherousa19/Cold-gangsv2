

-- Phase 4A: Drug Selling System

local SellingCooldown = {}

RegisterNetEvent("cold-gangs:server:sellDrug", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if SellingCooldown[src] and os.time() - SellingCooldown[src] < 30 then
        TriggerClientEvent("chat:addMessage", src, { args = {"Dealer", "Slow down, you're too hot right now!"} })
        return
    end

    -- Check for sellable drugs (loop through finalItems from config)
    for k, drug in pairs(Config.Drugs) do
        local item = drug.finalItem
        if item and Player.Functions.GetItemByName(item) then
            local qty = Player.Functions.GetItemByName(item).amount or 0
            if qty > 0 then
                local sellPrice = math.random(120, 500)  -- Placeholder value
                Player.Functions.RemoveItem(item, 1)
                Player.Functions.AddMoney("cash", sellPrice)

                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "remove")
                TriggerClientEvent("chat:addMessage", src, { args = {"Dealer", "Sold " .. item .. " for $" .. sellPrice} })

                SellingCooldown[src] = os.time()

                -- Optional: trigger police alert (10% chance)
                if math.random(1, 100) <= 10 then
                    TriggerEvent("cold-gangs:server:drugAlert", GetEntityCoords(GetPlayerPed(src)), item)
                end

                return  -- Stop after 1 item sale per command
            end
        end
    end

    TriggerClientEvent("chat:addMessage", src, { args = {"Dealer", "You have nothing sellable."} })
end)

-- Basic police alert hook (could be expanded)
RegisterNetEvent("cold-gangs:server:drugAlert", function(coords, item)
    TriggerClientEvent("chat:addMessage", -1, { args = {"Police Scanner", "Possible drug sale of " .. item .. " at location."} })
end)


-- Phase 4B: Turf-Influenced Pricing + Drug Sale Logs

local function GetZoneFromCoords(coords)
    for zoneId, data in pairs(Config.GangZones) do
        for _, box in pairs(data.parts) do
            local x1, y1, x2, y2 = box.x1 or box[1], box.y1 or box[2], box.x2 or box[3], box.y2 or box[4]
            local minX, maxX = math.min(x1, x2), math.max(x1, x2)
            local minY, maxY = math.min(y1, y2), math.max(y1, y2)
            if coords.x >= minX and coords.x <= maxX and coords.y >= minY and coords.y <= maxY then
                return zoneId
            end
        end
    end
    return nil
end

AddEventHandler("cold-gangs:server:sellDrug", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if SellingCooldown[src] and os.time() - SellingCooldown[src] < 30 then
        TriggerClientEvent("chat:addMessage", src, { args = {"Dealer", "You're too hot. Wait a bit!"} })
        return
    end

    local gang = GetPlayerGang(src)
    local coords = GetEntityCoords(GetPlayerPed(src))
    local zoneId = GetZoneFromCoords(coords)
    local turfOwner = TurfOwnership and TurfOwnership[zoneId] or nil

    for k, drug in pairs(Config.Drugs) do
        local item = drug.finalItem
        if item and Player.Functions.GetItemByName(item) then
            local qty = Player.Functions.GetItemByName(item).amount or 0
            if qty > 0 then
                local basePrice = math.random(100, 300)
                local bonus = 1.0

                -- Loyalty bonus
                if gang and turfOwner and turfOwner == gang then
                    bonus = bonus + 0.25  -- 25% bonus for home turf
                end

                local xpBoost = gang and GetGangXPBoost(gang) or 0
                local sellPrice = math.floor(basePrice * (bonus + xpBoost))

                Player.Functions.RemoveItem(item, 1)
                Player.Functions.AddMoney("cash", sellPrice)

                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "remove")
                TriggerClientEvent("chat:addMessage", src, { args = {"Dealer", "Sold " .. item .. " for $" .. sellPrice} })

                SellingCooldown[src] = os.time()

                -- Optional: Police alert
                if math.random(1, 100) <= 10 then
                    TriggerEvent("cold-gangs:server:drugAlert", coords, item)
                end

                -- Save to gang sale stats
                if gang then
                    exports.oxmysql:execute("INSERT INTO drug_sales (gang, drug_type, total, last_sale) VALUES (?, ?, 1, CURRENT_TIMESTAMP) ON DUPLICATE KEY UPDATE total = total + 1, last_sale = CURRENT_TIMESTAMP", {
                        gang, item
                    })
                end

                return
            end
        end
    end

    TriggerClientEvent("chat:addMessage", src, { args = {"Dealer", "You have nothing sellable."} })
end)


-- Phase 4C: Gang XP-Based Pricing Boost + Purity System

-- Helper to calculate purity boost
local function GetGangXPBoost(gang)
    local xp = exports["cold-gangs"]:GetGangXP(gang) or 0
    local boost = math.min(math.floor(xp / 100) * 0.05, 0.5) -- Max 50% boost
    return boost
end

-- Optionally extend drug items with purity metadata (if desired)
-- e.g., stored as item.info.purity during crafting
-- Not yet used directly, but ready to expand
