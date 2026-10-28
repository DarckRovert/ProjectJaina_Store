# 🛍️ ProjectJaina_Store — AddOn Oficial de Tienda In-Game (WoW 3.3.5a)
## Interfaz de Comercio Cosmético Kirin Tor con Probador 3D y Despacho en Vivo

**Proyecto:** Project Jaina (darckrovert.github.io/ProjectJaina_Web)  
**AddOn:** `ProjectJaina_Store`  
**Cliente:** World of Warcraft: Wrath of the Lich King (3.3.5a, Build 12340)  
**Estándar:** Staff Software Engineer L9 (Claude Mythos 5)  
**Fecha de Actualización:** 15 de Octubre de 2026  

---

## 🏛️ 1. Misión y Capacidades

`ProjectJaina_Store` es el cliente oficial integrado en el juego para acceder al catálogo omnicanal de **Project Jaina**. Permite a los jugadores explorar monturas míticas, auras de alas, títulos cosméticos, pases de batalla VIP y fichas de nivel sin salir del mundo, con previsualización en tiempo real sobre su avatar y compra directa con Tokens de Jaina.

---

## 📂 2. Estructura de Archivos del AddOn

| Archivo | Rol Arquitectónico |
| :--- | :--- |
| [`ProjectJaina_Store.toc`](file:///E:/ProjectJaina_Lab/AddOns/ProjectJaina_Store/ProjectJaina_Store.toc) | Descriptor del AddOn (Metadata, versión de interfaz 30300, SavedVariables y orden de carga). |
| [`StoreCatalog.lua`](file:///E:/ProjectJaina_Lab/AddOns/ProjectJaina_Store/StoreCatalog.lua) | Catálogo autoritativo in-game: definición de categorías (`monturas`, `cosmeticos`, `fichas`, `pases`), metadatos de ítems, calidad WoW e iconos oficiales. |
| [`StoreUI.lua`](file:///E:/ProjectJaina_Lab/AddOns/ProjectJaina_Store/StoreUI.lua) | Núcleo de la interfaz gráfica: ventana principal 750x520 con diseño Glassmorphism Kirin Tor, pestañas de navegación, rejilla de tarjetas con `GameTooltip` oficial, probador 3D interactivo (`DressUpModel`) y diálogo modal de confirmación. |
| [`MinimapButton.lua`](file:///E:/ProjectJaina_Lab/AddOns/ProjectJaina_Store/MinimapButton.lua) | Botón orbital para el minimapa con rotación trigonométrica dinámica y tooltip informativo. |

---

## 🎨 3. Especificaciones Visuales y de UX

* **Dimensiones:** Ventana principal de 750 x 520 píxeles, centrada y arrastrable.
* **Diseño Estético Kirin Tor:**
  - Fondo oscuro translúcido con tonalidades azul arcano y bordes dorados de Dalaran (`Interface\DialogFrame\UI-DialogBox-Border`).
  - Cabecera con tipografía de fantasía de alta legibilidad (`GameFontNormalHuge`).
* **Probador 3D Interactivo (`DressUpModel`):**
  - Muestra el modelo tridimensional del personaje del jugador con su equipamiento actual.
  - Soporte de rotación suave mediante arrastre de ratón (`OnMouseDown` / `OnUpdate`).
  - Botón de reinicio de cámara y vestimenta (`ResetModel`).
  - Detección inteligente de tipo de ítem: solo intenta `TryOn()` en ítems equipables, evitando comportamientos anómalos con monturas o bolsas.
* **Integración con GameTooltip:**
  - Al pasar el cursor sobre las tarjetas de la tienda, se invoca el `GameTooltip:SetHyperlink("item:" .. itemEntry)` nativo de WoW para mostrar estadísticas, nivel requerido, gemas y descripción de lore auténtica.

---

## 📡 4. Protocolo de Comunicación Cliente-Servidor

La comunicación con el backend de Eluna (`66_StoreDeliveryEngine.lua`) se realiza a través del canal seguro de mensajes de AddOn:

* **Prefijo Registrado:** `JAINA_STORE`
* **Comandos Soportados:**
  - `BUY:<itemEntry>`: Envío de solicitud de compra desde el cliente. El servidor valida en su catálogo oficial el coste de tokens del ítem (inmune a manipulación del cliente), descuenta las divisas y despacha inmediatamente la recompensa al personaje.
  - `BALANCE_REQ` / `BALANCE_RES:<tokens>`: Consulta y actualización en vivo del saldo de Tokens de Jaina en la interfaz.

---

## ⌨️ 5. Comandos de Consola (Slash Commands)

Los jugadores y administradores pueden abrir o alternar la visibilidad de la tienda mediante cualquiera de los siguientes comandos:
* `/tienda`
* `/shop`
* `/pjstore`
