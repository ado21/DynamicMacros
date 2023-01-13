local dynamicMacrosFrameName = "dynamicMacrosFrameName";
macroNameArray = {};
local nonExistentmacroNameArray

local H --healer var
local D -- damager var

--Register event on which macros should start changing
local dynamicMacros = CreateFrame("Frame", "DynamicMacrosFrame");
dynamicMacros:RegisterEvent("GROUP_ROSTER_UPDATE");--GROUP_ROSTER_UPDATE,PLAYER_TARGET_CHANGED,ARENA_TEAM_UPDATE

local function updatePlayerNamesInMacros(self, event, ...)
    H = nil
    D = nil
    --delay whole functionality by x seconds due to UnitName() api returning unknown immediately on player load into arena
    C_Timer.After(3, dynamicMacroUpdate)
end

dynamicMacros:SetScript("OnEvent", updatePlayerNamesInMacros);

function dynamicMacroUpdate()
    --trigger only if 2 or 3 players are in party (2v2 / 3v3 situations)
    if not InCombatLockdown() and ((GetNumGroupMembers() == 2) or (GetNumGroupMembers() == 3)) then
        nonExistentmacroNameArray = {}
        -- loop to parse every macro user defined 
        for key, value in pairs(macroNameArray) do
            body = GetMacroBody(macroNameArray[key])
            -- in case specified macro under specific name does not exist, add macro name into list which will be printed as information for user later in code
            if body == nil then
                table.insert(nonExistentmacroNameArray, macroNameArray[key])
            else
                H,D = specifyHealerAndDamagerInParty(macroNameArray[key]);
            end
        end
        if (not next(macroNameArray)) then
            --print("DynamicMacros are not created !")
            return
        -- print names of macros which do not exist but are specified in addon
        elseif (#nonExistentmacroNameArray ~= 0) then
            print("|cff33ff99DynamicMacros: |rOne or more of the specified macros are non existent. For that reason those macros:\n[ "..table.concat(nonExistentmacroNameArray, ', ').." ] has been omitted.")               
        else
            --print("All DynamicMacros has been adjusted")
        end
        -- Inform user who has been determined as healer and damager
        if (H ~= nil) then
            print('|cff33ff99DynamicMacros: |rHealer: ' .. H) 
        end
        if (D ~= nil) then
            print('|cff33ff99DynamicMacros: |rDamager: ' .. D) 
        end
    end
end

function specifyHealerAndDamagerInParty(macroName)
    local body=GetMacroBody(macroName) 
    local i,j,k,l
    local m = 0
    -- in case user macro is empty
    if (strlen(body) == 0) then
        print("|cff33ff99DynamicMacros: |rMacro \""..macroName.."\" is empty!")
        return
    end
    --go through whole content of users macro
    while m <= strlen(body) do
        -- look for first occurence [@<<anything>>]
        i,j,k,l = findNameInMacro(body,i,j,k,l)
        if j == nil then
            break
        end                
        m = m + (l - j)
        -- check if found string is not target, focus, mouseover, arena1/2/3, partypet1/2
        if ((strsub(body, j+1, k-1) ~= "target") and (strsub(body, j+1, k-1) ~= "focus") and (strsub(body, j+1, k-1) ~= "mouseover") and (strsub(body, j+1, k-1) ~= "arena1") and (strsub(body, j+1, k-1) ~= "arena2") and (strsub(body, j+1, k-1) ~= "arena3") and (strsub(body, j+1, k-1) ~= "partypet1") and (strsub(body, j+1, k-1) ~= "partypet2")) then
            -- check if found string is not users character name
            if (checkIfPlayerUnitName(body,j,k) == false) then
                local party1Name = strsub(body, j+1, k-1)
                --replace first occurence of a string with string \'.. H ..\'
                local cnt = 0
                body = string.gsub (body, party1Name, function ( m )
                    cnt = cnt + 1
                    if cnt == 1 then
                        return "\'.. H ..\'"
                    end
                end)
                break
            end
        end
    end
    --go through whole content of users macro
    while m <= strlen(body) do
        --look for second occurence [@<<anything>>]
        i,j,k,l = findNameInMacro(body,i,j,k,l)
        if j == nil then
            break
        end                
        m = m + (l - j)
        -- check if found string is not target, focus, arena1/2/3, partypet1/2 or previosuly set \'.. H ..\' string
        if ((strsub(body, j+1, k-1) ~= "target") and (strsub(body, j+1, k-1) ~= "focus") and (strsub(body, j+1, k-1) ~= "arena1") and (strsub(body, j+1, k-1) ~= "arena2") and (strsub(body, j+1, k-1) ~= "arena3") and (strsub(body, j+1, k-1) ~= "partypet1") and (strsub(body, j+1, k-1) ~= "partypet2") and (strsub(body, j+1, k-1) ~= "\'.. H ..\'")) then
            -- check if found string is not users character name
            if (checkIfPlayerUnitName(body,j,k) == false) then
                local party1Name = strsub(body, j+1, k-1)
                --replace first occurence of a string with string \'.. D ..\'
                local cnt = 0
                body = string.gsub (body, party1Name, function ( m )
                    cnt = cnt + 1
                    if cnt == 1 then
                        return "\'.. D ..\'"
                    end
                end)
                break
            end
        end
    end

    -- loop to look at all 3 party members
    local condition = GetNumGroupMembers()
    for i = GetNumGroupMembers()-1,0,-1 do
        --look for healer or prot pala tank who will be categorized as healers
        if (UnitGroupRolesAssigned("party"..i) == "HEALER" or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "Paladin"))) then
            --assign categorized healer into variable
            H=UnitNameUnmodified("party"..i)    
            --print('Healer: ' .. H)               
        end
        --look for healer or NON prot pala tanks who will be categorized as damagers
        if (UnitGroupRolesAssigned("party"..i) == "DAMAGER" or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "Warrior")) or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "DeathKnight")) or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "Druid")) or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "Demon Hunter")) or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "Monk")) or ((UnitGroupRolesAssigned("party"..i) == "TANK" and UnitClass("party"..i) == "Warrior"))) then
            --assign categorized damager into variable
            D=UnitNameUnmodified("party"..i) 
            --print('Damager: ' .. D)                 
        end 
    end  
    -- in case nothing has been found
    if (H == nil and D == nil) then
        return 0
    end
    --replace previosly set strings (\'.. H ..\' and \'.. D ..\') with Name of categorized healer and damager (H represents Healer and D represents Damager)
    if(H ~= nil) then
        body = string.gsub (body, "\'.. H ..\'", H) 
    end
    if (D ~= nil) then
        body = string.gsub (body, "\'.. D ..\'", D) 
    end

    --FINAL PIECE of puzzle put modified macro(body variable) back into to macros ingame.
    EditMacro(macroName,nil,nil,body,nil) 

    return H,D
end

function findNameInMacro(body,i,j,k,l)
    if l ~= nil then
        if l > strlen(body) then
            return
        end
    end
    --start of unit name at @
    i, j = string.find(body, "@", l)

    --look for name ending with "]"
    k, l = string.find(body, "%]", j)

    --look for name ending with ","
    local m, n = string.find(body, ",", j)

    -- in case "," has been found earlier than "]" consider it as end of name
    if (m ~= nil and n ~= nil) then
        if (n < l) then
            k = m
            l = n
        end 
    end

    --in case macro body is empty
    if (i == nil and j == nil and k == nil and l == nil) then
       return i,j,k,l 
    end
    return i,j,k,l+1
end

--Check if name is playerName if yes repeat search and return position indicators
function checkIfPlayerUnitName(body,j,k)
    local name,_ = UnitNameUnmodified("player")
    if (name == strsub(body, j+1, k-1)) then
        return true
    end
    return false
end
