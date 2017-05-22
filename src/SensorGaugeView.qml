import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtCharts 2.0
Item {
    property var masterColors: null
    property var rectColor: null
    property var sensorName: null
    Layout.fillHeight: true
    Layout.preferredWidth: this.height

    Rectangle {
        id: gaugeRect
        color: rectColor
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
                color: rectColor

                Label {
                    anchors.centerIn: parent
                    text: sensorName
                        color: "white"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height - 20
                color: rectColor

                CircularGauge {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    anchors.margins: 30
                    id:xGauge

                    Behavior on value {

                        NumberAnimation {
                            duration: 1000
                        }
                    }

                    style: CircularGaugeStyle {

                        needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.03
                            implicitHeight: outerRadius * 0.9
                            antialiasing: true
                            color: Qt.rgba(0.66, 0.3, 0, 1)
                        }
                    }
                }
            }
        }
    }
}
