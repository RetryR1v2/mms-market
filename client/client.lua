local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()

MarketBlips = {}
InventoryOpened = false
ListingsOpened = false
MyListingsOpened = false

Citizen.CreateThread(function()
    local MarketGroup = BccUtils.Prompts:SetupPromptGroup()
    local OpenMarket = MarketGroup:RegisterPrompt(_U('OpenMarket'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G

        for h,v in pairs(Config.Markets) do
            if v.SpawnBlip then
                local MarketBlips = BccUtils.Blips:SetBlip(v.Name, v.BlipSprite, 2.0, v.Coords.x,v.Coords.y,v.Coords.z)
                MarketBlips[#MarketBlips + 1] = MarketBlips
            end
        end


    while true do
        Wait(1)
        for h,v in pairs(Config.Markets) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - v.Coords)
            if dist < 3 then
                MarketGroup:ShowGroup(_U('OpenBoard'))

                if OpenMarket:HasCompleted() then
                    Marketplace:Open({
                    startupPage = MarketplacePage1,
                    })
                end
            end
        end
    end
end)


----------------- Menu Part ----------------


Citizen.CreateThread(function ()
    Marketplace = FeatherMenu:RegisterMenu('Marketplace', {
        top = '20%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '350px'
            }
        },
        draggable = true,
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
    MarketplacePage1 = Marketplace:RegisterPage('seite1')
    MarketplacePage1:RegisterElement('header', {
        value = _U('MarketplaceHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    MarketplacePage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    MarketplacePage1:RegisterElement('button', {
        label =  _U('BuyLicense') .. Config.LicensePrice,
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Marketplace:Close({ 
        })
        Citizen.Wait(250)
        TriggerServerEvent('mms-market:server:BuyMarketLicense')
    end)
    MarketplacePage1:RegisterElement('button', {
        label =  _U('Offer'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-market:server:GetInventory')
    end)
    MarketplacePage1:RegisterElement('button', {
        label =  _U('Listings'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-market:server:GetListings')
    end)
    MarketplacePage1:RegisterElement('button', {
        label =  _U('TakeMoney'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-market:server:GetMyMoney')
    end)
    MarketplacePage1:RegisterElement('button', {
        label =  _U('MyOffers'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-market:server:GetMyListings')
    end)
    MarketplacePage1:RegisterElement('button', {
        label =  _U('CloseMarketplace'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Marketplace:Close({ 
        })
    end)
    MarketplacePage1:RegisterElement('subheader', {
        value = _U('MarketplaceSubHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    MarketplacePage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)


-- Offer 

RegisterNetEvent('mms-market:client:OfferProdukt')
AddEventHandler('mms-market:client:OfferProdukt',function (Inventory)
    --print(json.encode(Inventory,{ident = true}))
    if not InventoryOpened then
        MarketplacePage2 = Marketplace:RegisterPage('seite2')
        MarketplacePage2:RegisterElement('header', {
            value = _U('OfferProdukt'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage2:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        local Amount = ''
        MarketplacePage2:RegisterElement('input', {
        label = _U('HowMuch'),
        placeholder = '0',
        persist = false,
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        }
        }, function(data)
            Amount = data.value
        end)
        local Price = ''
        MarketplacePage2:RegisterElement('input', {
        label = _U('PricePer'),
        placeholder = '0.00',
        persist = false,
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        }
        }, function(data)
            Price = data.value
        end)
        for h,v in ipairs(Inventory) do
            local buttonLabel = ' ' .. v.label .. ' ' .. v.count
            MarketplacePage2:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                NumberAmount = tonumber(Amount)
                NumberPrice = tonumber(Price)
                if NumberAmount ~= nil and NumberPrice ~= nil then
                    local Count = v.count
                    local ItemLabel = v.label
                    local ItemName = v.name
                    if NumberAmount <= Count then
                        TriggerServerEvent('mms-market:server:PlaceOffer', NumberAmount,NumberPrice, ItemName, ItemLabel)
                        Marketplace:Close({ 
                        })
                    else
                        VORPcore.NotifyTip(_U('NotEnoghAmount') .. ItemLabel, 5000)
                    end
                else
                    VORPcore.NotifyTip(_U('InsertAmount'), 5000)
                end
            end)
        end
        MarketplacePage2:RegisterElement('button', {
            label =  _U('CloseMarketplace'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Marketplace:Close({ 
            })
        end)
        MarketplacePage2:RegisterElement('subheader', {
            value = _U('MarketplaceSubHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage2:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        InventoryOpened = true
        Citizen.Wait(250)
        MarketplacePage2:RouteTo()
        elseif InventoryOpened then
        MarketplacePage2:UnRegister()
        MarketplacePage2 = Marketplace:RegisterPage('seite2')
        MarketplacePage2:RegisterElement('header', {
            value = _U('OfferProdukt'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage2:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        local Amount = ''
        MarketplacePage2:RegisterElement('input', {
        label = _U('HowMuch'),
        placeholder = '0',
        persist = false,
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        }
        }, function(data)
            Amount = data.value
        end)
        local Price = ''
        MarketplacePage2:RegisterElement('input', {
        label = _U('PricePer'),
        placeholder = '0.00',
        persist = false,
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        }
        }, function(data)
            Price = data.value
        end)
        for h,v in ipairs(Inventory) do
            local buttonLabel = ' ' .. v.label .. ' ' .. v.count
            MarketplacePage2:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                NumberAmount = tonumber(Amount)
                NumberPrice = tonumber(Price)
                if NumberAmount ~= nil and NumberPrice ~= nil then
                    local Count = v.count
                    local ItemLabel = v.label
                    local ItemName = v.name
                    if NumberAmount <= Count then
                        TriggerServerEvent('mms-market:server:PlaceOffer', NumberAmount,NumberPrice, ItemName, ItemLabel)
                        Marketplace:Close({ 
                        })
                    else
                        VORPcore.NotifyTip(_U(' NotEnoghAmount') .. ItemLabel, 5000)
                    end
                else
                    VORPcore.NotifyTip(_U('InsertAmount'), 5000)
                end
            end)
        end
        MarketplacePage2:RegisterElement('button', {
            label =  _U('CloseMarketplace'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Marketplace:Close({ 
            })
        end)
        MarketplacePage2:RegisterElement('subheader', {
            value = _U('MarketplaceSubHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage2:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage2:RouteTo()
        end
end)

-- Listings -----------------------------------------

RegisterNetEvent('mms-market:client:ShowListings')
AddEventHandler('mms-market:client:ShowListings',function (Listing)
    --print(json.encode(Inventory,{ident = true}))
    if not ListingsOpened then
        MarketplacePage3 = Marketplace:RegisterPage('seite3')
        MarketplacePage3:RegisterElement('header', {
            value = _U('ListingsProdukt'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage3:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for h,v in ipairs(Listing) do
            local buttonLabel = _U('OfferFrom') .. v.firstname .. ' ' .. v.lastname .. ' ' .. v.amount .. ' ' .. v.itemlabel .. _U('For') .. v.price
            MarketplacePage3:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                local ItemName = v.itemname
                local ItemLabel = v.itemlabel
                local Amount = v.amount
                local Price = v.price
                local SellerCharId = v.charidentifier
                local ID = v.id
                TriggerServerEvent('mms-market:server:BuyOffer',ID, ItemName,ItemLabel,Amount,Price,SellerCharId)
                Marketplace:Close({ 
                })
            end)
        end
        MarketplacePage3:RegisterElement('button', {
            label =  _U('CloseMarketplace'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Marketplace:Close({ 
            })
        end)
        MarketplacePage3:RegisterElement('subheader', {
            value = _U('MarketplaceSubHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage3:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        ListingsOpened = true
        Citizen.Wait(250)
        MarketplacePage3:RouteTo()
        elseif ListingsOpened then
        MarketplacePage3:UnRegister()
        MarketplacePage3 = Marketplace:RegisterPage('seite2')
        MarketplacePage3 = Marketplace:RegisterPage('seite3')
        MarketplacePage3:RegisterElement('header', {
            value = _U('ListingsProdukt'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage3:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for h,v in ipairs(Listing) do
            local buttonLabel = _U('OfferFrom') .. v.firstname .. ' ' .. v.lastname .. ' ' .. v.amount .. ' ' .. v.itemlabel .. _U('For') .. v.price
            MarketplacePage3:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                local ItemName = v.itemname
                local ItemLabel = v.itemlabel
                local Amount = v.amount
                local Price = v.price
                local SellerCharId = v.charidentifier
                local ID = v.id
                TriggerServerEvent('mms-market:server:BuyOffer',ID, ItemName,ItemLabel,Amount,Price,SellerCharId)
                Marketplace:Close({ 
                })
            end)
        end
        MarketplacePage3:RegisterElement('button', {
            label =  _U('CloseMarketplace'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Marketplace:Close({ 
            })
        end)
        MarketplacePage3:RegisterElement('subheader', {
            value = _U('MarketplaceSubHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage3:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage3:RouteTo()
        end
end)

-- MyListings -----------------------------------------

RegisterNetEvent('mms-market:client:ShowMyListings')
AddEventHandler('mms-market:client:ShowMyListings',function (MyListing)
    --print(json.encode(Inventory,{ident = true}))
    if not MyListingsOpened then
        MarketplacePage4 = Marketplace:RegisterPage('seite4')
        MarketplacePage4:RegisterElement('header', {
            value = _U('ListingsProdukt'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage4:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for h,v in ipairs(MyListing) do
            local buttonLabel = _U('OfferFrom') .. v.firstname .. ' ' .. v.lastname .. ' ' .. v.amount .. ' ' .. v.itemlabel .. _U('For') .. v.price
            MarketplacePage4:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                local ItemName = v.itemname
                local ItemLabel = v.itemlabel
                local Amount = v.amount
                local Price = v.price
                local SellerCharId = v.charidentifier
                local ID = v.id
                TriggerServerEvent('mms-market:server:RemoveMyOffer',ID, ItemName,ItemLabel,Amount,Price,SellerCharId)
                Marketplace:Close({ 
                })
            end)
        end
        MarketplacePage4:RegisterElement('button', {
            label =  _U('CloseMarketplace'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Marketplace:Close({ 
            })
        end)
        MarketplacePage4:RegisterElement('subheader', {
            value = _U('MarketplaceSubHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage4:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MyListingsOpened = true
        Citizen.Wait(250)
        MarketplacePage4:RouteTo()
        elseif MyListingsOpened then
        MarketplacePage4:UnRegister()
        MarketplacePage4 = Marketplace:RegisterPage('seite4')
        MarketplacePage4:RegisterElement('header', {
            value = _U('ListingsProdukt'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage4:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for h,v in ipairs(MyListing) do
            local buttonLabel = _U('OfferFrom') .. v.firstname .. ' ' .. v.lastname .. ' ' .. v.amount .. ' ' .. v.itemlabel .. _U('For') .. v.price
            MarketplacePage4:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                local ItemName = v.itemname
                local ItemLabel = v.itemlabel
                local Amount = v.amount
                local Price = v.price
                local SellerCharId = v.charidentifier
                local ID = v.id
                TriggerServerEvent('mms-market:server:RemoveMyOffer',ID, ItemName,ItemLabel,Amount,Price,SellerCharId)
                Marketplace:Close({ 
                })
            end)
        end
        MarketplacePage4:RegisterElement('button', {
            label =  _U('CloseMarketplace'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Marketplace:Close({ 
            })
        end)
        MarketplacePage4:RegisterElement('subheader', {
            value = _U('MarketplaceSubHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage4:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        MarketplacePage4:RouteTo()
        end
end)

----------------- Utilities -----------------


------ Progressbar

function Progressbar(Time)
    progressbar.start(_U('SearchingBinProgressbar'), Time, function ()
    end, 'linear')
    Wait(Time)
    ClearPedTasks(PlayerPedId())
end

------ Animation

function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

------------------------- Clean Up on Resource Restart -----------------------------

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
        --for _, mpeds in ipairs() do
        --    mpeds:Remove()
	    --end
        for _, mblips in ipairs(MarketBlips) do
            mblips:Remove()
	    end
    end
end)