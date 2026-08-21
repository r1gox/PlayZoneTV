sub init()

    ' =========================================================
    ' NODOS
    ' =========================================================

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
    m.searchGroup = m.top.findNode("searchGroup")
    m.searchKeyboard = m.top.findNode("searchKeyboard")
    m.searchResultsGrid = m.top.findNode("searchResultsGrid")

    ' =========================================================
    ' PORTAL
    ' =========================================================

    portalContent = CreateObject("roSGNode", "ContentNode")

    addItem(portalContent, "Películas")
    addItem(portalContent, "CANALES TV CABLE")
    addItem(portalContent, "TV POR PAÍSES")
    addItem(portalContent, "Instrucciones")
    addItem(portalContent, "BUSCAR PELÍCULAS")

    m.portalGrid.content = portalContent

    ' =========================================================
    ' MENU
    ' =========================================================

    menuContent = CreateObject("roSGNode", "ContentNode")

    addItem(menuContent, "INICIO")
    addItem(menuContent, "SIG. PÁGINA >")
    addItem(menuContent, "< PÁG. ANTERIOR")
    addItem(menuContent, "BUSCAR")
    addItem(menuContent, "CERRAR")

    m.menuList.content = menuContent

    ' =========================================================
    ' PAISES
    ' =========================================================

    m.countries = [
        {name: "Argentina", code: "ar"},
        {name: "Bolivia", code: "bo"},
        {name: "Brasil", code: "br"},
        {name: "Chile", code: "cl"},
        {name: "Colombia", code: "co"},
        {name: "Costa Rica", code: "cr"},
        {name: "Cuba", code: "cu"},
        {name: "Ecuador", code: "ec"},
        {name: "El Salvador", code: "sv"},
        {name: "España", code: "es"},
        {name: "Guatemala", code: "gt"},
        {name: "Honduras", code: "hn"},
        {name: "México", code: "mx"},
        {name: "Nicaragua", code: "ni"},
        {name: "Panamá", code: "pa"},
        {name: "Paraguay", code: "py"},
        {name: "Perú", code: "pe"},
        {name: "Puerto Rico", code: "pr"},
        {name: "Rep. Dominicana", code: "do"},
        {name: "Uruguay", code: "uy"},
        {name: "Venezuela", code: "ve"},
        {name: "USA (Español)", code: "us"},
        {name: "Francia", code: "fr"},
        {name: "Alemania", code: "de"},
        {name: "Italia", code: "it"},
        {name: "Portugal", code: "pt"},
        {name: "Reino Unido", code: "gb"},
        {name: "Afganistán", code: "af"},
        {name: "Albania", code: "al"},
        {name: "Argelia", code: "dz"},
        {name: "Andorra", code: "ad"},
        {name: "Angola", code: "ao"},
        {name: "Armenia", code: "am"},
        {name: "Australia", code: "au"},
        {name: "Austria", code: "at"},
        {name: "Azerbaiyán", code: "az"},
        {name: "Bahamas", code: "bs"},
        {name: "Bélgica", code: "be"},
        {name: "Canadá", code: "ca"},
        {name: "China", code: "cn"},
        {name: "Egipto", code: "eg"},
        {name: "Israel", code: "il"},
        {name: "Japón", code: "jp"},
        {name: "Noruega", code: "no"},
        {name: "Rusia", code: "ru"},
        {name: "Suecia", code: "se"},
        {name: "Suiza", code: "ch"},
        {name: "Turquía", code: "tr"}
    ]

    ' =========================================================
    ' ESTADO
    ' =========================================================

    m.viewMode = "portal"

    m.currentPage = 1
    m.moviesPerPage = 20

    m.allMovies = []
    m.totalPages = 1

    m.currentStreams = []
    m.currentSourceIndex = 0
    m.currentMovie = invalid

    ' =========================================================
    ' OBSERVADORES
    ' =========================================================

    m.portalGrid.observeField("itemSelected", "onPortalItemSelected")
    m.movieGrid.observeField("itemSelected", "onItemSelected")
    m.countryList.observeField("itemSelected", "onCountrySelected")
    m.menuList.observeField("itemSelected", "onMenuItemSelected")

    m.detailsScreen.observeField("playPressed", "onPlayPressed")

    m.top.findNode("closeInstructionsBtn").observeField("buttonSelected", "showPortal")

    m.searchKeyboard.observeField("text", "onSearchTextChanged")
    m.searchResultsGrid.observeField("itemSelected", "onSearchItemSelected")

    ' Estado real del Video.
    m.videoPlayer.observeField("state", "onVideoStateChanged")

    ' Timer para detectar streams que quedan colgados.
    m.videoTimeout = m.top.findNode("videoTimeout")
    if m.videoTimeout <> invalid
        m.videoTimeout.observeField("fire", "onVideoTimeout")
    end if

end sub


sub addItem(parent, title)

    item = parent.CreateChild("ContentNode")
    item.title = title

end sub


' =========================================================
' PORTAL
' =========================================================

sub onPortalItemSelected()

    idx = m.portalGrid.itemSelected

    if idx = 0 then
        loadMovies(1)
    else if idx = 1 then
        loadCable()
    else if idx = 2 then
        showCountryList()
    else if idx = 3 then
        showInstructions()
    else if idx = 4 then
        showSearch()
    end if

end sub


sub showPortal()

    m.viewMode = "portal"

    m.portalGroup.visible = true
    m.mainContent.visible = false
    m.instructionGroup.visible = false
    m.searchGroup.visible = false

    m.portalGrid.setFocus(true)

end sub


' =========================================================
' PELICULAS
' =========================================================

sub loadMovies(page as Integer)

    m.viewMode = "movies"
    m.currentPage = page

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false

    m.titleLabel.text = "PlayZone - Películas"

    ' Si el catálogo todavía no está cargado,
    ' descargarlo una sola vez.
    if m.allMovies.count() = 0

        m.movieCounterLabel.text = "Cargando catálogo..."

        m.apiTask = CreateObject("roSGNode", "ApiTask")

        m.apiTask.requestUrl = "https://raw.githubusercontent.com/r1gox/PlayZone-Api/refs/heads/main/data-api.json"

        m.apiTask.observeField("response", "onCatalogRetrieved")

        m.apiTask.control = "RUN"

        return

    end if

    renderMoviePage()

end sub


' =========================================================
' CATALOGO JSON
' =========================================================

sub onCatalogRetrieved()

    res = m.apiTask.response

    if res = invalid

        m.movieCounterLabel.text = "No se pudo cargar el catálogo."

        return

    end if

    ' data-api.json devuelve directamente un ARRAY.
    m.allMovies = res

    if m.allMovies = invalid
        m.allMovies = []
    end if

    totalMovies = m.allMovies.count()

    if totalMovies = 0

        m.movieCounterLabel.text = "Catálogo vacío."

        return

    end if

    m.totalPages = Int((totalMovies + m.moviesPerPage - 1) / m.moviesPerPage)

    m.movieCounterLabel.text = totalMovies.toStr() + " películas"

    renderMoviePage()

end sub


' =========================================================
' RENDER PAGINA
' =========================================================

sub renderMoviePage()

    if m.allMovies.count() = 0
        return
    end if

    if m.currentPage < 1
        m.currentPage = 1
    end if

    if m.currentPage > m.totalPages
        m.currentPage = m.totalPages
    end if

    startIndex = (m.currentPage - 1) * m.moviesPerPage
    endIndex = startIndex + m.moviesPerPage - 1

    if endIndex >= m.allMovies.count()
        endIndex = m.allMovies.count() - 1
    end if

    content = CreateObject("roSGNode", "ContentNode")

    visibleCount = 0

    for i = startIndex to endIndex

        mv = m.allMovies[i]

        if mv <> invalid

            item = content.CreateChild("ContentNode")

            if mv.title <> invalid
                item.title = decodeHtml(mv.title)
            else
                item.title = "Sin título"
            end if

            item.hdPosterUrl = getPosterUrl(mv)

            if mv.url <> invalid
                item.description = mv.url
            end if

            visibleCount++

        end if

    end for

    m.movieGrid.content = content
    m.movieGrid.setFocus(true)

    m.movieCounterLabel.text = m.allMovies.count().toStr() + " películas"

    m.pageIndicator.text = "Página " + m.currentPage.toStr() + " de " + m.totalPages.toStr()

end sub


' =========================================================
' TV CABLE
' =========================================================

sub loadCable()

    m.viewMode = "channels"

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = true
    m.countryGroup.visible = false
    m.searchGroup.visible = false

    m.titleLabel.text = "CANALES TV CABLE"

    m.m3uTask = CreateObject("roSGNode", "M3uTask")

    m.m3uTask.url = "https://raw.githubusercontent.com/NOVAPSNew/Novaps/main/tv.m3u"

    m.m3uTask.observeField("content", "onChannelsRetrieved")

    m.m3uTask.control = "RUN"

end sub


' =========================================================
' PAISES
' =========================================================

sub showCountryList()

    m.viewMode = "countries"

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = true
    m.searchGroup.visible = false

    m.titleLabel.text = "IPTV POR PAÍSES"

    content = CreateObject("roSGNode", "ContentNode")

    for each c in m.countries

        item = content.CreateChild("ContentNode")

        item.title = c.name
        item.description = "https://iptv-org.github.io/iptv/countries/" + c.code + ".m3u"

    end for

    m.countryList.content = content
    m.countryList.setFocus(true)

end sub


' =========================================================
' BUSCADOR
' =========================================================

sub showSearch()

    m.viewMode = "search"

    m.portalGroup.visible = false
    m.mainContent.visible = true
    m.movieGrid.visible = false
    m.countryGroup.visible = false
    m.searchGroup.visible = true

    m.titleLabel.text = "Buscar Películas"

    if m.allMovies.count() = 0

        m.movieCounterLabel.text = "Cargando catálogo..."

        m.apiTask = CreateObject("roSGNode", "ApiTask")

        m.apiTask.requestUrl = "https://raw.githubusercontent.com/r1gox/PlayZone-Api/refs/heads/main/data-api.json"

        m.apiTask.observeField("response", "onSearchCatalogRetrieved")

        m.apiTask.control = "RUN"

    else

        m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"

    end if

    m.searchKeyboard.findNode("keyGrid").setFocus(true)

end sub


sub onSearchCatalogRetrieved()

    res = m.apiTask.response

    if res <> invalid

        m.allMovies = res

        if m.allMovies = invalid
            m.allMovies = []
        end if

    end if

    m.movieCounterLabel.text = "Escribe para buscar (" + m.allMovies.count().toStr() + " títulos)"

    filterSearchResults()

end sub


sub onSearchTextChanged()

    filterSearchResults()

end sub


sub filterSearchResults()

    query = LCase(m.searchKeyboard.text)

    content = CreateObject("roSGNode", "ContentNode")

    count = 0

    if query <> "" and m.allMovies.count() > 0

        for each mv in m.allMovies

            if mv.title <> invalid

                title = LCase(decodeHtml(mv.title))

                if instr(1, title, query) > 0

                    item = content.CreateChild("ContentNode")

                    item.title = decodeHtml(mv.title)

                    item.hdPosterUrl = getPosterUrl(mv)

                    if mv.url <> invalid
                        item.description = mv.url
                    end if

                    count++

                    if count >= 60
                        exit for
                    end if

                end if

            end if

        end for

    end if

    m.searchResultsGrid.content = content

    if query <> ""

        m.movieCounterLabel.text = count.toStr() + " resultados para '" + query + "'"

    end if

end sub


' =========================================================
' SELECCIONAR PELICULA
' =========================================================

sub onItemSelected()

    idx = m.movieGrid.itemSelected

    item = m.movieGrid.content.getChild(idx)

    if m.viewMode = "movies"

        movie = findMovieByUrl(item.description)

        if movie <> invalid

            showMovieDetails(movie)

        end if

    else

        playVideo(item.description)

    end if

end sub


sub onSearchItemSelected()

    idx = m.searchResultsGrid.itemSelected

    item = m.searchResultsGrid.content.getChild(idx)

    movie = findMovieByUrl(item.description)

    if movie <> invalid

        showMovieDetails(movie)

    end if

end sub


' =========================================================
' BUSCAR MOVIE ORIGINAL
' =========================================================

function findMovieByUrl(movieUrl as String) as Object

    if movieUrl = invalid or movieUrl = ""
        return invalid
    end if

    for each mv in m.allMovies

        if mv.url <> invalid

            if mv.url = movieUrl
                return mv
            end if

        end if

    end for

    return invalid

end function


' =========================================================
' DETALLES
' =========================================================

sub showMovieDetails(movie as Object)

    if movie = invalid
        return
    end if

    m.currentMovie = movie

    ' Obtener todos los sources.
    if movie.sources <> invalid

        m.currentStreams = orderSources(movie.sources)

    else

        m.currentStreams = []

    end if

    m.currentSourceIndex = 0

    detailsContent = CreateObject("roSGNode", "ContentNode")

    if movie.title <> invalid
        detailsContent.title = decodeHtml(movie.title)
    else
        detailsContent.title = "Sin título"
    end if

    detailsContent.hdPosterUrl = getPosterUrl(movie)

    if movie.description <> invalid
        detailsContent.description = movie.description
    else
        detailsContent.description = ""
    end if

    if movie.rating <> invalid
        detailsContent.rating = movie.rating
    end if

    if movie.genres <> invalid
        detailsContent.categories = movie.genres
    end if

    m.detailsScreen.content = detailsContent

    m.detailsScreen.visible = true
    m.detailsScreen.setFocus(true)

end sub


' =========================================================
' ORDENAR SOURCES
'
' HLS SIEMPRE TIENE PRIORIDAD.
' =========================================================

function orderSources(sources as Object) as Object

    ordered = []

    ' Primero HLS.
    for each source in sources

        if source <> invalid

            sourceType = ""

            if source.type <> invalid
                sourceType = LCase(source.type.toStr())
            end if

            if sourceType = "hls"

                if source.url <> invalid and source.url <> ""
                    ordered.push(source)
                end if

            end if

        end if

    end for

    ' Después todo lo demás.
    for each source in sources

        if source <> invalid

            sourceType = ""

            if source.type <> invalid
                sourceType = LCase(source.type.toStr())
            end if

            if sourceType <> "hls"

                if source.url <> invalid and source.url <> ""
                    ordered.push(source)
                end if

            end if

        end if

    end for

    return ordered

end function


' =========================================================
' BOTON PLAY
' =========================================================

sub onPlayPressed()

    if m.currentStreams = invalid
        return
    end if

    if m.currentStreams.count() = 0

        print "[PLAYER] No hay sources disponibles"

        return

    end if

    m.currentSourceIndex = 0

    playCurrentSource()

end sub


' =========================================================
' REPRODUCIR SOURCE ACTUAL
' =========================================================

sub playCurrentSource()

    if m.currentStreams = invalid
        return
    end if

    total = m.currentStreams.count()

    if m.currentSourceIndex >= total

        print "[PLAYER] Todos los sources fallaron"

        stopVideo()

        return

    end if

    source = m.currentStreams[m.currentSourceIndex]

    if source = invalid

        tryNextSource()

        return

    end if

    url = source.url

    if url = invalid or url = ""

        tryNextSource()

        return

    end if

    streamType = "hls"

    if source.type <> invalid and source.type <> ""

        streamType = LCase(source.type.toStr())

    end if

    print "[PLAYER] Intentando source " + (m.currentSourceIndex + 1).toStr() + "/" + total.toStr()
    print "[PLAYER] Tipo: " + streamType
    print "[PLAYER] URL: " + url

    videoContent = CreateObject("roSGNode", "ContentNode")

    videoContent.url = url

    if streamType = "mp4"

        videoContent.streamFormat = "mp4"

    else

        videoContent.streamFormat = "hls"

    end if

    m.videoPlayer.content = videoContent

    m.videoPlayer.visible = true

    m.videoPlayer.setFocus(true)

    ' Reiniciar timeout.
    if m.videoTimeout <> invalid

        m.videoTimeout.control = "stop"

        m.videoTimeout.duration = 12

        m.videoTimeout.control = "start"

    end if

    m.videoPlayer.control = "play"

end sub


' =========================================================
' ESTADO DEL VIDEO
' =========================================================

sub onVideoStateChanged()

    state = m.videoPlayer.state

    print "[PLAYER] Estado: " + state

    if state = "playing"

        ' El video sí arrancó.
        if m.videoTimeout <> invalid
            m.videoTimeout.control = "stop"
        end if

    else if state = "error"

        print "[PLAYER] ERROR EN SOURCE"

        tryNextSource()

    end if

end sub


' =========================================================
' TIMEOUT
'
' Si después de 12 segundos no comenzó:
' probar siguiente source.
' =========================================================

sub onVideoTimeout()

    state = m.videoPlayer.state

    print "[PLAYER] Timeout. Estado: " + state

    if state <> "playing"

        tryNextSource()

    end if

end sub


' =========================================================
' SIGUIENTE SOURCE
' =========================================================

sub tryNextSource()

    if m.videoTimeout <> invalid
        m.videoTimeout.control = "stop"
    end if

    m.videoPlayer.control = "stop"

    m.currentSourceIndex++

    if m.currentSourceIndex < m.currentStreams.count()

        print "[PLAYER] Fallback -> siguiente source"

        playCurrentSource()

    else

        print "[PLAYER] No quedan sources."

        stopVideo()

    end if

end sub


' =========================================================
' DETENER VIDEO
' =========================================================

sub stopVideo()

    if m.videoTimeout <> invalid
        m.videoTimeout.control = "stop"
    end if

    m.videoPlayer.control = "stop"
    m.videoPlayer.visible = false

    if m.viewMode = "search"

        m.detailsScreen.setFocus(true)

    else

        m.detailsScreen.setFocus(true)

    end if

end sub


' =========================================================
' CANALES
' =========================================================

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

    m.m3uTask = CreateObject("roSGNode", "M3uTask")

    m.m3uTask.url = selected.description

    m.m3uTask.observeField("content", "onChannelsRetrieved")

    m.m3uTask.control = "RUN"

end sub


' =========================================================
' INSTRUCCIONES
' =========================================================

sub showInstructions()

    m.viewMode = "instructions"

    m.portalGroup.visible = false
    m.mainContent.visible = false
    m.instructionGroup.visible = true

    m.top.findNode("closeInstructionsBtn").setFocus(true)

end sub


' =========================================================
' MENU
' =========================================================

sub onMenuItemSelected()

    idx = m.menuList.itemSelected

    if idx = 0

        showPortal()

    else if idx = 1 and m.viewMode = "movies"

        if m.currentPage < m.totalPages

            m.currentPage++

            renderMoviePage()

        end if

    else if idx = 2 and m.viewMode = "movies"

        if m.currentPage > 1

            m.currentPage--

            renderMoviePage()

        end if

    else if idx = 3

        showSearch()

    end if

    toggleMenu(false)

end sub


' =========================================================
' MENU VISUAL
' =========================================================

sub toggleMenu(open as Boolean)

    if open

        m.menuOverlay.visible = true

        m.top.findNode("openMenuAnim").control = "start"

        m.menuList.setFocus(true)

    else

        m.menuOverlay.visible = false

        m.top.findNode("closeMenuAnim").control = "start"

        if m.viewMode = "movies" or m.viewMode = "channels"
            m.movieGrid.setFocus(true)
        end if

        if m.viewMode = "countries"
            m.countryList.setFocus(true)
        end if

        if m.viewMode = "portal"
            m.portalGrid.setFocus(true)
        end if

    end if

end sub


' =========================================================
' TECLAS
' =========================================================

function onKeyEvent(key as String, press as Boolean) as Boolean

    if not press
        return false
    end if

    if key = "back"

        if m.menuOverlay.visible

            toggleMenu(false)

            return true

        end if

        if m.videoPlayer.visible

            stopVideo()

            return true

        end if

        if m.detailsScreen.visible

            m.detailsScreen.visible = false

            if m.viewMode = "search"

                m.searchResultsGrid.setFocus(true)

            else

                m.movieGrid.setFocus(true)

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


' =========================================================
' POSTER
' =========================================================

function getPosterUrl(data as object) as string

    if data = invalid
        return ""
    end if

    posibles = [
        "poster",
        "image",
        "img",
        "thumbnail",
        "cover",
        "poster_url",
        "imageUrl",
        "thumb"
    ]

    for each campo in posibles

        if data.DoesExist(campo)

            valor = data[campo]

            if valor <> invalid and valor <> ""

                valor = valor.toStr()

                return valor

            end if

        end if

    end for

    return ""

end function


' =========================================================
' HTML SIMPLE
' =========================================================

function decodeHtml(value as String) as String

    if value = invalid
        return ""
    end if

    result = value

    result = result.Replace("&#8211;", "-")
    result = result.Replace("&#8212;", "-")
    result = result.Replace("&amp;", "&")
    result = result.Replace("&quot;", Chr(34))
    result = result.Replace("&#39;", "'")
    result = result.Replace("&apos;", "'")
    result = result.Replace("&nbsp;", " ")

    return result

end function


function urlEncode(value as String) as String

    transfer = CreateObject("roUrlTransfer")

    return transfer.Escape(value)

end function
