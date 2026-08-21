sub init()
    m.poster = m.top.findNode("poster")
    m.posterGroup = m.top.findNode("posterGroup")
    m.focusBorder = m.top.findNode("focusBorder")
    m.shadow = m.top.findNode("shadow")
    m.bg = m.top.findNode("bg")
    m.retryCount = 0
    m.poster.observeField("loadStatus", "onPosterLoadStatus")
end sub

sub onPosterLoadStatus()
    ' Si falla la carga (típico cuando el servidor todavía está generando
    ' la miniatura la primera vez que se pide), reintentamos una vez tras
    ' una breve espera, en vez de dejar el póster en gris para siempre.
    if m.poster.loadStatus = "failed" and m.retryCount < 2
        m.retryCount++
        url = m.savedUrl
        if url <> invalid and url <> ""
            timer = CreateObject("roSGNode", "Timer")
            timer.duration = 1.2
            timer.id = "retryTimer"
            timer.observeField("fire", "onRetryTimerFired")
            m.retryTimer = timer
            m.top.appendChild(timer)
            timer.control = "start"
        end if
    end if
end sub

sub onRetryTimerFired()
    if m.savedUrl <> invalid and m.savedUrl <> ""
        m.poster.uri = ""
        m.poster.uri = m.savedUrl
    end if
end sub

sub onContentChange()
    item = m.top.itemContent
    if item = invalid then return

    m.retryCount = 0

    ' Limpiamos primero
    m.poster.uri = ""

    if item.hdPosterUrl <> invalid and item.hdPosterUrl <> ""
        m.savedUrl = item.hdPosterUrl
        m.poster.uri = item.hdPosterUrl
    else if item.SDPosterUrl <> invalid and item.SDPosterUrl <> ""
        m.savedUrl = item.SDPosterUrl
        m.poster.uri = item.SDPosterUrl
    else
        m.savedUrl = ""
    end if
end sub

sub onFocusChange()
    focus = m.top.focusPercent

    if focus > 0.5
        m.posterGroup.scale = [1.08, 1.08]
        m.focusBorder.opacity = 1
        m.shadow.opacity = 0.55
    else
        m.posterGroup.scale = [1.0, 1.0]
        m.focusBorder.opacity = 0
        m.shadow.opacity = 0
    end if
end sub