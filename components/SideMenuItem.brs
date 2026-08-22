sub init()
    m.background = m.top.findNode("background")
    m.focusIndicator = m.top.findNode("focusIndicator")
    m.itemLabel = m.top.findNode("itemLabel")
end sub

sub onContentChange()
    content = m.top.itemContent
    if content <> invalid
        m.itemLabel.text = content.title
    end if
end sub

sub onFocusChange()
    if m.top.focusPercent > 0.5
        m.background.color = "0x333333FF"
        m.focusIndicator.color = "0x7F5AF0FF"
        m.itemLabel.color = "0xFFFFFFFF"
    else
        m.background.color = "0x00000000"
        m.focusIndicator.color = "0x00000000"
        m.itemLabel.color = "0xAAAAAAFF"
    end if
end sub
