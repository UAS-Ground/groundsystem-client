import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtCharts 2.0
import QtQuick.Templates 2.0
GroundSystemLayout {
    id:rootLayout
    Rectangle {
        anchors.fill: parent
        color: rootLayout.colors["light"]
        ColumnLayout {
            anchors.fill: parent
            Rectangle {
                id: leftColRect
                Layout.fillWidth: true
                Layout.preferredHeight:parent.height * 0.5
                color: rootLayout.colors["light"]
                ColumnLayout {
                    anchors.fill: parent
                    Rectangle {
                        id: sensorSectionLabelRect
                        Layout.fillWidth: true
                        Layout.preferredHeight: sensorRectLabel.implicitHeight
                        color: rootLayout.colors["dark"]
                        Label {
                            text: "ACTIVE SENSORS"
                            id: sensorRectLabel
                            anchors.margins: 10
                            color: rootLayout.colors["xlight"]
                            anchors.centerIn: parent
                            font.pixelSize: 30
                            font.bold: true
                            font.family: "Nimbus Mono L"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height - sensorSectionLabelRect.height
                        Flickable {
                            width:parent.width * 2
                            height: parent.height
                            flickableDirection: Flickable.HorizontalFlick
                            contentWidth: flickRect.width
                            Rectangle {
                                id: flickRect
                                width: sensorLayout.implicitWidth
                                height: parent.height
                                color: rootLayout.colors["neutral"]
                                RowLayout{
                                    id: sensorLayout
                                    height: parent.height
                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Pressure")
                                        masterColors: rootLayout.colors
                                    }
                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#18FFFF"
                                    }
                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Acidity")
                                        masterColors: rootLayout.colors
                                    }
                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Visibility")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#D50000"
                                    }
                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Radiation")
                                        masterColors: rootLayout.colors
                                    }
                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#FFA000"
                                    }
                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }
                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#18FFFF"
                                    }
                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight:parent.height * 0.5
                color: rootLayout.colors["light"]
                ColumnLayout {
                    anchors.fill: parent
                    Rectangle {
                        id: healthSectionLabelRect
                        Layout.fillWidth: true
                        Layout.preferredHeight: healthRectLabel.implicitHeight
                        color: rootLayout.colors["dark"]
                        Label {
                            text: "MACHINE HEALTH"
                            id: healthRectLabel
                            anchors.margins: 10
                            color: rootLayout.colors["xlight"]
                            anchors.centerIn: parent
                            font.pixelSize: 30
                            font.bold: true
                            font.family: "Nimbus Mono L"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height - healthSectionLabelRect.height
                        color: rootLayout.colors["neutral"]
                        Flickable {
                            id: sensorGraphLayoutFlickable
                            width: parent.width
                            height: parent.height
                            flickableDirection: Flickable.HorizontalFlick
                            Rectangle {
                                id: sensorGraphLayoutRect
                                width: sensorGraphLayout.implicitWidth
                                height: parent.height
                                color: rootLayout.colors["neutral"]
                                RowLayout{
                                    id: sensorGraphLayout
                                    height: parent.height
                                    width: parent.width
                                    SensorGaugeView {
                                        id: fuelGaugeView
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Fuel")
                                        masterColors: rootLayout.colors
                                    }
                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.preferredWidth: sensorGraphLayoutFlickable.width - fuelGaugeView.width - batteryGaugeView.width
                                        color: rootLayout.colors["light"]
                                        Image {
                                            width: parent.height * 0.9
                                            height: parent.height * 0.9
                                            anchors.centerIn: parent
                                            id: droneHealthImage
                                            source: "png/drone-512.png"
                                        }
//                                        Rectangle {
//                                            color: "#CC00FF00"
//                                            anchors.top: droneHealthImage.top
//                                            anchors.left: droneHealthImage.left
//                                            width: droneHealthImage.width * 0.25
//                                            height: droneHealthImage.height* 0.25
//                                        }
                                    }
                                    SensorGaugeView {
                                        id: batteryGaugeView
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Battery")
                                        masterColors: rootLayout.colors
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
