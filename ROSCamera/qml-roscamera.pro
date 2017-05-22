TEMPLATE = lib
TARGET = ROSCameraplugin

CONFIG += qt plugin c++11 nostrip
CONFIG -= android_install

QT += qml quick multimedia

QMAKE_CXXFLAGS -= -O2
QMAKE_CXXFLAGS_RELEASE -= -O2

QMAKE_CXXFLAGS += -O3
QMAKE_CXXFLAGS_RELEASE += -O3

TARGET = $$qtLibraryTarget($$TARGET)
uri = ROSCamera

HEADERS += \
    src/ROSCamera.h \
    src/ROSCameraPlugin.h \
    src/EffectManager.h \
    src/CameraThread.h

SOURCES += \
    src/ROSCamera.cpp \
    src/ROSCameraPlugin.cpp \
    src/EffectManager.cpp \
    src/CameraThread.cpp

LIBS += -lboost_system -lboost_thread

LIBS += -L$$HOME/OpenCV/platforms/build-desktop/lib -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_videoio -lopencv_objdetect -lopencv_imgcodecs

android {
    HEADERS += \
        src/CVCaptureAndroid.h
    SOURCES += \
        src/CVCaptureAndroid.cpp

    #Enable automatic NEON vectorization
    QMAKE_CXXFLAGS -= -mfpu=vfp
    QMAKE_CXXFLAGS_RELEASE -= -mfpu=vfp
    QMAKE_CXXFLAGS += -mfpu=neon -ftree-vectorize -ftree-vectorizer-verbose=1 -mfloat-abi=softfp
    QMAKE_CXXFLAGS_RELEASE += -mfpu=neon -ftree-vectorize -ftree-vectorizer-verbose=1 -mfloat-abi=softfp

    INCLUDEPATH += $(ANDROID_STANDALONE_TOOLCHAIN)/sysroot/usr/share/opencv/sdk/native/jni/include
    LIBS += -L$(ANDROID_STANDALONE_TOOLCHAIN)/sysroot/usr/share/opencv/sdk/native/libs/armeabi-v7a/
    LIBS += -lopencv_androidcamera
}

OTHER_FILES += qmldir roscamera.types

#Install plugin library, qmldir and types
qmldir.files = qmldir
types.files = roscamera.types
unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    types.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir types
}

