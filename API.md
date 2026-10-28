# 📡 Especificación de API y Protocolo — ProjectJaina_Store

**Prefijo de Red:** `PJ_STORE`  
**Backend:** `66_StoreDeliveryEngine.lua`  
**Versión:** 4.0.0  

---

## 1. Flujo Transaccional Idempotente

El cliente de la tienda interactúa con el servidor mediante un modelo transaccional seguro de 3 fases:

```
[Cliente]                       [Servidor Eluna]                   [Base de Datos]
    |                                   |                                |
    |----- REQ_BALANCE ---------------->|                                |
    |                                   |----- Consultar saldo --------->|
    |                                   |<---- Saldo verificado ---------|
    |<---- RESP_BALANCE <saldo> --------|                                |
    |                                   |                                |
    |----- BUY <itemId> <tier> -------->|                                |
    |                                   |----- Verificar inventario/tokens
    |                                   |----- Deducir tokens atómicamente
    |                                   |----- Entregar ítem en buzón/mochila
    |<---- BUY_OK <itemId> <saldo> -----|                                |
```

### Formato de Mensajes (`CHAT_MSG_ADDON`):
1. `REQ_BALANCE`: Solicitud de saldo actual de Tokens de Jaina.
2. `RESP_BALANCE\t<tokens>`: Respuesta autoritativa del servidor con el saldo numérico.
3. `BUY\t<itemId>\t<tierId>`: Solicitud de compra enviada por el cliente tras confirmación modal.
4. `BUY_OK\t<itemId>\t<newBalance>`: Confirmación de entrega exitosa y nuevo balance de cuenta.
5. `BUY_FAIL\t<errorCode>`: Notificación de rechazo (`ERR_NO_TOKENS`, `ERR_BAG_FULL`, `ERR_ALREADY_OWNED`).

---

## 2. Persistencia (`SavedVariables: ProjectJaina_Store_DB`)

```lua
ProjectJaina_Store_DB = {
    minimapPos = 45,
    lastCategory = "monturas",
    hideMinimap = false
}
```\n