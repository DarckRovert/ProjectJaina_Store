# 🤖 Directrices para Agentes de IA — ProjectJaina_Store

> **Documento Maestro de Arquitectura y Memoria Operativa**  
> **Ámbito:** `Client\Interface\AddOns\ProjectJaina_Store\`  

- No agregar ítems al catálogo (`StoreCatalog.lua`) sin verificar su existencia en la base de datos `acore_world.item_template`.
- Garantizar que los modelos 3D (`DressUpModel`) limpien su escena (`model:ClearModel()`) al cerrar la ventana.\n