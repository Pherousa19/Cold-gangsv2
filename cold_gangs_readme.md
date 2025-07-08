# Cold-Gangs 🎮
### The Ultimate Gang Management System for FiveM

A comprehensive and immersive gang system featuring territory control, drug production, weapon manufacturing, business fronts, and intense turf wars. Built with performance and flexibility in mind, supporting multiple frameworks and integrations.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![FiveM](https://img.shields.io/badge/FiveM-Ready-orange.svg)

## 🌟 Features

### 🏙️ Territory System
- **City-Wide Turfs**: 16+ predefined territories covering all of Los Santos
- **Multi-Poly Zones**: Complex territory shapes for realistic boundaries
- **Turf Wars**: Intense battles for territory control with capture mechanics
- **Real-Time Map**: Live territory status with influence heat maps
- **Income Generation**: Territories generate passive income based on type

### 💊 Advanced Drug System
- **Plant Anywhere**: Place drug plants throughout the city
- **Growth Mechanics**: Real-time growth with health and purity systems
- **Custom Strains**: Create unique drug variants with special properties
- **Drug Effects**: Visual and gameplay effects with addiction mechanics
- **Smart Harvesting**: Yield based on plant care and gang perks

### 🔫 Weapon Manufacturing
- **Crafting System**: Build weapons from raw materials
- **Tiered Access**: Basic to elite weapons based on gang reputation
- **Custom Recipes**: Expandable weapon crafting options
- **Quality Control**: Weapon quality affects performance

### 🏪 Business Fronts
- **Multiple Types**: Stores, casinos, chop shops, nightclubs, and more
- **Territory Locked**: Only place businesses in owned territories
- **Money Laundering**: Convert dirty money through businesses
- **Upgradeable**: Improve business income and capabilities

### 👥 Gang Management
- **Rank System**: 5 ranks with customizable permissions
- **Member Management**: Invite, promote, and manage members
- **Gang Bank**: Shared financial resources
- **Reputation System**: Unlock perks and abilities through actions
- **Activity Tracking**: Monitor member contributions

### 📱 Modern Tablet UI
- **iPad Pro Design**: Sleek widescreen interface with red/silver accents
- **Real-Time Updates**: Live data synchronization
- **Multi-Tab Interface**: Organized sections for all features
- **Responsive Design**: Smooth animations and interactions

### 🔌 Extensive Integrations

#### Supported Frameworks
- ✅ QBCore
- ✅ ESX
- ✅ Auto-detection

#### Inventory Systems
- ✅ ox_inventory
- ✅ qb-inventory
- ✅ codem_inventory
- ✅ qs_inventory

#### Garage Systems
- ✅ qb-garage
- ✅ codem-garage
- ✅ okokGarage
- ✅ qs-advancedgarages
- ✅ jg-advancedgarages

#### Phone Systems
- ✅ okokPhone
- ✅ lb-phone
- ✅ qs-phone
- ✅ qb-phone

#### Dispatch Systems
- ✅ ps-dispatch
- ✅ qs-dispatch
- ✅ cd_dispatch
- ✅ origen_police

## 📦 Installation

### Prerequisites
- FiveM Server (Latest artifacts)
- MySQL/MariaDB Database
- oxmysql or mysql-async
- PolyZone

### Step 1: Download & Extract
```bash
1. Download the Cold-Gangs package
2. Extract to your server's resources folder
3. Rename folder to 'cold-gangs'
```

### Step 2: Database Setup
```sql
-- Run the included SQL file in your database
-- This will create all necessary tables:
-- - cold_gangs
-- - cold_gang_members
-- - cold_gang_turfs
-- - cold_drug_plants
-- - cold_gang_activity
-- - cold_gang_businesses
```

### Step 3: Configure
Edit `config.lua` to match your server setup:
```lua
Config.DiscordWebhook = 'YOUR_WEBHOOK_URL' -- For activity logs
Config.Framework = 'auto-detect' -- or specify 'qb-core'/'esx'
Config.Inventory = 'auto-detect' -- or specify your inventory
-- ... adjust other settings as needed
```

### Step 4: Add to server.cfg
```cfg
ensure oxmysql # or mysql-async
ensure PolyZone
ensure cold-gangs
```

### Step 5: Add Items (QBCore Example)
Add to your `qb-core/shared/items.lua`:
```lua
-- Drug Seeds
['weed_seed'] = {
    ['name'] = 'weed_seed',
    ['label'] = 'Weed Seed',
    ['weight'] = 50,
    ['type'] = 'item',
    ['image'] = 'weed_seed.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['description'] = 'A mysterious seed'
},
['coca_seed'] = {
    ['name'] = 'coca_seed',
    ['label'] = 'Coca Seed',
    ['weight'] = 50,
    ['type'] = 'item',
    ['image'] = 'coca_seed.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['description'] = 'A rare seed'
},
-- Crafting Materials
['steel'] = {
    ['name'] = 'steel',
    ['label'] = 'Steel',
    ['weight'] = 500,
    ['type'] = 'item',
    ['image'] = 'steel.png',
    ['unique'] = false,
    ['useable'] = false,
    ['description'] = 'Refined steel'
},
-- Add other required items...
```

## 🎮 Usage

### Creating a Gang (Admin)
```
/creategang [name] [label] [leader_identifier]
Example: /creategang grove "Grove Street Families" ABC12345
```

### Player Commands
- **F7** - Open gang tablet (configurable)
- **/gang** - Alternative tablet command
- **/setgangrank [player_id] [rank]** - Set member rank (leader only)

### Gang Operations
1. **Capture Territory**: Enter enemy turf and press E to start capture
2. **Plant Drugs**: Use tablet > Drug Production > Plant New Drug
3. **Craft Weapons**: Visit gang weapon bench in owned territory
4. **Manage Business**: Access businesses through tablet interface
5. **Gang Stash**: Place stashes in owned territories (Lieutenant+)

## ⚙️ Configuration

### Territory Income Types
```lua
residential = $3,000-6,000/day
commercial = $6,000-10,000/day
industrial = $7,000-9,000/day
entertainment = $10,000-15,000/day
luxury = $15,000-20,000/day
beach = $8,000-11,000/day
rural = $2,000-3,500/day
```

### Gang Perks (Reputation Based)
- **500 Rep**: Faster drug growth (10% boost)
- **1,000 Rep**: Increased yield (20% more)
- **2,000 Rep**: Better purity (10% improvement)
- **3,000 Rep**: Reduced war cooldown (20% less)
- **5,000 Rep**: Extra turfs (+2 maximum)
- **10,000 Rep**: Elite weapons access

### Activity Points
- Daily login: 10 points
- Turf capture: 50 points
- Turf defense: 30 points
- Drug harvest: 20 points
- Weapon craft: 25 points
- Member recruit: 40 points

## 🔧 API & Exports

### Server Exports
```lua
-- Get gang data
exports['cold-gangs']:GetGangData(gangName)

-- Check if player is gang leader
exports['cold-gangs']:IsGangLeader(source, gangName)

-- Get player's gang
exports['cold-gangs']:GetPlayerGang(source)
```

### Client Exports
```lua
-- Get current gang
exports['cold-gangs']:GetCurrentGang()

-- Check if in gang turf
exports['cold-gangs']:IsInGangTurf(gangName)
```

## 🚀 Performance Optimization

- **State Bags**: Utilizes FiveM state bags for efficient sync
- **Smart Streaming**: Objects only render within streaming distance
- **Optimized Loops**: Configurable update intervals
- **Database Caching**: Minimizes database queries
- **Event Batching**: Groups updates to reduce network traffic

## 📝 Discord Webhook Events

The system logs the following to Discord:
- Gang creation/deletion
- Territory captures/losses
- Member joins/promotions
- Large financial transactions
- Turf war outcomes
- Drug harvests
- Weapon crafting

## 🐛 Troubleshooting

### Common Issues

**Tablet won't open:**
- Ensure you're in a gang
- Check key binding in settings
- Verify NUI resources loaded

**Can't plant drugs:**
- Must have required items
- Cannot plant in safe zones
- Check plant limit settings

**Territory not updating:**
- Verify PolyZone is installed
- Check zone coordinates
- Ensure MySQL connection

## 🤝 Support & Contributing

- **Discord**: [Your Discord Server]
- **Forum**: [Your Forum Thread]
- **Issues**: Use GitHub issues for bug reports

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Credits

- **Developer**: Cold Development
- **UI Design**: Modern tablet interface inspired by iPad Pro
- **Special Thanks**: FiveM community for framework support

---

### ⚡ Quick Start Checklist

- [ ] Install dependencies (oxmysql, PolyZone)
- [ ] Run SQL file in database
- [ ] Configure `config.lua`
- [ ] Add to `server.cfg`
- [ ] Add required items to shared
- [ ] Create test gang with `/creategang`
- [ ] Test core features
- [ ] Configure Discord webhook
- [ ] Set up admin permissions
- [ ] Enjoy!

---

*Made with ❤️ for the FiveM Community*