local DMVersion = GetAddOnMetadata("DynamicMacros", "Version")

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
    local panel = CreateFrame("Frame")
    panel.name = "DynamicMacros"            
    InterfaceOptions_AddCategory(panel)

    -- create GUI commands
    SLASH_DMCOMMANDSGUI1 = "/dm"
    SlashCmdList["DMCOMMANDSGUI"] = function(msg)
        InterfaceOptionsFrame_OpenToCategory(panel)
    end

    -- add widgets to the panel as desired
    local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 15, -15)
    title:SetText("Dynamic Macros")

    local dynamicMacrosDescription = CreateFrame("Frame", "dynamicMacrosFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    dynamicMacrosDescription:SetPoint("TOPLEFT", panel, "TOPLEFT", 15, -60)
    dynamicMacrosDescription:SetSize(50, 50)

    local dynamicMacrosDescriptionText = dynamicMacrosDescription:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    dynamicMacrosDescriptionText:SetText("To make this feature, blizzard's macro logic has undergone some improvements. Therefore to")
    dynamicMacrosDescriptionText:SetTextColor(1,0,0,1)
    dynamicMacrosDescriptionText:SetPoint("TOPLEFT", dynamicMacrosDescription, "TOPLEFT", 0, 0)
    dynamicMacrosDescriptionText:SetFontObject(GameFontNormal)
    local dynamicMacrosDescriptionText2 = dynamicMacrosDescription:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    dynamicMacrosDescriptionText2:SetText("understand logic of dynamic macros please see documentation at GitHub.")
    dynamicMacrosDescriptionText2:SetTextColor(1,0,0,1)
    dynamicMacrosDescriptionText2:SetPoint("TOPLEFT", dynamicMacrosDescription, "TOPLEFT", 0, -20)
    dynamicMacrosDescriptionText2:SetFontObject(GameFontNormal)

    -- add EditBox to UI
    local ideditbox = CreateEditBox("Macro Name", panel, 140, 30)
    ideditbox:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -150)

    -- add button to UI
    local addbutton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    addbutton:SetSize(65, 30)
    addbutton:SetText("Add")
    addbutton:SetPoint("TOPLEFT", ideditbox, "BOTTOMLEFT", -5, -5)
    addbutton:SetScript("OnClick", function(self, button, down)
        
        local userMacroNameInput = ideditbox:GetText()
        if userMacroNameInput == "" then
            print("|cff33ff99DynamicMacros: |rMacro name is empty!")
            return
        end
        result = has_value(DynamicMacros_macroNameArray, userMacroNameInput)
        if (result == false) then
            table.insert(DynamicMacros_macroNameArray, userMacroNameInput)
            ideditbox:SetText("");
            UpdateUIList()
        else
            print("|cff33ff99DynamicMacros: |rMacro with this name already exists!")
        end

    end)

    -- add button to UI
    local removebutton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    removebutton:SetSize(65, 30)
    removebutton:SetText("Remove")
    removebutton:SetPoint("LEFT", addbutton, "RIGHT", 15, 0)
    removebutton:SetScript("OnClick", function(self, button, down)

        local userMacroNameInput = ideditbox:GetText()
        local result = has_value(DynamicMacros_macroNameArray, userMacroNameInput)
        if (result ~= false) then
            table.remove(DynamicMacros_macroNameArray,result)
            ideditbox:SetText("");
            UpdateUIList()
        end 
        
    end) 
    
    local macroNameTitle = CreateFrame("Frame", "dynamicMacrosFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    macroNameTitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 15, -235)
    macroNameTitle:SetSize(50, 50)

    local macroNameTitleText = macroNameTitle:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    macroNameTitleText:SetText("List of macros which will function as Dynamic Macros")
    macroNameTitleText:SetPoint("TOPLEFT", macroNameTitle, "TOPLEFT", 0, 0)
    macroNameTitleText:SetFontObject(GameFontNormalLarge)

    local cpanel = CreateFrame("Frame", "dynamicMacrosFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    cpanel:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 15
    });
    cpanel:SetSize(640, 280)
    cpanel:SetPoint("TOP", panel, "TOP", -7, -260)
    listNames = CreateFrame("ScrollingMessageFrame", "dynamicMacrosFrame", cpanel, BackdropTemplateMixin and "BackdropTemplate")
    listNames:SetPoint("TOPLEFT", 27, -25)
    listNames:SetPoint("BOTTOMRIGHT", -25, 25)
    listNames:SetInsertMode(SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP)
    listNames:SetFading(false)
    listNames:SetIndentedWordWrap(false)
    listNames:SetFontObject(GameFontNormal)
    listNames:SetJustifyH("LEFT")
    listNames:AddMessage(table.concat(DynamicMacros_macroNameArray, ', '))


    local info = CreateFrame("Frame", "dynamicMacrosFrame", panel, BackdropTemplateMixin and "BackdropTemplate")
    info:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -555)
    info:SetSize(50, 50)
    
    local version = info:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    version:SetText("|cffffff00Version:|r |cff33ff99v" .. DMVersion .. "|r by |cffffff00Krionel|r")
    version:SetPoint("TOPLEFT", info, "TOPLEFT", 0, 0)

    local contact = info:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    contact:SetText("[ Contact: https://www.curseforge.com/wow/addons/dynamicmacros-pvp ]")
    contact:SetPoint("TOPLEFT", info, "TOPLEFT", 0, -15)
end

function UpdateUIList()
    listNames:Clear()
    listNames:AddMessage(table.concat(DynamicMacros_macroNameArray, ', '))
end

function CreateEditBox(name, parent, width, height)
    local editbox = CreateFrame("EditBox", parent:GetName(), parent, "InputBoxTemplate")
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
