QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


QBCore.Functions.CreateUseableItem("stashkey", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('secretstash', source, Player.PlayerData.citizenid, item.info, item.slot)
    end
end)

RegisterServerEvent('regsecretstash')
AddEventHandler('regsecretstash', function(car, plate, malik, slot)
    local malik2 = QBCore.Functions.GetPlayerByCitizenId(malik)
    if malik2.Functions.GetItemBySlot(slot) ~= nil then
        malik2.Functions.RemoveItem('stashkey', 1)
        local name = malik2.PlayerData.charinfo.firstname .. ' ' .. malik2.PlayerData.charinfo.lastname
        local info = {}
        info.car = car
        info.ss = plate
        info.owner = name
        malik2.Functions.AddItem('stashkey', 1, nil, info)
    else
        print('SLOT CHANGED')
    end
end)

QBCore.Functions.CreateCallback("hhfw:checkVehicleOwner", function(source, cb, plate, owner)
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {['@plate'] = plate, ['@citizenid'] = owner}, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)
