Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.BusinessSystem = {}

function ColdGangs:CreateBusinessFront(gangName, businessType, coords)
    local gang = self.Gangs[gangName]
    if not gang then return false end
    
    local businessConfig = nil
    for _, config in pairs(self.Config.BusinessTypes) do
        if config.type == businessType then
            businessConfig = config
            break
        end
    end
    
    if not businessConfig then return false end
    
    -- Check if gang has enough money
    if gang.bank_money < businessConfig.setupCost then
        return false, 'Not enough money in gang bank!'
    end
    
    -- Check if location is in gang turf
    local inTurf = self:IsLocationInGangTurf(coords, gangName)
    if not inTurf then
        return false, 'You can only place businesses in your own turf!'
    end
    
    -- Create business
    local businessId = MySQL.Sync.insert([[
        INSERT INTO cold_gang_businesses (gang_id, type, coords, income, level) 
        VALUES (?, ?, ?, ?, ?)
    ]], {
        gang.id,
        businessType,
        json.encode(coords),
        businessConfig.baseIncome,
        1
    })
    
    -- Deduct money
    self:UpdateGangBank(gangName, -businessConfig.setupCost)
    
    -- Add to runtime data
    self.BusinessFronts[businessId] = {
        id = businessId,
        gang_id = gang.id,
        type = businessType,
        coords = coords,
        income = businessConfig.baseIncome,
        level = 1,
        last_collected = os.time()
    }
    
    -- Create business on clients
    TriggerClientEvent('cold-gangs:client:createBusiness', -1, businessId, self.BusinessFronts[businessId])
    
    return true
end

function ColdGangs:CollectBusinessIncome(businessId, playerId)
    local business = self.BusinessFronts[businessId]
    if not business then return false end
    
    local Player = self:GetPlayer(playerId)
    if not Player then return false end
    
    local playerGang = self:GetPlayerGang(Player)
    local gang = self.Gangs[playerGang]
    
    if not gang or gang.id ~= business.gang_id then
        return false, 'This is not your gang\'s business!'
    end
    
    -- Calculate income
    local timeSinceCollection = os.time() - business.last_collected
    local hoursSinceCollection = timeSinceCollection / 3600
    local income = math.floor(business.income * hoursSinceCollection * business.level)
    
    if income < 100 then
        return false, 'Not enough income to collect yet!'
    end
    
    -- Add to gang bank
    self:UpdateGangBank(playerGang, income)
    
    -- Update last collected
    business.last_collected = os.time()
    MySQL.Async.execute('UPDATE cold_gang_businesses SET last_collected = NOW() WHERE id = ?', {businessId})
    
    -- Log activity
    self:LogGangActivity(playerGang, 'business_income', {
        business = businessId,
        amount = income
    })
    
    return true, income
end