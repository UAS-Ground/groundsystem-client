import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.6
import QtLocation 5.6
import QtQuick.Extras 1.4

Dialog {
    id: cancelMissionDialog
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: parent.width / 2
    height: parent.height/ 2
    parent: ApplicationWindow.overlay
    focus: true
    modal: true
    standardButtons: Dialog.Ok



}
