<div align="center">

# 🎬 PlayZoneTV

### Canal de streaming para Roku — Películas, Canales de TV y Contenido por País

![Roku](https://img.shields.io/badge/Roku-662D91?style=for-the-badge&logo=roku&logoColor=white)
![BrightScript](https://img.shields.io/badge/BrightScript-SceneGraph-E50914?style=for-the-badge)
![Status](https://img.shields.io/badge/status-en%20desarrollo-yellow?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)

</div>

---

## 📌 ¿Qué es PlayZoneTV?

**PlayZoneTV** es un canal privado para dispositivos **Roku**, desarrollado en **BrightScript / SceneGraph**.

Permite navegar y reproducir:

| Sección | Descripción |
|--------|-------------|
| 🎥 **Películas** | Catálogo paginado desde API externa, con detalle, rating, géneros y sinopsis |
| 📡 **Canales TV cable** | Listas M3U de canales |
| 🌎 **TV por países** | IPTV público por país |
| 🔎 **Buscar** | Teclado en pantalla; filtra el catálogo en tiempo real |
| 📖 **Instrucciones** | Guía de uso integrada |

No es una app de la Roku Channel Store: se instala por **sideload** (modo desarrollador).

---

## ✨ Características

- Portal de inicio con tarjetas e iconos por sección
- Header dinámico: el icono cambia según la sección (claqueta, TV, globo, lupa)
- Detalle de película con rating, año, géneros y botón **REPRODUCIR** centrado
- Si un video no es compatible con Roku: mensaje claro y salida (sin reintentos infinitos)
- Placeholder gris cuando una portada no carga
- Menú lateral (Inicio, páginas, Buscar)
- Buscador con teclado en pantalla o teclado del celular (app Roku)
- UI orientada a **HD 1280×720**

---

## 🧱 Estructura del proyecto

```
PlayZoneTV/
├── manifest                      # Nombre, versión, iconos, splash
├── source/
│   └── main.brs                  # Entrada de la app
├── components/
│   ├── MainScene.xml / .brs      # Portal, catálogo, menú, video
│   ├── PortalItem.xml            # Tarjetas del portal
│   ├── MovieItem.xml             # Poster del catálogo (+ placeholder)
│   ├── DetailsScreen.xml / .brs  # Detalle de película
│   ├── SideMenuItem.xml / .brs   # Menú lateral
│   ├── CustomKeyboard.xml / .brs # Teclado del buscador
│   ├── KeyItem.xml
│   ├── ApiTask.xml / .brs        # Peticiones HTTP/JSON
│   └── M3uTask.xml / .brs        # Listas M3U
└── images/
    ├── main_icon_hd.png          # Icono canal HD (290×218)
    ├── main_icon_sd.png          # Icono canal SD
    ├── splash_hd.png / splash_sd.png
    └── icons/
        ├── film.png              # Películas
        ├── tv.png                # Canales
        ├── globe.png             # Países
        ├── search.png            # Buscar
        └── info.png              # Instrucciones
```

---

## ⚙️ Requisitos

- **Roku físico** en la misma red Wi‑Fi/LAN que tu PC  
  (el emulador oficial no sustituye un dispositivo real para sideload completo)
- Conocer la **IP local** del Roku
- Navegador web en el PC
- Opcional: [VS Code](https://code.visualstudio.com/) + extensión **BrightScript Language** / `roku-deploy`

---

## 🔓 Paso 1 — Modo desarrollador en el Roku

1. En la pantalla de inicio del Roku, con el control:
2. Secuencia (sin pausas largas):

```text
Inicio ×3  →  Arriba ×2  →  Izquierda  →  Derecha  →  Izquierda  →  Derecha  →  Izquierda
```

3. Aparece **Developer Application Installer**
   - Usuario: `rokudev`
   - Contraseña: la que configures
   - Anota la **IP** del Roku
4. Acepta y reinicia

> Si ya estaba en modo desarrollador, puede abrir el instalador directamente.

---

## 📦 Paso 2 — Empaquetar el canal

1. Clona o descarga este repositorio.
2. Comprime el **contenido** de la carpeta del proyecto (no la carpeta padre).  
   Al abrir el zip deben verse `manifest`, `source/`, `components/`, `images/`.

```bash
cd PlayZoneTV
zip -r ../PlayZone.zip . -x "*.DS_Store" -x "**/.git/**"
```

---

## 📲 Paso 3 — Instalar (sideload)

1. En el PC, abre el navegador:

```text
http://<IP-DEL-ROKU>
```

2. Inicia sesión: usuario `rokudev` + tu contraseña.
3. **Upload** → elige `PlayZone.zip` → **Install** (o **Replace**).
4. El canal **PlayZoneTV** se abre y queda en **Sideloaded Channels**.

---

## 🕹️ Controles

| Acción | Control |
|--------|---------|
| Moverse | Flechas |
| Seleccionar | OK |
| Menú lateral | Izquierda (en el primer ítem de la fila) |
| Volver | Atrás |
| Buscar | Teclado en pantalla u app Roku en el celular |

Menú lateral: **Inicio · Siguiente página · Página anterior · Buscar · Cerrar**.

---

## 🌐 Fuentes de datos

- **Películas:** API HTTP/JSON externa (listado + extract de streams cuando aplica).
- **TV cable / países:** listas **M3U** públicas (IPTV).

PlayZoneTV **no aloja** el contenido: solo consulta y reproduce fuentes externas.

> Algunos enlaces pueden no ser compatibles con el reproductor de Roku. En ese caso se muestra un mensaje y se puede volver con **Atrás**.

---

## 🔧 Desarrollo

1. Clona el repo y ábrelo en VS Code.
2. Extensión BrightScript: deploy con **F5** (configura IP y contraseña del Roku).
3. Logs en vivo:

```bash
telnet <IP-DEL-ROKU> 8085
```

---

## 📋 Manifest (resumen)

| Campo | Valor típico |
|-------|----------------|
| `title` | PlayZoneTV |
| `ui_resolutions` | hd |
| Iconos | `mm_icon_focus_hd` / `_sd` |
| Splash | `splash_screen_hd` / `_sd` |

Tamaños recomendados de icono de canal: **HD 290×218**, **SD 214×144**.

---

## 🤝 Contribuciones

Bugs o ideas: abre un **Issue** o un **Pull Request**.

---

## 📬 Contacto

**Telegram:** [@I_am3301](https://t.me/I_am3301)

---

## 📄 Licencia

Distribuido bajo licencia **MIT**. Ver `LICENSE` si está incluida en el repositorio.

---

<div align="center">

Hecho con ❤️ para la comunidad Roku · **PlayZoneTV**

</div>
