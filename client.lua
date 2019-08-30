local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
RadarL = Tunnel.getInterface("vrp_radar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR
-----------------------------------------------------------------------------------------------------------------------------------------
local radares = {
	{ ['x'] = 270.05169677734, ['y'] = -884.10357666016, ['z'] = 29.130258560181 },
	{ ['x'] = 283.95687866211, ['y'] = -885.39770507813, ['z'] = 29.155006408691 }, 
	{ ['x'] = 223.17585754395, ['y'] = -1015.0646972656, ['z'] = 29.325428009033 },
	{ ['x'] = 237.10076904297, ['y'] = -1019.0006103516, ['z'] = 29.321067810059 },
	{ ['x'] = 199.86459350586, ['y'] = -1029.9130859375, ['z'] = 29.369081497192 }, 
	{ ['x'] = 196.72747802734, ['y'] = -1039.380859375, ['z'] = 29.369285583496 },
	{ ['x'] = 132.03970336914, ['y'] = -1000.6408081055, ['z'] = 29.405767440796 }, 
	{ ['x'] = 127.94882202148, ['y'] = -1010.8630371094, ['z'] = 29.406673431396 }, 
	{ ['x'] = 127.55332183838, ['y'] = -1016.0056152344, ['z'] = 29.406164169312 },
	{ ['x'] = 262.31838989258, ['y'] = -859.40045166016, ['z'] = 29.339338302612 }, 
	{ ['x'] = 265.91488647461, ['y'] = -848.91552734375, ['z'] = 29.338109970093 }, 
	{ ['x'] = 268.35852050781, ['y'] = -843.95007324219, ['z'] = 29.323219299316 }, 
	{ ['x'] = 195.12258911133, ['y'] = -837.46899414063, ['z'] = 30.935953140259 },
	{ ['x'] = 197.75634765625, ['y'] = -829.79406738281, ['z'] = 30.991416931152 }, 
	{ ['x'] = 200.05506896973, ['y'] = -821.99444580078, ['z'] = 31.003452301025 }, 
	{ ['x'] = 122.48711395264, ['y'] = -978.77172851563, ['z'] = 29.404535293579 }, 
	{ ['x'] = 116.77993011475, ['y'] = -976.85797119141, ['z'] = 29.407270431519 }, 
	{ ['x'] = 110.02415466309, ['y'] = -973.87243652344, ['z'] = 29.407308578491 }, 
	{ ['x'] = 156.06024169922, ['y'] = -839.46496582031, ['z'] = 31.113914489746 }, 
	{ ['x'] = 163.36291503906, ['y'] = -842.93292236328, ['z'] = 31.103658676147 }, 
	{ ['x'] = 170.62078857422, ['y'] = -845.91845703125, ['z'] = 31.0964012146 }, 
	{ ['x'] = 176.01515197754, ['y'] = -847.45904541016, ['z'] = 30.89661026001 }, 
	{ ['x'] = 253.80966186523, ['y'] = -623.19793701172, ['z'] = 41.570297241211 },  
	{ ['x'] = 248.42869567871, ['y'] = -621.89447021484, ['z'] = 41.489410400391 },  
	{ ['x'] = 243.83012390137, ['y'] = -619.859375, ['z'] = 41.495418548584 },  
	{ ['x'] = 237.59017944336, ['y'] = -617.61834716797, ['z'] = 41.466960906982 },  
	{ ['x'] = 281.0537109375, ['y'] = -559.71618652344, ['z'] = 43.278865814209 }, 
	{ ['x'] = 274.81539916992, ['y'] = -557.99182128906, ['z'] = 43.322231292725 }, 
	{ ['x'] = 269.19018554688, ['y'] = -556.15753173828, ['z'] = 43.321281433105 }, 
	{ ['x'] = 263.6516418457, ['y'] = -554.89581298828, ['z'] = 43.314785003662 },
	{ ['x'] = 399.9231262207, ['y'] = -967.17211914063, ['z'] = 29.403299331665 }, 
	{ ['x'] = 398.34548950195, ['y'] = -1019.6214599609, ['z'] = 29.461402893066 }
}

local tempo = false
local tempo2 = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for _,v in pairs(radares) do
		    local ped = PlayerPedId()
		    local vehicle = GetVehiclePedIsIn(ped)
		    local distance = GetDistanceBetweenCoords(v.x,v.y,v.z,GetEntityCoords(ped),true)
		    local speed = GetEntitySpeed(vehicle)*3.605936
		    if distance <= 8.0 then	
		        if IsEntityAVehicle(vehicle) then
			        if GetPedInVehicleSeat(vehicle,-1) then
				        if speed >= 101 and not tempo then
					        vRP.setDiv("radar",".div_radar { background: #fff; margin: 0; width: 100%; height: 100%; opacity: 0.9; }","")
					        PlaySoundFrontend( -1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1 )
		                    SetTimeout(200,function()
			                    vRP.removeDiv("radar")
			                    tempo = true
		                    end)
		                    SetTimeout(1150,function()
					        	tempo = false
					        end)
				        end
				        if speed >= 101 and speed < 150 and not RadarL.checarOrgs() then
				        	RadarL.checarMulta(200)
				        	if not tempo2 then
				        		TriggerEvent('chatMessage',"ALERTA",{255,70,50},"Radar: Limite de velocidade permitido é 100KM/H, voce estava a "..math.ceil(speed).."KM/H, recebeu uma multa de $200!")
				        		vRP._notify()
				        		tempo2 = true
				        		SetTimeout(1000,function()
					        	    tempo2 = false
					            end)
					        end
				        elseif speed >= 151 and speed < 200 and not RadarL.checarOrgs() then
				        	RadarL.checarMulta(300)
				        	if not tempo2 then
				        		TriggerEvent('chatMessage',"ALERTA",{255,70,50},"Radar: Limite de velocidade permitido é 100KM/H, voce estava a "..math.ceil(speed).."KM/H, recebeu uma multa de $300!")
				        		tempo2 = true
				        		SetTimeout(1000,function()
					        	    tempo2 = false
					            end)
					        end
				        elseif speed >= 201 and speed < 250 and not RadarL.checarOrgs() then
                            RadarL.checarMulta(400)
                            if not tempo2 then
				        		TriggerEvent('chatMessage',"ALERTA",{255,70,50},"Radar: Limite de velocidade permitido é 100KM/H, voce estava a "..math.ceil(speed).."KM/H, recebeu uma multa de $400!")
				        		tempo2 = true
				        		SetTimeout(1000,function()
					        	    tempo2 = false
					            end)
					        end
                        elseif speed >= 251 and not RadarL.checarOrgs() then
                        	RadarL.checarMulta(500)
                        	if not tempo2 then
				        		TriggerEvent('chatMessage',"ALERTA",{255,70,50},"Radar: Limite de velocidade permitido é 100KM/H, voce estava a "..math.ceil(speed).."KM/H, recebeu uma multa de $500!")
				        		tempo2 = true
				        		SetTimeout(1000,function()
					        	    tempo2 = false
					            end)
					        end
                        end
				    end
				end
			end
		end
	end
end)