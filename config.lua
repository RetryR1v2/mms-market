Config = {}

Config.defaultlang = "de_lang"

-- Webhook Settings

Config.WebHook = false      --- WEBHOOK NOT SUPPORTED YET

Config.WHTitle = 'Market:'
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Market:' -- name
Config.WHLogo = '' -- must be 30x30px
Config.WHFooterLogo = '' -- must be 30x30px
Config.WHAvatar = '' -- must be 30x30px

-- Script Settings

Config.LicensePrice = 500  -- Price in $
Config.MaxListings = 10 -- Max Offers in Market

Config.Markets = {
    {
        Name = 'Valentine Marktplatz',
        Coords = vector3(-179.44, 648.48, 113.63),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
    {
        Name = 'Rhodes Marktplatz',
        Coords = vector3(1231.77, -1277.57, 76.07),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
    {
        Name = 'Saint Denis Marktplatz',
        Coords = vector3(2754.75, -1394.91, 46.26),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
    {
        Name = 'Blackwater Marktplatz',
        Coords = vector3(-876.57, -1344.51, 43.27),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
    {
        Name = 'Strawberry Marktplatz',
        Coords = vector3(-1827.77, -433.2, 159.9),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
    {
        Name = 'Armadillo Marktplatz',
        Coords = vector3(-3662.68, -2624.98, -13.54),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
    {
        Name = 'Annesburg Marktplatz',
        Coords = vector3(2936.54, 1290.64, 44.7),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    },
}