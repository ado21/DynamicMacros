local SO = LibStub("LibATTSimpleOptions")
local DMVersion = 1

--check if value exists in array
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return index
        end
    end

    return false
end

-- create UI ingame
function CreateOptions()
    local panel = SO.AddOptionsPanel("DynamicMacros", function() end)
    SO.AddSlashCommand("DynamicMacros", "/dm")

    local title, subText = panel:MakeTitleTextAndSubText("Dynamic Macros")

    local dynamicMacrosDescription = CreateFrame("Frame", "ATTFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    dynamicMacrosDescription:SetPoint("TOPLEFT", panel, "TOPLEFT", 15, -60)
    dynamicMacrosDescription:SetSize(50, 50)

    local dynamicMacrosDescriptionText = dynamicMacrosDescription:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    dynamicMacrosDescriptionText:SetText("To make this feature blizzard macro logic has undergone some improvements. Therefore to")
    dynamicMacrosDescriptionText:SetTextColor(1,0,0,1)
    dynamicMacrosDescriptionText:SetPoint("TOPLEFT", dynamicMacrosDescription, "TOPLEFT", 0, 0)
    dynamicMacrosDescriptionText:SetFontObject(GameFontNormal)
    local dynamicMacrosDescriptionText2 = dynamicMacrosDescription:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    dynamicMacrosDescriptionText2:SetText("understand logic of dynamic macros please see documentation.")
    dynamicMacrosDescriptionText2:SetTextColor(1,0,0,1)
    dynamicMacrosDescriptionText2:SetPoint("TOPLEFT", dynamicMacrosDescription, "TOPLEFT", 0, -20)
    dynamicMacrosDescriptionText2:SetFontObject(GameFontNormal)

    -- add EditBox to UI
    local ideditbox = CreateEditBox("Macro Name", panel, 140, 30)
    ideditbox:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -150)

    -- add button to UI
    local addbutton = panel:MakeButton('name', 'Add','newsize', 2, 'description', "Add / Update ability", 'func', function()
        local userMacroNameInput = ideditbox:GetText()
        if userMacroNameInput == "" then
            print("Macro name is empty!")
            return
        end
        result = has_value(macroNameArray, userMacroNameInput)
        if (result == false) then
            table.insert(macroNameArray, userMacroNameInput)
            ideditbox:SetText("");
            UpdateUIList()
        else
            print("Macro with this name already exists!")
        end
           
    end)
    addbutton:SetPoint("TOPLEFT", ideditbox, "BOTTOMLEFT", -5, -5)

    -- add button to UI
    local removebutton = panel:MakeButton('name', 'Remove', 'newsize', 2, 'description', 'Remove ability', 'func', function()
        local userMacroNameInput = ideditbox:GetText()
        local result = has_value(macroNameArray, userMacroNameInput)
        if (result ~= false) then
            table.remove(macroNameArray,result)
            ideditbox:SetText("");
            UpdateUIList()
        end

    end)    

    removebutton:SetPoint("LEFT", addbutton, "RIGHT", 15, 0)
    
    local macroNameTitle = CreateFrame("Frame", "ATTFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    macroNameTitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 15, -235)
    macroNameTitle:SetSize(50, 50)

    local macroNameTitleText = macroNameTitle:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    macroNameTitleText:SetText("List of saved macros which will behave as Dynamic Macros")
    macroNameTitleText:SetPoint("TOPLEFT", macroNameTitle, "TOPLEFT", 0, 0)
    macroNameTitleText:SetFontObject(GameFontNormalLarge)

    local cpanel = CreateFrame("Frame", "ATTFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    cpanel:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 15
    });
    cpanel:SetSize(640, 280)
    cpanel:SetPoint("TOP", panel, "TOP", -7, -260)
    listNames = CreateFrame("ScrollingMessageFrame", "ATTFrame", cpanel, BackdropTemplateMixin and "BackdropTemplate")
    listNames:SetPoint("TOPLEFT", 27, -25)
    listNames:SetPoint("BOTTOMRIGHT", -25, 25)
    listNames:SetInsertMode(SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP)
    listNames:SetFading(false)
    listNames:SetIndentedWordWrap(false)
    listNames:SetFontObject(GameFontNormal)
    listNames:SetJustifyH("LEFT")
    listNames:AddMessage(table.concat(macroNameArray, ', '))


    local info = CreateFrame("Frame", "ATTFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    info:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -555)
    info:SetSize(50, 50)
    
    local version = info:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    version:SetText("|cffffff00Version:|r |cff33ff99v" .. DMVersion .. "|r by |cffffff00Krionel|r")
    version:SetPoint("TOPLEFT", info, "TOPLEFT", 0, 0)

    local contact = info:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    contact:SetText("[ Contact: curseforge.com/wow/addons/att ]")
    contact:SetPoint("TOPLEFT", info, "TOPLEFT", 0, -15)
end

function UpdateUIList()
    listNames:Clear()
    listNames:AddMessage(table.concat(macroNameArray, ', '))
end

function CreateEditBox(name, parent, width, height)
    local editbox = CreateFrame("EditBox", parent:GetName() .. name, parent, "InputBoxTemplate")
    editbox:SetHeight(height)
    editbox:SetWidth(width)
    editbox:SetAutoFocus(false)
    editbox:SetMaxLetters(16)
    local label = editbox:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    label:SetText(name)
    label:SetPoint("BOTTOMLEFT", editbox, "TOPLEFT", -3, 0)
    return editbox
end

-- basicaly main funcion
local loader = CreateFrame('Frame');
loader:RegisterEvent('ADDON_LOADED');
loader:SetScript('OnEvent', function(self, event, arg1)
    if event == 'ADDON_LOADED' and arg1 == 'DynamicMacros' then
        CreateOptions()
        self:UnregisterEvent('ADDON_LOADED');
    end
end);

