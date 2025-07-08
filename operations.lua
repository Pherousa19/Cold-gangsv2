Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.Operations = {}

function ColdGangs:StartKidnapping(playerId, targetId)
    local Player = self:GetPlayer(playerId)
    local Target = self:GetPlayer(targetId)
    
    if not Player or not Target then return false end
    
    local playerGang = self:GetPlayerGang(Player)
    if not playerGang then return false end
    
    -- Check if target is in a safe zone
    TriggerClientEvent('cold-gangs:client:checkSafeZone', playerId, targetId)
    
    -- Start kidnapping process
    self.Operations.ActiveKidnappings[targetId] = {
        kidnapper = playerId,
        gang = playerGang,
        startTime = os.time()
    }
    
    -- Notify target
    TriggerClientEvent('cold-gangs:client:beingKidnapped', targetId, playerId)
    
    -- Send dispatch alert
    local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
    self:SendDispatchAlert('kidnapping', targetCoords, {
        suspect = GetPlayerName(playerId),
        victim = GetPlayerName(targetId)
    })
    
    return true
end

function ColdGangs:StartRacketeering(playerId, businessId)
    local Player = self:GetPlayer(playerId)
    if not Player then return false end
    
    local playerGang = self:GetPlayerGang(Player)
    if not playerGang then return false end
    
    -- Check if business is already being extorted
    if self.Operations.ExtortedBusinesses[businessId] then
        local lastExtortion = self.Operations.ExtortedBusinesses[businessId].time
        if os.time() - lastExtortion < 86400 then -- 24 hours
            return false, 'This business was recently extorted!'
        end
    end
    
    -- Start racketeering
    self.Operations.ExtortedBusinesses[businessId] = {
        gang = playerGang,
        time = os.time(),
        amount = math.random(1000, 5000)
    }
    
    -- Give money to gang
    local amount = self.Operations.ExtortedBusinesses[businessId].amount
    self:UpdateGangBank(playerGang, amount)
    
    -- Update reputation
    self:UpdateGangReputation(playerGang, 20)
    
    -- Chance of police response
    if math.random() < 0.3 then
        local coords = GetEntityCoords(GetPlayerPed(playerId))
        self:SendDispatchAlert('racketeering', coords, {
            gang = playerGang
        })
    end
    
    return true, amount
end


-- Phase 3B: Drug Planting & Harvesting
local DrugPlants = {}
local nextPlantId = 1

-- Planting handler
RegisterNetEvent("cold-gangs:server:plantDrug", function(drugType, coords)
    local src = source
    local drug = Config.Drugs[drugType]
    if not drug or drug.type ~= "plant" then return end

    local id = nextPlantId
    nextPlantId = nextPlantId + 1

    local growTime = (drug.growTime or 60) * 60 * 1000  -- mins to ms
    local plantedAt = os.time()

    DrugPlants[id] = {
        id = id,
        drugType = drugType,
        plantedAt = plantedAt,
        growTime = growTime,
        coords = coords,
        src = src,
        harvested = false
    }

    print("[DRUG] Planted " .. drugType .. " (ID: " .. id .. ") at " .. json.encode(coords))

    -- Save to DB
    exports.oxmysql:insert("INSERT INTO drug_plants (id, drug_type, planted_at, x, y, z) VALUES (?, ?, ?, ?, ?, ?)", {
        id, drugType, plantedAt, coords.x, coords.y, coords.z
    })

    -- Timer to make it harvestable
    SetTimeout(growTime, function()
        if DrugPlants[id] then
            DrugPlants[id].ready = true
            TriggerClientEvent("cold-gangs:client:plantReady", -1, id, coords, drugType)
        end
    end)
end)

-- Harvesting handler
RegisterNetEvent("cold-gangs:server:harvestPlant", function(plantId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local plant = DrugPlants[plantId]
    if not plant or plant.harvested or not plant.ready then return end

    local drugType = plant.drugType
    local drug = Config.Drugs[drugType]
    if not drug then return end

    -- Mark as harvested
    plant.harvested = true
    TriggerClientEvent("cold-gangs:client:removePlant", -1, plantId)

    -- Reward player
    Player.Functions.AddItem(drug.finalItem, 1)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[drug.finalItem], "add")

    -- Cleanup DB
    exports.oxmysql:execute("DELETE FROM drug_plants WHERE id = ?", { plantId })

    print("[DRUG] Harvested " .. drugType .. " plant (ID: " .. plantId .. ")")
end)

-- On resource start: reload existing unharvested plants
CreateThread(function()
    local result = exports.oxmysql:executeSync("SELECT * FROM drug_plants")
    for _, row in ipairs(result) do
        local timeLeft = (row.planted_at + (Config.Drugs[row.drug_type].growTime or 60) * 60) - os.time()
        local id = row.id

        DrugPlants[id] = {
            id = id,
            drugType = row.drug_type,
            plantedAt = row.planted_at,
            growTime = (Config.Drugs[row.drug_type].growTime or 60) * 60 * 1000,
            coords = vector3(row.x, row.y, row.z),
            ready = timeLeft <= 0,
            harvested = false
        }

        if timeLeft > 0 then
            SetTimeout(timeLeft * 1000, function()
                if DrugPlants[id] then
                    DrugPlants[id].ready = true
                    TriggerClientEvent("cold-gangs:client:plantReady", -1, id, DrugPlants[id].coords, row.drug_type)
                end
            end)
        else
            TriggerClientEvent("cold-gangs:client:plantReady", -1, id, DrugPlants[id].coords, row.drug_type)
        end
    end
end)
