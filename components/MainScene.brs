sub init()
    ' Nodos
    m.portalGrid = m.top.findNode("portalGrid")
    m.portalGroup = m.top.findNode("portalGroup")
    m.mainContent = m.top.findNode("mainContent")
    m.movieGrid = m.top.findNode("movieGrid")
    m.countryGroup = m.top.findNode("countryGroup")
    m.countryList = m.top.findNode("countryList")
    m.instructionGroup = m.top.findNode("instructionGroup")
    m.sideMenu = m.top.findNode("sideMenu")
    m.menuList = m.top.findNode("menuList")
    m.menuOverlay = m.top.findNode("menuOverlay")
    m.titleLabel = m.top.findNode("titleLabel")
    m.headerIcon = m.top.findNode("headerIcon")
    m.movieCounterLabel = m.top.findNode("movieCounterLabel")
    m.navHintLabel = m.top.findNode("navHintLabel")
    m.pageBar = m.top.findNode("pageBar")
    m.pageIndicator = m.top.findNode("pageIndicator")
    m.detailsScreen = m.top.findNode("detailsScreen")
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoStatusBox = m.top.findNode("videoStatusBox")
    m.videoStatusLabel = m.top.findNode("videoStatusLabel")
    m.updateBanner = m.top.findNode("updateBanner")
    m.updateBannerLabel = m.top.findNode("updateBannerLabel")
    m.videoPlayer.observeField("state", "onVideoStateChange")
    m.searchGroup = m.top.findNode("searchGroup")
    m.searchKeyboard = m.top.findNode("searchKeyboard")
    m.searchResultsGrid = m.top.findNode("searchResultsGrid")

    ' 1. Configurar Portal
    portalContent = CreateObject("roSGNode", "ContentNode")
    addItem(portalContent, "Películas")
    addItem(portalContent, "CANALES TV CABLE")
    addItem(portalContent, "TV POR PAÍSES")
    addItem(portalContent, "Instrucciones")
    addItem(portalContent, "BUSCAR PELÍCULAS")
    m.portalGrid.content = portalContent

    ' 2. Menu Lateral Minimalista
    menuContent = CreateObject("roSGNode", "ContentNode")
    addItem(menuContent, "INICIO")
    addItem(menuContent, "SIG. PÁGINA >")
    addItem(menuContent, "< PÁG. ANTERIOR")
    addItem(menuContent, "BUSCAR")
    addItem(menuContent, "CERRAR")
    m.menuList.content = menuContent

    ' 3. Lista masiva de países (IPTV)
    m.countries = [
        {name: "Argentina", code: "ar"}, {name: "Bolivia", code: "bo"}, {name: "Brasil", code: "br"},
        {name: "Chile", code: "cl"}, {name: "Colombia", code: "co"}, {name: "Costa Rica", code: "cr"},
        {name: "Cuba", code: "cu"}, {name: "Ecuador", code: "ec"}, {name: "El Salvador", code: "sv"},
        {name: "España", code: "es"}, {name: "Guatemala", code: "gt"}, {name: "Honduras", code: "hn"},
        {name: "México", code: "mx"}, {name: "Nicaragua", code: "ni"}, {name: "Panamá", code: "pa"},
        {name: "Paraguay", code: "py"}, {name: "Perú", code: "pe"}, {name: "Puerto Rico", code: "pr"},
        {name: "Rep. Dominicana", code: "do"}, {name: "Uruguay", code: "uy"}, {name: "Venezuela", code: "ve"},
        {name: "USA (Español)", code: "us"}, {name: "Francia", code: "fr"}, {name: "Alemania", code: "de"},
        {name: "Italia", code: "it"}, {name: "Portugal", code: "pt"}, {name: "Reino Unido", code: "gb"},
        {name: "Afganistán", code: "af"}, {name: "Albania", code: "al"}, {name: "Argelia", code: "dz"},
        {name: "Andorra", code: "ad"}, {name: "Angola", code: "ao"}, {name: "Armenia", code: "am"},
        {name: "Australia", code: "au"}, {name: "Austria", code: "at"}, {name: "Azerbaiyán", code: "az"},
        {name: "Bahamas", code: "bs"}, {name: "Bélgica", code: "be"}, {name: "Canadá", code: "ca"},
        {name: "China", code: "cn"}, {name: "Egipto", code: "eg"}, {name: "Israel", code: "il"},
        {name: "Japón", code: "jp"}, {name: "Noruega", code: "no"}, {name: "Rusia", code: "ru"},
        {name: "Suecia", code: "se"}, {name: "Suiza", code: "ch"}, {name: "Turquía", code: "tr"}
    ]

    m.viewMode = "portal"
    m.lastMovieCounterText = ""
    m.currentPage = 1
    m.portalGrid.setFocus(true)

    ' Estado del buscador (catálogo cacheado para filtrar sin recargar la API en cada letra)
    m.allMovies = []
    m.moviesRawData = []
    m.searchResultsRawData = []
    m.searchCatalogPage = 0
    m.searchTotalPages = 16
    m.totalMoviePages = 16

    ' Observadores
    m.portalGrid.observeField("itemSelected", "onPortalItemSelected")
    m.movieGrid.observeField("itemSelected", "onItemSelected")
    m.countryList.observeField("itemSelected", "onCountrySelected")
    m.menuList.observeField("itemSelected", "onMenuItemSelected")
    m.detailsScreen.observeField("playPressed", "onPlayPressed")
    m.top.findNode("closeInstructionsBtn").observeField("buttonSelected", "showPortal")
    m.searchKeyboard.observeField("text", "onSearchTextChanged")
    m.searchResultsGrid.observeField("itemSelected", "onSearchItemSelected")

    ' Debounce del buscador: no filtrar en cada tecla (traba el Roku)
    m.searchTimer = CreateObject("roSGNode", "Timer")
    m.searchTimer.repeat = false
    m.searchTimer.duration = 0.4
    m.searchTimer.observeField("fire", "onSearchTimerFire")
    m.searchFilterBusy = false

    checkForUpdates()
end sub

' --- CHEQUEO DE ACTUALIZACIONES ---
' Como este canal se instala manualmente (sideload), Roku no lo actualiza
' solo. Al abrir la app, consulta un archivo version.json en GitHub y lo
' compara contra la version instalada. Si hay una mas nueva, muestra un
' aviso discreto en el portal (no bloquea nada, se puede seguir usando).
sub checkForUpdates()
    appInfo = CreateObject("roAppInfo")
    m.installedVersion = appInfo.GetVersion()

    m.updateTask = CreateObject("roSGNode", "VersionCheckTask")
    m.updateTask.requestUrl = "https://raw.githubusercontent.com/r1gox/PlayZoneTV/main/version.json"
    m.updateTask.observeField("response", "onUpdateCheckRetrieved")
    m.updateTask.control = "RUN"
end sub

sub onUpdateCheckRetrieved()
    res = m.updateTask.response
    if res = invalid or res.latest_version = invalid then return

    if res.latest_version <> m.installedVersion
        msg = "Hay una version nueva disponible (" + res.latest_version + "). Volve a instalar el canal para actualizar."
        if res.message <> invalid and res.message <> "" then msg = res.message
        m.updateBannerLabel.text = msg
        m.updateBanner.visible = true
    end if
end sub

sub addItem(parent, title)
    item = parent.CreateChild("ContentNode")
    item.title = title
end sub

' --- PORTAL ---
sub onPortalItemSelected()
    idx = m.portalGrid.itemSelected
    if idx = 0 then loadMovies(1)
    if idx = 1 then loadCable()
    if idx = 2 then showCountryList()
    if idx = 3 then showInstructions()
    if idx = 4 then showSearch()
end sub

sub showPortal()
    m.viewMode = "portal"
    m.portalGroup.visible = true
    m.mainContent.visible = false
    m.instructionGroup.visible = false
    m.searchGroup.visible = false
    m.portalGrid.setFocus(true)
end sub

' --- SECCIONES ---

sub setSectionHeader(title as String, iconName as String)
    if m.titleLabel <> invalid then m.titleLabel.text = title
    if m.headerIcon <> invalid
        m.headerIcon.uri = "pkg:/images/icons/" + iconName + ".png"
        m.headerIcon.visible = true
    end if
end sub

sub loadMovies(page as Integer)
    m.viewMode = "movies"
    m.currentPage = page
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    setSectionHeader("PELÍCULAS", "film")
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    m.apiTask = CreateObject("roSGNode", "ApiTask")
    m.apiTask.requestUrl = "https://zonaapp.ikkihkurogane.workers.dev/list?page=" + page.toStr()
    m.apiTask.observeField("response", "onMoviesRetrieved")
    m.apiTask.control = "RUN"
end sub

' Cada página del repo de GitHub ya trae un ARRAY con todo lo necesario por
' película (título, imagen, rating, sinopsis, géneros y los links de video),
' así que no hace falta pedir nada más al seleccionar una.
sub onMoviesRetrieved()
    res = m.apiTask.response
    if res <> invalid
        list = flattenMovieList(res)
        if res.totalPages <> invalid then m.totalMoviePages = res.totalPages
        content = CreateObject("roSGNode", "ContentNode")
        for each m_item in list
            item = content.CreateChild("ContentNode")
            item.title = m_item.title
            item.hdPosterUrl = getPosterUrl(m_item)
        end for
        m.moviesRawData = list
        m.movieGrid.content = content
        m.movieGrid.setFocus(true)
        m.lastMovieCounterText = "(" + content.getChildCount().toStr() + " películas)"
        m.movieCounterLabel.text = m.lastMovieCounterText
        m.pageIndicator.text = "Página " + m.currentPage.toStr() + " de " + m.totalMoviePages.toStr()
    end if
end sub

sub loadCable()
    m.viewMode = "channels"
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    setSectionHeader("CANALES TV CABLE", "tv")
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false
    m.m3uTask = CreateObject("roSGNode", "M3uTask")
    m.m3uTask.url = "https://raw.githubusercontent.com/NOVAPSNew/Novaps/main/tv.m3u"
    m.m3uTask.observeField("content", "onChannelsRetrieved")
    m.m3uTask.control = "RUN"
end sub

sub showCountryList()
    m.viewMode = "countries"
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = true
    m.searchGroup.visible = false
    setSectionHeader("TV POR PAÍSES", "globe")
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false

    content = CreateObject("roSGNode", "ContentNode")
    for each c in m.countries
        item = content.CreateChild("ContentNode")
        item.title = c.name
        item.description = "https://iptv-org.github.io/iptv/countries/" + c.code + ".m3u"
    end for
    m.countryList.content = content
    m.countryList.setFocus(true)
end sub

' --- BUSCADOR ---
' Reutiliza el mismo endpoint de listado que ya usa la app (loadMovies) y el
' componente CustomKeyboard existente. No modifica el flujo de películas,
' canales ni países: solo agrega una vista nueva.
sub showSearch()
    m.viewMode = "search"
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = true
    setSectionHeader("BUSCAR", "search")

    if m.allMovies.count() = 0
        m.movieCounterLabel.text = "Cargando catálogo..."
        m.searchCatalogPage = 1
        fetchCatalogPage(m.searchCatalogPage)
    else
        m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
    end if

    m.searchKeyboard.findNode("keyGrid").setFocus(true)
end sub

' Descarga todo el catálogo página por página (una sola vez, se cachea en
' m.allMovies) para poder filtrar instantáneamente mientras se escribe.
sub fetchCatalogPage(page as Integer)
    m.catalogTask = CreateObject("roSGNode", "ApiTask")
    m.catalogTask.requestUrl = "https://zonaapp.ikkihkurogane.workers.dev/list?page=" + page.toStr()
    m.catalogTask.observeField("response", "onCatalogPageRetrieved")
    m.catalogTask.control = "RUN"
end sub

sub onCatalogPageRetrieved()
    res = m.catalogTask.response
    if res <> invalid
        if res.totalPages <> invalid then m.searchTotalPages = res.totalPages
        list = flattenMovieList(res)
        for each mv in list
            m.allMovies.push(mv)
        end for
        if m.viewMode = "search"
            m.movieCounterLabel.text = "Cargando catálogo... (" + m.searchCatalogPage.toStr() + "/" + m.searchTotalPages.toStr() + ")"
        end if
    end if

    if m.searchCatalogPage < m.searchTotalPages
        m.searchCatalogPage++
        fetchCatalogPage(m.searchCatalogPage)
    else
        if m.viewMode = "search"
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
            filterSearchResults()
        end if
    end if
end sub

' Se dispara solo cuando cambia el texto del CustomKeyboard (su propio
' teclado sigue funcionando exactamente igual que antes).
sub onSearchTextChanged()
    ' Solo reinicia el timer; el filtro corre al soltar el teclado un momento
    if m.searchTimer <> invalid
        m.searchTimer.control = "stop"
        m.searchTimer.control = "start"
    end if
end sub

sub onSearchTimerFire()
    filterSearchResults()
end sub

sub filterSearchResults()
    if m.searchFilterBusy = true then return
    if m.searchKeyboard = invalid then return
    if m.searchResultsGrid = invalid then return

    m.searchFilterBusy = true

    raw = m.searchKeyboard.text
    if raw = invalid then raw = ""
    query = LCase(raw)

    content = CreateObject("roSGNode", "ContentNode")
    m.searchResultsRawData = []
    count = 0

    if m.allMovies = invalid or m.allMovies.count() = 0
        m.searchResultsGrid.content = content
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Cargando catálogo..."
        m.searchFilterBusy = false
        return
    end if

    if query = ""
        m.searchResultsGrid.content = content
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
        m.searchFilterBusy = false
        return
    end if

    maxResults = 20
    total = m.allMovies.count()
    i = 0
    while i < total and count < maxResults
        mv = m.allMovies[i]
        i = i + 1
        if mv <> invalid and mv.title <> invalid and mv.title <> ""
            if Instr(1, LCase(mv.title), query) > 0
                item = content.CreateChild("ContentNode")
                item.title = mv.title
                if mv.image <> invalid then
                    item.hdPosterUrl = mv.image
                else if mv.poster <> invalid then
                    item.hdPosterUrl = mv.poster
                else
                    item.hdPosterUrl = ""
                end if
                m.searchResultsRawData.push(mv)
                count = count + 1
            end if
        end if
    end while

    m.searchResultsGrid.content = content
    if m.movieCounterLabel <> invalid
        m.movieCounterLabel.text = count.toStr() + " resultados"
    end if

    m.searchFilterBusy = false
end sub

sub onSearchItemSelected()
    idx = m.searchResultsGrid.itemSelected
    if m.searchResultsRawData <> invalid and idx < m.searchResultsRawData.count()
        showMovieDetails(m.searchResultsRawData[idx])
    end if
end sub

' Arma la pantalla de detalle de una película a partir de los datos que ya
' vinieron completos en el JSON de GitHub (título, imagen, sinopsis, rating,
' géneros y los links de video). No hace ninguna llamada adicional.
sub showMovieDetails(data as object)
    if data = invalid then return

    ' Nueva API: el listado no trae streams; hay que llamar /extract
    if (data.sources = invalid or data.sources.count() = 0) and data.extractUrl <> invalid and data.extractUrl <> ""
        m.pendingMovieData = data
        m.extractTask = CreateObject("roSGNode", "ApiTask")
        m.extractTask.requestUrl = data.extractUrl
        m.extractTask.observeField("response", "onExtractRetrieved")
        m.extractTask.control = "RUN"
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Cargando detalles..."
        return
    end if

    openDetailsWithData(data)
end sub

sub onExtractRetrieved()
    res = m.extractTask.response
    data = m.pendingMovieData
    if data = invalid then data = {}

    if res <> invalid and res.status = "success"
        if res.title <> invalid then data.title = res.title
        if res.description <> invalid then data.description = res.description
        if res.rating <> invalid then data.rating = res.rating
        if res.genres <> invalid then data.genres = res.genres
        if res.poster <> invalid then data.image = res.poster
        data.sources = []
        seenUrl = CreateObject("roAssociativeArray")

        ' 1) streams del extract (los mas fiables: CDN directo)
        if res.streams <> invalid
            for each s in res.streams
                addStreamSource(data.sources, seenUrl, s.url, s.type)
            end for
        end if

        ' 2) alternativas del trace, excepto video.php (Cloudflare 403 en Roku)
        if res.resolutionTrace <> invalid
            for each t in res.resolutionTrace
                if t.finalCdnUrl <> invalid then addStreamSource(data.sources, seenUrl, t.finalCdnUrl, "hls")
                if t.streamUrl <> invalid then addStreamSource(data.sources, seenUrl, t.streamUrl, "hls")
                if t.masterPlaylistUrl <> invalid then addStreamSource(data.sources, seenUrl, t.masterPlaylistUrl, "hls")
            end for
        end if
    end if

    openDetailsWithData(data)
end sub

sub openDetailsWithData(data as object)
    if data = invalid then return

    detailsContent = CreateObject("roSGNode", "ContentNode")
    detailsContent.title = data.title
    detailsContent.hdPosterUrl = getPosterUrl(data)
    if data.description <> invalid then detailsContent.description = data.description else detailsContent.description = ""
    if data.rating <> invalid then detailsContent.rating = data.rating
    if data.year <> invalid then detailsContent.releaseDate = data.year
    if data.quality <> invalid and data.quality <> ""
        if detailsContent.description <> "" then
            detailsContent.description = detailsContent.description + " | " + data.quality
        else
            detailsContent.description = data.quality
        end if
    end if
    if data.genres <> invalid then detailsContent.categories = data.genres

    m.currentStreams = []
    if data.sources <> invalid
        for each src in data.sources
            streamItem = {}
            streamItem.url = src.url
            if src.type <> invalid then streamItem.format = src.type else streamItem.format = "hls"
            m.currentStreams.push(streamItem)
        end for
    end if

    m.detailsScreen.content = detailsContent
    m.detailsScreen.visible = true
    m.detailsScreen.setFocus(true)
end sub

sub showInstructions()
    m.viewMode = "instructions"
    m.portalGroup.visible = false
    m.mainContent.visible = false
    m.instructionGroup.visible = true
    m.top.findNode("closeInstructionsBtn").setFocus(true)
end sub

' --- NAVEGACIÓN ---
sub onMenuItemSelected()
    idx = m.menuList.itemSelected
    if idx = 0
        showPortal()
    else if idx = 1 and m.viewMode = "movies"
        if m.currentPage < m.totalMoviePages then m.currentPage++ : loadMovies(m.currentPage)
    else if idx = 2 and m.viewMode = "movies"
        if m.currentPage > 1 then m.currentPage-- : loadMovies(m.currentPage)
    else if idx = 3
        showSearch()
    end if
    toggleMenu(false)
end sub

sub onItemSelected()
    idx = m.movieGrid.itemSelected
    item = m.movieGrid.content.getChild(idx)
    if m.viewMode = "movies"
        if m.moviesRawData <> invalid and idx < m.moviesRawData.count()
            showMovieDetails(m.moviesRawData[idx])
        end if
    else
        playVideo(item.description)
    end if
end sub

sub onChannelsRetrieved()
    if m.m3uTask.content <> invalid
        m.movieGrid.content = m.m3uTask.content
        m.movieGrid.setFocus(true)
    end if
end sub

sub onCountrySelected()
    idx = m.countryList.itemSelected
    selected = m.countryList.content.getChild(idx)
    m.viewMode = "channels"
    m.countryGroup.visible = false
    m.movieGrid.visible = true
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false
    m.m3uTask = CreateObject("roSGNode", "M3uTask")
    m.m3uTask.url = selected.description
    m.m3uTask.observeField("content", "onChannelsRetrieved")
    m.m3uTask.control = "RUN"
end sub

sub onPlayPressed()
    if m.currentStreams <> invalid and m.currentStreams.count() > 0
        m.currentStreamIndex = 0
        tryPlayCurrentStream()
    else
        m.videoStatusLabel.text = "No se pudo reproducir." + chr(10) + "Esta película no tiene servidores disponibles."
        m.videoStatusBox.visible = true
        m.videoPlayer.visible = false
    end if
end sub

' Intenta reproducir el servidor actual (m.currentStreamIndex). Si ese
' servidor está caído, onVideoStateChange() avanza automáticamente al
' siguiente, hasta encontrar uno que funcione o agotar la lista.
sub tryPlayCurrentStream()
    if m.currentStreams = invalid or m.currentStreamIndex >= m.currentStreams.count()
        m.videoStatusLabel.text = "No se pudo reproducir esta película." + chr(10) + "Prueba otra o pulsa ATRÁS para volver."
        m.videoStatusBox.visible = true
        m.videoPlayer.visible = false
        return
    end if

    m.formatRetryDone = false
    total = m.currentStreams.count()
    if total > 1
        m.videoStatusBox.visible = true
        m.videoStatusLabel.text = "Cargando servidor " + (m.currentStreamIndex + 1).toStr() + " de " + total.toStr() + "..."
    else
        m.videoStatusBox.visible = false
    end if

    stream = m.currentStreams[m.currentStreamIndex]
    playVideo(stream.url, stream.format)
end sub

' Si el servidor actual falla, decide cómo seguir según el TIPO de error:
' - Si el error sugiere que el contenido está mal etiquetado (formato/
'   contenedor incorrecto), reintenta la MISMA url con el otro formato
'   común antes de rendirse con ese servidor.
' - Si es un error de red/HTTP real, pasa directo al siguiente servidor
'   (reintentar con otro formato no va a arreglar un servidor caído).
sub onVideoStateChange()
    state = m.videoPlayer.state
    if state = "error"
        print "=== ERROR DE REPRODUCCION ==="
        if m.videoPlayer.content <> invalid
            print "URL: "; m.videoPlayer.content.url
        end if
        print "errorCode: "; m.videoPlayer.errorCode
        print "errorMsg: "; m.videoPlayer.errorMsg
        print "=============================="
        m.videoPlayer.control = "stop"
        m.videoPlayer.visible = false
        m.videoStatusLabel.text = "Este video no es compatible con Roku." + chr(10) + "Pulsa ATRÁS para volver."
        m.videoStatusBox.visible = true
        if m.detailsScreen.visible then m.detailsScreen.setFocus(true)
    else if state = "playing" or state = "buffering"
        m.videoStatusBox.visible = false
    end if
end sub

sub playVideo(url as String, format = "hls" as String)
    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = url
    if format = "mp4"
        videoContent.streamFormat = "mp4"
    else
        videoContent.streamFormat = "hls"
    end if
    m.videoPlayer.content = videoContent
    m.videoPlayer.visible = true
    m.videoPlayer.control = "play"
    m.videoPlayer.setFocus(true)
end sub

sub toggleMenu(open as Boolean)
    if open
        m.menuOverlay.visible = true
        m.top.findNode("openMenuAnim").control = "start"
        m.menuList.setFocus(true)
    else
        m.menuOverlay.visible = false
        m.top.findNode("closeMenuAnim").control = "start"
        if m.viewMode = "movies" or m.viewMode = "channels" then m.movieGrid.setFocus(true)
        if m.viewMode = "countries" then m.countryList.setFocus(true)
        if m.viewMode = "portal" then m.portalGrid.setFocus(true)
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if key = "back"
        if m.menuOverlay.visible
            toggleMenu(false)
            return true
        end if
        if m.videoPlayer.visible
            m.videoPlayer.control = "stop"
            m.videoPlayer.visible = false
            m.videoStatusBox.visible = false
            if m.viewMode = "movies" or m.viewMode = "search" then m.detailsScreen.setFocus(true) else m.movieGrid.setFocus(true)
            return true
        end if
        if m.detailsScreen.visible
            m.detailsScreen.visible = false
            m.videoStatusBox.visible = false
            ' Restaurar contador de películas (evita que se quede en "Cargando detalles...")
            if m.viewMode = "movies" and m.lastMovieCounterText <> invalid
                m.movieCounterLabel.text = m.lastMovieCounterText
                m.movieCounterLabel.visible = true
            else if m.viewMode = "search" and m.allMovies <> invalid
                m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
            end if
            if m.viewMode = "search" then m.searchResultsGrid.setFocus(true) else m.movieGrid.setFocus(true)
            return true
        end if
        if m.viewMode <> "portal"
            showPortal()
            return true
        end if
    end if
    if key = "left" and m.viewMode <> "portal"
        if (m.movieGrid.hasFocus() and m.movieGrid.itemFocused mod 5 = 0) or m.countryList.hasFocus()
            toggleMenu(true)
            return true
        end if
    end if
    if m.viewMode = "search"
        if key = "right" and m.searchKeyboard.isInFocusChain()
            if m.searchResultsGrid.content <> invalid and m.searchResultsGrid.content.getChildCount() > 0
                m.searchResultsGrid.setFocus(true)
                return true
            end if
        else if key = "left" and m.searchResultsGrid.hasFocus()
            m.searchKeyboard.findNode("keyGrid").setFocus(true)
            return true
        end if
    end if
    return false
end function

' Algunas APIs no siempre usan el mismo nombre de campo para la imagen
' (por ejemplo "image" en el listado y "poster" en el detalle). Esta función
' prueba los nombres más comunes hasta encontrar uno con datos.

' Une featured + movies del JSON de zonaapp y quita duplicados por titulo

sub addStreamSource(sources as object, seenUrl as object, url as dynamic, fmt as dynamic)
    if url = invalid or url = "" then return
    u = url
    if type(u) <> "roString" and type(u) <> "String" then return
    ' video.php de zonaaps devuelve Cloudflare challenge (403); Roku no puede usarlo
    if Instr(1, LCase(u), "zonaaps.com/video.php") > 0 then return
    if Instr(1, LCase(u), "cdn-cgi/challenge") > 0 then return
    if seenUrl.DoesExist(u) then return
    seenUrl.AddReplace(u, true)
    src = CreateObject("roAssociativeArray")
    src.url = u
    if fmt <> invalid and fmt <> "" then src.type = fmt else src.type = "hls"
    ' URLs tipo .tar?r_file=chunklist de Rumble fallan mucho en Roku (-3); igual se prueban al final
    sources.Push(src)
end sub

function flattenMovieList(res as object) as object
    list = CreateObject("roArray", 0, true)
    seen = CreateObject("roAssociativeArray")
    if res = invalid then return list

    buckets = CreateObject("roArray", 0, true)
    if res.DoesExist("featured") and res.featured <> invalid then buckets.Push(res.featured)
    if res.DoesExist("movies") and res.movies <> invalid then buckets.Push(res.movies)
    ' API vieja envuelta: solo movies
    if buckets.Count() = 0 and res.DoesExist("items") and res.items <> invalid then buckets.Push(res.items)

    for each bucket in buckets
        if bucket <> invalid
            for each m_item in bucket
                if m_item <> invalid and m_item.DoesExist("title") and m_item.title <> invalid and m_item.title <> ""
                    key = LCase(m_item.title)
                    if seen.DoesExist(key) = false
                        seen.AddReplace(key, true)
                        list.Push(m_item)
                    end if
                end if
            end for
        end if
    end for
    return list
end function

function getPosterUrl(data as object) as string
    posibles = ["image", "poster", "img", "thumbnail", "cover", "poster_url", "imageUrl", "thumb"]
    for each campo in posibles
        if data.DoesExist(campo)
            valor = data[campo]
            if valor <> invalid and valor <> ""
                return proxyImageUrl(valor)
            end if
        end if
    end for
    return ""
end function

' Roku a menudo no carga imagenes directas de zonaaps; el proxy del worker si
function proxyImageUrl(url as string) as string
    if url = invalid or url = "" then return ""
    if Instr(1, LCase(url), "workers.dev/proxy") > 0 then return url
    enc = CreateObject("roUrlTransfer")
    return "https://zonaapp.ikkihkurogane.workers.dev/proxy?url=" + enc.Escape(url)
end function
