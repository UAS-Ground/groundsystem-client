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
    property var gaugeBarColor: null
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


                RowLayout {
                    anchors.fill: parent

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: (parent.width/2) - (gauge.implicitWidth/2)
                        color: rectColor
                    }
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: gauge.implicitWidth
                        color: rectColor

                        // Based on: http://doc.qt.io/qt-5/styling-gauge.html
                        Gauge {
                            id: gauge
                            value: 50
                            tickmarkStepSize: 20
                            minorTickmarkCount: 1
                            font.pixelSize: 15
                            height: parent.height

                            style: GaugeStyle {
                                valueBar: Rectangle {
                                    color: gaugeBarColor
                                    implicitWidth: 28
                                }

                                foreground: null

                                tickmark: Item {
                                    implicitWidth: 8
                                    implicitHeight: 4

                                    Rectangle {
                                        x: control.tickmarkAlignment === Qt.AlignLeft
                                            || control.tickmarkAlignment === Qt.AlignTop ? parent.implicitWidth : -28
                                        width: 28
                                        height: parent.height
                                        color: "#ffffff"
                                    }
                                }

                                minorTickmark: Item {
                                    implicitWidth: 8
                                    implicitHeight: 2

                                    Rectangle {
                                        x: control.tickmarkAlignment === Qt.AlignLeft
                                            || control.tickmarkAlignment === Qt.AlignTop ? parent.implicitWidth : -28
                                        width: 28
                                        height: parent.height
                                        color: "#ffffff"
                                    }
                                }
                            }
                        }

                    }
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: (parent.width/2) - (gauge.implicitWidth/2)
                        color: rectColor
                    }



                }


//                Gauge {
//                    minimumValue: 0
//                    value: 50
//                    maximumValue: 100
//                    id: gauge
//                    anchors.fill: parent
//                    anchors.centerIn: parent
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    anchors.margins: 30



//                    Behavior on value {
//                        NumberAnimation {
//                            duration: 1000
//                        }
//                    }
//                }
            }
        }
    }
}
