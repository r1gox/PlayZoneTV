sub init()
    m.top.functionName = "execute"
end sub

sub execute()
    url = m.top.url
    if url = "" then return

    http = CreateObject("roUrlTransfer")
    http.SetCertificatesFile("common:/certs/ca-bundle.crt")
    http.InitClientCertificates()
    http.SetUrl(url)

    data = http.GetToString()
    if data <> ""
        lines = data.Split(chr(10))
        content = CreateObject("roSGNode", "ContentNode")

        for i = 0 to lines.count() - 1
            line = lines[i].Trim()
            if line.left(7) = "#EXTINF"
                ' Extraer Nombre del canal
                name = "Canal Sin Nombre"
                commaIdx = line.Instr(",")
                if commaIdx > 0
                    name = line.mid(commaIdx + 1).Trim()
                end if

                ' Extraer Logo si existe (tvg-logo="...")
                logoUrl = "https://iptv-org.github.io/icons/channels/default.png"
                logoMatch = line.Instr("tvg-logo=")
                if logoMatch > 0
                    startIdx = line.Instr(logoMatch, chr(34)) ' Buscar primera comilla
                    if startIdx > 0
                        endIdx = line.Instr(startIdx + 1, chr(34)) ' Buscar segunda comilla
                        if endIdx > startIdx
                            extractedLogo = line.mid(startIdx + 1, endIdx - startIdx - 1)
                            if extractedLogo <> "" then logoUrl = extractedLogo
                        end if
                    end if
                end if

                ' La siguiente línea es la URL
                if i + 1 < lines.count()
                    streamUrl = lines[i+1].Trim()
                    if streamUrl.left(4) = "http"
                        item = content.CreateChild("ContentNode")
                        item.title = name
                        item.description = streamUrl
                        item.hdPosterUrl = logoUrl
                        item.sdPosterUrl = logoUrl
                        item.streamFormat = "hls"
                    end if
                end if
            end if
        end for
        m.top.content = content
    end if
end sub
