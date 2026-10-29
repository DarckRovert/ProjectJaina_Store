# 🛍️ ProjectJaina_Store — AddOn Oficial de Tienda In-Game (WoW 3.3.5a)
## Interfaz de Comercio Cosmético Kirin Tor con Probador 3D y Despacho en Vivo

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FProjectJaina__Store-black?logo=github)](https://github.com/DarckRovert/ProjectJaina_Store)
[![Ecosystem](https://img.shields.io/badge/Project%20Jaina-3.3.5a%20(Build%2012340)-blue)](https://darckrovert.github.io/ProjectJaina_Web/)
[![Standard](https://img.shields.io/badge/Governance-L9%20Staff%20Engineer-gold)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Proyecto:** Project Jaina ([darckrovert.github.io/ProjectJaina_Web](https://darckrovert.github.io/ProjectJaina_Web/))  
**AddOn:** `ProjectJaina_Store`  
**Cliente:** World of Warcraft: Wrath of the Lich King (3.3.5a, Build 12340)  
**Estándar:** Staff Software Engineer L9 (Claude Mythos 5)  
**Versión:** 4.0.0  

---

## 🏛️ 1. Misión y Capacidades

`ProjectJaina_Store` es el cliente oficial integrado en el juego para acceder al catálogo omnicanal de **Project Jaina**. Permite a los jugadores explorar monturas míticas, alas cosméticas, auras visuales, títulos de hermandad, pases de batalla VIP y fichas de servicio sin abandonar el mundo, con previsualización tridimensional interactiva sobre su propio avatar y compra protegida mediante Tokens de Jaina.

### Características Principales:
1. **Diseño Visual Glassmorphism Kirin Tor:** Ventana flotante de 750x520 píxeles con acabados azul arcano y bordes dorados de Dalaran (`Interface\DialogFrame\UI-DialogBox-Border`).
2. **Probador 3D Interactivo (`DressUpModel`):** Renderiza el modelo 3D del personaje en tiempo real con soporte para rotación mediante arrastre con el ratón (`OnMouseDown` / `OnUpdate`), botón de reinicio y detección inteligente de ítems equipables (`TryOn`).
3. **Catálogo Oficial Tipado:** 4 categorías principales (`monturas`, `cosmeticos`, `fichas`, `pases`), organizadas con paginación fluida, iconos Blizzlike y calidad de ítems nativa (Épico, Legendario, Raro).
4. **Integración Nativa con GameTooltip:** Consulta instantánea de estadísticas, descripciones de lore y requisitos de nivel mediante hipervínculos `item:<entry>` nativos de WoW.
5. **Protocolo Idempotente de Red (`PJ_STORE`):** Comunicación asíncrona segura con el motor del servidor (`66_StoreDeliveryEngine.lua`), inmune a manipulación en el cliente.
6. **Acceso Dual:** Botón orbital en el minimapa con rotación trigonométrica dinámica y comandos de consola (`/tienda`, `/shop`, `/pjstore`).

---

## 📂 2. Estructura de Archivos del AddOn

| Archivo | Rol Arquitectónico |
| :--- | :--- |
| [`ProjectJaina_Store.toc`](ProjectJaina_Store.toc) | Descriptor del AddOn (Interface `30300`, versión `4.0.0`, SavedVariables y orden de carga). |
| [`StoreCatalog.lua`](StoreCatalog.lua) | Catálogo autoritativo in-game: definición de categorías (`monturas`, `cosmeticos`, `fichas`, `pases`), metadatos de ítems, precios e iconos. |
| [`StoreUI.lua`](StoreUI.lua) | Núcleo de la interfaz gráfica: ventana principal 750x520, probador 3D (`DressUpModel`), rejilla de tarjetas y diálogo modal de confirmación. |
| [`MinimapButton.lua`](MinimapButton.lua) | Botón orbital para el minimapa con soporte de arrastre angular y tooltip informativo. |
| [`API.md`](API.md) | Especificación exhaustiva del protocolo de red `PJ_STORE` y flujo transaccional. |
| [`AGENTS.md`](AGENTS.md) | Directrices de arquitectura y memoria operativa para agentes de IA y desarrolladores. |
| [`GOVERNANCE.md`](GOVERNANCE.md) | Políticas de gobernanza, no pay-to-win y autoridad exclusiva del servidor. |
| [`ECOSYSTEM_REGISTRY.md`](ECOSYSTEM_REGISTRY.md) | Registro de dependencias, base de datos y bindings de Eluna. |
| [`SECURITY.md`](SECURITY.md) | Modelo de mitigación de exploits, sanitización y protección anti-taint en combate. |
| [`INSTALL.md`](INSTALL.md) | Instrucciones paso a paso de despliegue y solución de problemas. |
| [`NOTICE.md`](NOTICE.md) | Declaración de atribución de propiedad intelectual y Blizzard UI Policy (2009). |
| [`CHANGELOG.md`](CHANGELOG.md) | Registro histórico de cambios y versiones según Keep a Changelog. |
| [`LICENSE`](LICENSE) | Términos de licenciamiento de código abierto MIT. |
| [`Tests/validate_store.py`](Tests/validate_store.py) | Suite de pruebas unitarias sintácticas y validación de APIs WoW 3.3.5a. |

---

## 🎨 3. Especificaciones Visuales y de UX

* **Dimensiones:** Ventana principal de 750 x 520 píxeles, centrada, arrastrable y registrada en `UISpecialFrames` para cierre Blizzlike mediante la tecla `Escape`.
* **Probador 3D (`DressUpModel`):**
  - Muestra la malla tridimensional del jugador con su transfiguración y equipamiento actual.
  - Al seleccionar un cosmético equipable, ejecuta `DressUpModel:TryOn("item:" .. itemEntry)`.
  - Para monturas o consumibles, el probador conserva la vista del personaje sin producir errores de modelo.
  - Al cerrar la ventana, se ejecuta `DressUpModel:ClearModel()` para liberar los búferes de memoria de texturas DirectX 9.
* **Modal de Confirmación Seguro:**
  - Evita compras accidentales solicitando confirmación explícita con nombre del ítem, coste en tokens y saldo restante proyectado.

---

## 📡 4. Protocolo de Comunicación Cliente-Servidor

La comunicación con el backend de Eluna (`66_StoreDeliveryEngine.lua`) se ejecuta mediante el canal de AddOn Messages:

* **Prefijo Registrado:** `PJ_STORE`
* **Mensajes Emitidos por el Cliente:**
  - `GET_BALANCE`: Solicita la sincronización del saldo actual de Tokens de Jaina.
  - `BUY:<itemEntry>:<costTokens>`: Envía solicitud de compra de un artículo del catálogo.
* **Respuestas Procesadas desde el Servidor:**
  - `BALANCE:<tokens>:<eventTokens>`: Actualiza los contadores de divisas en la barra superior.
  - `BUY_OK:<itemEntry>:<remTokens>`: Notifica compra exitosa, actualiza saldo y reproduce sonido de logro (`Sound\Interface\LevelUp.wav`).
  - `BUY_FAIL:<motivo>`: Despliega mensaje de error en rojo y desbloquea la interfaz.
  - `TOKEN_REDEEM_OK:<cantidad>:<remTokens>`: Confirma canje de fichas in-game.

---

## ⌨️ 5. Comandos de Consola (Slash Commands)

Los jugadores pueden alternar la visibilidad de la tienda mediante cualquiera de los siguientes comandos:
* `/tienda`
* `/shop`
* `/pjstore`
* `/store`

---

## 🛡️ 6. Licencia y Cumplimiento

Distribuido bajo la Licencia **MIT**. Cumple al 100% con la **Blizzard Custom UI Policy (2009)**. No comercializa ventajas competitivas ni altera mecánicas del núcleo del juego.
