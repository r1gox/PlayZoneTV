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
    m.movieCounterLabel = m.top.findNode("movieCounterLabel")
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

    ' Nodos de interfaz (header + page bar)
    m.headerIcon = m.top.findNode("headerIcon")
    m.navHintLabel = m.top.findNode("navHintLabel")
    m.pageBar = m.top.findNode("pageBar")

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
    m.currentPage = 1
    m.portalGrid.setFocus(true)

    ' Estado del buscador
    m.allMovies = []
    m.moviesRawData = []
    m.searchResultsRawData = []
    m.searchCatalogPage = 0
    m.searchTotalPages = 38
    m.totalMoviePages = 38

    ' Observadores
    m.portalGrid.observeField("itemSelected", "onPortalItemSelected")
    m.movieGrid.observeField("itemSelected", "onItemSelected")
    m.countryList.observeField("itemSelected", "onCountrySelected")
    m.menuList.observeField("itemSelected", "onMenuItemSelected")
    m.detailsScreen.observeField("playPressed", "onPlayPressed")
    m.top.findNode("closeInstructionsBtn").observeField("buttonSelected", "showPortal")
    m.searchKeyboard.observeField("text", "onSearchTextChanged")
    m.searchResultsGrid.observeField("itemSelected", "onSearchItemSelected")

    checkForUpdates()
end sub

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

' UI de películas: header completo + página
sub setMoviesUI()
    m.headerIcon.visible = true
    m.movieCounterLabel.visible = true
    m.navHintLabel.visible = true
    m.pageBar.visible = true
end sub

' UI de canales: solo título + icono (sin contador, sin menú, sin página)
sub setChannelsUI()
    m.headerIcon.visible = true
    m.movieCounterLabel.visible = false
    m.navHintLabel.visible = false
    m.pageBar.visible = false
end sub

' --- SECCIONES ---
sub loadMovies(page as Integer)
    m.viewMode = "movies"
    m.currentPage = page
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false

    m.titleLabel.text = "PLAYZONE - PELÍCULAS"
    setMoviesUI()

    m.apiTask = CreateObject("roSGNode", "ApiTask")
    m.apiTask.requestUrl = "https://raw.githubusercontent.com/r1gox/PlayZone-Api/main/movies/page-" + page.toStr() + ".json"
    m.apiTask.observeField("response", "onMoviesRetrieved")
    m.apiTask.control = "RUN"
end sub

sub onMoviesRetrieved()
    res = m.apiTask.response
    if res <> invalid
        content = CreateObject("roSGNode", "ContentNode")
        for each m_item in res
            item = content.CreateChild("ContentNode")
            item.title = m_item.title
            item.hdPosterUrl = getPosterUrl(m_item)
        end for
        m.moviesRawData = res
        m.movieGrid.content = content
        m.movieGrid.setFocus(true)
        m.movieCounterLabel.text = "(" + content.getChildCount().toStr() + " películas)"
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

    m.titleLabel.text = "CANALES TV CABLE"
    setChannelsUI()

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
    m.titleLabel.text = "IPTV POR PAÍSES"

    m.headerIcon.visible = true
    m.movieCounterLabel.visible = false
    m.navHintLabel.visible = false
    m.pageBar.visible = false

    content = CreateObject("roSGNode", "ContentNode")
    for each c in m.countries
        item = content.CreateChild("ContentNode")
        item.title = c.name
        item.description = "https://iptv-org.github.io/iptv/countries/" + c.code + ".m3u"
    end for
    m.countryList.content = content
    m.countryList.setFocus(true)
end sub

sub showSearch()
    m.viewMode = "search"
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = true
    m.titleLabel.text = "Buscar Películas"

    m.headerIcon.visible = true
    m.movieCounterLabel.visible = true
    m.navHintLabel.visible = false
    m.pageBar.visible = false

    if m.allMovies.count() = 0
        m.movieCounterLabel.text = "Cargando catálogo..."
        m.searchCatalogPage = 1
        fetchCatalogPage(m.searchCatalogPage)
    else
        m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
    end if

    m.searchKeyboard.findNode("keyGrid").setFocus(true)
end sub

sub fetchCatalogPage(page as Integer)
    m.catalogTask = CreateObject("roSGNode", "ApiTask")
    m.catalogTask.requestUrl = "https://raw.githubusercontent.com/r1gox/PlayZone-Api/main/movies/page-" + page.toStr() + ".json"
    m.catalogTask.observeField("response", "onCatalogPageRetrieved")
    m.catalogTask.control = "RUN"
end sub

sub onCatalogPageRetrieved()
    res = m.catalogTask.response
    if res <> invalid
        for each mv in res
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

sub onSearchTextChanged()
    filterSearchResults()
end sub

sub filterSearchResults()
    query = LCase(m.searchKeyboard.text)
    content = CreateObject("roSGNode", "ContentNode")
    m.searchResultsRawData = []
    count = 0

    if query <> "" and m.allMovies.count() > 0
        for each mv in m.allMovies
            if instr(1, LCase(mv.title), query) > 0
                item = content.CreateChild("ContentNode")
                item.title = mv.title
                item.hdPosterUrl = getPosterUrl(mv)
                m.searchResultsRawData.push(mv)
                count++
                if count >= 60 then exit for
            end if
        end for
    end if

    m.searchResultsGrid.content = content

    if query <> "" and m.allMovies.count() > 0
        m.movieCounterLabel.text = count.toStr() + " resultados para '" + query + "'"
    end if
end sub

sub onSearchItemSelected()
    idx = m.searchResultsGrid.itemSelected
    if m.searchResultsRawData <> invalid and idx < m.searchResultsRawData.count()
        showMovieDetails(m.searchResultsRawData[idx])
    end if
end sub

sub showMovieDetails(data as object)
    if data = invalid then return

    detailsContent = CreateObject("roSGNode", "ContentNode")
    detailsContent.title = data.title
    detailsContent.hdPosterUrl = getPosterUrl(data)
    detailsContent.description = data.description
    if data.rating <> invalid then detailsContent.rating = data.rating
    if data.year <> invalid then detailsContent.releaseDate = data.year
    if data.quality <> invalid then detailsContent.shortDescription = data.quality
    if data.genres <> invalid then detailsContent.categories = data.genres

    m.currentStreams = []
    if data.sources <> invalid
        for each src in data.sources
            streamItem = {}
            streamItem.url = src.url
            streamItem.format = src.type
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

    m.titleLabel.text = "CANALES TV CABLE"
    setChannelsUI()

    m.m3uTask = CreateObject("roSGNode", "M3uTask")
    m.m3uTask.url = selected.description
    m.m3uTask.observeField("content", "onChannelsRetrieved")
    m.m3uTask.control = "RUN"
end sub

sub onPlayPressed()
    if m.currentStreams <> invalid and m.currentStreams.count() > 0
        m.currentStreamIndex = 0
        tryPlayCurrentStream()
    end if
end sub

sub tryPlayCurrentStream()
    if m.currentStreams = invalid or m.currentStreamIndex >= m.currentStreams.count()
        m.videoStatusLabel.text = "No se pudo reproducir con ningún servidor disponible."
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

sub onVideoStateChange()
    state = m.videoPlayer.state
    if state = "error"
        print "=== ERROR DE REPRODUCCION ==="
        print "Servidor intentado: "; m.currentStreamIndex + 1; " de "; m.currentStreams.count()
        print "URL: "; m.videoPlayer.content.url
        print "Formato declarado: "; m.videoPlayer.content.streamFormat
        print "errorCode: "; m.videoPlayer.errorCode
        print "errorMsg: "; m.videoPlayer.errorMsg
        print "=============================="

        msg = LCase(m.videoPlayer.errorMsg)
        esProblemaDeFormato = (instr(1, msg, "malformed") > 0) or (instr(1, msg, "codec") > 0) or (instr(1, msg, "container") > 0)

        if esProblemaDeFormato and not m.formatRetryDone
            m.formatRetryDone = true
            actual = m.currentStreams[m.currentStreamIndex]
            if actual.format = "hls" then
                otroFormato = "mp4"
            else
                otroFormato = "hls"
            end if
            print "Reintentando mismo link con formato alternativo: "; otroFormato
            m.videoStatusLabel.text = "Probando otro formato para este servidor..."
            m.videoStatusBox.visible = true
            playVideo(actual.url, otroFormato)
        else
            m.currentStreamIndex++
            tryPlayCurrentStream()
        end if
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

function getPosterUrl(data as object) as string
    posibles = ["image", "poster", "img", "thumbnail", "cover", "poster_url", "imageUrl", "thumb"]
    for each campo in posibles
        if data.DoesExist(campo)
            valor = data[campo]
            if valor <> invalid and valor <> ""
                return valor
            end if
        end if
    end for
    return ""
end function
