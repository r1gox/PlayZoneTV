sub init()
    m.keyGrid = m.top.findNode("keyGrid")
    m.displayText = m.top.findNode("displayText")

    ' Definición de teclas: letras, números, y ESPACIO/BORRAR como una
    ' tecla más de la grilla (así se navegan con las mismas flechas,
    ' sin combinaciones especiales de control remoto).
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

    ' Eventos
    m.keyGrid.observeField("itemSelected", "onKeySelected")

    m.currentText = ""
    ' Nota: ya no se hace setFocus aquí. Este componente puede estar
    ' instanciado dentro de una pantalla oculta (como el buscador dentro de
    ' MainScene); si se enfoca a sí mismo apenas se construye, le roba el
    ' foco del control remoto a lo que sea que esté visible en pantalla.
    ' Quien lo use debe llamar keyboardNode.findNode("keyGrid").setFocus(true)
    ' cuando realmente lo muestre.
end sub

sub onKeySelected()
    idx = m.keyGrid.itemSelected
    key = m.keyGrid.content.getChild(idx).title

    if key = "ESP"
        m.currentText += " "
    else if key = "DEL"
        if m.currentText.len() > 0
            m.currentText = m.currentText.left(m.currentText.len() - 1)
        end if
    else
        m.currentText += key
    end if

    update()
end sub

sub update()
    m.displayText.text = m.currentText
    m.top.text = m.currentText
end sub

' Soporte para el teclado del teléfono en la app de Roku: cuando escribís
' ahí, Roku manda cada letra/número como un evento de tecla "literal" (un
' caracter individual), y el backspace como su propia tecla. Esto se suma
' a la navegación con flechas + OK de la grilla de arriba; no la reemplaza.
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if LCase(key) = "backspace"
        if m.currentText.len() > 0
            m.currentText = m.currentText.left(m.currentText.len() - 1)
            update()
        end if
        return true
    end if

    if key.Len() = 1
        code = Asc(key)
        if code >= 32 ' caracter imprimible (letras, números, espacio, acentos, etc.)
            m.currentText += key
            update()
            return true
        end if
    end if

    return false
end function
