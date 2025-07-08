Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.Leaderboard = {}

function ColdGangs:UpdateLeaderboard()
    -- Get top gangs by reputation
    local topGangs = MySQL.Sync.fetchAll([[
        SELECT g.*, 
               COUNT(DISTINCT m.id) as member_count,
               COUNT(DISTINCT t.id) as turf_count
        FROM cold_gangs g
        LEFT JOIN cold_gang_members m ON g.id = m.gang_id
        LEFT JOIN cold_gang_turfs t ON g.id = t.gang_id
        GROUP BY g.id
        ORDER BY g.reputation DESC
        LIMIT 10
    ]])
    
    self.Leaderboard.TopGangs = topGangs
    
    -- Get most active players this week
    local topPlayers = MySQL.Sync.fetchAll([[
        SELECT player, COUNT(*) as activity_count, SUM(points) as total_points
        FROM cold_gang_activity
        WHERE timestamp > DATE_SUB(NOW(), INTERVAL 7 DAY)
        GROUP BY player
        ORDER BY total_points DESC
        LIMIT 10
    ]])
    
    self.Leaderboard.TopPlayers = topPlayers
    
    -- Update all clients
    TriggerClientEvent('cold-gangs:client:updateLeaderboard', -1, self.Leaderboard)
    
    -- Send to Discord
    if self.Config.DiscordWebhook ~= '' then
        self:SendLeaderboardToDiscord()
    end
end

function ColdGangs:LogGangActivity(gangName, action, details)
    local gang = self.Gangs[gangName]
    if not gang then return end
    
    local points = self.Config.ActivityPoints[action] or 0
    
    MySQL.Async.insert([[
        INSERT INTO cold_gang_activity (gang_id, player, action, details, points)
        VALUES (?, ?, ?, ?, ?)
    ]], {
        gang.id,
        details.player or 'GANG',
        action,
        json.encode(details),
        points
    })
end
