sub init()
    m.poster = m.top.findNode("poster")
    m.posterGroup = m.top.findNode("posterGroup")
    m.focusBorder = m.top.findNode("focusBorder")
    m.shadow = m.top.findNode("shadow")
    m.bg = m.top.findNode("bg")
end sub

sub onContentChange()
    item = m.top.itemContent
    if item = invalid then return

    ' Limpiamos primero
    m.poster.uri = ""

    if item.hdPosterUrl <> invalid and item.hdPosterUrl <> ""
        m.poster.uri = item.hdPosterUrl
    else if item.SDPosterUrl <> invalid and item.SDPosterUrl <> ""
        m.poster.uri = item.SDPosterUrl
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