# 📡 Especificación de API y Protocolo — ProjectJaina_Store

**Prefijo de Red:** `PJ_STORE`  
**Backend:** `66_StoreDeliveryEngine.lua` (Eluna Engine)  
**Versión:** 4.0.0  
**Transporte:** `SendAddonMessage` / `CHAT_MSG_ADDON` (Canal: `WHISPER` local / Servidor)  

---

## 1. Diagrama de Secuencia Transaccional

```
[Cliente AddOn]                 [Servidor Eluna (66)]              [Base de Datos]
       |                                   |                                |
       |--- GET_BALANCE ------------------>|                                |
       |                                   |--- Consultar tokens ---------->|
       |                                   |<-- Saldo (tokens, event) ------|
       |<-- BALANCE:<tokens>:<event> ------|                                |
       |                                   |                                |
       |--- BUY:<itemEntry>:<costTokens> ->|                                |
       |                                   |--- Validar catálogo y saldo -->|
       |                                   |--- Iniciar transacción DDL --->|
       |                                   |--- Descontar saldo ------------|
       |                                   |--- Despachar ítem (AddItem) ---|
       |<-- BUY_OK:<itemEntry>:<remTokens>-|                                |
       |   (o BUY_FAIL:<motivo>)           |                                |
```

---

## 2. Definición Estricta de Paquetes de Red

### 2.1 Mensajes Emitidos por el Cliente (C -> S)

| Comando | Sintaxis | Descripción |
| :--- | :--- | :--- |
| `GET_BALANCE` | `GET_BALANCE` | Solicita el saldo actual de Tokens de Jaina y Tokens de Evento del jugador activo. |
| `BUY` | `BUY:<itemEntry>:<costTokens>` | Solicita la adquisición del artículo `itemEntry`. El coste enviado sirve de chequeo preliminar, pero el servidor valida el precio real en su catálogo oficial. |

### 2.2 Mensajes Emitidos por el Servidor (S -> C)

| Comando | Sintaxis | Descripción |
| :--- | :--- | :--- |
| `BALANCE` | `BALANCE:<tokens>:<eventTokens>` | Entrega los saldos verificados desde la base de datos `acore_characters.jaina_store_tokens`. |
| `BUY_OK` | `BUY_OK:<itemEntry>:<remainingTokens>` | Confirma la transacción completada y entrega el saldo restante para actualización inmediata de la UI. |
| `BUY_FAIL` | `BUY_FAIL:<motivo>` | Notifica el rechazo de la operación con la causa exacta (fondos insuficientes, ítem ya poseído, catálogo desfasado). |
| `TOKEN_REDEEM_OK`| `TOKEN_REDEEM_OK:<amount>:<remaining>`| Confirma la activación de un ítem consumible de tokens en el inventario. |

---

## 3. Modelo de Persistencia (`SavedVariables: ProjectJaina_Store_DB`)

El estado de personalización de la interfaz se almacena a nivel de cuenta/cliente en `WTF\SavedVariables\ProjectJaina_Store.lua`:

```lua
ProjectJaina_Store_DB = {
    minimapPos = 45.0,        -- Posición angular del botón en el minimapa (grados)
    hideMinimap = false,      -- Visibilidad del icono orbital
    lastCategory = "monturas",-- Última pestaña navegada
    soundEffects = true,      -- Reproducción acústica de interfaz
}
```

---

## 4. Estructura de Datos de Catálogo (`StoreCatalog.lua`)

Cada entrada en la tabla `StoreCatalog.Items` implementa el siguiente esquema tipado:

```lua
{
    id = 101,                                   -- Identificador único interno
    name = "Draco del Alba Crepuscular",         -- Nombre en español
    itemEntry = 43954,                          -- ID de ítem en acore_world.item_template
    category = "monturas",                      -- 'monturas' | 'cosmeticos' | 'fichas' | 'pases'
    cost = 250,                                 -- Coste en Tokens de Jaina
    currency = "tokens",                        -- Tipo de divisa ('tokens' | 'event')
    icon = "Interface\\Icons\\Ability_Mount_Drake_Twilight", -- Textura Blizzlike
    quality = 4,                                -- 3: Raro (Azul), 4: Épico (Morado), 5: Legendario (Naranja)
    isEquippable = false,                       -- true si admite DressUpModel:TryOn()
    description = "Montura voladora de élite obtenida al purificar la Cámara de Obsidiana.",
}
```
