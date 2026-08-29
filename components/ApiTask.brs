sub init()
    m.top.functionName = "executeRequest"
end sub

sub executeRequest()
    url = m.top.requestUrl
    if url = "" then return

    http = CreateObject("roUrlTransfer")
    http.SetCertificatesFile("common:/certs/ca-bundle.crt")
    http.InitClientCertificates()
    http.SetUrl(url)
    http.AddHeader("User-Agent", "Roku/PlayZoneTV")

    port = CreateObject("roMessagePort")
    http.SetMessagePort(port)

    if not http.AsyncGetToString()
        m.top.response = invalid
        return
    end if

    ' Limite de tiempo real por pedido: si en 8 segundos no hay
    ' respuesta, cancelamos y avisamos "sin respuesta" en vez de dejar
    ' a Roku esperando por su cuenta (que puede tardar mucho mas).
    timeoutMs = 8000
    msg = wait(timeoutMs, port)

    if msg = invalid
        print "=== TIMEOUT DE RED (8s) ==="
        print "url="; url
        http.AsyncCancel()
        m.top.response = invalid
        return
    end if

    if type(msg) = "roUrlEvent"
        responseString = msg.GetString()
        if responseString <> ""
            parsed = ParseJson(responseString)
            if parsed <> invalid
                ' Si es array (API vieja), lo envolvemos para que quepa en assocarray
                if GetInterface(parsed, "ifArray") <> invalid
                    wrap = CreateObject("roAssociativeArray")
                    wrap.movies = parsed
                    m.top.response = wrap
                else
                    m.top.response = parsed
                end if
                return
            end if
        end if
    end if

    m.top.response = invalid
end sub