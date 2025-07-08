Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.Torture = {}

function ColdGangs:StartTortureRoom(victimId)
    if not self.CurrentGang then return end
    
    -- Transport to torture location
    local tortureLocations = {
        vector4(1000.0, -3200.0, -38.99, 180.0), -- Underground location
        vector4(566.0, -3127.0, -42.0, 90.0)
    }
    
    local location = tortureLocations[math.random(#tortureLocations)]
    
    -- Teleport players
    local ped = PlayerPedId()
    local victimPed = GetPlayerPed(GetPlayerFromServerId(victimId))
    
    DoScreenFadeOut(1000)
    Wait(1000)
    
    SetEntityCoords(ped, location.x, location.y, location.z)
    SetEntityHeading(ped, location.w)
    
    -- Create torture props
    local chairModel = GetHashKey('prop_torture_ch_01')
    RequestModel(chairModel)
    while not HasModelLoaded(chairModel) do Wait(10) end
    
    local chair = CreateObject(chairModel, location.x + 1.0, location.y, location.z, false, false, false)
    PlaceObjectOnGroundProperly(chair)
    FreezeEntityPosition(chair, true)
    
    -- Attach victim to chair
    AttachEntityToEntity(victimPed, chair, 0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    
    DoScreenFadeIn(1000)
    
    -- Create torture menu
    self:OpenTortureMenu(victimId, chair)
end

function ColdGangs:OpenTortureMenu(victimId, chair)
    local tortureOptions = {
        {
            title = 'Threaten',
            description = 'Intimidate the victim',
            icon = 'comment-slash',
            onSelect = function()
                self:PerformTortureAction('threaten', victimId)
            end
        },
        {
            title = 'Beat',
            description = 'Physical violence',
            icon = 'fist-raised',
            onSelect = function()
                self:PerformTortureAction('beat', victimId)
            end
        },
        {
            title = 'Waterboard',
            description = 'Advanced interrogation',
            icon = 'water',
            onSelect = function()
                self:PerformTortureAction('waterboard', victimId)
            end
        },
        {
            title = 'Release',
            description = 'Let them go',
            icon = 'unlock',
            onSelect = function()
                self:ReleaseTortureVictim(victimId, chair)
            end
        }
    }
    
    lib.registerContext({
        id = 'torture_menu',
        title = 'Torture Options',
        options = tortureOptions
    })
    
    lib.showContext('torture_menu')
end