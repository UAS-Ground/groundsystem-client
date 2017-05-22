import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtPositioning 5.5
import QtLocation 5.6
import QtQuick.Window 2.0
import QtCharts 2.0
Item {
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


                ChartView {
                    id:splineChart1
                    anchors.fill: parent

                    SplineSeries {
                        id:splineSeries1
                        XYPoint { x: 0; y: 0.0 }
                        XYPoint { x: 1.1; y: 3.2 }
                        XYPoint { x: 1.9; y: 2.4 }
                        XYPoint { x: 2.1; y: 2.1 }
                        XYPoint { x: 2.9; y: 2.6 }
                        XYPoint { x: 3.4; y: 2.3 }
                        XYPoint { x: 4.1; y: 3.1 }
                    }

                }

            }
        }
    }
}
