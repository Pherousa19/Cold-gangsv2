
-- Shared Drug Configuration

Config.Drugs = {
    -- Outdoor Growables
    weed = {
        label = "Weed",
        type = "plant",
        growTime = 15, -- minutes
        rawItem = "wet_weed",
        finalItem = "weed_bag",
        effect = "chill"
    },
    mushrooms = {
        label = "Magic Mushrooms",
        type = "plant",
        growTime = 20,
        rawItem = "wild_mushroom",
        finalItem = "magic_mushroom",
        effect = "mushroom_trip"
    },
    peyote = {
        label = "Peyote",
        type = "plant",
        growTime = 25,
        rawItem = "peyote_plant",
        finalItem = "peyote_button",
        effect = "hallucinate"
    },
    kratom = {
        label = "Kratom",
        type = "plant",
        growTime = 18,
        rawItem = "kratom_leaf",
        finalItem = "kratom_dose",
        effect = "regen"
    },
    coca = {
        label = "Coca Plant",
        type = "plant",
        growTime = 30,
        rawItem = "raw_coke",
        finalItem = "coke_wrap",
        effect = "speed_strength"
    },
    poppy = {
        label = "Poppy Plant",
        type = "plant",
        growTime = 35,
        rawItem = "raw_opium",
        finalItem = "heroin_bag",
        effect = "slow_haze"
    },
    tobacco = {
        label = "Tobacco Leaf",
        type = "plant",
        growTime = 15,
        rawItem = "tobacco_leaf",
        finalItem = "cigar_roll",
        effect = "relax"
    },
    ayahuasca = {
        label = "Ayahuasca",
        type = "plant",
        growTime = 40,
        rawItem = "ayahuasca_root",
        finalItem = "ayahuasca_bottle",
        effect = "trip_regen"
    },
    catnip = {
        label = "Catnip",
        type = "plant",
        growTime = 12,
        rawItem = "catnip_leaf",
        finalItem = "catnip_joint",
        effect = "funny"
    },
    datura = {
        label = "Datura",
        type = "plant",
        growTime = 45,
        rawItem = "datura_seed",
        finalItem = "datura_extract",
        effect = "nausea"
    },

    -- Synthetic / Lab-based
    lsd = {
        label = "LSD",
        type = "synth",
        ingredients = {"fungal_slurry", "ether"},
        finalItem = "lsd_tab",
        effect = "hallucinate"
    },
    meth = {
        label = "Meth",
        type = "synth",
        ingredients = {"pseudo", "chem_fluid"},
        finalItem = "crystal_meth",
        effect = "hyper"
    },
    mdma = {
        label = "MDMA",
        type = "synth",
        ingredients = {"pill_mix", "binding_agent"},
        finalItem = "x_pill",
        effect = "pulse"
    },
    pcp = {
        label = "PCP",
        type = "synth",
        ingredients = {"ether", "cotton"},
        finalItem = "pcp_stick",
        effect = "rage"
    },
    ghb = {
        label = "GHB",
        type = "synth",
        ingredients = {"solvent", "bottle"},
        finalItem = "ghb_dose",
        effect = "blackout"
    },
    krokodil = {
        label = "Krokodil",
        type = "synth",
        ingredients = {"codeine", "diesel"},
        finalItem = "krok_dose",
        effect = "power_decay"
    },
    lean = {
        label = "Lean",
        type = "synth",
        ingredients = {"cough_syrup", "soda", "jollyrancher"},
        finalItem = "lean_cup",
        effect = "slow_color"
    },
    scopolamine = {
        label = "Scopolamine",
        type = "synth",
        ingredients = {"datura_root", "lime"},
        finalItem = "scop_dose",
        effect = "wipe"
    },

    -- Looted / Pharmacy
    oxy = {
        label = "Oxycodone",
        type = "pharma",
        finalItem = "oxy_pill",
        effect = "heal"
    },
    adderall = {
        label = "Adderall",
        type = "pharma",
        finalItem = "adderall_tab",
        effect = "focus"
    }
}
