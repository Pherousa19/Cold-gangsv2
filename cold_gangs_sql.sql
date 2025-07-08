-- Cold-Gangs Database Setup
-- Version 1.0.0

-- Create main gangs table
CREATE TABLE IF NOT EXISTS `cold_gangs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `label` varchar(50) NOT NULL,
    `leader` varchar(50) DEFAULT NULL,
    `color` varchar(7) DEFAULT '#FF0000',
    `reputation` int(11) DEFAULT 0,
    `bank_money` int(11) DEFAULT 0,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `metadata` longtext DEFAULT NULL,
    `radio_channel` varchar(10) DEFAULT NULL,
    `max_members` int(11) DEFAULT 50,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`),
    INDEX `idx_leader` (`leader`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gang members table
CREATE TABLE IF NOT EXISTS `cold_gang_members` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang_id` int(11) NOT NULL,
    `identifier` varchar(50) NOT NULL,
    `rank` int(11) DEFAULT 1,
    `joined_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `last_active` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `contribution_points` int(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_member` (`gang_id`, `identifier`),
    INDEX `idx_identifier` (`identifier`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Turf territories table
CREATE TABLE IF NOT EXISTS `cold_gang_turfs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `gang_id` int(11) DEFAULT NULL,
    `zone` longtext NOT NULL,
    `center` longtext NOT NULL,
    `influence` int(11) DEFAULT 0,
    `type` varchar(50) DEFAULT 'general',
    `income` int(11) DEFAULT 100,
    `captured_at timestamp NULL DEFAULT NULL,
    `last_war timestamp NULL DEFAULT NULL,
    `defense_level` int(11) DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`),
    INDEX `idx_gang_turf` (`gang_id`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Drug plants table
CREATE TABLE IF NOT EXISTS `cold_drug_plants` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `owner` varchar(50) NOT NULL,
    `gang_id` int(11) DEFAULT NULL,
    `type` varchar(50) NOT NULL,
    `coords` longtext NOT NULL,
    `planted_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `growth` int(11) DEFAULT 0,
    `health` int(11) DEFAULT 100,
    `purity` int(11) DEFAULT 70,
    `water_level` int(11) DEFAULT 100,
    `fertilizer_level` int(11) DEFAULT 100,
    `custom_strain` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_owner` (`owner`),
    INDEX `idx_gang_plants` (`gang_id`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gang activity log
CREATE TABLE IF NOT EXISTS `cold_gang_activity` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang_id` int(11) NOT NULL,
    `player` varchar(50) NOT NULL,
    `action` varchar(50) NOT NULL,
    `details` longtext DEFAULT NULL,
    `points` int(11) DEFAULT 0,
    `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_gang_activity` (`gang_id`),
    INDEX `idx_player_activity` (`player`),
    INDEX `idx_timestamp` (`timestamp`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Business fronts table
CREATE TABLE IF NOT EXISTS `cold_gang_businesses` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang_id` int(11) NOT NULL,
    `type` varchar(50) NOT NULL,
    `name` varchar(100) DEFAULT NULL,
    `coords` longtext NOT NULL,
    `income` int(11) DEFAULT 1000,
    `level` int(11) DEFAULT 1,
    `last_collected` timestamp DEFAULT CURRENT_TIMESTAMP,
    `upgrades` longtext DEFAULT NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_gang_business` (`gang_id`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gang stashes table
CREATE TABLE IF NOT EXISTS `cold_gang_stashes` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang_id` int(11) NOT NULL,
    `coords` longtext NOT NULL,
    `turf_id` int(11) DEFAULT NULL,
    `created_by` varchar(50) NOT NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_gang_stash` (`gang_id`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`turf_id`) REFERENCES `cold_gang_turfs`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gang garages table
CREATE TABLE IF NOT EXISTS `cold_gang_garages` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang_id` int(11) NOT NULL,
    `coords` longtext NOT NULL,
    `spawn_coords` longtext NOT NULL,
    `turf_id` int(11) DEFAULT NULL,
    `capacity` int(11) DEFAULT 10,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_gang_garage` (`gang_id`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`turf_id`) REFERENCES `cold_gang_turfs`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Graffiti table
CREATE TABLE IF NOT EXISTS `cold_gang_graffiti` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang_id` int(11) NOT NULL,
    `coords` longtext NOT NULL,
    `normal` longtext NOT NULL,
    `texture` varchar(50) DEFAULT 'gang_tag_01',
    `placed_by` varchar(50) NOT NULL,
    `placed_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_gang_graffiti` (`gang_id`),
    FOREIGN KEY (`gang_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gang wars history
CREATE TABLE IF NOT EXISTS `cold_gang_wars` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `attacking_gang` int(11) NOT NULL,
    `defending_gang` int(11) NOT NULL,
    `turf_id` int(11) NOT NULL,
    `winner_gang` int(11) DEFAULT NULL,
    `started_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `ended_at timestamp NULL DEFAULT NULL,
    `attacking_score` int(11) DEFAULT 0,
    `defending_score` int(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `idx_war_gangs` (`attacking_gang`, `defending_gang`),
    FOREIGN KEY (`attacking_gang`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`defending_gang`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`turf_id`) REFERENCES `cold_gang_turfs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gang alliances table
CREATE TABLE IF NOT EXISTS `cold_gang_alliances` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `gang1_id` int(11) NOT NULL,
    `gang2_id` int(11) NOT NULL,
    `type` enum('alliance','ceasefire','enemy') DEFAULT 'alliance',
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `expires_at timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_alliance` (`gang1_id`, `gang2_id`),
    FOREIGN KEY (`gang1_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`gang2_id`) REFERENCES `cold_gangs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default turfs (Los Santos territories)
INSERT INTO `cold_gang_turfs` (`name`, `zone`, `center`, `type`, `income`) VALUES
('Grove Street', '{"points":[{"x":85.0,"y":-1956.0},{"x":170.0,"y":-1956.0},{"x":170.0,"y":-1900.0},{"x":85.0,"y":-1900.0}]}', '{"x":126.7,"y":-1929.8,"z":21.4}', 'residential', 5000),
('Forum Drive', '{"points":[{"x":-250.0,"y":-1500.0},{"x":-100.0,"y":-1500.0},{"x":-100.0,"y":-1350.0},{"x":-250.0,"y":-1350.0}]}', '{"x":-178.0,"y":-1426.0,"z":31.3}', 'residential', 4500);

-- Create indexes for performance
CREATE INDEX idx_activity_week ON cold_gang_activity(timestamp, gang_id);
CREATE INDEX idx_plant_growth ON cold_drug_plants(growth, gang_id);
CREATE INDEX idx_business_income ON cold_gang_businesses(last_collected, gang_id);

-- Create views for leaderboards
CREATE OR REPLACE VIEW gang_leaderboard AS
SELECT 
    g.id,
    g.name,
    g.label,
    g.reputation,
    g.bank_money,
    COUNT(DISTINCT m.id) as member_count,
    COUNT(DISTINCT t.id) as turf_count,
    COUNT(DISTINCT b.id) as business_count
FROM cold_gangs g
LEFT JOIN cold_gang_members m ON g.id = m.gang_id
LEFT JOIN cold_gang_turfs t ON g.id = t.gang_id
LEFT JOIN cold_gang_businesses b ON g.id = b.gang_id
GROUP BY g.id
ORDER BY g.reputation DESC;

-- Activity leaderboard view
CREATE OR REPLACE VIEW player_activity_leaderboard AS
SELECT 
    a.player,
    m.gang_id,
    g.name as gang_name,
    SUM(a.points) as total_points,
    COUNT(*) as activity_count
FROM cold_gang_activity a
JOIN cold_gang_members m ON a.player = m.identifier
JOIN cold_gangs g ON m.gang_id = g.id
WHERE a.timestamp > DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY a.player, m.gang_id
ORDER BY total_points DESC;
