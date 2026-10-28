--[[
    =============================================================================
    PROJECT JAINA — CATÁLOGO IN-GAME DE LA TESORERÍA DE DALARAN (v5.0)
    =============================================================================
    Archivo: StoreCatalog.lua
    Ecosistema: World of Warcraft 3.3.5a (Build 12340)
    Autores: Darckrovert & Antigravity (Mythos 5)
    Propósito: Catálogo omnicanal sincronizado con el motor Eluna del servidor.
               100% Cosmético y Anti-P2W con precios en Tokens de Jaina y
               referencia en Soles Peruanos (PEN S/.) y Dólares (USD $).
    =============================================================================
]]

ProjectJaina_Store = ProjectJaina_Store or {}
local PJ = ProjectJaina_Store

PJ.Catalog = {
    -- Rarezas y colores de borde/texto WoW 3.3.5a
    Rarities = {
        comun      = { hex = "ffffff", r = 1.00, g = 1.00, b = 1.00, label = "COMÚN" },
        raro       = { hex = "0070dd", r = 0.00, g = 0.44, b = 0.87, label = "RARO" },
        epico      = { hex = "a335ee", r = 0.64, g = 0.21, b = 0.93, label = "ÉPICO" },
        legendario = { hex = "ff8000", r = 1.00, g = 0.50, b = 0.00, label = "LEGENDARIO" },
        mitico     = { hex = "ffd700", r = 1.00, g = 0.84, b = 0.00, label = "MÍTICO" },
        especial   = { hex = "1eff00", r = 0.12, g = 1.00, b = 0.00, label = "ESPECIAL" }
    },

    Items = {
        -- =====================================================================
        -- CATEGORÍA: MONTURAS MÍTICAS Y ÉPICAS (Terrestres, Voladoras y Acrobáticas)
        -- =====================================================================
        {
            id          = "mount_invincible",
            category    = "mounts",
            name        = "Riendas de Invencible",
            itemEntry   = 50818,
            costTokens  = 8000,
            refPEN      = 120.00,
            rarity      = "mitico",
            icon        = "Interface\\Icons\\Ability_Mount_Undeadhorse",
            spellId     = 72286,
            mountType   = "Terrestre y Voladora",
            speed       = "310%",
            reqLevel    = 80,
            reqSkill    = "Artesano jinete (300)",
            description = "El legendario corcel de Arthas Menethil. 310% de velocidad terrestre y aérea. ¡Deja huellas de escarcha al galopar!",
            actionType  = "buy_item"
        },
        {
            id          = "mount_mimiron",
            category    = "mounts",
            name        = "Cabeza de Mimiron",
            itemEntry   = 45693,
            costTokens  = 5000,
            refPEN      = 80.00,
            rarity      = "mitico",
            icon        = "Interface\\Icons\\INV_Misc_EngGizmos_03",
            spellId     = 63956,
            mountType   = "Voladora",
            speed       = "310%",
            reqLevel    = 80,
            reqSkill    = "Artesano jinete (300)",
            description = "El artefacto volador de ingeniería titánica más cotizado de Ulduar. 310% velocidad aérea con hélices arcanas.",
            actionType  = "buy_item"
        },
        {
            id          = "mount_celestial",
            category    = "mounts",
            name        = "Destrero Celestial",
            itemEntry   = 54811,
            costTokens  = 3500,
            refPEN      = 65.00,
            rarity      = "legendario",
            icon        = "Interface\\Icons\\Ability_Mount_CelestialSteed",
            spellId     = 74856,
            mountType   = "Terrestre y Voladora",
            speed       = "Escalable (150%-310%)",
            reqLevel    = 20,
            reqSkill    = "Aprendiz de jinete (75+)",
            description = "Corcel astral forjado por los Titanes con constelaciones vivientes. Se adapta a tu habilidad máxima de vuelo.",
            actionType  = "buy_item"
        },
        {
            id          = "mount_chopper",
            category    = "mounts",
            name        = "Chopper de Mekigeniero",
            itemEntry   = 44413,
            costTokens  = 3000,
            refPEN      = 55.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\INV_Vehicle_01",
            spellId     = 60424,
            mountType   = "Terrestre (Sidecar)",
            speed       = "100%",
            reqLevel    = 80,
            reqSkill    = "Jinete experto (150)",
            description = "Motocicleta de ingeniería gnómica con sidecar para transportar a un compañero de grupo por todo Azeroth.",
            actionType  = "buy_item"
        },
        {
            id          = "mount_rooster",
            category    = "mounts",
            name        = "Huevo de Gallo Mágico",
            itemEntry   = 49290,
            costTokens  = 2200,
            refPEN      = 45.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\Inv_Egg_03",
            spellId     = 66122,
            mountType   = "Terrestre",
            speed       = "100%",
            reqLevel    = 40,
            reqSkill    = "Jinete experto (150)",
            description = "Montura humorística y exclusiva de cartas coleccionables (TCG). Totalmente animada con graznidos al saltar.",
            actionType  = "buy_item"
        },
        {
            id          = "mount_proto_green",
            category    = "mounts",
            name        = "Riendas del Protodraco Verde",
            itemEntry   = 44707,
            costTokens  = 1800,
            refPEN      = 40.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\Ability_Mount_Drake_Proto",
            spellId     = 61294,
            mountType   = "Voladora",
            speed       = "280%",
            reqLevel    = 80,
            reqSkill    = "Jinete experto (225)",
            description = "Protodraco ancestral de la Cuenca de Sholazar con 280% de velocidad aérea y rugido elemental.",
            actionType  = "buy_item"
        },
        {
            id          = "mount_spectral_tiger",
            category    = "mounts",
            name        = "Tigre Espectral Raudo",
            itemEntry   = 49284,
            costTokens  = 1500,
            refPEN      = 35.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\Ability_Mount_SpectralTiger",
            spellId     = 42777,
            mountType   = "Terrestre",
            speed       = "100%",
            reqLevel    = 60,
            reqSkill    = "Jinete experto (150)",
            description = "El felino fantasmal más codiciado de Azeroth. Totalmente translúcido con brillo de runas arcanas.",
            actionType  = "buy_item"
        },

        -- =====================================================================
        -- CATEGORÍA: MASCOTAS & COMPAÑEROS MÍSTICOS
        -- =====================================================================
        {
            id          = "pet_spectral_cub",
            category    = "pets",
            name        = "Cría de Tigre Espectral",
            itemEntry   = 49343,
            costTokens  = 400,
            refPEN      = 12.00,
            rarity      = "raro",
            icon        = "Interface\\Icons\\Ability_Mount_SpectralTiger",
            description = "Un pequeño cachorro de tigre fantasmal que te sigue y ronronea cuando te sientas junto a él.",
            actionType  = "buy_item"
        },
        {
            id          = "pet_dragon_kite",
            category    = "pets",
            name        = "Cometa de Dragón",
            itemEntry   = 34493,
            costTokens  = 400,
            refPEN      = 12.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\INV_Misc_Toy_01",
            description = "Cometa mágica flotante que lanza pequeños rayos a las criaturas cercanas cuando descansas.",
            actionType  = "buy_item"
        },
        {
            id          = "pet_blizzard_bear",
            category    = "pets",
            name        = "Osezno de Blizzard",
            itemEntry   = 44819,
            costTokens  = 350,
            refPEN      = 10.00,
            rarity      = "raro",
            icon        = "Interface\\Icons\\INV_Misc_MonsterClaw_03",
            description = "Pequeño oso polar con capa de ventisca que saluda y hace reverencias a otros jugadores.",
            actionType  = "buy_item"
        },
        {
            id          = "pet_ammen_lashling",
            category    = "pets",
            name        = "Brote del Valle Ammen",
            itemEntry   = 44984,
            costTokens  = 300,
            refPEN      = 9.00,
            rarity      = "raro",
            icon        = "Interface\\Icons\\INV_Misc_Herb_01",
            description = "Compañero vegetal flotante que emite esporas bioluminiscentes en zonas oscuras.",
            actionType  = "buy_item"
        },

        -- =====================================================================
        -- CATEGORÍA: FICHAS & SUMINISTROS DE UTILIDAD
        -- =====================================================================
        {
            id          = "tokens_event_100",
            category    = "tokens",
            name        = "100x Fichas de Evento",
            itemEntry   = 910000,
            itemCount   = 100,
            costTokens  = 1500,
            refPEN      = 35.00,
            rarity      = "legendario",
            icon        = "Interface\\Icons\\INV_Misc_Coin_06",
            description = "Gran cofre de 100 Fichas de Evento para desbloqueos masivos de cosméticos con Kaelia.",
            actionType  = "buy_item"
        },
        {
            id          = "tokens_event_50",
            category    = "tokens",
            name        = "50x Fichas de Evento",
            itemEntry   = 910000,
            itemCount   = 50,
            costTokens  = 800,
            refPEN      = 22.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\INV_Misc_Coin_04",
            description = "Alijo de 50 Fichas de Evento para desbloqueos mayores de cosméticos y títulos.",
            actionType  = "buy_item"
        },
        {
            id          = "tokens_event_10",
            category    = "tokens",
            name        = "10x Fichas de Evento",
            itemEntry   = 910000,
            itemCount   = 10,
            costTokens  = 200,
            refPEN      = 6.00,
            rarity      = "raro",
            icon        = "Interface\\Icons\\INV_Misc_Coin_02",
            description = "Paquete de 10 Fichas de Evento canjeables con Kaelia Sombraetérea en Dalaran.",
            actionType  = "buy_item"
        },
        {
            id          = "jeeves_bot",
            category    = "tokens",
            name        = "Jeeves (Mayordomo de Reparación)",
            itemEntry   = 49040,
            itemCount   = 1,
            costTokens  = 600,
            refPEN      = 18.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\INV_Gizmo_02",
            description = "Invoca a un mayordomo robot durante 10 minutos para reparar equipo y acceder al banco en raid.",
            actionType  = "buy_item"
        },
        {
            id          = "bag_onyxia",
            category    = "tokens",
            name        = "Mochila de Piel de Onyxia (22c)",
            itemEntry   = 49295,
            itemCount   = 1,
            costTokens  = 350,
            refPEN      = 10.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\INV_Misc_Bag_EnlargedOnyxiaHide",
            description = "Bolsa de máxima capacidad (22 casillas) forjada con las escamas de la mismísima Onyxia.",
            actionType  = "buy_item"
        },
        {
            id          = "bag_glacial",
            category    = "tokens",
            name        = "Bolsa Glacial (22 casillas)",
            itemEntry   = 41600,
            itemCount   = 1,
            costTokens  = 180,
            refPEN      = 5.00,
            rarity      = "raro",
            icon        = "Interface\\Icons\\INV_Misc_Bag_10_Blue",
            description = "Bolsa de 22 casillas cosida con tejido de escarcha para almacenar equipo y botín.",
            actionType  = "buy_item"
        },
        {
            id          = "bag_frostweave",
            category    = "tokens",
            name        = "Cartera de Tejido de Escarcha (20c)",
            itemEntry   = 41599,
            itemCount   = 1,
            costTokens  = 80,
            refPEN      = 3.00,
            rarity      = "raro",
            icon        = "Interface\\Icons\\INV_Misc_Bag_19",
            description = "Bolsa espaciosa de 20 casillas para aventureros en fase de nivelación.",
            actionType  = "buy_item"
        },

        -- =====================================================================
        -- CATEGORÍA: ECOSISTEMA DE DALARAN (INTEGRACIONES DIRECTAS)
        -- =====================================================================
        {
            id          = "eco_wings",
            category    = "ecosystem",
            name        = "Alas & Auras Místicas",
            costTokens  = 0,
            refPEN      = 20.00,
            rarity      = "mitico",
            icon        = "Interface\\Icons\\Spell_Holy_AuraOfLight",
            description = "Abre el catálogo oficial de 17 Alas Místicas animadas con partículas y efectos visuales.",
            actionType  = "open_addon",
            addonTarget = "ProjectJaina_VisualShop"
        },
        {
            id          = "eco_wardrobe",
            category    = "ecosystem",
            name        = "Guardarropa Invisible de Kaelia",
            costTokens  = 0,
            refPEN      = 15.00,
            rarity      = "legendario",
            icon        = "Interface\\Icons\\INV_Chest_Cloth_23",
            description = "Accede al vestidor de 9 ranuras translúcidas sin perder estadísticas ni gemas de combate.",
            actionType  = "open_addon",
            addonTarget = "ProjectJaina_Wardrobe"
        },
        {
            id          = "eco_battlepass",
            category    = "ecosystem",
            name        = "Pase de Batalla de Azeroth",
            costTokens  = 0,
            refPEN      = 25.00,
            rarity      = "epico",
            icon        = "Interface\\Icons\\Achievement_Zone_Wintergrasp",
            description = "Consulta tu progreso en los 50 niveles del Pase de Batalla de la temporada actual.",
            actionType  = "open_addon",
            addonTarget = "ProjectJaina_BattlePass"
        }
    }
}
