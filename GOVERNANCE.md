# 🏛️ Modelo de Gobernanza — ProjectJaina_Store

**Líder del Proyecto & Autor:** DarckRovert (Ingame: `Elnazzareno`)  
**Staff AI Engineer:** Antigravity L9 (Mythos 5)  
**Servidor Destino:** [Project Jaina](https://darckrovert.github.io/ProjectJaina_Web/)  
**Versión:** 4.0.0  

---

## 1. Principio Fundamental de Omnicanalidad y No Pay-to-Win
La tienda oficial de Project Jaina ofrece exclusivamente artículos cosméticos (monturas, alas, auras, transformaciones visuales y utilidades de calidad de vida como cambio de apariencia o fichas de hermandad). Ningún artículo del catálogo otorga ventaja competitiva numérica en bandas (PvE) ni arenas/campos de batalla (PvP).

## 2. Autoridad Servidor Absoluta
El cliente gráfico es únicamente una vista desacoplada (`StoreUI.lua`, `StoreCatalog.lua`). Todas las operaciones de deducción de saldo y entrega de ítems se ejecutan exclusivamente en el servidor central mediante transacciones seguras de base de datos (`acore_characters.jaina_store_tokens` y `character_store_log`).

## 3. Flujo de Lanzamiento y Paridad Multireino
Cualquier modificación al catálogo de la tienda debe ser evaluada simultáneamente en los dos reinos del clúster:
* **Reino 1 (JainaCore - Cap 60 Vanilla):** Restricción de monturas y apariencias anacrónicas que rompan la inmersión de la Era Vanilla.
* **Reino 3 (WanitosGYM - Cap 80 WotLK):** Soporte de catálogo ampliado de Wrath of the Lich King e ICC.
