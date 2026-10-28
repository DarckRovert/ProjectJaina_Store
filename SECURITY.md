# 🛡️ Política de Seguridad — ProjectJaina_Store

**Proyecto:** Project Jaina  
**Estándar:** Staff Software Engineer L9 (Mythos 5)  

---

## 1. Cero Autoridad de Compra en Cliente
El cliente no puede forzar la adición de ítems o monedas en el inventario. La manipulación de paquetes locales es descartada de forma silenciosa por el backend `66_StoreDeliveryEngine.lua` si la firma o el saldo no concuerdan.

## 2. Protección de Interfaz (Anti-Taint)
Los botones de compra y pestañas de la tienda utilizan handlers seguros sin interacción con `SecureActionButtonTemplate` durante estados de combate (`InCombatLockdown()`).\n