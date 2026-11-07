# 📋 Registro de Cambios — ProjectJaina_Store

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [4.1.0] — 2026-11-07
### Dinamización de Atributos de Monturas y Adaptación Faccionaria Mecamoto (Horda)
- **Inspección Mística Dinámica (`StoreUI.lua`):**
  - Erradicado el texto hardcodeado fijo ("Mítica 310% / Terrestre y Voladora / Nivel 80").
  - El panel ahora lee dinámicamente los campos reales del catálogo (`speed`, `mountType`, `reqLevel`, `reqSkill`).
- **Adaptación Faccionaria Chopper / Mecamoto (`StoreUI.lua` & `66_StoreDeliveryEngine.lua`):**
  - Implementada detección canónica de facción `IsPlayerHorde()` resiliente a locales (`esES`, `esMX`, `enUS`).
  - Para jugadores de la Horda, el Chopper (44413) se sustituye automáticamente por la Mecamoto de la Horda (41508) en tarjeta, tooltip, preview y confirmación.
  - Sincronizado `AUTHORITATIVE_CATALOG` en servidor incorporando el entry `41508` con tarifa autorizada de 3000 Tokens.

## [4.0.0] — 2026-10-28
### Lanzamiento Oficial v4.0.0 — Interfaz Kirin Tor Glassmorphism, Probador 3D y Despacho en Vivo
- **Núcleo de Interfaz Gráfica (`StoreUI.lua`):**
  - Ventana principal calibrada a 750x520 píxeles con estética Kirin Tor Glassmorphism, bordes dorados de Dalaran y soporte arrastrable.
  - Rejilla responsiva de tarjetas con soporte nativo de `GameTooltip` oficial vía `SetHyperlink("item:<id>")`.
  - Diálogo modal de confirmación de compra con previsualización del coste en Puntos de Donación / Tokens de Jaina.
- **Probador 3D Interactivo (`DressUpModel`):**
  - Renderizado tridimensional en tiempo real del personaje del jugador con rotación suave (`OnMouseDown` / `OnUpdate`).
  - Botón de reinicio de cámara y vestimenta (`ResetModel`).
  - Detección inteligente de tipo de ítem (`TryOn` restringido estrictamente a piezas de equipamiento cosmético).
- **Catálogo Autoritativo In-Game (`StoreCatalog.lua`):**
  - 4 Categorías oficiales: Monturas (`monturas`), Cosméticos y Alas (`cosmeticos`), Fichas de Nivel y Oro (`fichas`), y Pases de Batalla VIP (`pases`).
  - Metadatos con nombre, coste en PD, calidad WoW (Poco común, Raro, Épico, Legendario) e iconos canónicos.
- **Protocolo de Red Cliente-Servidor (`66_StoreDeliveryEngine.lua`):**
  - Canal bidireccional seguro bajo el prefijo `JAINA_STORE`.
  - Despacho inmediato in-game con animación arcana `SPELL_PORTAL_VISUAL` y confirmación por sonido.
  - Soporte de consulta y sincronización en caliente del balance de tokens (`BALANCE_REQ` / `BALANCE_RES`).
- **Botón de Minimapa Orbital (`MinimapButton.lua`):**
  - Botón orbital acoplado con rotación trigonométrica suave y tooltip informativo.
- **Comandos de Consola (Slash Commands):**
  - Registrados `/tienda`, `/shop` y `/pjstore` con apertura y conmutación instantánea.
- **Homologación Documental L9:**
  - Incorporados `AGENTS.md`, `API.md`, `GOVERNANCE.md`, `ECOSYSTEM_REGISTRY.md`, `INSTALL.md`, `NOTICE.md`, `LICENSE` y `SECURITY.md`.
