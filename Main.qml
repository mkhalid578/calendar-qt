import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQml


Window {
    id: root
    width: 640
    height: 800
    visible: true
    title: qsTr("Calendar")
    color: Theme.background

    property date currentDate: new Date()
    property date selection: new Date()
    property var locale: Qt.locale("en_US")
    signal dateSelected(int month, int day, int year);

    ColumnLayout {

        anchors.fill: parent

        RowLayout {
            spacing: 10
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.margins: 5

            ButtonGroup {id: navigator }

            NavigatorButton {
                id: prev
                isForward: false
                onPressed: {
                    selection.setMonth(selection.getMonth() - 1)
                    animation.start()
                    buttonGroup.checkState = false
                }

                ButtonGroup.group: navigator
            }

            Text {
                id: month_text
                text: qsTr("%1 %2").arg(locale.monthName(grid.month)).arg(grid.year)
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                Layout.leftMargin: 40
                color: Theme.primary
                font.pixelSize: 24

            }

            NavigatorButton {
                id: next
                isForward: true
                onPressed: {
                    selection.setMonth(selection.getMonth() + 1)
                    animation.start()
                    buttonGroup.checkState = false

                }

                ButtonGroup.group: navigator
            }
        }

        ColumnLayout {
            DayOfWeekRow {
                id: control
                locale: grid.locale
                Layout.fillWidth: true
                font.pixelSize: 20

                delegate: Text {
                    text: model.shortName
                    font: control.font
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MonthGrid {
                id: grid

                property bool checked: false

                month: selection.getMonth() // this is how the Calendar can be used
                year: selection.getFullYear()
                locale: Qt.locale("en_US")
                Layout.fillWidth: true
                font.pixelSize: 20

                ButtonGroup {id: buttonGroup}

                delegate: Button {
                    id: day
                    required property var model

                    text: model.day
                    font: grid.font

                    checkable: true

                    contentItem: Text {
                        text: day.text
                        font: day.font
                        opacity: enabled ? 1.0 : 0.3
                        color: day.checked ? Theme.date  :
                                             day.down ? Theme.dateSelected :
                                                        day.hovered ? Theme.hovered :
                                                                      model.month !== grid.month ? Theme.hovered : Theme.date
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                    }

                    background: Rectangle {

                        implicitHeight: 50
                        implicitWidth: 50
                        opacity: enabled ? 1: 0.3
                        border.color: day.down ? Theme.borderPressed : day.checked ? Theme.dateSelectedBackground : Theme.border
                        border.width: day.hovered ?  1 : day.checked ? 4 : 0
                        radius: width /2
                        color: day.hovered ? Theme.hoveredSecondary :
                                             model.today ? Theme.todayColor : "transparent"
                    }

                    NumberAnimation on opacity  {
                        from: 0; to: 1.0;
                        easing.type: Easing.InOutQuad
                        duration: 550
                    }

                    ToolTip.visible: day.hovered
                    ToolTip.text: qsTr("%1/%2/%3").arg(model.month + 1).arg(model.day).arg(model.year)
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000

                    onPressed: dateSelected(model.month, model.day, model.year)

                    ButtonGroup.group: buttonGroup
                }
            }

            ColumnLayout {

                Text {
                    id: eventsTitle
                    text: qsTr("Today")
                    Layout.margins: 8
                    font.pixelSize: 20
                    color: "#FFFFFF"
                }

                TextField {
                    id: events
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    Layout.margins: 8
                    text: qsTr("No Events")
                    enabled: false

                }
            }
        }
    }

    NumberAnimation {
        id: animation
        target: grid
        property: "opacity"
        duration: 1000
        from: 0
        to : 1
        easing.type: Easing.InOutQuad
    }

    Connections {
        target: root
        function onDateSelected(month, day, year) {
            if (month === currentDate.getMonth()) {
                let diff = day - currentDate.getDate()
                switch (diff) {
                case 0:
                    eventsTitle.text = qsTr("Today");
                    break;
                case 1:
                    eventsTitle.text = qsTr("Tomorrow");
                    break;
                case -1:
                    eventsTitle.text = qsTr("Yesterday")
                    break;
                default:
                    eventsTitle.text = qsTr("%1 %2").arg(locale.monthName(month)).arg(day)
                    break;
                }
            } else {
                eventsTitle.text = qsTr("%1 %2").arg(locale.monthName(month)).arg(day)

            }
        }
    }
}
