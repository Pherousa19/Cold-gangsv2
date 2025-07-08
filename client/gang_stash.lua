Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.Stashes = {}

function ColdGangs:PlaceGangStash()
    if not self.CurrentGang then return end
    
    -- Check if player is high enough rank
    local playerRank = self:GetPlayerGangRank()
    if playerRank < 4 then
        self:ShowNotification('Gang Stash', 'You need to be Lieutenant or higher!', 'error')
        return
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Check if in gang turf
    local inTurf, turfId = self:IsInGangTurf(coords, self.CurrentGang.name)
    if not inTurf then
        self:ShowNotification('Gang Stash', 'You can only place stashes in your turf!', 'error')
        return
    end
    
    -- Create stash preview
    local stashModel = GetHashKey('prop_box_wood02a_pu')
    RequestModel(stashModel)
    while not HasModelLoaded(stashModel) do Wait(10) end
    
    local stashObject = CreateObject(stashModel, coords.x, coords.y, coords.z - 1.0, false, false, false)
    SetEntityAlpha(stashObject, 150)
    SetEntityCollision(stashObject, false, false)
    
    -- Placement mode
    self:ShowNotification('Placement', 'Use arrow keys to move, Q/E to rotate, Enter to place, X to cancel', 'info')
    
    CreateThread(function()
        while stashObject do
            Wait(0)
            
            local objCoords = GetEntityCoords(stashObject)
            local objHeading = GetEntityHeading(stashObject)
            
            -- Movement controls
            if IsControlPressed(0, 172) then -- Up arrow
                SetEntityCoords(stashObject, objCoords.x, objCoords.y + 0.01, objCoords.z)
            elseif IsControlPressed(0, 173) then -- Down arrow
                SetEntityCoords(stashObject, objCoords.x, objCoords.y - 0.01, objCoords.z)
            elseif IsControlPressed(0, 174) then -- Left arrow
                SetEntityCoords(stashObject, objCoords.x - 0.01, objCoords.y, objCoords.z)
            elseif IsControlPressed(0, 175) then -- Right arrow
                SetEntityCoords(stashObject, objCoords.x + 0.01, objCoords.y, objCoords.z)
            end
            
            -- Rotation controls
            if IsControlPressed(0, 44) then -- Q
                SetEntityHeading(stashObject, objHeading - 1.0)
            elseif IsControlPressed(0, 38) then -- E
                SetEntityHeading(stashObject, objHeading + 1.0)
            end
            
            -- Place stash
            if IsControlJustPressed(0, 201) then -- Enter
                SetEntityAlpha(stashObject, 255)
                SetEntityCollision(stashObject, true, true)
                PlaceObjectOnGroundProperly(stashObject)
                FreezeEntityPosition(stashObject, true)
                
                local finalCoords = GetEntityCoords(stashObject)
                local finalHeading = GetEntityHeading(stashObject)
                
                TriggerServerEvent('cold-gangs:server:placeStash', {
                    coords = finalCoords,
                    heading = finalHeading,
                    turf = turfId
                })
                
                self:CreateStashZone(stashObject, finalCoords)
                stashObject = nil
            end
            
            -- Cancel placement
            if IsControlJustPressed(0, 73) then -- X
                DeleteObject(stashObject)
                stashObject = nil
            end
        end
    end)
end

function ColdGangs:CreateStashZone(object, coords)
    exports['qb-target']:AddTargetEntity(object, {
        options = {
            {
                icon = 'fas fa-box',
                label = 'Open Gang Stash',
                action = function()
                    TriggerServerEvent('cold-gangs:server:openStash', self.CurrentGang.name)
                end,
                canInteract = function()
                    return self.CurrentGang ~= nil
                end
            },
            {
                icon = 'fas fa-trash',
                label = 'Remove Stash',
                action = function()
                    if self:GetPlayerGangRank() >= 4 then
                        DeleteObject(object)
                        TriggerServerEvent('cold-gangs:server:removeStash', coords)
                    end
                end,
                canInteract = function()
                    return self:GetPlayerGangRank() >= 4
                end
            }
        },
        distance = 2.0
    })
end

-- Utility functions
function ColdGangs:GetItemCount(item)
    if Config.Inventory == 'ox_inventory' then
        return exports.ox_inventory:Search('count', item)
    elseif Config.Inventory == 'qb-inventory' then
        local Player = QBCore.Functions.GetPlayerData()
        for _, v in pairs(Player.items) do
            if v.name == item then
                return v.amount
            end
        end
    end
    return 0
end

function ColdGangs:GetPlayerGangRank()
    if not self.CurrentGang then return 0 end
    
    local playerIdentifier = nil
    if Config.Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayerData()
        playerIdentifier = Player.citizenid
    elseif Config.Framework == 'esx' then
        playerIdentifier = ESX.GetPlayerData().identifier
    end
    
    if self.CurrentGang.members[playerIdentifier] then
        return self.CurrentGang.members[playerIdentifier].rank
    end
    
    return 0
end

function ColdGangs:IsInGangTurf(coords, gangName)
    for turfId, turf in pairs(self.Turfs) do
        if turf.gang_name == gangName then
            local zone = self.TurfZones[turfId]
            if zone and zone:isPointInside(coords) then
                return true, turfId
            end
        end
    end
    return false, nil
end