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

        responseString = http.GetToString()
        if responseString <> ""
            m.top.response = ParseJson(responseString)
        end if
    end if
end sub
