local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-market/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-- Buy Market License

RegisterServerEvent('mms-market:server:BuyMarketLicense',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    local Firstname = Character.firstname
    local Lastname = Character.lastname
    local Money = Character.money
    if Money >= Config.LicensePrice then
        local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
        if #result > 0 then
            VORPcore.NotifyTip(src, _U('AlreadyGotLicense'), 4000)
        else
            Character.removeCurrency(0,Config.LicensePrice)
            VORPcore.NotifyTip(src, _U('BoughtLicense'), 4000)
            MySQL.insert('INSERT INTO `mms_marketlicense` (identifier,charidentifier,firstname,lastname,lincense,listings,marketmoney) VALUES (?,?,?,?,?,?,?)',
            {Identifier,Charidentifier,Firstname,Lastname,1,0,0}, function()end)
        end
    else
        VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 4000)
    end
end)

RegisterServerEvent('mms-market:server:GetInventory',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Charidentifier = Character.charIdentifier
    local Inventory = exports.vorp_inventory:getUserInventoryItems(src,nil)
    local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
    if #result > 0 then
        TriggerClientEvent('mms-market:client:OfferProdukt',src,Inventory)
    else
        VORPcore.NotifyTip(src, _U('NeedLicenseFirst'), 4000)
    end
end)

RegisterServerEvent('mms-market:server:PlaceOffer',function(NumberAmount,NumberPrice, ItemName, ItemLabel)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    local Firstname = Character.firstname
    local Lastname = Character.lastname
    local Price = NumberAmount * NumberPrice
    local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
    if #result > 0 then
        MyListings = result[1].listings
        NewListings = MyListings + 1
        if MyListings < Config.MaxListings then
            MySQL.update('UPDATE `mms_marketlicense` SET listings = ? WHERE charidentifier = ?',{NewListings, Charidentifier})
            MySQL.insert('INSERT INTO `mms_market` (identifier,charidentifier,firstname,lastname,itemname,itemlabel,amount,price) VALUES (?,?,?,?,?,?,?,?)',
            {Identifier,Charidentifier,Firstname,Lastname,ItemName,ItemLabel,NumberAmount,Price}, function()end)
            exports.vorp_inventory:subItem(src, ItemName, NumberAmount)
            VORPcore.NotifyTip(src, _U('OfferSuccessfull'), 4000)
        else
            VORPcore.NotifyTip(src, _U('TooManyOffers'), 4000)
        end
    else
        VORPcore.NotifyTip(src, _U('NeedLicenseFirst'), 4000)
    end
end)

RegisterServerEvent('mms-market:server:GetListings',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    --local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
    --if #result > 0 then
        local Listing = MySQL.query.await("SELECT * FROM mms_market", { })
        if #Listing > 0 then
            TriggerClientEvent('mms-market:client:ShowListings',src,Listing)
        else
            VORPcore.NotifyTip(src, _U('NoEntrys'), 4000)
        end
    --else
        --VORPcore.NotifyTip(src, _U('NeedLicenseFirst'), 4000)
    --end
end)

RegisterServerEvent('mms-market:server:BuyOffer',function(ID,ItemName,ItemLabel,Amount,Price,SellerCharId)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    local Money = Character.money
    local CanCarry = exports.vorp_inventory:canCarryItem(src, ItemName, Amount)
    local result3 = MySQL.query.await("SELECT * FROM mms_market WHERE charidentifier=@charidentifier", { ["charidentifier"] = SellerCharId})
    if #result3 > 0 then
        if result3[1].charidentifier == Charidentifier then
            VORPcore.NotifyTip(src, _U('CantBuyOwn'), 5000)
        else
    if CanCarry then
        if Money >= Price then
            Character.removeCurrency(0,Price)
            exports.vorp_inventory:addItem(src, ItemName, Amount)
            local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = SellerCharId})
                if #result > 0 then
                    MyListings = result[1].listings
                    NewListings = MyListings - 1
                    MyMarketMoney = result[1].marketmoney
                    NewMarketMoney = MyMarketMoney + Price
                    MySQL.update('UPDATE `mms_marketlicense` SET listings = ? WHERE charidentifier = ?',{NewListings, SellerCharId})
                    MySQL.update('UPDATE `mms_marketlicense` SET marketmoney = ? WHERE charidentifier = ?',{NewMarketMoney, SellerCharId})
                end
            local result2 = MySQL.query.await("SELECT * FROM mms_market WHERE id=@id", { ["id"] = ID})
                if #result2 > 0 then
                    MySQL.execute('DELETE FROM mms_market WHERE id = ?', { ID }, function()
                    end)
                end
                VORPcore.NotifyTip(src, _U('YouBought') .. Amount .. ' ' .. ItemLabel  .. _U('For') .. Price, 5000)
        else
            VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
        end
    else
        VORPcore.NotifyTip(src, _U('NotEnoghSpace'), 5000)
    end
end
end
end)

RegisterServerEvent('mms-market:server:GetMyListings',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
    if #result > 0 then
        local MyListing = MySQL.query.await("SELECT * FROM mms_market WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
        if #MyListing > 0 then
            TriggerClientEvent('mms-market:client:ShowMyListings',src,MyListing)
        else
            VORPcore.NotifyTip(src, _U('NoEntrys'), 4000)
        end
    else
        VORPcore.NotifyTip(src, _U('NeedLicenseFirst'), 4000)
    end
end)

RegisterServerEvent('mms-market:server:RemoveMyOffer',function(ID,ItemName,ItemLabel,Amount,Price,SellerCharId)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    local CanCarry = exports.vorp_inventory:canCarryItem(src, ItemName, Amount)
    if CanCarry then
    local result = MySQL.query.await("SELECT * FROM mms_market WHERE id=@id", { ["id"] = ID})
        if #result > 0 then
            MySQL.execute('DELETE FROM mms_market WHERE id = ?', { ID }, function()
            end)
        end
    local result2 = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
        if #result2 > 0 then
            local MyListings = result2[1].listings
            local NewListings = MyListings - 1
            MySQL.update('UPDATE `mms_marketlicense` SET listings = ? WHERE charidentifier = ?',{NewListings, Charidentifier})
        end
        exports.vorp_inventory:addItem(src, ItemName, Amount)
        VORPcore.NotifyTip(src, _U('RemovedOwnOffer'), 5000)
    else
        VORPcore.NotifyTip(src, _U('NotEnoghSpace'), 5000)
    end
end)

RegisterServerEvent('mms-market:server:GetMyMoney',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local Charidentifier = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_marketlicense WHERE charidentifier=@charidentifier", { ["charidentifier"] = Charidentifier})
    if #result > 0 then
        local MyMoney = result[1].marketmoney
        if MyMoney > 0 then
            local NewMoney = 0
            Character.addCurrency(0, MyMoney)
            MySQL.update('UPDATE `mms_marketlicense` SET marketmoney = ? WHERE charidentifier = ?',{NewMoney, Charidentifier})
            VORPcore.NotifyTip(src, _U('GotMoney') .. MyMoney .. _U('MoneyEarned'), 5000)
        else
            VORPcore.NotifyTip(src, _U('NothingSold'), 5000)
        end
    end
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()