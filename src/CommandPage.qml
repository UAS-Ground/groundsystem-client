import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.6
import QtLocation 5.6
import QtQuick.Extras 1.4
import "mapviewer"

GroundSystemLayout {
    id:rootLayout
    myVar: "hello command var"
    Connections {
        target: ROSController
    }
    ListModel {
        id: myList
    }
    GroundSystemModal {
        id: cancelMissionDialog
        title: "Confirm Cancel Mission"
        standardButtons: Dialog.Ok
        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2
            Label {
                id:selectColorLabel
                text: qsTr("Are you sure you want to cancel the current mission?")
                color: "white"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }
        }
        onAccepted: {
            console.log("user canceled current mission...");
            mapViewer.map.clearWaypoints();
            ROSController.sendCommand();
        }
    }
    GroundSystemModal {
        id: allWaypointsDialog
        title: "All Waypoints"
        standardButtons: Dialog.Ok | Dialog.Cancel
        Component.onCompleted: {
            console.log("just FINISHED making waypoints dialog...");
        }
        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2
            ListView {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 180; height: 200
                model: myList
                delegate: Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.margins: 12
                    color: "white"
                    text: latitude + " , " + longitude
                }
            }
        }
    }
    GroundSystemModal {
        id: commandHelpDialog
        title: "Help"
        standardButtons: Dialog.Ok | Dialog.Cancel
        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2
            Label {
                id:commandHelpDialogLabel
                text: qsTr("Command Help")
                color: "white"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }
        }
    }
    GroundSystemModal {
        id: immediateMoveDialog
        title: "Immediate Goal"
        standardButtons: Dialog.Ok | Dialog.Cancel
        contentItem: Rectangle {
            id: immediateMoveDialogRootRect
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2
            RowLayout {
                anchors.fill: parent
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.333
                    color: immediateMoveDialogRootRect.color
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.333
                    color: "transparent"
                    ColumnLayout {
                        anchors.fill: parent
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            Label {
                                id:immediateMoveDialogLabel
                                text: qsTr("Set Immediate Goal")
                                color: "white"
                                font.pixelSize: 18
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            TextField {
                                id: latTextField
                                placeholderText: qsTr("latitude")
                            }
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            TextField {
                                id: lonTextField
                                placeholderText: qsTr("longitude")
                            }
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            TextField {
                                id: altTextField
                                placeholderText: qsTr("altitude")
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.333
                    color: "transparent"
                }
            }
        }
        onAccepted: {
            var coordinate = {
                longitude: parseFloat(lonTextField.text),
                latitude: parseFloat(latTextField.text),
                altitude: parseFloat(altTextField.text)
            };
            for(var key in coordinate)
            {
                console.log("   " + key + ": " + coordinate[key]);
            }
            ROSController.sendCommand(coordinate.longitude, coordinate.latitude, coordinate.altitude);
        }
    }
    RowLayout {
        anchors.fill: parent
        Rectangle {
            id: leftCol
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.1
            color: rootLayout.colors["dark"]
            ColumnLayout {
                anchors.fill: parent
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    GroundSystemFeatureButton {
                        Image {
                            id: targetIcon
                            source: "png/earth-globe.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var myWaypointList = mapViewer.map.getWaypointList();
                                console.log("just called getWaypointList()... ")
                                console.log("    got " + myWaypointList.length + " waypoints... ")
                                for(var key in myWaypointList){
                                    console.log("-- " + key + ": " + myWaypointList[key]);
                                    myList.append({
                                        latitude: myWaypointList[key].latitude,
                                        longitude: myWaypointList[key].longitude
                                    });
                                }
                                allWaypointsDialog.open();
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    anchors.margins: 50
//                    color: "green"
                    RowLayout {
                        width: parent.width
                        height: parent.height - altitudeLabel.height
                        id: altControlLayout
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            anchors.margins: 30
                            color: "transparent"
                            radius: 20
                            border.color: rootLayout.colors["dark"]
                            border.width: 5
                            Gauge {
                                id:altGauge
                                height: slider.height
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.top: parent.top
                                anchors.right: parent.right
                                maximumValue: 1220
                                minimumValue: 20
                                tickmarkStepSize: (maximumValue - minimumValue) / 10
                                style: GaugeStyle {
                                    valueBar: Rectangle {
                                        width: 0
                                        anchors.fill: parent
                                        color: "transparent"
                                    }
                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                    }
                                }
                            }
                        }
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            anchors.margins: 30
                            color: "transparent"
                            radius: 20
                            border.color: rootLayout.colors["dark"]
                            border.width: 5
                            Slider {
                                anchors.top: parent.top
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                tickmarksEnabled: true
                                id: slider
                                value: 0.5
                                orientation: Qt.Vertical
                                style: SliderStyle {
                                    groove: Rectangle {
                                        implicitWidth: 200
                                        implicitHeight: 8
                                        color: "gray"
                                        radius: 8
                                    }
                                    handle: Rectangle {
                                        anchors.centerIn: parent
                                        color: control.pressed ? "white" : "lightgray"
                                        border.color: "gray"
                                        border.width: 2
                                        implicitWidth: 10
                                        implicitHeight: 34
                                        //radius: 12
                                    }
                                }
                                onValueChanged: {
                                    console.log("value is now " + slider.value)
                                }
                            }
                        }
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        //y: slider.y + slider.height
                        anchors.top: altControlLayout.bottom
                        font.bold: true
                        color: "white"
                        id: altitudeLabel
                        text: qsTr(("" + (slider.value.toFixed(2) * 1200 + 20)).substring(0, 6) + " ft" )
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    GroundSystemFeatureButton {
                        Image {
                            id: cancelIcon
                            source: "png/remove-button.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                cancelMissionDialog.open();
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.8
            //color: rootLayout.colors["red"]
            color: "yellow"
            MapViewer {
                id: mapViewer
                anchors.fill: parent
            }
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.1
            color: rootLayout.colors["dark"]
            id: rightCol
            ColumnLayout {
                anchors.fill: parent
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: rightCol.color
                    GroundSystemFeatureButton {
                        id: pushPinRect
                        property bool clicked: false
                        color: clicked ? rootLayout.colors["light"] : rootLayout.colors["xlight"];
                        Image {
                            id: waypointIcon
                            source: "png/paper-push-pin.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                pushPinRect.clicked = !pushPinRect.clicked;
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    GroundSystemFeatureButton {
                        Image {
                            id: customGoalIcon
                            source: "png/move-option.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: immediateMoveDialog.open()
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    GroundSystemFeatureButton {
                        Image {
                            id: helpIcon
                            source: "png/question-sign.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                commandHelpDialog.open();
                            }
                        }
                    }
                }
            }
        }
    }
}
