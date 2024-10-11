Config = {}

Config.defaultlang = "de_lang"

-- Webhook Settings

Config.WebHook = true

Config.WHTitle = 'Market:'
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Market:' -- name
Config.WHLogo = '' -- must be 30x30px
Config.WHFooterLogo = '' -- must be 30x30px
Config.WHAvatar = '' -- must be 30x30px

-- Script Settings

Config.LicensePrice = 500  -- Price in $
Config.MaxListings = 3 -- Max Offers in Market

Config.Markets = {
    {
        Name = 'Valentine Marktplatz',
        Coords = vector3(-179.44, 648.48, 113.63),
        SpawnBlip = true,
        BlipSprite = 'blip_ambient_quartermaster',
    }
}