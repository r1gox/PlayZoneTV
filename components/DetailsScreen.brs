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

    m.playButton.observeField("buttonSelected", "onPlaySelected")
end sub

sub onContentChange()
    content = m.top.content
    if content <> invalid
        m.poster.uri = content.hdPosterUrl
        m.titleLabel.text = content.title
        m.descriptionLabel.text = content.description

        ' Cada badge se oculta si esa película no trae el dato (en vez de
        ' quedar mostrando una caja de color vacía, o el texto de la
        ' película anterior).
        if content.rating <> invalid and content.rating <> ""
            m.ratingLabel.text = "Rating: " + content.rating
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

        ' Géneros de la película (comedia, romance, etc.)
        if content.categories <> invalid and content.categories.count() > 0
            gen = ""
            for each g in content.categories
                gen += g + "  "
            end for
            m.languagesLabel.text = "Géneros: " + gen
        else
            m.languagesLabel.text = ""
        end if

        m.playButton.setFocus(true)
    end if
end sub

sub onPlaySelected()
    m.top.playPressed = true
end sub
