local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
RadarL = {}
Tunnel.bindInterface("vrp_radar",RadarL)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR
-----------------------------------------------------------------------------------------------------------------------------------------
local tempo = false
function RadarL.checarMulta(valor)
	local user_id = vRP.getUserId(source)
	if not tempo then
	    vRP.tryPayment(user_id,valor)
	    tempo = true
	    SetTimeout(1000,function()
			tempo = false
		end)
	end
end

function RadarL.checarOrgs()
	local user_id = vRP.getUserId(source)
	if vRP.hasGroup(user_id,"PoliciaSalario") then
        return true
    elseif vRP.hasGroup(user_id,"ParamedicoSalario") then
        return true
    end
    return false
end

