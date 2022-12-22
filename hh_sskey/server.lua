RegisterCommand("rope", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    RopeLoadTextures() 
    while not RopeAreTexturesLoaded() do Wait(1) 
    end
    local rope = AddRope(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 5.0, 5, 5.0, 0.0, 0.0, false, true, true, 1.0, false, 0)
    LoadRopeData(rope, 'ropeFamily3')
    StartRopeWinding(rope)
    RequestModel(`a_f_m_beach_01`)
    while not HasModelLoaded(`a_f_m_beach_01`) do
        Wait(1)
    end
    local npc = CreatePed(0, `a_f_m_beach_01`, pos.x+2, pos.y+2, pos.z, 60.0, true)
    Wait(1000)
    local pos2 = GetEntityCoords(npc)
    AttachEntitiesToRope(rope, ped, npc, pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, 5.0, 0, 0, nil, nil)
end)



local QBCore = exports['qb-core']:GetCoreObject()


QBCore.Functions.CreateUseableItem("stashkey", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('secretstash', source, Player.PlayerData.citizenid, item.info, item.slot)
    end
end)


RegisterServerEvent('regsecretstash', function(car, plate, ident, slot)
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
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',{plate, owner}, function(result)
        if result[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)


