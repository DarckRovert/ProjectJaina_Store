--[[
    =============================================================================
    PROJECT JAINA — INTERFAZ OFICIAL DE LA TESORERÍA DE DALARAN (WotLK 3.3.5a)
    =============================================================================
    Archivo: StoreUI.lua
    Ecosistema: World of Warcraft 3.3.5a (Build 12340)
    Autores: Darckrovert & Antigravity (Mythos 5)
    =============================================================================
]]

ProjectJaina_Store = ProjectJaina_Store or {}
local PJ = ProjectJaina_Store

local PREFIX = "PJ_STORE"
local JAINA_TOKEN_ENTRY = 900100
local EVENT_TOKEN_ENTRY = 910000

local state = {
    tokens = 0,
    eventTokens = 0,
    selectedCategory = "all",
    selectedItem = nil
}

-- =============================================================================
-- COMUNICACIÓN DE RED (PJ_STORE)
-- =============================================================================
local function SendStoreMessage(msg)
    local pName = UnitName("player")
    if not pName or pName == "" or pName == UNKNOWNOBJECT then return end
    if RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix(PREFIX)
    end
    SendAddonMessage(PREFIX, msg, "WHISPER", pName)
end

function PJ:RequestBalance()
    -- Conteo local inmediato desde bolsas
    local localTokens = GetItemCount(JAINA_TOKEN_ENTRY) or 0
    local localEvents = GetItemCount(EVENT_TOKEN_ENTRY) or 0
    state.tokens = localTokens
    state.eventTokens = localEvents
    PJ:UpdateBalanceDisplay()

    -- Consulta autoritativa al servidor JainaCore
    SendStoreMessage("GET_BALANCE")
end

function PJ:BuyItem(itemEntry, costTokens)
    if not itemEntry or not costTokens then return end
    if state.tokens < costTokens then
        UIErrorsFrame:AddMessage("|cffff2020[Tesorería]|r Tokens insuficientes. Necesitas " .. costTokens .. " Tokens de Jaina.", 1.0, 0.1, 0.1, 1.0, 3)
        PlaySound("igQuestFailed")
        return
    end
    SendStoreMessage(string.format("BUY:%d:%d", itemEntry, costTokens))
end

-- =============================================================================
-- CREACIÓN DE LA VENTANA PRINCIPAL
-- =============================================================================
local frame = CreateFrame("Frame", "ProjectJaina_StoreFrame", UIParent)
frame:SetWidth(750)
frame:SetHeight(520)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
frame:SetFrameStrata("HIGH")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()
tinsert(UISpecialFrames, "ProjectJaina_StoreFrame") -- Cierra con Escape

-- Fondo Glassmorphism Kirin Tor
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 24,
    insets = { left = 6, right = 6, top = 6, bottom = 6 }
})
frame:SetBackdropColor(0.04, 0.06, 0.12, 0.94)
frame:SetBackdropBorderColor(0.83, 0.69, 0.22, 1.0) -- Oro Dalaran

-- Cabecera con Título
local header = CreateFrame("Frame", nil, frame)
header:SetHeight(50)
header:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -10)
header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -10)

local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
title:SetPoint("TOPLEFT", header, "TOPLEFT", 10, -5)
title:SetText("|cffd4af37Tesorería Mística de Dalaran|r")

local subtitle = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 10, 5)
subtitle:SetText("Ecosistema Omnicanal Project JAIna · Recompensas Cosméticas & Monturas")

-- Botón de Cierre [X]
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-- Saldo de Tokens en Vivo
local balanceBox = CreateFrame("Frame", nil, header)
balanceBox:SetSize(320, 36)
balanceBox:SetPoint("RIGHT", header, "RIGHT", -30, 0)

local tokensText = balanceBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tokensText:SetPoint("RIGHT", balanceBox, "RIGHT", -36, 0)
tokensText:SetText("|cffffd700Tokens:|r 0   |cff00e5ffFichas:|r 0")
PJ.tokensText = tokensText

local refreshBtn = CreateFrame("Button", nil, balanceBox)
refreshBtn:SetSize(24, 24)
refreshBtn:SetPoint("RIGHT", balanceBox, "RIGHT", 0, 0)
refreshBtn:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton")
refreshBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
refreshBtn:SetScript("OnClick", function()
    PlaySound("igMainMenuOptionCheckBoxOn")
    PJ:RequestBalance()
end)

function PJ:UpdateBalanceDisplay()
    if PJ.tokensText then
        PJ.tokensText:SetText(string.format("|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:0:0|t |cffffd700%d Tokens|r   |TInterface\\Icons\\INV_Misc_Token_ArgentDawn:14:14:0:0|t |cff00e5ff%d Fichas|r", state.tokens, state.eventTokens))
    end
end

-- =============================================================================
-- BARRA DE FILTROS POR CATEGORÍA
-- =============================================================================
local filterBar = CreateFrame("Frame", nil, frame)
filterBar:SetHeight(32)
filterBar:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
filterBar:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -4)

local categories = {
    { id = "all",       name = "Todos" },
    { id = "mounts",    name = "Monturas" },
    { id = "pets",      name = "Mascotas" },
    { id = "tokens",    name = "Suministros" },
    { id = "ecosystem", name = "Dalaran" }
}

local filterButtons = {}
local btnOffset = 10
for i, cat in ipairs(categories) do
    local b = CreateFrame("Button", nil, filterBar, "UIPanelButtonTemplate")
    b:SetSize(86, 26)
    b:SetPoint("LEFT", filterBar, "LEFT", btnOffset, 0)
    b:SetText(cat.name)
    b.catId = cat.id
    b:SetScript("OnClick", function(self)
        PlaySound("igMainMenuOptionCheckBoxOn")
        state.selectedCategory = self.catId
        PJ:UpdateFilterTabs()
        PJ:RefreshItemList()
    end)
    btnOffset = btnOffset + 90
    table.insert(filterButtons, b)
end

function PJ:UpdateFilterTabs()
    for _, b in ipairs(filterButtons) do
        if b.catId == state.selectedCategory then
            b:Disable()
        else
            b:Enable()
        end
    end
end

-- =============================================================================
-- PANEL DE LISTADO DE OBJETOS (SCROLLFRAME)
-- =============================================================================
local listContainer = CreateFrame("Frame", nil, frame)
listContainer:SetPoint("TOPLEFT", filterBar, "BOTTOMLEFT", 10, -8)
listContainer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 14)
listContainer:SetWidth(460)

local scrollFrame = CreateFrame("ScrollFrame", "ProjectJaina_StoreScroll", listContainer, "UIPanelScrollFrameTemplate")
scrollFrame:SetAllPoints(listContainer)

local contentFrame = CreateFrame("Frame", nil, scrollFrame)
contentFrame:SetWidth(435)
contentFrame:SetHeight(500)
scrollFrame:SetScrollChild(contentFrame)

local itemCards = {}

local function CreateItemCard(index)
    local card = CreateFrame("Button", nil, contentFrame)
    card:SetSize(425, 78)
    card:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    card:SetBackdropColor(0.08, 0.11, 0.20, 0.85)
    card:SetBackdropBorderColor(0.3, 0.5, 0.8, 0.7)

    -- Icono
    local icon = card:CreateTexture(nil, "ARTWORK")
    icon:SetSize(48, 48)
    icon:SetPoint("LEFT", card, "LEFT", 12, 0)
    card.icon = icon

    -- Borde de Icono
    local iconBorder = card:CreateTexture(nil, "OVERLAY")
    iconBorder:SetSize(52, 52)
    iconBorder:SetPoint("CENTER", icon, "CENTER", 0, 0)
    iconBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    iconBorder:SetBlendMode("ADD")
    card.iconBorder = iconBorder

    -- Nombre
    local name = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 4)
    name:SetPoint("RIGHT", card, "RIGHT", -125, 0)
    name:SetJustifyH("LEFT")
    card.name = name

    -- Descripción
    local desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    desc:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -4)
    desc:SetPoint("RIGHT", card, "RIGHT", -125, 0)
    desc:SetJustifyH("LEFT")
    card.desc = desc

    -- Botón de Acción
    local actionBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
    actionBtn:SetSize(100, 26)
    actionBtn:SetPoint("RIGHT", card, "RIGHT", -10, 0)
    card.actionBtn = actionBtn

    -- Precio en Tokens
    local priceText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    priceText:SetPoint("BOTTOM", actionBtn, "TOP", 0, 3)
    card.priceText = priceText

    return card
end

function PJ:RefreshItemList()
    local catalog = PJ.Catalog.Items or {}
    local filtered = {}

    for _, it in ipairs(catalog) do
        if state.selectedCategory == "all" or it.category == state.selectedCategory then
            table.insert(filtered, it)
        end
    end

    local cardHeight = 84
    contentFrame:SetHeight(math.max(480, #filtered * cardHeight + 10))

    for i = 1, math.max(#filtered, #itemCards) do
        if i <= #filtered then
            local it = filtered[i]
            local card = itemCards[i] or CreateItemCard(i)
            itemCards[i] = card
            card:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 5, -((i - 1) * cardHeight + 5))
            card:Show()

            -- Datos
            local itemTex = it.icon
            if it.itemEntry and it.itemEntry > 0 then
                local _, _, _, _, _, _, _, _, _, clientTex = GetItemInfo(it.itemEntry)
                if clientTex and clientTex ~= "" then
                    itemTex = clientTex
                end
            end
            card.icon:SetTexture(itemTex or "Interface\\Icons\\INV_Misc_QuestionMark")
            local rData = PJ.Catalog.Rarities[it.rarity] or PJ.Catalog.Rarities.epico
            card.name:SetText(string.format("|cff%s%s|r", rData.hex, it.name))
            card.desc:SetText(it.description or "")
            card.iconBorder:SetVertexColor(rData.r, rData.g, rData.b, 0.8)

            if it.actionType == "buy_item" then
                local penStr = it.refPEN and string.format(" |cff94a3b8(S/. %.0f)|r", it.refPEN) or ""
                card.priceText:SetText(string.format("|TInterface\\MoneyFrame\\UI-GoldIcon:12:12:0:0|t |cffffd700%d|r%s", it.costTokens, penStr))
                card.actionBtn:SetText("Adquirir")
                card.actionBtn:SetScript("OnClick", function()
                    PlaySound("igMainMenuOptionCheckBoxOn")
                    PJ:ConfirmPurchase(it)
                end)
            else
                card.priceText:SetText("|cff00e5ffEcosistema|r")
                card.actionBtn:SetText("Abrir")
                card.actionBtn:SetScript("OnClick", function()
                    PlaySound("igMainMenuOptionCheckBoxOn")
                    PJ:HandleEcosystemAction(it)
                end)
            end

            card.itemData = it

            -- Hover con GameTooltip Canónico y Feedback Visual
            card:SetScript("OnEnter", function(self)
                self:SetBackdropBorderColor(1.0, 0.84, 0.0, 1.0)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if it.itemEntry and it.itemEntry > 0 then
                    GameTooltip:SetHyperlink("item:" .. it.itemEntry)
                else
                    local rData = PJ.Catalog.Rarities[it.rarity] or PJ.Catalog.Rarities.epico
                    GameTooltip:SetText(it.name, rData.r, rData.g, rData.b)
                    if it.description then
                        GameTooltip:AddLine(it.description, 1, 1, 1, true)
                    end
                end
                GameTooltip:Show()
            end)

            card:SetScript("OnLeave", function(self)
                if state.selectedItem ~= it then
                    local rData = PJ.Catalog.Rarities[it.rarity] or PJ.Catalog.Rarities.epico
                    self:SetBackdropBorderColor(rData.r, rData.g, rData.b, 0.7)
                else
                    self:SetBackdropBorderColor(1.0, 0.84, 0.0, 1.0)
                end
                GameTooltip:Hide()
            end)

            -- Click en la tarjeta selecciona e inspecciona el ítem
            card:SetScript("OnClick", function()
                PlaySound("igMainMenuOptionCheckBoxOn")
                PJ:PreviewItem(it)
            end)

        elseif itemCards[i] then
            itemCards[i]:Hide()
        end
    end
end

-- =============================================================================
-- PANEL DERECHO: PROBADOR 3D & ENLACE WEB
-- =============================================================================
local rightPanel = CreateFrame("Frame", nil, frame)
rightPanel:SetPoint("TOPRIGHT", filterBar, "BOTTOMRIGHT", -10, -8)
rightPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 14)
rightPanel:SetWidth(250)
rightPanel:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
rightPanel:SetBackdropColor(0.04, 0.07, 0.15, 0.90)
rightPanel:SetBackdropBorderColor(0.83, 0.69, 0.22, 0.6)

local previewTitle = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
previewTitle:SetPoint("TOP", rightPanel, "TOP", 0, -8)
previewTitle:SetText("|cffd4af37Probador Místico 3D|r")

-- DressUpModel nativo de WotLK 3.3.5a calibrado sin colisiones
local model3D = CreateFrame("DressUpModel", "ProjectJaina_StoreModel", rightPanel)
model3D:SetSize(220, 205)
model3D:SetPoint("TOP", previewTitle, "BOTTOM", 0, -4)
model3D:EnableMouse(true)
model3D:SetRotation(0)

-- Rotación interactiva con arrastre de ratón
local isDragging = false
local prevX = 0
model3D:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        isDragging = true
        prevX = GetCursorPosition()
    end
end)
model3D:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        isDragging = false
    end
end)
model3D:SetScript("OnUpdate", function(self)
    if isDragging then
        local curX = GetCursorPosition()
        local diff = curX - prevX
        prevX = curX
        self:SetRotation(self:GetFacing() + (diff * 0.02))
    end
end)

local resetBtn = CreateFrame("Button", nil, rightPanel, "UIPanelButtonTemplate")
resetBtn:SetSize(100, 22)
resetBtn:SetPoint("TOP", model3D, "BOTTOM", 0, -6)
resetBtn:SetText("Restablecer")
resetBtn:SetScript("OnClick", function()
    PlaySound("igMainMenuOptionCheckBoxOn")
    PJ:ResetModel()
end)

-- Ficha de Inspección Detallada para Monturas, Bolsas, Fichas y Ecosistema
local detailFrame = CreateFrame("Frame", nil, rightPanel)
detailFrame:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 10, -32)
detailFrame:SetPoint("BOTTOMRIGHT", rightPanel, "BOTTOMRIGHT", -10, 115)
detailFrame:Hide()

local detailIcon = detailFrame:CreateTexture(nil, "ARTWORK")
detailIcon:SetSize(56, 56)
detailIcon:SetPoint("TOP", detailFrame, "TOP", 0, -8)

local detailIconBorder = detailFrame:CreateTexture(nil, "OVERLAY")
detailIconBorder:SetSize(62, 62)
detailIconBorder:SetPoint("CENTER", detailIcon, "CENTER", 0, 0)
detailIconBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
detailIconBorder:SetBlendMode("ADD")

local detailName = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
detailName:SetPoint("TOP", detailIcon, "BOTTOM", 0, -8)
detailName:SetPoint("LEFT", detailFrame, "LEFT", 6, 0)
detailName:SetPoint("RIGHT", detailFrame, "RIGHT", -6, 0)
detailName:SetJustifyH("CENTER")

local detailCategory = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
detailCategory:SetPoint("TOP", detailName, "BOTTOM", 0, -4)
detailCategory:SetJustifyH("CENTER")

local detailDesc = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
detailDesc:SetPoint("TOP", detailCategory, "BOTTOM", 0, -8)
detailDesc:SetPoint("LEFT", detailFrame, "LEFT", 8, 0)
detailDesc:SetPoint("RIGHT", detailFrame, "RIGHT", -8, 0)
detailDesc:SetJustifyH("LEFT")

local detailAttr = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
detailAttr:SetPoint("TOP", detailDesc, "BOTTOM", 0, -8)
detailAttr:SetPoint("LEFT", detailFrame, "LEFT", 8, 0)
detailAttr:SetPoint("RIGHT", detailFrame, "RIGHT", -8, 0)
detailAttr:SetJustifyH("LEFT")

function PJ:UpdateSelectionBorders()
    for _, card in ipairs(itemCards) do
        if card:IsShown() and card.itemData then
            local it = card.itemData
            if state.selectedItem and state.selectedItem == it then
                card:SetBackdropBorderColor(1.0, 0.84, 0.0, 1.0)
            else
                local rData = PJ.Catalog.Rarities[it.rarity] or PJ.Catalog.Rarities.epico
                card:SetBackdropBorderColor(rData.r, rData.g, rData.b, 0.7)
            end
        end
    end
end

function PJ:ResetModel()
    state.selectedItem = nil
    PJ:UpdateSelectionBorders()
    detailFrame:Hide()
    model3D:Show()
    resetBtn:Show()
    model3D:ClearModel()
    model3D:SetUnit("player")
    model3D:Dress()
    model3D:SetRotation(0)
    previewTitle:SetText("|cffd4af37Probador Místico 3D|r")
end

-- Caja Informativa de Enlace Web Oficial
local infoBox = CreateFrame("Frame", nil, rightPanel)
infoBox:SetSize(230, 90)
infoBox:SetPoint("BOTTOM", rightPanel, "BOTTOM", 0, 8)
infoBox:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
infoBox:SetBackdropColor(0.02, 0.04, 0.08, 0.95)

local infoText = infoBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
infoText:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 8, -6)
infoText:SetPoint("BOTTOMRIGHT", infoBox, "BOTTOMRIGHT", -8, 6)
infoText:SetJustifyH("LEFT")
infoText:SetText("|cffd4af37¿Necesitas más Tokens?|r\nApoya el proyecto en la Tienda Web oficial para costear el servidor y la IA.\n|cff00e5ffComando:|r |cffffffff/tienda|r")

function PJ:PreviewItem(item)
    if not item then return end
    state.selectedItem = item
    PJ:UpdateSelectionBorders()

    -- Determinar si el objeto es equipable en el modelo 3D
    local isEquippable = false
    if item.itemEntry and item.itemEntry > 0 then
        local _, link, _, _, _, _, _, _, equipLoc = GetItemInfo(item.itemEntry)
        if equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
            isEquippable = true
        end
    end

    if isEquippable then
        detailFrame:Hide()
        model3D:Show()
        resetBtn:Show()
        previewTitle:SetText("|cffd4af37Probador Místico 3D|r")
        pcall(function()
            local _, link = GetItemInfo(item.itemEntry)
            if link then
                model3D:TryOn(link)
            end
        end)
    else
        -- Mostrar Ficha de Inspección Mística para Monturas, Consumibles y Ecosistema
        model3D:Hide()
        resetBtn:Hide()
        detailFrame:Show()
        previewTitle:SetText("|cffd4af37Inspección Mística|r")

        local rData = PJ.Catalog.Rarities[item.rarity] or PJ.Catalog.Rarities.epico
        local detailTex = item.icon
        if item.itemEntry and item.itemEntry > 0 then
            local _, _, _, _, _, _, _, _, _, clientTex = GetItemInfo(item.itemEntry)
            if clientTex and clientTex ~= "" then
                detailTex = clientTex
            end
        end
        detailIcon:SetTexture(detailTex or "Interface\\Icons\\INV_Misc_QuestionMark")
        detailIconBorder:SetVertexColor(rData.r, rData.g, rData.b, 0.9)
        detailName:SetText(string.format("|cff%s%s|r", rData.hex, item.name))

        if item.category == "mounts" then
            detailCategory:SetText("|cff00e5ffMontura Mítica (Velocidad 310%)|r")
            detailAttr:SetText(string.format("|cffffd700Hechizo:|r #%d\n|cffffd700Uso:|r Terrestre y Voladora\n|cffffd700Requisito:|r Nivel 80 (Artesano jinete)", item.spellId or 0))
        elseif item.category == "tokens" then
            detailCategory:SetText("|cff00e5ffTesoro & Divisa Soberana|r")
            detailAttr:SetText(string.format("|cffffd700Cantidad:|r %d unidades\n|cffffd700Destino:|r Bolsas de Inventario", item.itemCount or 1))
        else
            detailCategory:SetText("|cff00e5ffIntegración Ecosistema Dalaran|r")
            detailAttr:SetText("|cffffd700Acceso:|r Catálogo Interactivo Directo")
        end

        detailDesc:SetText(item.description or "")
    end
end

function PJ:HandleEcosystemAction(item)
    if not item then return end
    if item.addonTarget == "ProjectJaina_VisualShop" then
        if SlashCmdList["JAINA_VISUAL"] then
            SlashCmdList["JAINA_VISUAL"]("")
        elseif JainaVisual_ToggleUI then
            JainaVisual_ToggleUI()
        elseif SlashCmdList["WOWPERU_VISUAL"] then
            SlashCmdList["WOWPERU_VISUAL"]("")
        elseif WowPeruVisual_ToggleUI then
            WowPeruVisual_ToggleUI()
        elseif SlashCmdList["WOWPERUVISUAL"] then
            SlashCmdList["WOWPERUVISUAL"]("")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffd4af37[Project Jaina]|r Usa |cffffffff/alas|r para abrir el Catálogo de Alas Místicas.")
        end
    elseif item.addonTarget == "ProjectJaina_Wardrobe" then
        if SlashCmdList["JAINA_WARDROBE"] then
            SlashCmdList["JAINA_WARDROBE"]("")
        elseif SlashCmdList["WP_WARDROBEV2"] then
            SlashCmdList["WP_WARDROBEV2"]("")
        elseif ProjectJaina_Wardrobe_Toggle then
            ProjectJaina_Wardrobe_Toggle()
        elseif SlashCmdList["WARDROBE"] then
            SlashCmdList["WARDROBE"]("")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffd4af37[Project Jaina]|r Usa |cffffffff/armario|r o visita a Kaelia Sombraetérea para transfigurar.")
        end
    elseif item.addonTarget == "ProjectJaina_BattlePass" then
        if SlashCmdList["JAINA_BP"] then
            SlashCmdList["JAINA_BP"]("")
        elseif Jaina_BattlePass and Jaina_BattlePass.UI and Jaina_BattlePass.UI.Toggle then
            Jaina_BattlePass.UI:Toggle()
        elseif SlashCmdList["WOWPERUBP"] then
            SlashCmdList["WOWPERUBP"]("")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffd4af37[Project Jaina]|r Usa |cffffffff/bp|r para abrir el Pase de Batalla de Azeroth.")
        end
    end
end


-- =============================================================================
-- DIÁLOGO DE CONFIRMACIÓN DE COMPRA
-- =============================================================================
StaticPopupDialogs["PROJECT_JAINA_STORE_CONFIRM"] = {
    text = "¿Deseas adquirir %s por %d Tokens de Jaina?",
    button1 = "Confirmar",
    button2 = "Cancelar",
    OnAccept = function(self, data)
        if data then
            PJ:BuyItem(data.itemEntry, data.costTokens)
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

function PJ:ConfirmPurchase(item)
    if not item then return end
    local dialog = StaticPopup_Show("PROJECT_JAINA_STORE_CONFIRM", item.name, item.costTokens, item)
    if dialog then
        dialog.data = item
    end
end

-- =============================================================================
-- EVENTOS DEL ADDON & MANEJO DE PROTOCOLO DE RED
-- =============================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")

eventFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, arg4)
    if event == "PLAYER_LOGIN" then
        if RegisterAddonMessagePrefix then
            RegisterAddonMessagePrefix(PREFIX)
        end
        PJ:RequestBalance()

    elseif event == "BAG_UPDATE" then
        -- Actualizar saldo si cambiaron los ítems
        local t = GetItemCount(JAINA_TOKEN_ENTRY) or 0
        local e = GetItemCount(EVENT_TOKEN_ENTRY) or 0
        if t ~= state.tokens or e ~= state.eventTokens then
            state.tokens = t
            state.eventTokens = e
            PJ:UpdateBalanceDisplay()
        end

    elseif event == "GET_ITEM_INFO_RECEIVED" then
        local itemID = arg1
        if state.selectedItem and state.selectedItem.itemEntry == itemID then
            PJ:PreviewItem(state.selectedItem)
        end
        for _, card in ipairs(itemCards) do
            if card:IsShown() and card.itemData and card.itemData.itemEntry == itemID then
                local _, _, _, _, _, _, _, _, _, clientTex = GetItemInfo(itemID)
                if clientTex and clientTex ~= "" then
                    card.icon:SetTexture(clientTex)
                end
            end
        end

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message = arg1, arg2
        if prefix == PREFIX then
            if message:find("^BALANCE:") then
                local tStr, eStr = message:match("^BALANCE:(%d+):(%d+)")
                state.tokens = tonumber(tStr) or state.tokens
                state.eventTokens = tonumber(eStr) or state.eventTokens
                PJ:UpdateBalanceDisplay()

            elseif message:find("^BUY_OK:") then
                local itemEntryStr, remTokensStr = message:match("^BUY_OK:(%d+):(%d+)")
                state.tokens = tonumber(remTokensStr) or state.tokens
                PJ:UpdateBalanceDisplay()
                PlaySound("AuctionWindowOpen")
                UIErrorsFrame:AddMessage("|cffd4af37[Tesorería de Dalaran]|r ¡Compra completada con éxito! Revisa tu inventario.", 0.2, 1.0, 0.2, 1.0, 4)

            elseif message:find("^BUY_FAIL:") then
                local reason = message:match("^BUY_FAIL:(.+)")
                PlaySound("igQuestFailed")
                UIErrorsFrame:AddMessage("|cffff2020[Tesorería]|r Error: " .. (reason or "Fallo en compra"), 1.0, 0.1, 0.1, 1.0, 4)
            end
        end
    end
end)

-- Mostrar/Ocultar y Carga Inicial
frame:SetScript("OnShow", function()
    PJ:RequestBalance()
    PJ:ResetModel()
    PJ:UpdateFilterTabs()
    PJ:RefreshItemList()
end)

function PJ:Toggle()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

-- Comandos Slash con soporte de gestión de minimapa
SLASH_PROJECTJAINA_STORE1 = "/tienda"
SLASH_PROJECTJAINA_STORE2 = "/shop"
SLASH_PROJECTJAINA_STORE3 = "/pjstore"
SlashCmdList["PROJECTJAINA_STORE"] = function(msg)
    local cmd = msg and msg:match("^%s*(%S+)")
    cmd = cmd and cmd:lower() or ""
    if cmd == "minimap" or cmd == "boton" or cmd == "icon" then
        if PJ.Minimap and PJ.Minimap.Toggle then
            PJ.Minimap:Toggle()
        end
    elseif cmd == "reset" then
        if PJ.Minimap and PJ.Minimap.ResetPosition then
            PJ.Minimap:ResetPosition()
        end
    else
        PJ:Toggle()
    end
end

print("|cffd4af37[Project Jaina]|r AddOn Tienda Mística de Dalaran v4.0 cargado. Usa |cffffffff/tienda|r para abrir.")
