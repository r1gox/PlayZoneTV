sub init()
    m.poster = m.top.findNode("poster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.yearLabel = m.top.findNode("yearLabel")
    m.yearBox = m.top.findNode("yearBox")
    m.ratingLabel = m.top.findNode("ratingLabel")
    m.ratingBox = m.top.findNode("ratingBox")
    m.qualityLabel = m.top.findNode("qualityLabel")
    m.qualityBox = m.top.findNode("qualityBox")
    m.languagesLabel = m.top.findNode("languagesLabel")
    m.descriptionLabel = m.top.findNode("descriptionLabel")
    m.playButton = m.top.findNode("playButton")
    m.playBg = m.top.findNode("playBg")
    m.playLabel = m.top.findNode("playLabel")

    m.playButton.observeField("focusedChild", "onPlayFocus")
end sub

sub onPlayFocus()
    if m.playButton.isInFocusChain()
        m.playBg.color = "0x9B7AFFFF"   ' más claro al enfocar
    else
        m.playBg.color = "0x7F5AF0FF"
    end if
end sub

sub onContentChange()
    content = m.top.content
    if content <> invalid
        m.poster.uri = content.hdPosterUrl
        m.titleLabel.text = content.title

        if content.description <> invalid and content.description <> ""
            m.descriptionLabel.text = "Sinopsis: " + content.description
        else
            m.descriptionLabel.text = "Sinopsis: No disponible"
        end if

        if content.rating <> invalid and content.rating <> ""
            r = content.rating
            if type(r) = "Integer" or type(r) = "Float" or type(r) = "Double" then r = r.ToStr()
            m.ratingLabel.text = "★ " + r
            m.ratingBox.visible = true
        else
            m.ratingBox.visible = false
        end if

        if content.releaseDate <> invalid and content.releaseDate <> ""
            m.yearLabel.text = content.releaseDate
            m.yearBox.visible = true
        else
            m.yearBox.visible = false
        end if

        if content.shortDescription <> invalid and content.shortDescription <> ""
            m.qualityLabel.text = content.shortDescription
            m.qualityBox.visible = true
        else
            m.qualityBox.visible = false
        end if

        if content.categories <> invalid and content.categories.count() > 0
            gen = ""
            for each g in content.categories
                gen += g + "  "
            end for
            m.languagesLabel.text = "Géneros: " + gen.Trim()
        else
            m.languagesLabel.text = ""
        end if

        m.playButton.setFocus(true)
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if key = "OK" or key = "play"
        if m.playButton.isInFocusChain()
            m.top.playPressed = true
            return true
        end if
    end if
    return false
end function
