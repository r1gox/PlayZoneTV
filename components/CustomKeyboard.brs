sub init()
    m.keyGrid = m.top.findNode("keyGrid")
    m.displayText = m.top.findNode("displayText")
    m.currentText = ""
    m.busy = false

    keys = ["A", "B", "C", "D", "E", "F",
            "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R",
            "S", "T", "U", "V", "W", "X",
            "Y", "Z", "1", "2", "3", "4",
            "5", "6", "7", "8", "9", "0",
            "ESP", "DEL"]

    content = CreateObject("roSGNode", "ContentNode")
    for each char in keys
        item = content.CreateChild("ContentNode")
        item.title = char
    end for
    m.keyGrid.content = content
    m.keyGrid.observeField("itemSelected", "onKeySelected")
end sub

sub onKeySelected()
    if m.busy = true then return
    idx = m.keyGrid.itemSelected
    if idx = invalid or idx < 0 then return
    if m.keyGrid.content = invalid then return
    if idx >= m.keyGrid.content.getChildCount() then return

    m.busy = true
    key = m.keyGrid.content.getChild(idx).title

    if key = "ESP"
        m.currentText = m.currentText + " "
    else if key = "DEL"
        if Len(m.currentText) > 0
            m.currentText = Left(m.currentText, Len(m.currentText) - 1)
        end if
    else
        m.currentText = m.currentText + key
    end if

    if m.displayText <> invalid then m.displayText.text = m.currentText
    ' Notifica al MainScene (dispara el debounce, no el filtro directo)
    m.top.text = m.currentText
    m.busy = false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if LCase(key) = "backspace"
        if m.busy = true then return true
        m.busy = true
        if Len(m.currentText) > 0
            m.currentText = Left(m.currentText, Len(m.currentText) - 1)
        end if
        if m.displayText <> invalid then m.displayText.text = m.currentText
        m.top.text = m.currentText
        m.busy = false
        return true
    end if

    if Len(key) = 1
        code = Asc(key)
        if code >= 32
            if m.busy = true then return true
            m.busy = true
            m.currentText = m.currentText + UCase(key)
            if m.displayText <> invalid then m.displayText.text = m.currentText
            m.top.text = m.currentText
            m.busy = false
            return true
        end if
    end if

    return false
end function
