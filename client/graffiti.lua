Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.Graffiti = {}
ColdGangs.ActiveGraffiti = {}

local sprayCanModel = GetHashKey('prop_cs_spray_can')
local graffitiTextures = {
    'gang_tag_01',
    'gang_tag_02',
    'gang_tag_03',
    'gang_crown',
    'gang_skull'
}

function ColdGangs:StartGraffitiPlacement()
    if not self.CurrentGang then
        self:ShowNotification('Graffiti', 'You must be in a gang to place graffiti!', 'error')
        return
    end
    
    -- Check if player has spray can
    if not self:HasItem('spray_can') then
        self:ShowNotification('Graffiti', 'You need a spray can!', 'error')
        return
    end
    
    local ped = PlayerPedId()
    
    -- Load spray can model
    RequestModel(sprayCanModel)
    while not HasModelLoaded(sprayCanModel) do
        Wait(10)
    end
    
    -- Create spray can prop
    local sprayCan = CreateObject(sprayCanModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(sprayCan, ped, GetPedBoneIndex(ped, 57005), 0.072, 0.041, -0.06, -60.0, 0.0, 0.0, true, true, false, true, 1, true)
    
    self:ShowNotification('Graffiti', 'Aim at a wall and press [E] to spray', 'info')
    
    -- Placement thread
    CreateThread(function()
        while sprayCan do
            Wait(0)
            
            -- Get aim position
            local coords = GetEntityCoords(ped)
            local forward = GetEntityForwardVector(ped)
            local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x + forward.x * 5, coords.y + forward.y * 5, coords.z + forward.z * 5, -1, ped, 0)
            local _, hit, hitCoords, hitNormal, entity = GetShapeTestResult(rayHandle)
            
            if hit then
                -- Draw preview
                DrawSphere(hitCoords.x, hitCoords.y, hitCoords.z, 0.1, 255, 0, 0, 0.5)
                
                if IsControlJustPressed(0, 38) then -- E key
                    -- Start spraying animation
                    self:SprayGraffiti(sprayCan, hitCoords, hitNormal)
                    break
                end
            end
            
            -- Cancel
            if IsControlJustPressed(0, 73) then -- X key
                DeleteObject(sprayCan)
                sprayCan = nil
                break
            end
        end
    end)
end

function ColdGangs:SprayGraffiti(sprayCan, coords, normal)
    local ped = PlayerPedId()
    
    -- Load animation
    RequestAnimDict('switch@franklin@lamar_tagging_wall')
    while not HasAnimDictLoaded('switch@franklin@lamar_tagging_wall') do
        Wait(10)
    end
    
    -- Face the wall
    local heading = GetHeadingFromVector_2d(normal.x, normal.y)
    SetEntityHeading(ped, heading + 180.0)
    
    -- Play animation
    TaskPlayAnim(ped, 'switch@franklin@lamar_tagging_wall', 'lamar_tagging_wall_loop_lamar', 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Progress bar
    local success = lib.progressBar({
        duration = 5000,
        label = 'Spraying graffiti...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'switch@franklin@lamar_tagging_wall',
            clip = 'lamar_tagging_wall_loop_lamar'
        }
    })
    
    -- Clean up
    ClearPedTasks(ped)
    DeleteObject(sprayCan)
    
    if success then
        -- Create graffiti
        TriggerServerEvent('cold-gangs:server:placeGraffiti', coords, normal, self.CurrentGang.name)
        self:ShowNotification('Graffiti', 'Graffiti placed successfully!', 'success')
    else
        self:ShowNotification('Graffiti', 'Cancelled', 'error')
    end
end

function ColdGangs:CreateGraffiti(id, data)
    -- Create runtime graffiti (would use actual decals in production)
    self.ActiveGraffiti[id] = {
        coords = data.coords,
        gang = data.gang,
        texture = data.texture
    }
    
    -- Add interaction
    exports['qb-target']:AddBoxZone('graffiti_' .. id, data.coords, 2.0, 2.0, {
        name = 'graffiti_' .. id,
        heading = 0,
        debugPoly = false,
        minZ = data.coords.z - 1,
        maxZ = data.coords.z + 2
    }, {
        options = {
            {
                icon = 'fas fa-paint-roller',
                label = 'Remove Graffiti',
                action = function()
                    self:RemoveGraffiti(id)
                end,
                canInteract = function()
                    return self.CurrentGang and self.CurrentGang.name ~= data.gang
                end
            }
        },
        distance = 2.0
    })
end