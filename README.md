<div align="center">

# 🎬 PlayZone

### Canal de streaming para Roku — Películas, Canales de TV y Contenido por País

![Roku](https://img.shields.io/badge/Roku-662D91?style=for-the-badge&logo=roku&logoColor=white)
![BrightScript](https://img.shields.io/badge/BrightScript-SceneGraph-E50914?style=for-the-badge)
![Status](https://img.shields.io/badge/status-en%20desarrollo-yellow?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)

</div>

---

## 📌 ¿Qué es PlayZone?

**PlayZone** es un canal privado para dispositivos **Roku**, desarrollado en **BrightScript / SceneGraph**. Permite navegar y reproducir:

- 🎥 **Películas** — catálogo paginado, consumido desde una API externa.
- 📡 **Canales de TV por cable** — vía listas M3U.
- 🌎 **TV por países** — selección de país y reproducción de su lista IPTV pública.
- 🔎 **Buscador** — teclado en pantalla (control remoto o teclado del celular) que filtra el catálogo completo en tiempo real.
- 📖 **Instrucciones** integradas dentro de la propia app.

No es una app oficial de Roku Channel Store: se instala manualmente en modo desarrollador (**sideload**), como se explica más abajo.

---

## 🖼️ Vista previa

> Agregá tus propias capturas de pantalla acá una vez que la tengas corriendo en tu Roku. Sugerencia de carpeta: `docs/screenshots/`.

| Portal principal | Catálogo de películas | Buscador |
|:---:|:---:|:---:|
| _(captura pendiente)_ | _(captura pendiente)_ | _(captura pendiente)_ |

---

## 🧱 Estructura del proyecto

```
PlayZoneTV/
├── manifest                     # Metadatos del canal (nombre, versión, íconos)
├── source/
│   └── main.brs                 # Punto de entrada de la app
├── components/
│   ├── MainScene.xml / .brs     # Pantalla principal: portal, menú, navegación general
│   ├── PortalItem.xml           # Tarjeta de cada opción del portal de inicio
│   ├── SideMenuItem.xml / .brs  # Ítem del menú lateral (Inicio, Buscar, etc.)
│   ├── CustomKeyboard.xml / .brs# Teclado en pantalla para el buscador
│   ├── KeyItem.xml              # Tecla individual del teclado
│   ├── DetailsScreen.xml / .brs # Pantalla de detalle de una película/canal
│   ├── ApiTask.xml / .brs       # Tarea asíncrona para consumir la API HTTP (JSON)
│   └── M3uTask.xml / .brs       # Tarea asíncrona para descargar y parsear listas M3U
└── images/
    ├── main_icon_hd.png / _sd.png
    └── splash_hd.png / _sd.png
```

---

## ⚙️ Requisitos

- Un **Roku** físico conectado a la misma red Wi-Fi/LAN que tu computadora (no funciona en el emulador oficial de Roku para PC/Mac sin el dispositivo real).
- Acceso al router o simplemente saber la **IP local del Roku**.
- Una computadora con navegador web (no hace falta instalar nada más para el sideload).
- Opcional para desarrollo: [Visual Studio Code](https://code.visualstudio.com/) + extensión **BrightScript Language** (roku-deploy / vscode-brightscript-language), o el CLI `roku-deploy`.

---

## 🔓 Paso 1 — Activar el modo desarrollador en el Roku

1. Con el control remoto del Roku, apuntá a la pantalla de inicio.
2. Presioná esta combinación de teclas **en orden**, sin pausas largas:

   ```
   Inicio  x3   →   Arriba  x2   →   Izquierda  →   Derecha  →   Izquierda  →   Derecha  →   Izquierda
   ```

3. Va a aparecer una pantalla llamada **"Developer Application Installer"** con:
   - Un usuario (`rokudev` por defecto).
   - Una contraseña que vos elegís.
   - La **dirección IP** del Roku (anotala, la vas a necesitar).
4. Aceptá los términos y confirmá. El Roku se reinicia y queda en modo desarrollador.

> ⚠️ Si tu Roku ya estuvo antes en modo desarrollador, puede que directamente te muestre la pantalla del instalador sin pedir la combinación de nuevo.

---

## 📦 Paso 2 — Empaquetar el canal

1. Descargá o cloná este repositorio.
2. Comprimí el **contenido** de la carpeta del proyecto (no la carpeta en sí) en un `.zip`. Es decir, al abrir el zip deberías ver directamente `manifest`, `source/`, `components/`, `images/` — sin una carpeta extra por encima.

   ```bash
   cd PlayZoneTV
   zip -r ../PlayZone.zip . -x "*.DS_Store"
   ```

---

## 📲 Paso 3 — Instalar el canal en el Roku (sideload)

1. En tu computadora, abrí el navegador y entrá a:

   ```
   http://<IP-DEL-ROKU>
   ```

   (reemplazando `<IP-DEL-ROKU>` por la IP que anotaste en el paso 1).

2. Iniciá sesión con el usuario `rokudev` y la contraseña que configuraste.
3. En la sección **"Upload"**, hacé clic en **"Choose File"** y seleccioná el `PlayZone.zip` que armaste.
4. Presioná **"Install"** (o "Replace" si ya había una versión instalada antes).
5. A los pocos segundos, el canal **PlayZone** va a abrirse solo en el Roku, y va a quedar disponible en la lista de canales privados (**Sideloaded Channels**) de tu Home.

---

## 🕹️ Cómo se usa la app

- **Flechas del control**: para moverte entre opciones.
- **OK / Select**: para elegir una película, canal, país o tecla.
- **Izquierda** (sobre el primer póster o país de la lista): abre el **menú lateral**.
- **Menú lateral**: Inicio · Siguiente página · Página anterior · Buscar · Cerrar.
- **Atrás**: cierra el menú si está abierto, o vuelve a la pantalla anterior.
- **Buscador**: se navega con flechas + OK sobre el teclado en pantalla, o directamente tipeando desde el **teclado del celular** en la app oficial de Roku (control remoto por celular).

Estas mismas instrucciones están disponibles dentro de la app, en la opción **"Instrucciones"** del portal principal.

---

## 🔧 Desarrollo

Si querés modificar el proyecto:

1. Cloná el repo y abrilo en VS Code.
2. Instalá la extensión **BrightScript Language** para autocompletado, debugging remoto y despliegue directo desde el editor (`Cmd/Ctrl + Shift + P` → *"Configure Launch"*, apuntando a la IP y contraseña de tu Roku).
3. Cada vez que guardes cambios, podés volver a desplegar sin generar el `.zip` manualmente usando la extensión (`F5`), o repitiendo el sideload manual del Paso 3.
4. Para ver los logs y errores en vivo (muy útil si algo no responde), conectate por telnet al puerto **8085** de tu Roku:

   ```bash
   telnet <IP-DEL-ROKU> 8085
   ```

---

## 🌐 Fuentes de datos

La app consume:

- Una API externa (HTTP/JSON) para el catálogo de películas y sus detalles/servidores de reproducción.
- Listas **M3U** públicas para los canales de TV por cable y por país (formato estándar IPTV).

No aloja ni almacena contenido propio: solo consulta y muestra fuentes externas ya existentes.

---

## 🤝 Contribuciones

¿Encontraste un bug o tenés una idea para mejorar PlayZone? Abrí un **Issue** o mandá un **Pull Request**. Toda ayuda es bienvenida.

---

## 📬 Contacto

Para soporte, dudas o sugerencias:

**Telegram:** [@I_am3301](https://t.me/I_am3301)

---

## 📄 Licencia

Este proyecto se distribuye bajo licencia **MIT**. Ver el archivo `LICENSE` para más detalles.

<div align="center">

Hecho con ❤️ para la comunidad Roku.

</div>
