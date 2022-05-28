-- Golden Framework --

-- Server Functions --
function convertDate(vardate)
    local m,d,y = string.match(vardate, '(%d+)/(%d+)/(%d+)')
    return string.format('%s/%s/%s', y,m,d)
end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function string.starts(String, Start)
    return string.sub(String,1,string.len(Start))==Start
end

-- Client Functions --
function QuitGame()
	Wait(1000)
	
	ForceSocialClubUpdate()
end

function selectCharacter()
	TriggerServerEvent('golden:framework:getPlayerCharacters')
    TriggerEvent("golden:framework:payCheckToggle", "changingCharacter")
end

function loadInPlayerDepartmentData()
    TriggerServerEvent('golden:framework:getPlayerDepData')
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end