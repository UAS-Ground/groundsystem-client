import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import ROSCamera 1.0;
import QtMultimedia 5.5
GroundSystemLayout {
    id:rootLayout
    property Dial ctrstDial: contrastDial


    GroundSystemModal {
        id: viewPhotosDialog
        title: "View Photos"
        standardButtons: Dialog.Ok | Dialog.Cancel
        property int currentImageIndex: 0
        property int maxImageIndex: 0
        contentItem: Rectangle {
            id: viewPhotosDialogRootRect
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2


            RowLayout {
                anchors.fill: parent


                Rectangle{
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.15
                    color: "transparent"
                    Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.9
                        height: width
                        source: "png/angle-pointing-to-left.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Prev image button clicked: with imageIndex " + viewPhotosDialog.currentImageIndex + " and maxImageIndex " + viewPhotosDialog.maxImageIndex);
                                if(viewPhotosDialog.currentImageIndex > 1) {
                                    viewPhotosDialog.currentImageIndex--;
                                    viewPhotosDialog.updatePhoto();
                                }
                                else
                                {
                                    console.log("Condition fails");
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.7
                    color: "transparent"

                    Image {
                        id: currentImage
                        anchors.centerIn: parent
                        width: parent.width
                    }
                }

                Rectangle{
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.15
                    color: "transparent"
                    Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.9
                        height: width
                        source: "png/angle-arrow-pointing-to-right.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Next image button clicked: with imageIndex " + viewPhotosDialog.currentImageIndex + " and maxImageIndex " + viewPhotosDialog.maxImageIndex);
                                if(viewPhotosDialog.currentImageIndex < viewPhotosDialog.maxImageIndex) {
                                    viewPhotosDialog.currentImageIndex++;
                                    viewPhotosDialog.updatePhoto();
                                }
                                else
                                {
                                    console.log("Condition fails");
                                }
                            }
                        }
                    }
                }
            }

        }
        function displayPhotos(){
            console.log('im in displayPhotos()');
            maxImageIndex = camera.currentImageIndex;
            viewPhotosDialog.currentImageIndex = viewPhotosDialog.maxImageIndex;
            console.log('maxImageIndex is ' + maxImageIndex);
            console.log('currentImageIndex is ' + currentImageIndex);
            if(maxImageIndex > 0){
                currentImage.source = applicationPath + "captured_imgs/image" + maxImageIndex + ".png";
            }
            console.log('Done displaying image..');
        }
        function updatePhoto(){
            console.log('in updatePhoto(int) with currentImageIndex ' + currentImageIndex);
            if(currentImageIndex > 0){
                currentImage.source = applicationPath + "captured_imgs/image" + currentImageIndex + ".png";
            }
            console.log('Done displaying image..');
        }
    }


    GroundSystemModal {
        id: objectDetectionDialog
        title: "Detect Objects"
        standardButtons: Dialog.Ok | Dialog.Cancel
        contentItem: Rectangle {
            id: objectDetectionDialogRootRect
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2
            RowLayout {
                id:topRowLayout
                width: parent.width
                height: parent.height / 2
                Rectangle {
                    id: faceDetectIconRect
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 2
                    anchors.margins: 10
                    radius: 10
                    property bool clicked: false
                    color: clicked ? rootLayout.colors["light"] : rootLayout.colors["xlight"]
                    Image {
                        id: faceDetectionIcon
                        source: "png/user-shape.png"
                        anchors.centerIn: parent
                        height: parent.height * 0.7
                        width: parent.height * 0.7
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            faceDetectIconRect.clicked = !faceDetectIconRect.clicked;
                            camera.addEffect(rootLayout.effectsEnum["faceDetection"]);
                            //camera.toggleObjectDetection();
                        }
                    }
                }
                Rectangle {
                    id: licenseIconRect
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 2
                    anchors.margins: 10
                    radius: 10
                    property bool clicked: false
                    color: clicked ? rootLayout.colors["light"] : rootLayout.colors["xlight"]
                    Image {
                        id: cancelIcon
                        source: "png/license_plate.png"
                        anchors.centerIn: parent
                        height: parent.height * 0.7
                        width: parent.height * 0.7
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            faceDetectIconRect.clicked = !faceDetectIconRect.clicked;
                            //camera.toggleObjectDetection();
                            camera.addEffect(rootLayout.effectsEnum["licenseDetection"]);
                        }
                    }
                }
            }
            RowLayout {
                height: parent.height / 2
                anchors.top: topRowLayout.bottom
                width: parent.width
                Rectangle {
                    id: gunIconRect
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 2
                    radius: 10
                    property bool clicked: false
                    anchors.margins: 10
                    color: clicked ? rootLayout.colors["light"] : rootLayout.colors["xlight"]
                    Image {
                        id: licenseIcon
                        source: "png/gun.png"
                        anchors.centerIn: parent
                        height: parent.height * 0.7
                        width: parent.height * 0.7
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            faceDetectIconRect.clicked = !faceDetectIconRect.clicked;
                            camera.addEffect(rootLayout.effectsEnum["gunDetection"]);
                            //camera.toggleObjectDetection();
                        }
                    }
                }
                Rectangle {
                    id: cancelIconRect
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 2
                    anchors.margins: 10
                    radius: 10
                    property bool clicked: false
                    color: clicked ? rootLayout.colors["light"] : rootLayout.colors["xlight"]
                    Image {
                        id: trashIcon
                        source: "png/trash.png"
                        anchors.centerIn: parent
                        height: parent.height * 0.7
                        width: parent.height * 0.7
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            faceDetectIconRect.clicked = !faceDetectIconRect.clicked;
                            //camera.toggleObjectDetection();

                        }
                    }
                }
            }
//                }
//            }
        }
    }
    Connections{
        target: CVController
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
                            source: "png/bullseye.png"
                            anchors.centerIn: parent
                            height: parent.width * 0.7
                            width: parent.width * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                objectDetectionDialog.open()
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
                            id: openFolderIcon
                            source: "png/open-folder.png"
                            anchors.centerIn: parent
                            height: parent.width * 0.7
                            width: parent.width * 0.7
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                viewPhotosDialog.open();
                                viewPhotosDialog.displayPhotos();

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
                            id: faceIcon
                            source: "png/camera-retro.png"
                            anchors.centerIn: parent
                            height: parent.width * 0.7
                            width: parent.width * 0.7
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                camera.captureNextFrame();
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.8
            color: rootLayout.colors["neutral"]
            Rectangle {
                id: cameraContainerRect
                anchors.centerIn: parent
                width: 690
                height: 530
                color: rootLayout.colors["dark"]
                radius: 20
//                CVCamera {
//                    id: camera
//                    device: deviceBox.currentIndex
//                    //size: "640x480"
//                    size: "320x240"
//                    anchors.centerIn: parent
//                }

                ROSCamera {
                    id: camera
                    //size: "640x480"
                    size: "320x240"
                    anchors.centerIn: parent

                }

//                Camera {
//                    id: camera
//                }
//                VideoOutput {
//                    anchors.top: camera.top
//                    id: output
//                    source: camera
//                    anchors.fill: parent
//                    anchors.margins: 10
//                    anchors.centerIn: parent
//                }
                VideoOutput {
                    anchors.top: camera.top
                    id: output
                    source: camera
                    anchors.centerIn: parent
                }
            }
            /*RowLayout {
                width: parent.width
                height: 80
                anchors.bottom: cameraContainerRect.bottom
                Rectangle {
                    color: "transparent"
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.5
                    ComboBox {
                        id: deviceBox
                        width: parent.width * 0.5
                        anchors.centerIn: parent
                        model: camera.deviceList
                    }
                }
                Rectangle {
                    color: "transparent"
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.5
                    Rectangle {
                        property bool gazeboCamera: false
                        width: parent.width * 0.5
                        anchors.centerIn: parent
                        height: parent.height
                        id: gazeboCameraOnRect
                        color: gazeboCameraOnRect.gazeboCamera ? "red" : "yellow"
                        Text {
                            anchors.centerIn: parent
                            id: gazeboCameraOnText
                            text: gazeboCameraOnRect.gazeboCamera ? qsTr("GAZEBO ON") : qsTr("GAZEBO OFF")
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("i am in GAZEBO button's onclicked!");
                                gazeboCameraOnRect.gazeboCamera = !gazeboCameraOnRect.gazeboCamera;
                            }
                        }
                    }
                }
            }*/
        }
        Rectangle {
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
                        id: brightnessDialRect
                        Dial {
                            id: brightnessDial
                            anchors.centerIn: parent
                            height: parent.width * 0.7
                            width: parent.width * 0.7
                            property bool animate: true
                            value: 0.5
                            onValueChanged: {
                                var brightness = brightnessDial.value;
                                console.log("brightness dial is at " + brightness);
                                camera.setBrightness(Math.floor(brightness * 100.0));
                            }
                            Behavior on value {
                                enabled: true
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutCirc
                                }
                            }
                        }
                    }
                    Label {
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: brightnessDialRect.bottom
                        text: qsTr("BRIGHTNESS")
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    GroundSystemFeatureButton {
                        id: contrastDialRect
                        Dial {
                            id: contrastDial
                            height: parent.width * 0.7
                            width: parent.width * 0.7
                            anchors.centerIn: parent
                            property bool animate: true
                            value: 0.5
                            onValueChanged: {
                                var contrast = contrastDial.value;
                                //camera.setContrast(contrast);
                                console.log("contrast dial is at " + contrast);
                                camera.setContrast(contrast * 3.0);
                            }
                            Behavior on value {
                                enabled: true
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutCirc
                                }
                            }
                        }
                    }
                    Label {
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: contrastDialRect.bottom
                        text: qsTr("CONTRAST")
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color
                    GroundSystemFeatureButton {
                        id: tintDialRect
                        Dial {
                            id: tintDial
                            height: parent.width * 0.7
                            width: parent.width * 0.7
                            anchors.centerIn: parent
                            property bool animate: true
                            value: 0.5
                            Behavior on value {
                                enabled: true
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutCirc
                                }
                            }
                        }
                    }
                    Label {
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: tintDialRect.bottom
                        text: qsTr("TINT")
                    }
                }
            }
        }
    }
}
