# 🛡️ Política de Seguridad — ProjectJaina_Store

**Proyecto:** Project Jaina  
**Estándar:** Staff Software Engineer L9 (Mythos 5)  

---

## 1. Cero Autoridad de Compra en Cliente
El cliente no puede forzar la adición de ítems o monedas en el inventario. La manipulación de paquetes locales es descartada de forma silenciosa por el backend `66_StoreDeliveryEngine.lua` si la firma o el saldo no concuerdan con la base de datos central.

## 2. Protección de Interfaz (Anti-Taint)
Los botones de compra y pestañas de la tienda utilizan handlers seguros sin interacción con `SecureActionButtonTemplate` durante estados de combate (`InCombatLockdown()`).

## 3. Prevención de Desbordamiento y Memory Leaks
- Los modelos tridimensionales son limpiados (`DressUpModel:ClearModel()`) al cerrar la ventana para prevenir acumulación de mallas en la VRAM de DirectX 9.
- El búfer de eventos descarta mensajes de red malformados o mayores a 255 bytes.
