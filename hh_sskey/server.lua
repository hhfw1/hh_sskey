QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


QBCore.Functions.CreateUseableItem("stashkey", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('secretstash', source, Player.PlayerData.citizenid, item.info, item.slot)
    end
end)

RegisterServerEvent('regsecretstash')
AddEventHandler('regsecretstash', function(car, plate, ident, slot)
    local Player = QBCore.Functions.GetPlayerByCitizenId(ident)
    if Player.Functions.GetItemBySlot(slot) ~= nil then
        Player.Functions.RemoveItem('stashkey', 1)
        local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        local info = {}
        info.car = car
        info.ss = plate
        info.owner = name
        Player.Functions.AddItem('stashkey', 1, nil, info)
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

