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

    ' 1. Portal
    portalContent = CreateObject("roSGNode", "ContentNode")
    addItem(portalContent, "Películas")
    addItem(portalContent, "Series")
    addItem(portalContent, "Doramas")
    addItem(portalContent, "Animes")
    addItem(portalContent, "CANALES TV CABLE")
    addItem(portalContent, "TV POR PAÍSES")
    addItem(portalContent, "Instrucciones")
    m.portalGrid.content = portalContent

    ' 2. Menu lateral
    menuContent = CreateObject("roSGNode", "ContentNode")
    addItem(menuContent, "INICIO")
    addItem(menuContent, "SIG. PÁGINA >")
    addItem(menuContent, "< PÁG. ANTERIOR")
    addItem(menuContent, "BUSCAR")
    addItem(menuContent, "★ FAVORITOS")
    addItem(menuContent, "CERRAR")
    m.menuList.content = menuContent

    ' 3. Países IPTV
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

    ' Estado películas / buscador
    m.allMovies = []
    m.moviesRawData = []
    m.searchResultsRawData = []
    m.searchCatalogPage = 0
    m.searchTotalPages = 16
    m.totalMoviePages = 16

    ' Estado series
    m.totalSeriesPages = 3
    m.seriesRawData = []
    m.currentSeasons = []
    m.currentEpisodes = []
    m.pendingSeriesData = invalid
    m.pendingSeriesFullData = invalid
    m.pendingEpisodeData = invalid
    m.seriesDetailsActive = false
    m.doramaDetailsActive = false
    m.seriesDetailsReturnMode = "series"
    m.seriesEnteredFromSearch = false
    m.allSeries = []
    m.searchMode = "movies"
    m.searchSeriesCatalogPage = 0
    m.searchSeriesTotalPages = 3

    m.totalDoramasPages = 14
    m.doramasRawData = []
    m.pendingDoramaData = invalid
    m.allDoramas = []
    m.searchDoramasCatalogPage = 0
    m.searchDoramasTotalPages = 14

    m.totalAnimesPages = 36
    m.animesRawData = []
    m.pendingAnimeData = invalid
    m.allAnimes = []
    m.searchAnimesCatalogPage = 0
    m.searchAnimesTotalPages = 36
    m.animeDetailsActive = false

    ' Observadores
    m.portalGrid.observeField("itemSelected", "onPortalItemSelected")
    m.movieGrid.observeField("itemSelected", "onItemSelected")
    m.countryList.observeField("itemSelected", "onCountrySelected")
    m.menuList.observeField("itemSelected", "onMenuItemSelected")
    m.detailsScreen.observeField("playPressed", "onPlayPressed")
    m.detailsScreen.observeField("favPressed", "onFavPressed")
    m.top.findNode("closeInstructionsBtn").observeField("buttonSelected", "showPortal")
    m.searchKeyboard.observeField("text", "onSearchTextChanged")
    m.searchResultsGrid.observeField("itemSelected", "onSearchItemSelected")

    m.searchTimer = CreateObject("roSGNode", "Timer")
    m.searchTimer.repeat = false
    m.searchTimer.duration = 0.4
    m.searchTimer.observeField("fire", "onSearchTimerFire")
    m.searchFilterBusy = false

    ' --- CONFIG REMOTO (URLs) ---
    m.config = {
        moviesApiUrl: "https://zonaapp.ikkihkurogane.workers.dev/list?page=",
        seriesApiUrl: "https://apiprorescue.testaacc.workers.dev/list?type=tvshows&page=",
        doramasApiUrl: "https://pelisplushd.tvymas.workers.dev/doramas?page=",
        animesApiUrl: "https://pelisplushd.tvymas.workers.dev/animes?page=",
        imageProxyBase: "https://zonaapp.ikkihkurogane.workers.dev",
        cableM3u: "https://raw.githubusercontent.com/NOVAPSNew/Novaps/main/tv.m3u",
        countriesIptvBase: "https://iptv-org.github.io/iptv/countries/"
    }
    m.configLoaded = false
    loadRemoteConfig()

    m.watchedMap = {}
    m.favoritesList = []
    m.currentPlayId = ""
    m.currentPlayParentId = ""
    loadUserData()

    checkForUpdates()
end sub

' --- ACTUALIZACIONES ---
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

' --- CONFIG REMOTO ---
sub loadRemoteConfig()
    m.configTask = CreateObject("roSGNode", "ApiTask")
    m.configTask.requestUrl = "https://raw.githubusercontent.com/r1gox/PlayZoneTV/main/config.json"
    m.configTask.observeField("response", "onConfigRetrieved")
    m.configTask.control = "RUN"
end sub

sub onConfigRetrieved()
    res = m.configTask.response
    if res = invalid then return

    if res.moviesApiUrl <> invalid and res.moviesApiUrl <> "" then m.config.moviesApiUrl = res.moviesApiUrl
    if res.seriesApiUrl <> invalid and res.seriesApiUrl <> "" then m.config.seriesApiUrl = res.seriesApiUrl
    if res.doramasApiUrl <> invalid and res.doramasApiUrl <> "" then m.config.doramasApiUrl = res.doramasApiUrl
    if res.animesApiUrl <> invalid and res.animesApiUrl <> "" then m.config.animesApiUrl = res.animesApiUrl
    if res.imageProxyBase <> invalid and res.imageProxyBase <> "" then m.config.imageProxyBase = res.imageProxyBase
    if res.cableM3u <> invalid and res.cableM3u <> "" then m.config.cableM3u = res.cableM3u
    if res.countriesIptvBase <> invalid and res.countriesIptvBase <> "" then m.config.countriesIptvBase = res.countriesIptvBase

    m.configLoaded = true
end sub

sub addItem(parent, title)
    item = parent.CreateChild("ContentNode")
    item.title = title
end sub

' --- PORTAL ---
sub onPortalItemSelected()
    idx = m.portalGrid.itemSelected
    if idx = 0 then loadMovies(1)
    if idx = 1 then loadSeries(1)
    if idx = 2 then loadDoramas(1)
    if idx = 3 then loadAnimes(1)
    if idx = 4 then loadCable()
    if idx = 5 then showCountryList()
    if idx = 6 then showInstructions()
end sub

sub showPortal()
    m.viewMode = "portal"
    m.portalGroup.visible = true
    m.mainContent.visible = false
    m.instructionGroup.visible = false
    m.searchGroup.visible = false
    m.portalGrid.setFocus(true)
end sub

sub setSectionHeader(title as String, iconName as String)
    if m.titleLabel <> invalid then m.titleLabel.text = title
    if m.headerIcon <> invalid
        m.headerIcon.uri = "pkg:/images/icons/" + iconName + ".png"
        m.headerIcon.visible = true
    end if
end sub

' --- PELÍCULAS ---
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
    m.apiTask.requestUrl = m.config.moviesApiUrl + page.toStr()
    m.apiTask.observeField("response", "onMoviesRetrieved")
    m.apiTask.control = "RUN"
end sub

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
            applyWatchedFlag(item, makeContentId("movie", m_item))
        end for
        m.moviesRawData = list
        m.movieGrid.content = content
        m.movieGrid.setFocus(true)
        m.lastMovieCounterText = "(" + content.getChildCount().toStr() + " películas)"
        m.movieCounterLabel.text = m.lastMovieCounterText
        m.pageIndicator.text = "Página " + m.currentPage.toStr() + " de " + m.totalMoviePages.toStr()
    end if
end sub

' --- SERIES ---
sub loadSeries(page as Integer)
    m.viewMode = "series"
    m.currentPage = page
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    setSectionHeader("SERIES", "series")
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    m.apiTask = CreateObject("roSGNode", "ApiTask")
    m.apiTask.requestUrl = m.config.seriesApiUrl + page.toStr()
    m.apiTask.observeField("response", "onSeriesRetrieved")
    m.apiTask.control = "RUN"
end sub

sub onSeriesRetrieved()
    res = m.apiTask.response
    if res = invalid then return
    if res.totalPages <> invalid then m.totalSeriesPages = res.totalPages else m.totalSeriesPages = 3

    list = []
    if res.featured <> invalid
        for each s in res.featured
            list.Push(s)
        end for
    end if
    if res.tvshows <> invalid
        for each s in res.tvshows
            list.Push(s)
        end for
    end if
    if res.items <> invalid
        for each s in res.items
            list.Push(s)
        end for
    end if

    content = CreateObject("roSGNode", "ContentNode")
    m.seriesRawData = list
    for each s_item in list
        item = content.CreateChild("ContentNode")
        item.title = s_item.title
        item.hdPosterUrl = getPosterUrl(s_item)
        applyWatchedFlag(item, makeContentId("series", s_item))
        if s_item.extractUrl <> invalid
            item.description = FixZonaApiUrl(s_item.extractUrl)
        end if
    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.lastMovieCounterText = "(" + content.getChildCount().toStr() + " series)"
    m.movieCounterLabel.text = m.lastMovieCounterText
    m.pageIndicator.text = "Página " + m.currentPage.toStr() + " de " + m.totalSeriesPages.toStr()
end sub

sub showSeriesDetails(data as object, isNewSelection = true as Boolean)
    if data = invalid then return

    extractUrl = ""
    if data.extractUrl <> invalid then extractUrl = FixZonaApiUrl(data.extractUrl)
    if extractUrl = "" then return

    ' Guardamos por dónde entró el usuario.
    ' Esto permite conservar el comportamiento actual de búsqueda y navegación.
    if isNewSelection
        m.seriesEnteredFromSearch = (m.viewMode = "search")
        m.seriesDetailsReturnMode = "series"
    else
        ' Cuando volvemos desde un episodio, conservamos el flujo anterior:
        ' episodio -> ficha de serie -> atrás -> episodios.
        m.seriesDetailsReturnMode = "episodes"
    end if

    m.pendingSeriesData = data
    m.extractTask = CreateObject("roSGNode", "ApiTask")
    m.extractTask.requestUrl = extractUrl
    m.extractTask.observeField("response", "onSeriesExtractRetrieved")
    m.extractTask.control = "RUN"
    showCenteredLoading("Cargando detalles...")
end sub


sub onSeriesExtractRetrieved()
    res = m.extractTask.response
    if res = invalid or res.status <> "success"
        hideCenteredLoading()
        showTemporaryStatus("No se pudieron cargar los detalles.")
        return
    end if
    if res.seasons = invalid
        hideCenteredLoading()
        showTemporaryStatus("Esta serie no tiene temporadas.")
        return
    end if

    ' Mantener exactamente los datos usados por temporadas/episodios.
    m.currentSeasons = res.seasons
    m.pendingSeriesFullData = res

    data = m.pendingSeriesData
    if data = invalid then data = {}

    ' ============================================================
    ' DATOS DE LA FICHA DE SERIE
    ' Se preparan con los mismos campos que usa DetailsScreen
    ' para las películas.
    ' ============================================================

    if res.title <> invalid and res.title <> ""
        data.title = res.title
    end if

    if data.title = invalid or data.title = ""
        if res.name <> invalid and res.name <> "" then data.title = res.name
    end if

    if res.description <> invalid and res.description <> ""
        data.description = res.description
    else if res.synopsis <> invalid and res.synopsis <> ""
        data.description = res.synopsis
    else if res.summary <> invalid and res.summary <> ""
        data.description = res.summary
    end if

    if res.rating <> invalid and res.rating <> ""
        data.rating = res.rating
    else if res.imdbRating <> invalid and res.imdbRating <> ""
        data.rating = res.imdbRating
    end if

    if res.year <> invalid and res.year <> ""
        data.year = res.year
    else if res.releaseDate <> invalid and res.releaseDate <> ""
        data.year = res.releaseDate
    else if res.seasons.count() > 0
        if res.seasons[0].releaseDate <> invalid and res.seasons[0].releaseDate <> ""
            data.year = res.seasons[0].releaseDate
        end if
    end if

    if res.genres <> invalid
        data.genres = res.genres
    else if res.categories <> invalid
        data.genres = res.categories
    end if

    if res.poster <> invalid and res.poster <> ""
        data.image = res.poster
    else if res.image <> invalid and res.image <> ""
        data.image = res.image
    end if

    ' La ficha de serie no necesita streams.
    ' Al pulsar el botón de la ficha, onPlayPressed() llevará al usuario
    ' a las temporadas, manteniendo el flujo original.
    data.sources = []

    m.pendingSeriesData = data
    m.seriesDetailsActive = true

    ' Ocultar el catálogo detrás de la ficha.
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false

    ' ============================================================
    ' USAR EL MISMO DetailsScreen DE LAS PELÍCULAS
    ' ============================================================
    openDetailsWithData(data)
end sub


sub showSeasonEpisodes(seasonIdx as Integer)
    if m.currentSeasons = invalid or seasonIdx >= m.currentSeasons.count() then return
    season = m.currentSeasons[seasonIdx]
    m.currentSeasonIndex = seasonIdx
    m.currentEpisodes = season.episodes
    m.viewMode = "episodes"
    setSectionHeader(season.title, "film")

    content = CreateObject("roSGNode", "ContentNode")
    if season.episodes <> invalid
        for each ep in season.episodes
            item = content.CreateChild("ContentNode")
            t = ""
            if ep.numerando <> invalid then t = ep.numerando + "  "
            if ep.title <> invalid then t = t + ep.title
            item.title = t
            item.hdPosterUrl = getPosterUrl(ep)
            if ep.extractUrl <> invalid
                item.description = FixZonaApiUrl(ep.extractUrl)
            end if
            applyWatchedFlag(item, makeContentId("ep", ep))
        end for
    end if

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    cnt = content.getChildCount()
    m.movieCounterLabel.text = cnt.toStr() + " episodios"
end sub

sub playEpisode(epIdx as Integer)
    if m.currentEpisodes = invalid or epIdx >= m.currentEpisodes.count() then return
    ep = m.currentEpisodes[epIdx]
    extractUrl = FixZonaApiUrl(ep.extractUrl)
    if extractUrl = "" then return
    m.pendingEpisodeData = ep
    m.currentPlayId = makeContentId("ep", ep)
    m.currentPlayParentId = makeContentId("series", m.pendingSeriesData)
    m.extractTask = CreateObject("roSGNode", "ApiTask")
    m.extractTask.requestUrl = extractUrl
    m.extractTask.observeField("response", "onEpisodeExtractRetrieved")
    m.extractTask.control = "RUN"
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Cargando episodio..."
end sub


sub onEpisodeExtractRetrieved()
    res = m.extractTask.response
    if res = invalid or res.status <> "success" then return

    m.currentStreams = []
    if res.streams <> invalid
        for each s in res.streams
            url = ""
            fmt = "hls"

            ' Prioridad de campos según la nueva API
            if s.proxyUrlHLS <> invalid and s.proxyUrlHLS <> ""
                url = FixZonaApiUrl(s.proxyUrlHLS)
                fmt = "hls"
            else if s.proxyUrlMP4 <> invalid and s.proxyUrlMP4 <> ""
                url = FixZonaApiUrl(s.proxyUrlMP4)
                fmt = "mp4"
            else if s.url <> invalid and s.url <> ""
                url = FixZonaApiUrl(s.url)
            else if s.proxyUrl <> invalid and s.proxyUrl <> ""
                url = FixZonaApiUrl(s.proxyUrl)
            end if

            if url <> ""
                ' Solo re-detectamos el formato si el campo no nos lo dijo
                ' ya con certeza (proxyUrlHLS/proxyUrlMP4). Para cualquier
                ' otro caso (url / proxyUrl genérico), miramos el link REAL
                ' de adentro del proxy en vez de confiar en el nombre del
                ' endpoint envolvente (ver detectStreamFormat).
                if s.proxyUrlHLS = invalid or s.proxyUrlHLS = ""
                    if s.proxyUrlMP4 = invalid or s.proxyUrlMP4 = ""
                        fmt = detectStreamFormat(url)
                    end if
                end if

                streamItem = {}
                streamItem.url = url
                streamItem.format = fmt
                m.currentStreams.Push(streamItem)
            end if
        end for
    end if

    if m.currentStreams.count() > 0
        m.currentStreamIndex = 0
        tryPlayCurrentStream()
    else
        showTemporaryStatus("No se encontraron streams para este episodio.")
    end if
end sub

' Detecta el formato real de un link de video, incluso cuando viene
' envuelto en un proxy tipo ".../proxyvideo?url=<link real>&...".
' Antes se asumía "hls" para CUALQUIER url que contuviera "proxyvideo",
' pero ese mismo endpoint también sirve MP4 (proxyUrlMP4), así que había
' que mirar el link de ADENTRO, no el nombre del endpoint de afuera.
function detectStreamFormat(url as String) as String
    lowerUrl = LCase(url)

    ' ¿Es un proxy con un "url=" adentro? Miramos ESE valor primero.
    idx = Instr(1, lowerUrl, "url=")
    checkUrl = lowerUrl
    if idx > 0
        resto = Mid(lowerUrl, idx + 4)
        ampIdx = Instr(1, resto, "&")
        if ampIdx > 0
            innerUrl = Left(resto, ampIdx - 1)
        else
            innerUrl = resto
        end if
        ' Por si el link interno viene url-encoded
        innerUrl = innerUrl.Replace("%2e", ".")
        innerUrl = innerUrl.Replace("%2f", "/")
        if innerUrl <> "" then checkUrl = innerUrl
    end if

    if Instr(1, checkUrl, ".m3u8") > 0 or Instr(1, checkUrl, "/hls/") > 0
        return "hls"
    else if Instr(1, checkUrl, ".mp4") > 0
        return "mp4"
    end if

    ' Si no pudimos determinar nada por la URL interna, recién ahí usamos
    ' el nombre del endpoint como última pista (comportamiento anterior).
    if Instr(1, lowerUrl, "proxyvideo") > 0
        return "hls"
    end if

    return "hls"
end function

function FixZonaApiUrl(url as string) as string
    if url = invalid or url = "" then return ""
    u = url
    u = u.Replace("zonaapis.arcando.cloud//", "zonaapis.arcando.cloud/")
    u = u.Replace("arcando.cloud//", "arcando.cloud/")
    u = u.Replace("apiprorescue.testaacc.workers.dev//", "apiprorescue.testaacc.workers.dev/")
    return u
end function


' --- DORAMAS ---
sub loadDoramas(page as Integer)
    m.viewMode = "doramas"
    m.currentPage = page
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    setSectionHeader("DORAMAS", "doramas")
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    m.apiTask = CreateObject("roSGNode", "ApiTask")
    m.apiTask.requestUrl = m.config.doramasApiUrl + page.toStr()
    m.apiTask.observeField("response", "onDoramasRetrieved")
    m.apiTask.control = "RUN"
end sub

sub onDoramasRetrieved()
    res = m.apiTask.response
    if res = invalid then return
    if res.total_pages <> invalid then
        m.totalDoramasPages = res.total_pages
    else if res.totalPages <> invalid then
        m.totalDoramasPages = res.totalPages
    end if

    list = []
    if res.doramas <> invalid
        for each d in res.doramas
            list.Push(d)
        end for
    end if

    content = CreateObject("roSGNode", "ContentNode")
    m.doramasRawData = list
    for each d_item in list
        ' Preferir poster mediano de TMDB para que cargue más rápido
        if d_item.tmdb_poster <> invalid and d_item.tmdb_poster <> ""
            d_item.image = d_item.tmdb_poster
        else if d_item.image <> invalid
            img = d_item.image
            if Instr(1, LCase(img), "/original/") > 0
                d_item.image = img.Replace("/original/", "/w500/")
            end if
        end if
        item = content.CreateChild("ContentNode")
        item.title = d_item.title
        item.hdPosterUrl = getPosterUrl(d_item)
        if d_item.url <> invalid then item.description = d_item.url
        applyWatchedFlag(item, makeContentId("dorama", d_item))
    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.lastMovieCounterText = "(" + content.getChildCount().toStr() + " doramas)"
    m.movieCounterLabel.text = m.lastMovieCounterText
    m.pageIndicator.text = "Página " + m.currentPage.toStr() + " de " + m.totalDoramasPages.toStr()
end sub

sub showDoramaDetails(data as object, isNewSelection = true as Boolean)
    if data = invalid then return
    detailUrl = ""
    if data.url <> invalid and data.url <> "" then detailUrl = data.url
    if detailUrl = "" and data.slug <> invalid
        detailUrl = "https://pelisplushd.tvymas.workers.dev/dorama/" + data.slug
    end if
    if detailUrl = "" then return

    if isNewSelection
        m.doramaEnteredFromSearch = (m.viewMode = "search")
    end if

    m.pendingDoramaData = data
    if m.movieCounterLabel <> invalid
        m.movieCounterLabel.visible = true
        m.movieCounterLabel.text = m.lastMovieCounterText
    end if
    showCenteredLoading("Cargando detalles...")
    m.extractTask = CreateObject("roSGNode", "ApiTask")
    m.extractTask.requestUrl = detailUrl
    m.extractTask.observeField("response", "onDoramaDetailRetrieved")
    m.extractTask.control = "RUN"
end sub

sub onDoramaDetailRetrieved()
    res = m.extractTask.response
    if res = invalid
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Error al cargar el dorama"
        hideCenteredLoading()
        showTemporaryStatus("No se pudo cargar este dorama.")
        return
    end if
    if res.temporadas = invalid
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "No hay temporadas"
        showTemporaryStatus("Este dorama no tiene temporadas.")
        return
    end if

    seasons = []
    for each t in res.temporadas
        season = {}
        if t.name <> invalid then season.title = t.name else season.title = "Temporada"
        if t.season_number <> invalid and (t.name = invalid or t.name = "")
            season.title = "Temporada " + t.season_number.toStr()
        end if
        if t.air_date <> invalid then season.releaseDate = t.air_date
        season.episodesCount = t.episode_count
        eps = []
        if t.episodios <> invalid
            for each e in t.episodios
                ep = {}
                if e.episode_number <> invalid
                    ep.numerando = "E" + e.episode_number.toStr()
                else
                    ep.numerando = "E"
                end if
                if e.name <> invalid then ep.title = e.name else ep.title = "Episodio"
                if e.still <> invalid then ep.image = e.still
                if e.url <> invalid then ep.extractUrl = e.url
                eps.Push(ep)
            end for
        end if
        season.episodes = eps
        seasons.Push(season)
    end for

    m.currentSeasons = seasons

    data = m.pendingDoramaData
    if data = invalid then data = {}

    if res.title <> invalid and res.title <> "" then data.title = res.title

    desc = ""
    if res.description <> invalid and res.description <> ""
        desc = res.description
    else if res.overview_tmdb <> invalid and res.overview_tmdb <> ""
        desc = res.overview_tmdb
    else if res.tmdb_overview <> invalid and res.tmdb_overview <> ""
        desc = res.tmdb_overview
    end if
    ' Evitar textos enormes que traben la UI
    if Len(desc) > 600 then desc = Left(desc, 600) + "..."
    data.description = desc

    ' Rating siempre como string
    data.rating = ""
    if res.rating <> invalid
        rt = type(res.rating)
        if rt = "Integer" or rt = "roInteger" or rt = "Float" or rt = "roFloat" or rt = "Double" or rt = "roDouble"
            data.rating = res.rating.ToStr()
        else
            data.rating = res.rating
        end if
    else if res.tmdb_rating <> invalid
        rt = type(res.tmdb_rating)
        if rt = "Integer" or rt = "roInteger" or rt = "Float" or rt = "roFloat" or rt = "Double" or rt = "roDouble"
            data.rating = res.tmdb_rating.ToStr()
        else
            data.rating = res.tmdb_rating
        end if
    end if

    data.year = ""
    if res.year <> invalid and res.year <> ""
        data.year = res.year
    else if res.release_date <> invalid and res.release_date <> ""
        data.year = Left(res.release_date.ToStr(), 4)
    else if res.tmdb_release_date <> invalid and res.tmdb_release_date <> ""
        data.year = Left(res.tmdb_release_date.ToStr(), 4)
    end if

    ' Géneros como array de strings
    data.genres = []
    rawGenres = invalid
    if res.genres <> invalid then rawGenres = res.genres
    if rawGenres = invalid and res.genres_tmdb <> invalid then rawGenres = res.genres_tmdb
    if rawGenres = invalid and res.tmdb_genres <> invalid then rawGenres = res.tmdb_genres
    if rawGenres <> invalid
        for each g in rawGenres
            if g <> invalid
                data.genres.Push(g.ToStr())
            end if
        end for
    end if

    ' Portada: preferir w500
    if res.poster_tmdb <> invalid and res.poster_tmdb <> ""
        data.tmdb_poster = res.poster_tmdb
        data.image = res.poster_tmdb
    else if res.image <> invalid and res.image <> ""
        data.image = res.image
    end if

    data.sources = []

    m.pendingDoramaData = data
    m.doramaDetailsActive = true
    m.seriesDetailsActive = false

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false

    openDetailsWithData(data)
end sub

sub showDoramaSeasons()
    if m.currentSeasons = invalid or m.currentSeasons.count() = 0 then return

    m.doramaDetailsActive = false
    m.detailsScreen.visible = false
    m.videoStatusBox.visible = false
    m.viewMode = "dorama_seasons"

    m.movieGrid.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true

    titleTxt = "TEMPORADAS"
    if m.pendingDoramaData <> invalid and m.pendingDoramaData.title <> invalid
        titleTxt = m.pendingDoramaData.title
    end if
    setSectionHeader(titleTxt, "film")

    content = CreateObject("roSGNode", "ContentNode")
    sidx = 0
    for each season in m.currentSeasons
        item = content.CreateChild("ContentNode")
        if season.title <> invalid and season.title <> ""
            item.title = season.title
        else
            item.title = "Temporada"
        end if
        if season.releaseDate <> invalid and season.releaseDate <> ""
            item.title = item.title + "  (" + season.releaseDate + ")"
        end if
        if m.pendingDoramaData <> invalid
            item.hdPosterUrl = getPosterUrl(m.pendingDoramaData)
        end if
        parentId = makeContentId("dorama", m.pendingDoramaData)
        seasonId = parentId + ":season:" + sidx.toStr()
        if isWatched(seasonId) or isSeasonFullyWatched(m.currentSeasons, sidx)
            applyWatchedFlag(item, seasonId)
        end if
        sidx = sidx + 1
    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.movieCounterLabel.text = m.currentSeasons.count().toStr() + " temporadas"
end sub

sub showDoramaSeasonEpisodes(seasonIdx as Integer)
    if m.currentSeasons = invalid or seasonIdx >= m.currentSeasons.count() then return
    season = m.currentSeasons[seasonIdx]
    m.currentSeasonIndex = seasonIdx
    m.currentEpisodes = season.episodes
    m.viewMode = "dorama_episodes"
    setSectionHeader(season.title, "film")

    content = CreateObject("roSGNode", "ContentNode")
    if season.episodes <> invalid
        for each ep in season.episodes
            item = content.CreateChild("ContentNode")
            t = ""
            if ep.numerando <> invalid then t = ep.numerando + "  "
            if ep.title <> invalid then t = t + ep.title
            item.title = t
            item.hdPosterUrl = getPosterUrl(ep)
            if ep.extractUrl <> invalid then item.description = ep.extractUrl
            applyWatchedFlag(item, makeContentId("ep", ep))
        end for
    end if

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.movieCounterLabel.text = content.getChildCount().toStr() + " episodios"
end sub

sub playDoramaEpisode(epIdx as Integer)
    if m.currentEpisodes = invalid or epIdx >= m.currentEpisodes.count() then return
    ep = m.currentEpisodes[epIdx]
    if ep.extractUrl = invalid or ep.extractUrl = "" then return
    m.pendingEpisodeData = ep
    m.currentPlayId = makeContentId("ep", ep)
    m.currentPlayParentId = makeContentId("dorama", m.pendingDoramaData)
    m.extractTask = CreateObject("roSGNode", "ApiTask")
    m.extractTask.requestUrl = ep.extractUrl
    m.extractTask.observeField("response", "onDoramaEpisodeRetrieved")
    m.extractTask.control = "RUN"
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Cargando episodio..."
end sub

sub onDoramaEpisodeRetrieved()
    res = m.extractTask.response
    if res = invalid then
        showTemporaryStatus("No se pudo cargar el episodio.")
        return
    end if

    streamUrl = ""
    if res.embeds <> invalid and res.embeds.video <> invalid
        for each emb in res.embeds.video
            if emb.stream_url <> invalid and emb.stream_url <> ""
                streamUrl = emb.stream_url
                exit for
            end if
        end for
    end if

    if streamUrl = ""
        showTemporaryStatus("No hay servidores para este episodio.")
        return
    end if

    m.streamResolveTask = CreateObject("roSGNode", "ApiTask")
    m.streamResolveTask.requestUrl = streamUrl
    m.streamResolveTask.observeField("response", "onDoramaStreamResolved")
    m.streamResolveTask.control = "RUN"
end sub

sub onDoramaStreamResolved()
    res = m.streamResolveTask.response
    if res = invalid then
        showTemporaryStatus("No se pudo resolver el stream.")
        return
    end if

    m.currentStreams = []

    if res.qualities <> invalid
        for each q in res.qualities
            if q.proxy_url <> invalid and q.proxy_url <> ""
                streamItem = {}
                streamItem.url = q.proxy_url
                streamItem.format = "hls"
                m.currentStreams.Push(streamItem)
            else if q.url <> invalid and q.url <> ""
                streamItem = {}
                streamItem.url = q.url
                streamItem.format = "hls"
                m.currentStreams.Push(streamItem)
            end if
        end for
    end if

    if m.currentStreams.count() = 0 and res.videos <> invalid and res.videos.hls <> invalid
        for each h in res.videos.hls
            if h <> invalid and h <> ""
                streamItem = {}
                streamItem.url = h
                streamItem.format = "hls"
                m.currentStreams.Push(streamItem)
            end if
        end for
    end if

    if m.currentStreams.count() > 0
        m.currentStreamIndex = 0
        tryPlayCurrentStream()
    else
        showTemporaryStatus("No se encontraron streams HLS.")
    end if
end sub


' --- ANIMES (misma API estructura que doramas) ---
sub loadAnimes(page as Integer)
    m.viewMode = "animes"
    m.currentPage = page
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    setSectionHeader("ANIMES", "animes")
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    m.apiTask = CreateObject("roSGNode", "ApiTask")
    m.apiTask.requestUrl = m.config.animesApiUrl + page.toStr()
    m.apiTask.observeField("response", "onAnimesRetrieved")
    m.apiTask.control = "RUN"
end sub

sub onAnimesRetrieved()
    res = m.apiTask.response
    if res = invalid then return
    if res.total_pages <> invalid then
        m.totalAnimesPages = res.total_pages
    else if res.totalPages <> invalid then
        m.totalAnimesPages = res.totalPages
    end if

    list = []
    if res.animes <> invalid
        for each a in res.animes
            list.Push(a)
        end for
    end if

    content = CreateObject("roSGNode", "ContentNode")
    m.animesRawData = list
    for each a_item in list
        if a_item.tmdb_poster <> invalid and a_item.tmdb_poster <> ""
            a_item.image = a_item.tmdb_poster
        else if a_item.image <> invalid
            img = a_item.image
            if Instr(1, LCase(img), "/original/") > 0
                a_item.image = img.Replace("/original/", "/w500/")
            end if
        end if
        item = content.CreateChild("ContentNode")
        item.title = a_item.title
        item.hdPosterUrl = getPosterUrl(a_item)
        if a_item.url <> invalid then item.description = a_item.url
        applyWatchedFlag(item, makeContentId("anime", a_item))
    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.lastMovieCounterText = "(" + content.getChildCount().toStr() + " animes)"
    m.movieCounterLabel.text = m.lastMovieCounterText
    m.pageIndicator.text = "Página " + m.currentPage.toStr() + " de " + m.totalAnimesPages.toStr()
end sub

sub showAnimeDetails(data as object, isNewSelection = true as Boolean)
    if data = invalid then return
    detailUrl = ""
    if data.url <> invalid and data.url <> "" then detailUrl = data.url
    if detailUrl = "" and data.slug <> invalid
        detailUrl = "https://pelisplushd.tvymas.workers.dev/anime/" + data.slug
    end if
    if detailUrl = "" then return

    if isNewSelection
        m.animeEnteredFromSearch = (m.viewMode = "search")
    end if

    m.pendingAnimeData = data
    if m.movieCounterLabel <> invalid
        m.movieCounterLabel.visible = true
        m.movieCounterLabel.text = m.lastMovieCounterText
    end if
    showCenteredLoading("Cargando detalles...")
    m.extractTask = CreateObject("roSGNode", "ApiTask")
    m.extractTask.requestUrl = detailUrl
    m.extractTask.observeField("response", "onAnimeDetailRetrieved")
    m.extractTask.control = "RUN"
end sub

sub onAnimeDetailRetrieved()
    res = m.extractTask.response
    if res = invalid
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Error al cargar el anime"
        showTemporaryStatus("No se pudo cargar este anime.")
        return
    end if
    if res.temporadas = invalid
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "No hay temporadas"
        showTemporaryStatus("Este anime no tiene temporadas.")
        return
    end if

    seasons = []
    for each t in res.temporadas
        season = {}
        if t.name <> invalid then season.title = t.name else season.title = "Temporada"
        if t.season_number <> invalid and (t.name = invalid or t.name = "")
            season.title = "Temporada " + t.season_number.toStr()
        end if
        if t.air_date <> invalid then season.releaseDate = t.air_date
        season.episodesCount = t.episode_count
        eps = []
        if t.episodios <> invalid
            for each e in t.episodios
                ep = {}
                if e.episode_number <> invalid
                    ep.numerando = "E" + e.episode_number.toStr()
                else
                    ep.numerando = "E"
                end if
                if e.name <> invalid then ep.title = e.name else ep.title = "Episodio"
                if e.still <> invalid then ep.image = e.still
                if e.url <> invalid then ep.extractUrl = e.url
                eps.Push(ep)
            end for
        end if
        season.episodes = eps
        seasons.Push(season)
    end for

    m.currentSeasons = seasons

    data = m.pendingAnimeData
    if data = invalid then data = {}

    if res.title <> invalid and res.title <> "" then data.title = res.title

    desc = ""
    if res.description <> invalid and res.description <> ""
        desc = res.description
    else if res.overview_tmdb <> invalid and res.overview_tmdb <> ""
        desc = res.overview_tmdb
    else if res.tmdb_overview <> invalid and res.tmdb_overview <> ""
        desc = res.tmdb_overview
    end if
    if Len(desc) > 600 then desc = Left(desc, 600) + "..."
    data.description = desc

    data.rating = ""
    if res.rating <> invalid
        rt = type(res.rating)
        if rt = "Integer" or rt = "roInteger" or rt = "Float" or rt = "roFloat" or rt = "Double" or rt = "roDouble"
            data.rating = res.rating.ToStr()
        else
            data.rating = res.rating
        end if
    else if res.tmdb_rating <> invalid
        rt = type(res.tmdb_rating)
        if rt = "Integer" or rt = "roInteger" or rt = "Float" or rt = "roFloat" or rt = "Double" or rt = "roDouble"
            data.rating = res.tmdb_rating.ToStr()
        else
            data.rating = res.tmdb_rating
        end if
    end if

    data.year = ""
    if res.year <> invalid and res.year <> ""
        data.year = res.year
    else if res.release_date <> invalid and res.release_date <> ""
        data.year = Left(res.release_date.ToStr(), 4)
    else if res.tmdb_release_date <> invalid and res.tmdb_release_date <> ""
        data.year = Left(res.tmdb_release_date.ToStr(), 4)
    end if

    data.genres = []
    rawGenres = invalid
    if res.genres <> invalid then rawGenres = res.genres
    if rawGenres = invalid and res.genres_tmdb <> invalid then rawGenres = res.genres_tmdb
    if rawGenres = invalid and res.tmdb_genres <> invalid then rawGenres = res.tmdb_genres
    if rawGenres <> invalid
        for each g in rawGenres
            if g <> invalid then data.genres.Push(g.ToStr())
        end for
    end if

    if res.poster_tmdb <> invalid and res.poster_tmdb <> ""
        data.tmdb_poster = res.poster_tmdb
        data.image = res.poster_tmdb
    else if res.image <> invalid and res.image <> ""
        data.image = res.image
    end if

    data.sources = []

    m.pendingAnimeData = data
    m.animeDetailsActive = true
    m.doramaDetailsActive = false
    m.seriesDetailsActive = false

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false

    openDetailsWithData(data)
end sub

sub showAnimeSeasons()
    if m.currentSeasons = invalid or m.currentSeasons.count() = 0 then return

    m.animeDetailsActive = false
    m.detailsScreen.visible = false
    m.videoStatusBox.visible = false
    m.viewMode = "anime_seasons"

    m.movieGrid.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true

    titleTxt = "TEMPORADAS"
    if m.pendingAnimeData <> invalid and m.pendingAnimeData.title <> invalid
        titleTxt = m.pendingAnimeData.title
    end if
    setSectionHeader(titleTxt, "film")

    content = CreateObject("roSGNode", "ContentNode")
    sidx = 0
    for each season in m.currentSeasons
        item = content.CreateChild("ContentNode")
        if season.title <> invalid and season.title <> ""
            item.title = season.title
        else
            item.title = "Temporada"
        end if
        if season.releaseDate <> invalid and season.releaseDate <> ""
            item.title = item.title + "  (" + season.releaseDate + ")"
        end if
        if m.pendingAnimeData <> invalid
            item.hdPosterUrl = getPosterUrl(m.pendingAnimeData)
        end if
        parentId = makeContentId("anime", m.pendingAnimeData)
        seasonId = parentId + ":season:" + sidx.toStr()
        if isWatched(seasonId) or isSeasonFullyWatched(m.currentSeasons, sidx)
            applyWatchedFlag(item, seasonId)
        end if
        sidx = sidx + 1
    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.movieCounterLabel.text = m.currentSeasons.count().toStr() + " temporadas"
end sub

sub showAnimeSeasonEpisodes(seasonIdx as Integer)
    if m.currentSeasons = invalid or seasonIdx >= m.currentSeasons.count() then return
    season = m.currentSeasons[seasonIdx]
    m.currentSeasonIndex = seasonIdx
    m.currentEpisodes = season.episodes
    m.viewMode = "anime_episodes"
    setSectionHeader(season.title, "film")

    content = CreateObject("roSGNode", "ContentNode")
    if season.episodes <> invalid
        for each ep in season.episodes
            item = content.CreateChild("ContentNode")
            t = ""
            if ep.numerando <> invalid then t = ep.numerando + "  "
            if ep.title <> invalid then t = t + ep.title
            item.title = t
            item.hdPosterUrl = getPosterUrl(ep)
            if ep.extractUrl <> invalid then item.description = ep.extractUrl
            applyWatchedFlag(item, makeContentId("ep", ep))
        end for
    end if

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.movieCounterLabel.text = content.getChildCount().toStr() + " episodios"
end sub

sub playAnimeEpisode(epIdx as Integer)
    if m.currentEpisodes = invalid or epIdx >= m.currentEpisodes.count() then return
    ep = m.currentEpisodes[epIdx]
    if ep.extractUrl = invalid or ep.extractUrl = "" then return
    m.pendingEpisodeData = ep
    m.currentPlayId = makeContentId("ep", ep)
    m.currentPlayParentId = makeContentId("anime", m.pendingAnimeData)
    m.extractTask = CreateObject("roSGNode", "ApiTask")
    m.extractTask.requestUrl = ep.extractUrl
    m.extractTask.observeField("response", "onDoramaEpisodeRetrieved")
    m.extractTask.control = "RUN"
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = "Cargando episodio..."
end sub

' --- CANALES / PAÍSES ---
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
    m.m3uTask.url = m.config.cableM3u
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
        item.description = m.config.countriesIptvBase + c.code + ".m3u"
    end for
    m.countryList.content = content
    m.countryList.setFocus(true)
end sub

' --- BUSCADOR (películas o series según sección) ---
sub showSearch(mode = "movies" as String, keepQuery = false as Boolean)
    ' Solo actualizamos "a dónde volver" cuando es una entrada NUEVA al
    ' buscador (no cuando keepQuery=true, que es volver desde una serie ya
    ' vista - ahí el origen real es de más atrás, no lo pisamos).
    if not keepQuery
        m.searchReturnMode = m.viewMode
    end if

    m.viewMode = "search"
    m.searchMode = mode
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = true

    if not keepQuery
        m.searchKeyboard.clearTrigger = true
        m.searchResultsRawData = []
        m.searchResultsGrid.content = CreateObject("roSGNode", "ContentNode")
    end if

    if mode = "series"
        setSectionHeader("BUSCAR SERIES", "search")
        if m.allSeries.count() = 0
            m.movieCounterLabel.text = "Cargando catálogo de series..."
            m.searchSeriesCatalogPage = 1
            fetchSeriesCatalogPage(m.searchSeriesCatalogPage)
        else if keepQuery
            filterSearchResults()
        else
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allSeries.count().toStr() + " series)"
        end if
    else if mode = "doramas"
        setSectionHeader("BUSCAR DORAMAS", "search")
        if m.allDoramas.count() = 0
            m.movieCounterLabel.text = "Cargando catálogo de doramas..."
            m.searchDoramasCatalogPage = 1
            fetchDoramasCatalogPage(m.searchDoramasCatalogPage)
        else if keepQuery
            filterSearchResults()
        else
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allDoramas.count().toStr() + " doramas)"
        end if
    else if mode = "animes"
        setSectionHeader("BUSCAR ANIMES", "search")
        if m.allAnimes.count() = 0
            m.movieCounterLabel.text = "Cargando catálogo de animes..."
            m.searchAnimesCatalogPage = 1
            fetchAnimesCatalogPage(m.searchAnimesCatalogPage)
        else if keepQuery
            filterSearchResults()
        else
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allAnimes.count().toStr() + " animes)"
        end if
    else
        setSectionHeader("BUSCAR PELÍCULAS", "search")
        if m.allMovies.count() = 0
            m.movieCounterLabel.text = "Cargando catálogo..."
            m.searchCatalogPage = 1
            fetchCatalogPage(m.searchCatalogPage)
        else if keepQuery
            filterSearchResults()
        else
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
        end if
    end if

    m.searchKeyboard.findNode("keyGrid").setFocus(true)
end sub

sub fetchCatalogPage(page as Integer)
    m.catalogTask = CreateObject("roSGNode", "ApiTask")
    m.catalogTask.requestUrl = m.config.moviesApiUrl + page.toStr()
    m.catalogTask.observeField("response", "onCatalogPageRetrieved")
    m.catalogTask.control = "RUN"
end sub

sub onCatalogPageRetrieved()
    res = m.catalogTask.response
    if res <> invalid
        if res.totalPages <> invalid then m.searchTotalPages = res.totalPages
        list = flattenMovieList(res)
        for each mv in list
            m.allMovies.Push(mv)
        end for
        if m.viewMode = "search" and m.searchMode = "movies"
            m.movieCounterLabel.text = "Cargando catálogo... (" + m.searchCatalogPage.toStr() + "/" + m.searchTotalPages.toStr() + ")"
        end if
    end if
    if m.searchCatalogPage < m.searchTotalPages
        m.searchCatalogPage++
        fetchCatalogPage(m.searchCatalogPage)
    else
        if m.viewMode = "search" and m.searchMode = "movies"
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
            filterSearchResults()
        end if
    end if
end sub

sub fetchSeriesCatalogPage(page as Integer)
    m.catalogTask = CreateObject("roSGNode", "ApiTask")
    m.catalogTask.requestUrl = m.config.seriesApiUrl + page.toStr()
    m.catalogTask.observeField("response", "onSeriesCatalogPageRetrieved")
    m.catalogTask.control = "RUN"
end sub

sub onSeriesCatalogPageRetrieved()
    res = m.catalogTask.response
    if res <> invalid
        if res.totalPages <> invalid then m.searchSeriesTotalPages = res.totalPages
        list = []
        if res.featured <> invalid
            for each s in res.featured
                list.Push(s)
            end for
        end if
        if res.tvshows <> invalid
            for each s in res.tvshows
                list.Push(s)
            end for
        end if
        if res.items <> invalid
            for each s in res.items
                list.Push(s)
            end for
        end if
        for each s in list
            m.allSeries.Push(s)
        end for
        if m.viewMode = "search" and m.searchMode = "series"
            m.movieCounterLabel.text = "Cargando series... (" + m.searchSeriesCatalogPage.toStr() + "/" + m.searchSeriesTotalPages.toStr() + ")"
        end if
    end if
    if m.searchSeriesCatalogPage < m.searchSeriesTotalPages
        m.searchSeriesCatalogPage++
        fetchSeriesCatalogPage(m.searchSeriesCatalogPage)
    else
        if m.viewMode = "search" and m.searchMode = "series"
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allSeries.count().toStr() + " series)"
            filterSearchResults()
        end if
    end if
end sub


sub fetchDoramasCatalogPage(page as Integer)
    m.catalogTask = CreateObject("roSGNode", "ApiTask")
    m.catalogTask.requestUrl = m.config.doramasApiUrl + page.toStr()
    m.catalogTask.observeField("response", "onDoramasCatalogPageRetrieved")
    m.catalogTask.control = "RUN"
end sub

sub onDoramasCatalogPageRetrieved()
    res = m.catalogTask.response
    if res <> invalid
        if res.total_pages <> invalid then m.searchDoramasTotalPages = res.total_pages
        if res.totalPages <> invalid then m.searchDoramasTotalPages = res.totalPages
        list = []
        if res.doramas <> invalid
            for each d in res.doramas
                list.Push(d)
            end for
        end if
        for each d in list
            m.allDoramas.Push(d)
        end for
        if m.viewMode = "search" and m.searchMode = "doramas"
            m.movieCounterLabel.text = "Cargando doramas... (" + m.searchDoramasCatalogPage.toStr() + "/" + m.searchDoramasTotalPages.toStr() + ")"
        end if
    end if
    if m.searchDoramasCatalogPage < m.searchDoramasTotalPages
        m.searchDoramasCatalogPage++
        fetchDoramasCatalogPage(m.searchDoramasCatalogPage)
    else
        if m.viewMode = "search" and m.searchMode = "doramas"
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allDoramas.count().toStr() + " doramas)"
            filterSearchResults()
        end if
    end if
end sub

sub fetchAnimesCatalogPage(page as Integer)
    m.catalogTask = CreateObject("roSGNode", "ApiTask")
    m.catalogTask.requestUrl = m.config.animesApiUrl + page.toStr()
    m.catalogTask.observeField("response", "onAnimesCatalogPageRetrieved")
    m.catalogTask.control = "RUN"
end sub

sub onAnimesCatalogPageRetrieved()
    res = m.catalogTask.response
    if res <> invalid
        if res.total_pages <> invalid then m.searchAnimesTotalPages = res.total_pages
        if res.totalPages <> invalid then m.searchAnimesTotalPages = res.totalPages
        list = []
        if res.animes <> invalid
            for each a in res.animes
                list.Push(a)
            end for
        end if
        for each a in list
            m.allAnimes.Push(a)
        end for
        if m.viewMode = "search" and m.searchMode = "animes"
            m.movieCounterLabel.text = "Cargando animes... (" + m.searchAnimesCatalogPage.toStr() + "/" + m.searchAnimesTotalPages.toStr() + ")"
        end if
    end if
    if m.searchAnimesCatalogPage < m.searchAnimesTotalPages
        m.searchAnimesCatalogPage++
        fetchAnimesCatalogPage(m.searchAnimesCatalogPage)
    else
        if m.viewMode = "search" and m.searchMode = "animes"
            m.movieCounterLabel.text = "Escribe para buscar (" + m.allAnimes.count().toStr() + " animes)"
            filterSearchResults()
        end if
    end if
end sub

sub onSearchTextChanged()
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

    sourceList = m.allMovies
    emptyMsg = "Cargando catálogo..."
    typeLabel = "títulos"
    if m.searchMode = "series"
        sourceList = m.allSeries
        emptyMsg = "Cargando catálogo de series..."
        typeLabel = "series"
    else if m.searchMode = "doramas"
        sourceList = m.allDoramas
        emptyMsg = "Cargando catálogo de doramas..."
        typeLabel = "doramas"
    else if m.searchMode = "animes"
        sourceList = m.allAnimes
        emptyMsg = "Cargando catálogo de animes..."
        typeLabel = "animes"
    end if

    if sourceList = invalid or sourceList.count() = 0
        m.searchResultsGrid.content = content
        if m.movieCounterLabel <> invalid then m.movieCounterLabel.text = emptyMsg
        m.searchFilterBusy = false
        return
    end if

    if query = ""
        m.searchResultsGrid.content = content
        if m.movieCounterLabel <> invalid
            m.movieCounterLabel.text = "Escribe para buscar (" + sourceList.count().toStr() + " " + typeLabel + ")"
        end if
        m.searchFilterBusy = false
        return
    end if

    maxResults = 20
    total = sourceList.count()
    i = 0
    while i < total and count < maxResults
        mv = sourceList[i]
        i = i + 1
        if mv <> invalid and mv.title <> invalid and mv.title <> ""
            if Instr(1, LCase(mv.title), query) > 0
                item = content.CreateChild("ContentNode")
                item.title = mv.title
                item.hdPosterUrl = getPosterUrl(mv)
                m.searchResultsRawData.Push(mv)
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
    if m.searchResultsRawData = invalid or idx >= m.searchResultsRawData.count() then return
    data = m.searchResultsRawData[idx]
    if m.searchMode = "series"
        showSeriesDetails(data)
    else if m.searchMode = "doramas"
        showDoramaDetails(data)
    else if m.searchMode = "animes"
        showAnimeDetails(data)
    else
        showMovieDetails(data)
    end if
end sub

' --- DETALLE PELÍCULA ---
sub showMovieDetails(data as object)
    if data = invalid then return
    if (data.sources = invalid or data.sources.count() = 0) and data.extractUrl <> invalid and data.extractUrl <> ""
        m.pendingMovieData = data
        m.extractTask = CreateObject("roSGNode", "ApiTask")
        m.extractTask.requestUrl = data.extractUrl
        m.extractTask.observeField("response", "onExtractRetrieved")
        m.extractTask.control = "RUN"
        showCenteredLoading("Cargando detalles...")
        return
    end if
    openDetailsWithData(data)
end sub

sub onExtractRetrieved()
    res = m.extractTask.response
    data = m.pendingMovieData
    if data = invalid then data = {}
    if res <> invalid and res.status = "success"
        if res.title <> invalid and res.title <> "" then data.title = res.title
        if res.description <> invalid and res.description <> "" then data.description = res.description
        ' rating puede ser Float: NUNCA comparar con ""
        if res.rating <> invalid
            rt = type(res.rating)
            if rt = "Integer" or rt = "roInteger" or rt = "Float" or rt = "roFloat" or rt = "Double" or rt = "roDouble"
                data.rating = res.rating.ToStr()
            else if (rt = "String" or rt = "roString") and res.rating <> ""
                data.rating = res.rating
            end if
        end if
        if res.genres <> invalid and GetInterface(res.genres, "ifArray") <> invalid and res.genres.count() > 0
            data.genres = res.genres
        end if
        if res.year <> invalid
            yt = type(res.year)
            if yt = "Integer" or yt = "roInteger" or yt = "Float" or yt = "roFloat"
                data.year = res.year.ToStr()
            else if (yt = "String" or yt = "roString") and res.year <> ""
                data.year = res.year
            end if
        end if
        if res.quality <> invalid
            qt = type(res.quality)
            if qt = "String" or qt = "roString"
                if res.quality <> "" then data.quality = res.quality
            else
                data.quality = res.quality.ToStr()
            end if
        end if
        if res.poster <> invalid and res.poster <> "" then data.image = res.poster

        data.sources = []
        seenUrl = CreateObject("roAssociativeArray")

        if res.streams <> invalid
            for each s in res.streams
                ' API ikki: url + type
                if s.url <> invalid and s.url <> ""
                    addStreamSource(data.sources, seenUrl, FixZonaApiUrl(s.url), s.type)
                end if

                ' API apiprorescue: proxy → sacar el link real
                if s.proxyUrlMP4 <> invalid and s.proxyUrlMP4 <> ""
                    mp4 = unwrapProxyVideoUrl(FixZonaApiUrl(s.proxyUrlMP4))
                    addStreamSource(data.sources, seenUrl, mp4, "mp4")
                end if
                if s.proxyUrlHLS <> invalid and s.proxyUrlHLS <> ""
                    hls = unwrapProxyVideoUrl(FixZonaApiUrl(s.proxyUrlHLS))
                    addStreamSource(data.sources, seenUrl, hls, "hls")
                end if
                if s.proxyUrl <> invalid and s.proxyUrl <> ""
                    p = unwrapProxyVideoUrl(FixZonaApiUrl(s.proxyUrl))
                    addStreamSource(data.sources, seenUrl, p, invalid)
                end if
            end for
        end if

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

    ' TITULO
    if data.title <> invalid and data.title <> ""
        detailsContent.title = data.title
    else
        detailsContent.title = "Sin título"
    end if

    ' POSTER
    detailsContent.hdPosterUrl = getPosterUrl(data)


    ' SINOPSIS
    if data.description <> invalid and data.description <> ""
        detailsContent.description = data.description
    else
        detailsContent.description = "No disponible"
    end if


    ' RATING (puede venir como Float desde TMDB / doramas)
    if data.rating <> invalid
        r = data.rating
        rType = type(r)
        if rType = "Integer" or rType = "roInteger" or rType = "Float" or rType = "roFloat" or rType = "Double" or rType = "roDouble"
            detailsContent.rating = r.ToStr()
        else if rType = "String" or rType = "roString"
            if r <> "" then detailsContent.rating = r else detailsContent.rating = "Null"
        else
            detailsContent.rating = "Null"
        end if
    else
        detailsContent.rating = "Null"
    end if

    ' AÑO
    if data.year <> invalid
        y = data.year
        yType = type(y)
        if yType = "Integer" or yType = "roInteger" or yType = "Float" or yType = "roFloat"
            detailsContent.releaseDate = y.ToStr()
        else if yType = "String" or yType = "roString"
            if y <> "" then detailsContent.releaseDate = y else detailsContent.releaseDate = "Null"
        else
            detailsContent.releaseDate = "Null"
        end if
    else
        detailsContent.releaseDate = "Null"
    end if


    ' CALIDAD
    ' Ejemplo: 720 HD / 1080p HD
    detailsContent.qualityText = "Null"
    if data.quality <> invalid
        qt = type(data.quality)
        if qt = "String" or qt = "roString"
            if data.quality <> "" then detailsContent.qualityText = data.quality.Trim()
        else
            detailsContent.qualityText = data.quality.ToStr()
        end if
    end if




    ' GENEROS
    if data.genres <> invalid and GetInterface(data.genres, "ifArray") <> invalid and data.genres.count() > 0
        detailsContent.categories = data.genres
    else
        emptyGenres = CreateObject("roArray", 0, true)
        emptyGenres.Push("No disponible")
        detailsContent.categories = emptyGenres
    end if


    ' STREAMS
    m.currentStreams = []

    if data.sources <> invalid

        for each src in data.sources

            streamItem = {}

            streamItem.url = src.url

            if src.type <> invalid
                streamItem.format = src.type
            else
                streamItem.format = "hls"
            end if

            m.currentStreams.Push(streamItem)

        end for

    end if


    m.detailsScreen.content = detailsContent

    playLabel = m.detailsScreen.findNode("playLabel")
    if playLabel <> invalid
        if m.seriesDetailsActive = true or m.doramaDetailsActive = true or m.animeDetailsActive = true
            playLabel.text = "TEMPORADAS"
        else
            playLabel.text = "REPRODUCIR"
        end if
    end if

    ' Favoritos: actualizar botón sin usar campos raros de ContentNode
    kind = "movie"
    pdata = data
    if m.seriesDetailsActive = true
        kind = "series"
        pdata = m.pendingSeriesData
    else if m.doramaDetailsActive = true
        kind = "dorama"
        pdata = m.pendingDoramaData
    else if m.animeDetailsActive = true
        kind = "anime"
        pdata = m.pendingAnimeData
    end if
    cid = makeContentId(kind, pdata)
    updateFavButtonLabel(cid)

    hideCenteredLoading()
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

' --- MENÚ / SELECCIÓN ---
sub onMenuItemSelected()
    idx = m.menuList.itemSelected
    if idx = 0
        showPortal()
    else if idx = 1 and (m.viewMode = "movies" or m.viewMode = "series" or m.viewMode = "doramas" or m.viewMode = "animes")
        if m.viewMode = "movies"
            if m.currentPage < m.totalMoviePages then m.currentPage++ : loadMovies(m.currentPage)
        else if m.viewMode = "series"
            if m.currentPage < m.totalSeriesPages then m.currentPage++ : loadSeries(m.currentPage)
        else if m.viewMode = "doramas"
            if m.currentPage < m.totalDoramasPages then m.currentPage++ : loadDoramas(m.currentPage)
        else if m.viewMode = "animes"
            if m.currentPage < m.totalAnimesPages then m.currentPage++ : loadAnimes(m.currentPage)
        end if
    else if idx = 2 and (m.viewMode = "movies" or m.viewMode = "series" or m.viewMode = "doramas" or m.viewMode = "animes")
        if m.viewMode = "movies"
            if m.currentPage > 1 then m.currentPage-- : loadMovies(m.currentPage)
        else if m.viewMode = "series"
            if m.currentPage > 1 then m.currentPage-- : loadSeries(m.currentPage)
        else if m.viewMode = "doramas"
            if m.currentPage > 1 then m.currentPage-- : loadDoramas(m.currentPage)
        else if m.viewMode = "animes"
            if m.currentPage > 1 then m.currentPage-- : loadAnimes(m.currentPage)
        end if
    else if idx = 3
        if m.viewMode = "series" or m.viewMode = "seasons" or m.viewMode = "episodes"
            showSearch("series")
        else if m.viewMode = "doramas" or m.viewMode = "dorama_seasons" or m.viewMode = "dorama_episodes"
            showSearch("doramas")
        else if m.viewMode = "animes" or m.viewMode = "anime_seasons" or m.viewMode = "anime_episodes"
            showSearch("animes")
        else
            showSearch("movies")
        end if
    else if idx = 4
        showFavorites()
    end if
    toggleMenu(false)
end sub

sub onItemSelected()
    idx = m.movieGrid.itemSelected
    item = m.movieGrid.content.getChild(idx)
    if m.viewMode = "favorites"
        if m.favoritesRawData <> invalid and idx < m.favoritesRawData.count()
            fav = m.favoritesRawData[idx]
            if fav.kind = "series"
                showSeriesDetails(fav)
            else if fav.kind = "dorama"
                showDoramaDetails(fav)
            else if fav.kind = "anime"
                showAnimeDetails(fav)
            else
                showMovieDetails(fav)
            end if
        end if
    else if m.viewMode = "movies"
        if m.moviesRawData <> invalid and idx < m.moviesRawData.count()
            showMovieDetails(m.moviesRawData[idx])
        end if
    else if m.viewMode = "series"
        if m.seriesRawData <> invalid and idx < m.seriesRawData.count()
            showSeriesDetails(m.seriesRawData[idx])
        end if
    else if m.viewMode = "doramas"
        if m.doramasRawData <> invalid and idx < m.doramasRawData.count()
            showDoramaDetails(m.doramasRawData[idx])
        end if
    else if m.viewMode = "animes"
        if m.animesRawData <> invalid and idx < m.animesRawData.count()
            showAnimeDetails(m.animesRawData[idx])
        end if
    else if m.viewMode = "seasons"
        showSeasonEpisodes(idx)
    else if m.viewMode = "episodes"
        playEpisode(idx)
    else if m.viewMode = "dorama_seasons"
        showDoramaSeasonEpisodes(idx)
    else if m.viewMode = "dorama_episodes"
        playDoramaEpisode(idx)
    else if m.viewMode = "anime_seasons"
        showAnimeSeasonEpisodes(idx)
    else if m.viewMode = "anime_episodes"
        playAnimeEpisode(idx)
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

sub showSeriesSeasons()
    if m.currentSeasons = invalid or m.currentSeasons.count() = 0 then return

    m.seriesDetailsActive = false
    m.detailsScreen.visible = false
    m.videoStatusBox.visible = false
    m.viewMode = "seasons"

    m.movieGrid.visible = true
    if m.pageBar <> invalid then m.pageBar.visible = true
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true

    seriesTitle = ""
    if m.pendingSeriesData <> invalid and m.pendingSeriesData.title <> invalid
        seriesTitle = m.pendingSeriesData.title
    end if

    if seriesTitle <> ""
        setSectionHeader(seriesTitle, "film")
    else
        setSectionHeader("TEMPORADAS", "film")
    end if

    content = CreateObject("roSGNode", "ContentNode")

    sidx = 0
    for each season in m.currentSeasons
        item = content.CreateChild("ContentNode")
        if season.title <> invalid and season.title <> ""
            item.title = season.title
        else
            item.title = "Temporada"
        end if
        if season.releaseDate <> invalid and season.releaseDate <> ""
            item.title = item.title + "  (" + season.releaseDate + ")"
        end if
        if m.pendingSeriesData <> invalid
            item.hdPosterUrl = getPosterUrl(m.pendingSeriesData)
        end if
        parentId = makeContentId("series", m.pendingSeriesData)
        seasonId = parentId + ":season:" + sidx.toStr()
        if isWatched(seasonId) or isSeasonFullyWatched(m.currentSeasons, sidx)
            applyWatchedFlag(item, seasonId)
        end if
        sidx = sidx + 1
    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)

    totalEpisodes = 0
    for each season in m.currentSeasons
        if season.episodesCount <> invalid
            totalEpisodes = totalEpisodes + season.episodesCount
        else if season.episodes <> invalid
            totalEpisodes = totalEpisodes + season.episodes.count()
        end if
    end for

    if m.movieCounterLabel <> invalid
        if totalEpisodes > 0
            m.movieCounterLabel.text = m.currentSeasons.count().toStr() + " temporadas · " + totalEpisodes.toStr() + " episodios"
        else
            m.movieCounterLabel.text = m.currentSeasons.count().toStr() + " temporadas"
        end if
    end if
end sub

sub showSeriesDescription()
    if m.pendingSeriesData = invalid then return

    m.seriesDetailsActive = true
    m.seriesDetailsReturnMode = "series"

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    if m.pageBar <> invalid then m.pageBar.visible = false
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = false
    m.videoStatusBox.visible = false

    openDetailsWithData(m.pendingSeriesData)
end sub

sub onPlayPressed()

    ' ============================================================
    ' SERIE
    ' El botón de la ficha lleva a temporadas.
    ' ============================================================
    if m.seriesDetailsActive = true
        if m.currentSeasons = invalid or m.currentSeasons.count() = 0
            m.videoStatusLabel.text = "Esta serie no tiene temporadas disponibles."
            m.videoStatusBox.visible = true
            return
        end if

        showSeriesSeasons()
        return
    end if

    if m.doramaDetailsActive = true
        if m.currentSeasons = invalid or m.currentSeasons.count() = 0
            m.videoStatusLabel.text = "Este dorama no tiene temporadas disponibles."
            m.videoStatusBox.visible = true
            return
        end if

        showDoramaSeasons()
        return
    end if

    if m.animeDetailsActive = true
        if m.currentSeasons = invalid or m.currentSeasons.count() = 0
            m.videoStatusLabel.text = "Este anime no tiene temporadas disponibles."
            m.videoStatusBox.visible = true
            return
        end if

        showAnimeSeasons()
        return
    end if

    ' ============================================================
    ' PELÍCULA
    ' Flujo original sin cambios.
    ' ============================================================
    if m.currentStreams <> invalid and m.currentStreams.count() > 0
        m.currentStreamIndex = 0
        m.currentPlayId = makeContentId("movie", m.pendingMovieData)
        m.currentPlayParentId = ""
        tryPlayCurrentStream()
    else
        m.videoStatusLabel.text = "No se pudo reproducir." + chr(10) + "Esta película no tiene servidores disponibles."
        m.videoStatusBox.visible = true
        m.videoPlayer.visible = false
    end if
end sub

sub tryPlayCurrentStream()
    if m.currentStreams = invalid or m.currentStreamIndex >= m.currentStreams.count()
        m.videoStatusLabel.text = "No se pudo reproducir este video." + chr(10) + "Pulsa ATRÁS para volver."
        m.videoStatusBox.visible = true
        m.videoPlayer.visible = false
        return
    end if
    m.formatRetryDone = false
    total = m.currentStreams.count()
    m.videoStatusBox.visible = true
    if total > 1
        m.videoStatusLabel.text = "Cargando servidor " + (m.currentStreamIndex + 1).toStr() + " de " + total.toStr() + "..."
    else
        m.videoStatusLabel.text = "Cargando video..."
    end if
    stream = m.currentStreams[m.currentStreamIndex]
    playVideo(stream.url, stream.format)
end sub

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
        showTemporaryStatus("Este video no es compatible con Roku." + chr(10) + "Pulsa ATRÁS para volver.")
        if m.detailsScreen.visible then m.detailsScreen.setFocus(true)
    else if state = "buffering"
        m.videoStatusBox.visible = true
        if m.videoStatusLabel.text = "" or m.videoStatusLabel.text = invalid
            m.videoStatusLabel.text = "Cargando video..."
        end if
    else if state = "playing"
        m.videoStatusBox.visible = false
    else if state = "finished"
        ' Marcar visto al TERMINAR el video
        onPlaybackFinished()
    end if
end sub


sub showCenteredLoading(msg as String)
    if m.videoStatusLabel <> invalid
        m.videoStatusLabel.text = msg
    end if
    if m.videoStatusBox <> invalid
        m.videoStatusBox.visible = true
    end if
end sub

sub hideCenteredLoading()
    if m.videoStatusBox <> invalid
        m.videoStatusBox.visible = false
    end if
end sub

sub showTemporaryStatus(msg as String)
    if m.videoStatusLabel <> invalid then m.videoStatusLabel.text = msg
    if m.videoStatusBox <> invalid then m.videoStatusBox.visible = true

    ' Timer nuevo cada vez para que el mensaje SÍ se quite solo
    if m.statusTimer <> invalid
        m.statusTimer.control = "stop"
        m.statusTimer.unobserveField("fire")
    end if
    m.statusTimer = CreateObject("roSGNode", "Timer")
    m.statusTimer.repeat = false
    m.statusTimer.duration = 2.5
    m.statusTimer.observeField("fire", "onStatusTimerFire")
    m.statusTimer.control = "start"
end sub

sub onStatusTimerFire()
    if m.videoStatusBox <> invalid then m.videoStatusBox.visible = false
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
        if m.viewMode = "movies" or m.viewMode = "channels" or m.viewMode = "series" or m.viewMode = "seasons" or m.viewMode = "episodes" or m.viewMode = "doramas" or m.viewMode = "dorama_seasons" or m.viewMode = "dorama_episodes" or m.viewMode = "animes" or m.viewMode = "anime_seasons" or m.viewMode = "anime_episodes" or m.viewMode = "favorites" then m.movieGrid.setFocus(true)
        if m.viewMode = "countries" then m.countryList.setFocus(true)
        if m.viewMode = "portal" then m.portalGrid.setFocus(true)
        if m.viewMode = "search" then m.searchKeyboard.findNode("keyGrid").setFocus(true)
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
            if m.viewMode = "movies" or m.viewMode = "search" then
                if m.detailsScreen.visible then m.detailsScreen.setFocus(true) else m.movieGrid.setFocus(true)
            else
                m.movieGrid.setFocus(true)
            end if
            return true
        end if
        if m.detailsScreen.visible

            ' ====================================================
            ' FICHA DE DORAMA
            ' ====================================================
            if m.doramaDetailsActive = true
                m.doramaDetailsActive = false
                m.detailsScreen.visible = false
                m.videoStatusBox.visible = false

                if m.doramaEnteredFromSearch = true
                    m.viewMode = "search"
                    if m.movieCounterLabel <> invalid and m.allDoramas <> invalid
                        m.movieCounterLabel.text = "Escribe para buscar (" + m.allDoramas.count().toStr() + " doramas)"
                        m.movieCounterLabel.visible = true
                    end if
                    m.searchResultsGrid.setFocus(true)
                else
                    m.viewMode = "doramas"
                    m.movieGrid.visible = true
                    m.countryGroup.visible = false
                    m.searchGroup.visible = false
                    if m.pageBar <> invalid then m.pageBar.visible = true
                    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
                    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
                    loadDoramas(m.currentPage)
                end if
                return true
            end if

            if m.animeDetailsActive = true
                m.animeDetailsActive = false
                m.detailsScreen.visible = false
                m.videoStatusBox.visible = false

                if m.animeEnteredFromSearch = true
                    m.viewMode = "search"
                    if m.movieCounterLabel <> invalid and m.allAnimes <> invalid
                        m.movieCounterLabel.text = "Escribe para buscar (" + m.allAnimes.count().toStr() + " animes)"
                        m.movieCounterLabel.visible = true
                    end if
                    m.searchResultsGrid.setFocus(true)
                else
                    m.viewMode = "animes"
                    m.movieGrid.visible = true
                    m.countryGroup.visible = false
                    m.searchGroup.visible = false
                    if m.pageBar <> invalid then m.pageBar.visible = true
                    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
                    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
                    loadAnimes(m.currentPage)
                end if
                return true
            end if

            ' ====================================================
            ' FICHA DE SERIE
            ' Volver desde la ficha NO altera el flujo actual.
            ' ====================================================
            if m.seriesDetailsActive = true
                m.seriesDetailsActive = false
                m.detailsScreen.visible = false
                m.videoStatusBox.visible = false

                ' Ficha abierta desde una serie del catálogo.
                if m.seriesEnteredFromSearch = true
                    m.viewMode = "search"
                    if m.movieCounterLabel <> invalid and m.allSeries <> invalid
                        m.movieCounterLabel.text = "Escribe para buscar (" + m.allSeries.count().toStr() + " series)"
                        m.movieCounterLabel.visible = true
                    end if
                    m.searchResultsGrid.setFocus(true)
                else
                   ' ====================================================
                   ' FICHA DE SERIE -> CATÁLOGO DE SERIES
                   ' ====================================================
                   m.viewMode = "series"
                   m.seriesDetailsActive = false

                   m.detailsScreen.visible = false
                   m.movieGrid.visible = true
                   m.countryGroup.visible = false
                   m.searchGroup.visible = false

                   if m.pageBar <> invalid then m.pageBar.visible = true
                   if m.navHintLabel <> invalid then m.navHintLabel.visible = true
                   if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true
 
                   ' IMPORTANTE:
                   ' Recargar el catálogo de series para que movieGrid
                   ' deje de contener las temporadas anteriores.
                   loadSeries(m.currentPage)

                   return true
               end if
            end if

            ' ====================================================
            ' FICHA DE PELÍCULA
            ' Código original.
            ' ====================================================
            m.detailsScreen.visible = false
            m.videoStatusBox.visible = false
            if m.viewMode = "movies" and m.lastMovieCounterText <> invalid
                m.movieCounterLabel.text = m.lastMovieCounterText
                m.movieCounterLabel.visible = true
            else if m.viewMode = "search"
                if m.searchMode = "series" and m.allSeries <> invalid
                    m.movieCounterLabel.text = "Escribe para buscar (" + m.allSeries.count().toStr() + " series)"
                else if m.searchMode = "doramas" and m.allDoramas <> invalid
                    m.movieCounterLabel.text = "Escribe para buscar (" + m.allDoramas.count().toStr() + " doramas)"
                else if m.searchMode = "animes" and m.allAnimes <> invalid
                    m.movieCounterLabel.text = "Escribe para buscar (" + m.allAnimes.count().toStr() + " animes)"
                else if m.allMovies <> invalid
                    m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"
                end if
            end if
            if m.viewMode = "search" then m.searchResultsGrid.setFocus(true) else m.movieGrid.setFocus(true)
            return true
        end if
        if m.viewMode = "episodes"
            ' Episodios -> Temporadas
            showSeriesSeasons()
            return true
        end if
        if m.viewMode = "dorama_episodes"
            showDoramaSeasons()
            return true
        end if
        if m.viewMode = "anime_episodes"
            showAnimeSeasons()
            return true
        end if
        if m.viewMode = "seasons"
            ' Temporadas -> Ficha de la serie
            showSeriesDescription()
            return true
        end if
        if m.viewMode = "dorama_seasons"
            ' Temporadas -> ficha del dorama
            if m.pendingDoramaData <> invalid
                m.doramaDetailsActive = true
                m.seriesDetailsActive = false
                m.animeDetailsActive = false
                m.movieGrid.visible = false
                if m.pageBar <> invalid then m.pageBar.visible = false
                if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
                if m.navHintLabel <> invalid then m.navHintLabel.visible = false
                openDetailsWithData(m.pendingDoramaData)
            else
                loadDoramas(m.currentPage)
            end if
            return true
        end if
        if m.viewMode = "anime_seasons"
            if m.pendingAnimeData <> invalid
                m.animeDetailsActive = true
                m.seriesDetailsActive = false
                m.doramaDetailsActive = false
                m.movieGrid.visible = false
                if m.pageBar <> invalid then m.pageBar.visible = false
                if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = false
                if m.navHintLabel <> invalid then m.navHintLabel.visible = false
                openDetailsWithData(m.pendingAnimeData)
            else
                loadAnimes(m.currentPage)
            end if
            return true
        end if
        if m.viewMode = "search"
            if m.searchReturnMode = "movies"
                loadMovies(m.currentPage)
            else if m.searchReturnMode = "series"
                loadSeries(m.currentPage)
            else if m.searchReturnMode = "doramas"
                loadDoramas(m.currentPage)
            else if m.searchReturnMode = "animes"
                loadAnimes(m.currentPage)
            else
                showPortal()
            end if
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

' --- HELPERS ---
sub addStreamSource(sources as object, seenUrl as object, url as dynamic, fmt as dynamic)
    if url = invalid or url = "" then return
    u = url
    if type(u) <> "roString" and type(u) <> "String" then return
    if Instr(1, LCase(u), "zonaaps.com/video.php") > 0 then return
    if Instr(1, LCase(u), "cdn-cgi/challenge") > 0 then return
    if seenUrl.DoesExist(u) then return
    seenUrl.AddReplace(u, true)

    src = CreateObject("roAssociativeArray")
    src.url = u

    ' Detectar formato automáticamente si no viene especificado
    if fmt <> invalid and fmt <> ""
        src.type = fmt
    else
        src.type = detectStreamFormat(u)
    end if

    sources.Push(src)
end sub


function unwrapProxyVideoUrl(url as String) as String
    if url = invalid or url = "" then return ""
    u = url
    lower = LCase(u)

    ' Solo si es proxyvideo / proxy
    if Instr(1, lower, "proxyvideo") = 0 and Instr(1, lower, "proxy?url=") = 0
        return u
    end if

    idx = Instr(1, lower, "url=")
    if idx = 0 then return u

    resto = Mid(u, idx + 4)
    ' Cortar en &referer= u otros params
    amp = Instr(1, resto, "&")
    if amp > 0 then resto = Left(resto, amp - 1)

    ' Decodificar lo básico
    resto = resto.Replace("%3A", ":")
    resto = resto.Replace("%2F", "/")
    resto = resto.Replace("%3a", ":")
    resto = resto.Replace("%2f", "/")
    resto = resto.Replace("%3F", "?")
    resto = resto.Replace("%3D", "=")
    resto = resto.Replace("%26", "&")

    if Left(resto, 4) = "http" then return resto
    return u
end function

function flattenMovieList(res as object) as object
    list = CreateObject("roArray", 0, true)
    seen = CreateObject("roAssociativeArray")
    if res = invalid then return list
    buckets = CreateObject("roArray", 0, true)
    if res.DoesExist("featured") and res.featured <> invalid then buckets.Push(res.featured)
    if res.DoesExist("movies") and res.movies <> invalid then buckets.Push(res.movies)
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
    ' Preferir posters medianos de TMDB (cargan más rápido en Roku)
    posibles = ["tmdb_poster", "poster_tmdb", "poster", "still", "image", "img", "thumbnail", "cover", "poster_url", "imageUrl", "thumb"]
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

function UrlEncode(s as string) as string
    if s = invalid or s = "" then return ""
    out = ""
    i = 1
    while i <= Len(s)
        c = Mid(s, i, 1)
        a = Asc(c)
        if (a >= 48 and a <= 57) or (a >= 65 and a <= 90) or (a >= 97 and a <= 122) or c = "-" or c = "_" or c = "." or c = "~"
            out = out + c
        else if c = " "
            out = out + "%20"
        else
            h = StrI(a, 16).Trim()
            if Left(h, 1) = "&" then h = Mid(h, 2)
            if Len(h) = 1 then h = "0" + h
            out = out + "%" + UCase(h)
        end if
        i = i + 1
    end while
    return out
end function

function proxyImageUrl(url as string) as string
    if url = invalid or url = "" then return ""

    u = url
    u = u.Replace("zonaapis.arcando.cloud//", "zonaapis.arcando.cloud/")
    u = u.Replace("arcando.cloud//", "arcando.cloud/")
    u = u.Replace("apiprorescue.testaacc.workers.dev//", "apiprorescue.testaacc.workers.dev/")

    lower = LCase(u)

    ' Ya es un proxy → no tocar
    if Instr(1, lower, "/proxy?url=") > 0 then return u
    if Instr(1, lower, "workers.dev/proxy") > 0 then return u

    ' TMDB y otros CDN públicos: Roku los carga directo (más rápido, sin proxy)
    if Instr(1, lower, "image.tmdb.org") > 0 then return u
    if Instr(1, lower, "themoviedb.org") > 0 then return u

    ' Reducir original de TMDB si viniera embebido raro
    if Instr(1, lower, "/original/") > 0 and Instr(1, lower, "tmdb") > 0
        u = u.Replace("/original/", "/w500/")
        return u
    end if

    base = "https://zonaapp.ikkihkurogane.workers.dev"
    if m.config <> invalid and m.config.imageProxyBase <> invalid and m.config.imageProxyBase <> ""
        base = m.config.imageProxyBase
    end if

    return base + "/proxy?url=" + UrlEncode(u)
end function


sub onPlaybackFinished()
    if m.currentPlayId <> invalid and m.currentPlayId <> ""
        markWatched(m.currentPlayId)
    end if

    ' Episodio terminado → revisar temporada y portada
    if m.currentPlayParentId <> invalid and m.currentPlayParentId <> ""
        if m.currentSeasons <> invalid and m.currentSeasonIndex <> invalid
            if isSeasonFullyWatched(m.currentSeasons, m.currentSeasonIndex)
                sid = m.currentPlayParentId + ":season:" + m.currentSeasonIndex.toStr()
                markWatched(sid)
            end if
            if areAllSeasonsWatched(m.currentSeasons, m.currentPlayParentId)
                markWatched(m.currentPlayParentId)
            end if
        end if
    end if
end sub

function isSeasonFullyWatched(seasons as object, seasonIdx as Integer) as Boolean
    if seasons = invalid or seasonIdx < 0 or seasonIdx >= seasons.count() then return false
    season = seasons[seasonIdx]
    if season.episodes = invalid or season.episodes.count() = 0 then return false
    for each ep in season.episodes
        if not isWatched(makeContentId("ep", ep)) then return false
    end for
    return true
end function

function areAllSeasonsWatched(seasons as object, parentId as String) as Boolean
    if seasons = invalid or seasons.count() = 0 then return false
    for i = 0 to seasons.count() - 1
        sid = parentId + ":season:" + i.toStr()
        if not isWatched(sid)
            ' también válido si todos los episodios están vistos aunque no se haya guardado el season id
            if not isSeasonFullyWatched(seasons, i) then return false
        end if
    end for
    return true
end function

' --- VISTOS Y FAVORITOS (Registry local en el Roku) ---
sub loadUserData()
    sec = CreateObject("roRegistrySection", "PlayZoneTV")
    w = sec.Read("watched")
    m.watchedMap = {}
    if w <> invalid and w <> ""
        parsed = ParseJson(w)
        if parsed <> invalid and GetInterface(parsed, "ifAssociativeArray") <> invalid
            m.watchedMap = parsed
        end if
    end if
    f = sec.Read("favorites")
    m.favoritesList = []
    if f <> invalid and f <> ""
        parsed = ParseJson(f)
        if parsed <> invalid and GetInterface(parsed, "ifArray") <> invalid
            m.favoritesList = parsed
        end if
    end if
end sub

sub saveWatched()
    sec = CreateObject("roRegistrySection", "PlayZoneTV")
    sec.Write("watched", FormatJson(m.watchedMap))
    sec.Flush()
end sub

sub saveFavorites()
    sec = CreateObject("roRegistrySection", "PlayZoneTV")
    sec.Write("favorites", FormatJson(m.favoritesList))
    sec.Flush()
end sub

function isWatched(id as String) as Boolean
    if id = invalid or id = "" then return false
    if m.watchedMap = invalid then return false
    if GetInterface(m.watchedMap, "ifAssociativeArray") = invalid then return false
    if m.watchedMap.DoesExist(id) then return true
    return false
end function

sub markWatched(id as String)
    if id = invalid or id = "" then return
    if m.watchedMap = invalid then m.watchedMap = {}
    m.watchedMap.AddReplace(id, true)
    saveWatched()
end sub

function makeContentId(kind as String, data as object) as String
    if data = invalid then return ""
    key = ""
    if data.extractUrl <> invalid and data.extractUrl <> "" then key = data.extractUrl
    if key = "" and data.url <> invalid then key = data.url
    if key = "" and data.slug <> invalid then key = data.slug
    if key = "" and data.title <> invalid then key = data.title
    if key = "" then return ""
    return kind + ":" + key
end function

function isFavorite(id as String) as Boolean
    if id = "" or m.favoritesList = invalid then return false
    for each fav in m.favoritesList
        if fav.id <> invalid and fav.id = id then return true
    end for
    return false
end function

sub toggleFavorite(data as object, kind as String)
    if data = invalid then return
    id = makeContentId(kind, data)
    if id = "" then return
    if isFavorite(id)
        newList = []
        for each fav in m.favoritesList
            if fav.id <> id then newList.Push(fav)
        end for
        m.favoritesList = newList
        saveFavorites()
        showTemporaryStatus("Quitado de favoritos")
        updateFavButtonLabel(id)
        return
    end if
    fav = {}
    fav.id = id
    fav.kind = kind
    if data.title <> invalid then fav.title = data.title else fav.title = "Sin título"
    fav.image = getPosterUrl(data)
    if data.extractUrl <> invalid then fav.extractUrl = data.extractUrl
    if data.url <> invalid then fav.url = data.url
    if data.slug <> invalid then fav.slug = data.slug
    if data.rating <> invalid then fav.rating = data.rating
    if data.year <> invalid then fav.year = data.year
    if data.description <> invalid then fav.description = data.description
    if data.genres <> invalid then fav.genres = data.genres
    m.favoritesList.Push(fav)
    saveFavorites()
    showTemporaryStatus("Agregado a favoritos ★")
    updateFavButtonLabel(id)
end sub

sub updateFavButtonLabel(id as String)
    ' Estrella vacía ☆ / llena ★ amarilla (lógica en DetailsScreen)
    isFav = isFavorite(id)
    ' Pasar estado al componente si existe el campo interno
    favLabel = m.detailsScreen.findNode("favLabel")
    favBg = m.detailsScreen.findNode("favBg")
    if favLabel = invalid then return
    if isFav
        favLabel.text = "★"
        favLabel.color = "0xFFD700FF"
        if favBg <> invalid then favBg.color = "0x5A4A10FF"
    else
        favLabel.text = "☆"
        favLabel.color = "0xCCCCCCCC"
        if favBg <> invalid then favBg.color = "0x333333FF"
    end if
end sub

sub onFavPressed()
    kind = "movie"
    data = m.pendingMovieData
    if m.seriesDetailsActive = true
        kind = "series"
        data = m.pendingSeriesData
    else if m.doramaDetailsActive = true
        kind = "dorama"
        data = m.pendingDoramaData
    else if m.animeDetailsActive = true
        kind = "anime"
        data = m.pendingAnimeData
    end if
    toggleFavorite(data, kind)
end sub

sub applyWatchedFlag(item as object, id as String)
    if item = invalid then return
    if isWatched(id)
        item.shortDescription = "watched"
    else
        item.shortDescription = ""
    end if
end sub

sub showFavorites()
    kind = "movie"
    titleTxt = "FAVORITOS · PELÍCULAS"
    if m.viewMode = "series" or m.viewMode = "seasons" or m.viewMode = "episodes"
        kind = "series"
        titleTxt = "FAVORITOS · SERIES"
    else if m.viewMode = "doramas" or m.viewMode = "dorama_seasons" or m.viewMode = "dorama_episodes"
        kind = "dorama"
        titleTxt = "FAVORITOS · DORAMAS"
    else if m.viewMode = "animes" or m.viewMode = "anime_seasons" or m.viewMode = "anime_episodes"
        kind = "anime"
        titleTxt = "FAVORITOS · ANIMES"
    else if m.viewMode = "portal" or m.viewMode = "search"
        kind = "all"
        titleTxt = "FAVORITOS"
    end if

    m.viewMode = "favorites"
    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false
    m.detailsScreen.visible = false
    setSectionHeader(titleTxt, "film")
    if m.pageBar <> invalid then m.pageBar.visible = false
    if m.navHintLabel <> invalid then m.navHintLabel.visible = true
    if m.movieCounterLabel <> invalid then m.movieCounterLabel.visible = true

    content = CreateObject("roSGNode", "ContentNode")
    m.favoritesRawData = []
    if m.favoritesList <> invalid
        for each fav in m.favoritesList
            if kind = "all" or (fav.kind <> invalid and fav.kind = kind)
                m.favoritesRawData.Push(fav)
                item = content.CreateChild("ContentNode")
                item.title = fav.title
                if fav.image <> invalid then item.hdPosterUrl = fav.image
                applyWatchedFlag(item, fav.id)
            end if
        end for
    end if

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)
    m.movieCounterLabel.text = "(" + content.getChildCount().toStr() + " favoritos)"
end sub
