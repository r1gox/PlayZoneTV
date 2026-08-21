sub init()
    m.poster = m.top.findNode("poster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.yearLabel = m.top.findNode("yearLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
    m.qualityLabel = m.top.findNode("qualityLabel")
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

        ' Extraemos datos adicionales si están disponibles
        if content.rating <> invalid then m.ratingLabel.text = "Rating: " + content.rating
        if content.releaseDate <> invalid then m.yearLabel.text = content.releaseDate
        if content.shortDescription <> invalid then m.qualityLabel.text = content.shortDescription

        ' Mostrar lenguajes (unidos por coma)
        if content.categories <> invalid and content.categories.count() > 0
            langs = ""
            for each lang in content.categories
                langs += lang + "  "
            end for
            m.languagesLabel.text = "Idiomas: " + langs
        else
            m.languagesLabel.text = ""
        end if

        m.playButton.setFocus(true)
    end if
end sub

sub onPlaySelected()
    m.top.playPressed = true
end sub
