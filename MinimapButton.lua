--[[
    =============================================================================
    PROJECT JAINA — BOTÓN DE MINIMAPA PARA LA TESORERÍA (WotLK 3.3.5a)
    =============================================================================
    Archivo: MinimapButton.lua
    Ecosistema: World of Warcraft 3.3.5a (Build 12340)
    Autores: Darckrovert & Antigravity (Mythos 5)
    =============================================================================
]]

ProjectJaina_Store = ProjectJaina_Store or {}
local PJ = ProjectJaina_Store

ProjectJaina_Store_DB = ProjectJaina_Store_DB or {}

PJ.Minimap = PJ.Minimap or {}
local MM = PJ.Minimap

local DEFAULT_ANGLE = 195
local RADIUS = 80

local function UpdateButtonPosition(button, angle)
    if not button then return end
    local rad = math.rad(angle or DEFAULT_ANGLE)
    local x = math.cos(rad) * RADIUS
    local y = math.sin(rad) * RADIUS
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local btn = CreateFrame("Button", "ProjectJaina_Store_MinimapBtn", Minimap)
btn:SetFrameStrata("MEDIUM")
btn:SetWidth(32)
btn:SetHeight(32)
btn:SetFrameLevel(8)
btn:EnableMouse(true)
btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
btn:RegisterForDrag("RightButton")
btn:SetMovable(true)

-- Icono Dorado de Moneda / Cofre Arcano
local icon = btn:CreateTexture(nil, "BACKGROUND")
icon:SetWidth(20)
icon:SetHeight(20)
icon:SetPoint("CENTER", btn, "CENTER", 0, 0)
icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_17")
icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
btn.icon = icon

-- Borde Circular WotLK
local border = btn:CreateTexture(nil, "OVERLAY")
border:SetWidth(54)
border:SetHeight(54)
border:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
btn.border = border

-- Brillo de selección
local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
highlight:SetWidth(24)
highlight:SetHeight(24)
highlight:SetPoint("CENTER", btn, "CENTER", 0, 0)
highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
highlight:SetBlendMode("ADD")
btn.highlight = highlight

-- Posicionamiento inicial inmediato para evitar Ghost Layout en carga
UpdateButtonPosition(btn, DEFAULT_ANGLE)

-- Arrastre Orbital sobre el Minimapa con guardia de valores nulos
local isDragging = false
btn:SetScript("OnDragStart", function(self)
    isDragging = true
    self:LockHighlight()
end)

btn:SetScript("OnDragStop", function(self)
    isDragging = false
    self:UnlockHighlight()
end)

btn:SetScript("OnUpdate", function(self)
    if isDragging then
        local mx, my = Minimap:GetCenter()
        local cx, cy = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        if not mx or not my or not cx or not cy or not scale or scale == 0 then
            return
        end
        cx, cy = cx / scale, cy / scale
        local angle = math.deg(math.atan2(cy - my, cx - mx))
        if angle < 0 then angle = angle + 360 end
        ProjectJaina_Store_DB.minimapAngle = angle
        UpdateButtonPosition(self, angle)
    end
end)

btn:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        PlaySound("igMainMenuOptionCheckBoxOn")
        if PJ.Toggle then
            PJ:Toggle()
        end
    end
end)

btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cffd4af37Tesorería Mística de Dalaran|r", 1, 1, 1)
    GameTooltip:AddLine("Tienda Oficial de Cosméticos & Monturas de Project JAIna", 0.8, 0.8, 0.8, true)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("|cffffffffClick Izquierdo:|r", "|cff00ff00Abrir / Cerrar Tienda|r")
    GameTooltip:AddDoubleLine("|cffffffffClick Derecho (Arrastrar):|r", "|cffaaaaaaMover icono|r")
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cff00e5ffComandos:|r |cffffffff/tienda|r · |cffffffff/tienda minimap|r", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)

btn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- API de Control de Minimapa
function MM:Init()
    ProjectJaina_Store_DB = ProjectJaina_Store_DB or {}
    local angle = ProjectJaina_Store_DB.minimapAngle or DEFAULT_ANGLE
    UpdateButtonPosition(btn, angle)
    if ProjectJaina_Store_DB.hideMinimap then
        btn:Hide()
    else
        btn:Show()
    end
end

function MM:Toggle()
    ProjectJaina_Store_DB = ProjectJaina_Store_DB or {}
    if btn:IsShown() then
        btn:Hide()
        ProjectJaina_Store_DB.hideMinimap = true
        print("|cffd4af37[Tesorería]|r Botón del minimapa oculto. Usa |cffffffff/tienda minimap|r para volver a mostrarlo.")
    else
        btn:Show()
        ProjectJaina_Store_DB.hideMinimap = false
        print("|cffd4af37[Tesorería]|r Botón del minimapa visible.")
    end
end

function MM:ResetPosition()
    ProjectJaina_Store_DB = ProjectJaina_Store_DB or {}
    ProjectJaina_Store_DB.minimapAngle = DEFAULT_ANGLE
    UpdateButtonPosition(btn, DEFAULT_ANGLE)
    btn:Show()
    ProjectJaina_Store_DB.hideMinimap = false
    print("|cffd4af37[Tesorería]|r Posición del botón de minimapa restaurada.")
end

-- Sincronización atómica de ciclo de vida
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "ProjectJaina_Store" then
        MM:Init()
    elseif event == "PLAYER_LOGIN" then
        MM:Init()
        self:UnregisterAllEvents()
    end
end)
