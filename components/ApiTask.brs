sub init()
    m.top.functionName = "executeRequest"
end sub

sub executeRequest()
    url = m.top.requestUrl
    if url <> ""
        http = CreateObject("roUrlTransfer")
        http.SetCertificatesFile("common:/certs/ca-bundle.crt")
        http.InitClientCertificates()
        http.SetUrl(url)
        http.AddHeader("User-Agent", "Roku/PlayZoneTV")

        responseString = http.GetToString()
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
            end if
        end if
    end if
end sub
