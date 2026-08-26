sub init()

    m.poster = m.top.findNode("poster")
    m.titleLabel = m.top.findNode("titleLabel")

    m.yearLabel = m.top.findNode("yearLabel")
    m.yearBox = m.top.findNode("yearBox")

    m.ratingLabel = m.top.findNode("ratingLabel")
    m.ratingBox = m.top.findNode("ratingBox")

    m.qualityLabel = m.top.findNode("qualityLabel")
    m.qualityBox = m.top.findNode("qualityBox")

    m.genresLabel = m.top.findNode("genresLabel")
    m.descriptionLabel = m.top.findNode("descriptionLabel")

    m.playButton = m.top.findNode("playButton")
    m.playBg = m.top.findNode("playBg")
    m.playLabel = m.top.findNode("playLabel")

    m.playButton.observeField("focusedChild", "onPlayFocus")

end sub


sub onPlayFocus()

    if m.playButton.isInFocusChain()
        m.playBg.color = "0x9B7AFFFF"
    else
        m.playBg.color = "0x7F5AF0FF"
    end if

end sub


sub onContentChange()

    content = m.top.content

    if content <> invalid

        ' POSTER
        m.poster.uri = content.hdPosterUrl


        ' TITULO
        m.titleLabel.text = content.title


        ' ==========================================
        ' GENEROS
        ' ==========================================

        if content.categories <> invalid and content.categories.count() > 0

            gen = ""

            for each g in content.categories

                if g <> invalid

                    gText = g.ToStr().Trim()

                    if gText <> ""
                        gen += gText + "  "
                    end if

                end if

            end for

            gen = gen.Trim()

            if gen <> ""
                m.genresLabel.text = "Géneros: " + gen
            else
                m.genresLabel.text = "Géneros: No disponible"
            end if

        else

            m.genresLabel.text = "Géneros: No disponible"

        end if

        m.genresLabel.visible = true


        ' ==========================================
        ' SINOPSIS
        ' ==========================================

        if content.description <> invalid and content.description <> ""

            m.descriptionLabel.text = "Sinopsis: " + content.description

        else

            m.descriptionLabel.text = "Sinopsis: No disponible"

        end if

        m.descriptionLabel.visible = true


        ' ==========================================
        ' RATING
        ' ==========================================

        if content.rating <> invalid and content.rating <> ""

            r = content.rating

            if type(r) = "Integer" or type(r) = "Float" or type(r) = "Double"
                r = r.ToStr()
            end if

            m.ratingLabel.text = "★ " + r
            m.ratingBox.visible = true

        else

            m.ratingBox.visible = false

        end if


        ' ==========================================
        ' AÑO / FECHA
        ' ==========================================

        if content.releaseDate <> invalid and content.releaseDate <> ""

            m.yearLabel.text = content.releaseDate
            m.yearBox.visible = true

        else

            m.yearBox.visible = false

        end if


        ' ==========================================
        ' CALIDAD
        ' Ejemplo: 720 HD / 1080p HD
        ' ==========================================

        if content.qualityText <> invalid and content.qualityText <> ""

            quality = content.qualityText.ToStr().Trim()

            if quality <> ""

                m.qualityLabel.text = quality
                m.qualityBox.visible = true

            else

                m.qualityBox.visible = false

            end if

        else

            m.qualityBox.visible = false

        end if



        ' MANTENER FLUJO ACTUAL
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