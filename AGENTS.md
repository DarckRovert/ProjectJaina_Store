# 🤖 Directrices para Agentes de IA — ProjectJaina_Store

> **Documento Maestro de Arquitectura, Restricciones y Memoria Operativa**  
> **Ámbito:** `Client\Interface\AddOns\ProjectJaina_Store\`  
> **Persona:** 'Claude Mythos 5' — Staff Software Engineer (L9)  

---

## 1. Leyes Inviolables de Implementación

1. **Cero Autoridad en el Cliente:**
   El AddOn jamás debe asumir que una compra ha tenido éxito hasta recibir explícitamente `BUY_OK:<itemEntry>:<remTokens>` desde el servidor. Prohibido manipular inventarios o modificar saldos localmente.
2. **Ciclo de Vida de Modelos 3D (`DressUpModel`):**
   - Siempre invocar `model:ClearModel()` en el handler `OnHide` de la ventana principal para prevenir fugas de memoria VRAM en el cliente DirectX 9 de 3.3.5a.
   - Antes de llamar a `model:TryOn()`, comprobar imperativamente que el ítem sea de tipo armadura o arma mediante `itemData.isEquippable`. Jamás invocar `TryOn()` con monturas o consumibles.
3. **Aislamiento Seguro en Combate (Anti-Taint):**
   - Las operaciones de apertura, cierre y cambio de pestañas deben permanecer desacopladas de `SecureActionButtonTemplate`. Si el jugador entra en combate (`InCombatLockdown()`), el diálogo modal de compra no debe realizar mutaciones protegidas de marcos.
4. **Verificación Empírica de Catálogo:**
   - Antes de sugerir o agregar nuevas entradas en `StoreCatalog.lua`, es obligatorio contrastar empíricamente que el `itemEntry` exista en la base de datos `acore_world.item_template`.

---

## 2. Invariantes de Red y Protocolo

* **Prefijo Canónico:** `PJ_STORE` (registrado con `RegisterAddonMessagePrefix("PJ_STORE")`).
* **Límite de Longitud:** Ningún payload emitido por el AddOn debe superar 255 bytes (límite duro de `SendAddonMessage` en WoW 3.3.5a).
* **Idempotencia:** Ante múltiples clics rápidos en el botón de compra, el botón debe deshabilitarse (`button:Disable()`) hasta que arribe la respuesta del servidor o expire un temporizador de seguridad de 5 segundos.

---

## 3. Checklist Pre-Despliegue

- [ ] Sintaxis validada con `Tests/validate_store.py` (cero errores léxicos, balance de bloques depth=0).
- [ ] No referencias a APIs de Retail (`C_Timer`, `C_Item`, etc.).
- [ ] Sincronización idéntica entre `ProjectJaina_FHD` y `ProjectJaina_Lab/AddOns/ProjectJaina_Store`.
