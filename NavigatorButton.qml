import QtQuick
import QtQuick.Controls.Basic as T

T.Button {
    id: navigator

    property bool isForward: false

    icon.name: "arrow"
    icon.source: isForward ? "arrow-right.svg" : "arrow-left.svg"
    icon.width: 25
    icon.height: 25
    icon.color: navigator.hovered ? Theme.hovered :
                                    Theme.iconColor

    checkable: true

    background: Rectangle {
        implicitWidth: 50
        implicitHeight: 50
        border.width: navigator.hovered ? 1 : 0
        border.color: Theme.buttonBackgroundBorderColor
        radius: width/2
        color: navigator.hovered ? Theme.buttonHover :
                                   checked ? Theme.buttonCheckedColor :
                                             "transparent"

    }
}
