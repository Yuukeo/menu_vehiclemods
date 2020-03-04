local ESX = nil

function gigneMenu()
	TriggerEvent('gigne:registerMenu', 'vehicleStatus', {event = 'gigne:vehicleStatus', label = 'Check Vehicle Upgrades'})
end

RegisterNetEvent('gigne:startMenu')
AddEventHandler('gigne:startMenu', function()
	gigneMenu()
end)

RegisterNetEvent('gigne:vehicleStatus')
AddEventHandler('gigne:vehicleStatus', function()
	if IsPedInAnyVehicle(PlayerPedId(), true) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		vehicleStatus(vehicle)
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	gigneMenu()
end)

function vehicleStatus(vehicle)
	-- body
	local elements = {}
	local vehicleMods = {
		x11 = 'modEngine',
		x12 = 'modBrakes',
		x13 = 'modTransmission',
		x14 = 'modHorns',
		x15 = 'modSuspension',
		x16 = 'modArmor',
		x17 = 'modTurbo',
	}
	

	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	print(json.encode(currentMods))

	for i = 11, 17, 1 do
		local noMod = 'x' .. i
		if i == 17 then
			if currentMods[vehicleMods[noMod]] then
				_label = 'Turbo - <span style="color:cornflowerblue;">Installed</span>'
				table.insert(elements, {label = _label})
			end			
		else
			local modCount = GetNumVehicleMods(vehicle, i) -- UPGRADES
			for j = 0, modCount, 1 do
				local _label = ''
				if j == currentMods[vehicleMods[noMod]] then
					_label = vehicleMods[noMod] .. ' level ' .. j+1 .. ' - <span style="color:cornflowerblue;">Installed</span>'
					table.insert(elements, {label = _label})
					break
				end
				
				if j == modCount-1 then
					break
				end
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicleStatus', {
		title    = 'Vehicle Upgrades',
		align    = 'top-left',
		elements = elements
	}, function(data2, menu2)

	end, function(data2, menu2)
		menu2.close()
	end)
end
