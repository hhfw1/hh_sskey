QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)


RegisterNetEvent('secretstash')
AddEventHandler('secretstash', function(ident, info, slot)
    local me = PlayerPedId()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(me))
    local car = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(me)))
    print(info.ss, info.owner, info.car)
    if not IsPedSittingInAnyVehicle(me) then
        QBCore.Functions.Notify("You cant use Stash Key Inside", "error")
        return
    end
    ExecuteCommand('e mechanic')
    QBCore.Functions.Progressbar("tmkc", "Inserting Secret Stash Key", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        ExecuteCommand('e c')
        QBCore.Functions.TriggerCallback('hhfw:checkVehicleOwner', function(tmkc)
            if tmkc then
                if info.ss == nil then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", plate.."SS", {
                        maxweight = 40000,
                        slots = 10,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", plate.."SS")
                    TriggerServerEvent('regsecretstash', car, plate, ident, slot)
                elseif info.ss == plate then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", plate.."SS", {
                        maxweight = 40000,
                        slots = 10,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", plate.."SS")
                else
                    QBCore.Functions.Notify("Key Mismatch", "error")
                end
            else
                QBCore.Functions.Notify("You dont't own this Vehicle", "error")
            end
        end, plate, ident)
    end, function() -- Cancel
        ExecuteCommand('e c')
        QBCore.Functions.Notify("Canceled..", "error")
    end)
end)
