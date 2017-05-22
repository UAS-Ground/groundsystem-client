import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.1

ApplicationWindow {
    visible: true
    width: 1200
    height: 900

    Component.onCompleted: {
        console.log("in onCompleted!")
    }





    Dialog {
        id: settingsDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: parent.height/ 2
        parent: ApplicationWindow.overlay

        focus: true
        modal: true
        title: "Settings"
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2


            ColumnLayout {
                anchors.fill: parent



                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: selectColorLabel.height + 5
                    color: "#303030"

                    Label {
                        id:selectColorLabel
                        text: qsTr("Color Theme:")
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: colorSelector.height + 5
                    color: "#303030"

                    ComboBox {
                        id: colorSelector
                        model: ["Dark", "Ocean", "Desert"]
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }


            }

        }

    }

    header: ToolBar {
        anchors.top: parent.top
        width: parent.width
        height: menuButton.implicitHeight

        ToolButton {
            id: menuButton
            anchors.right: parent.right
            contentItem: Image {
                fillMode: Image.Pad
                horizontalAlignment: Image.AlignRight
                verticalAlignment: Image.AlignVCenter
                source: "png/vertical-ellipsis.png"
                height: parent.height * 0.75
                anchors.centerIn: parent
            }
            onClicked: optionsMenu.open()

            Menu {
                id: optionsMenu
                x: parent.width - width
                transformOrigin: Menu.TopRight

                MenuItem {
                    text: "Credits"
                    onTriggered: null
                }
                MenuItem {
                    text: "About"
                    onTriggered: null
                }
                MenuItem {
                    text: "Settings"
                    onTriggered: settingsDialog.open()
                }
            }
        }
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        CommandPage {

        }

        DroneViewPage {

        }

        SensorView {

        }

    }

    footer: TabBar {
        anchors.bottom: parent.bottom
        width: parent.width
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Command")
        }
        TabButton {
            text: qsTr("Camera")
        }

        TabButton {
            text: qsTr("Sensors/Health")
        }
    }
}
