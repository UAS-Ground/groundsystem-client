import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1


Item {
    id: gsLayout
    property var myVar: null
    property var colors: colorsList[0]

    property var effectsEnum: {
        "faceDetection": 0,
        "licenseDetection": 1,
        "gunDetection": 2
    }

    property var colorsList: [
        {
            "light":"#424242",
            "dark":"#212121",
            "neutral":"#303030",
            "xlight":"#E0E0E0"
        },
        {
            "light":"#7986CB",
            "dark":"#1A237E",
            "neutral":"#5C6BC0",
            "xlight":"#C5CAE9"
        },
        {
            "light":"#BCAAA4",
            "dark":"#3E2723",
            "neutral":"#A1887F",
            "xlight":"#D7CCC8"
        }

    ]



}
