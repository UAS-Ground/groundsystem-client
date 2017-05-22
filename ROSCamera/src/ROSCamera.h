/*
 * Copyright (C) 2014 EPFL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see http://www.gnu.org/licenses/.
 */

/**
 * @file ROSCamera.h
 * @brief Nice QML wrapper for camera access with OpenCV
 * @author Ayberk Özgür
 * @version 1.0
 * @date 2014-09-22
 */
/**
 * MODIFIED BY: CSULA UAS Ground Systems Team
 * @brief Nice QML wrapper for ROS camera access via boost::asio::udp socket(s)
 * @date Spring 2017
 */

#ifndef ROSCamera_H
#define ROSCamera_H

#include <QQuickItem>
#include <QCameraInfo>
#include <QList>
#include <QAbstractVideoSurface>
#include <QVideoSurfaceFormat>
#include <QSize>
#include <QMutex>
#include <QWaitCondition>
#include <QVariant>
#include <QDebug>

#include <opencv2/highgui/highgui.hpp>

#include"CameraThread.h"

Q_DECLARE_METATYPE(cv::Mat)



class ROSCamera : public QQuickItem {
Q_OBJECT
    Q_DISABLE_COPY(ROSCamera)
    Q_PROPERTY(int device READ getDevice WRITE setDevice)
    Q_PROPERTY(int currentImageIndex READ getCurrentImageIndex)
    Q_PROPERTY(QAbstractVideoSurface* videoSurface READ getVideoSurface WRITE setVideoSurface)
    Q_PROPERTY(QSize size READ getSize WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(QStringList deviceList READ getDeviceList NOTIFY deviceListChanged)
    Q_PROPERTY(QVariant cvImage READ getCvImage NOTIFY cvImageChanged)

public:
    ROSCamera(QQuickItem* parent = 0);
    ~ROSCamera();
    int getDevice() const;
    int getCurrentImageIndex() const;
    void setDevice(int device);
    QSize getSize() const;
    void setSize(QSize size);
    QStringList getDeviceList() const;
    QAbstractVideoSurface* getVideoSurface() const;
    void setVideoSurface(QAbstractVideoSurface* videoSurface);
    QVariant getCvImage();

signals:
    void sizeChanged();
    void deviceListChanged();
    void cvImageChanged();

private:

#ifdef ANDROID
    const QVideoFrame::PixelFormat VIDEO_OUTPUT_FORMAT = QVideoFrame::PixelFormat::Format_YV12;
#else
    const QVideoFrame::PixelFormat VIDEO_OUTPUT_FORMAT = QVideoFrame::PixelFormat::Format_ARGB32;
#endif
    bool captureNext = false;
    int effects = 0;
    int brightness = 50;
    float contrast = 1.5;
    int device = 0;                                         ///< The camera device number
    int currentImageIndex = 0;
    QStringList deviceList;                                 ///< The list of available devices, indices corresponding to device indices
    QSize size;                                             ///< The desired camera resolution
    CameraThread* thread = NULL;             
    QVideoFrame* videoFrame = NULL;                         ///< Object that contains the image buffer to be presented to the video surface
    QAbstractVideoSurface* videoSurface = NULL;
    bool exportCvImage = false;                             ///< Whether to export the CV image
    cv::Mat cvImage;                                        ///< Buffer to export the camera image to
    unsigned char* cvImageBuf = NULL;
    void update();
    void allocateCvImage();
    void allocateVideoFrame();

public slots:
    void setContrast(float contrast);
    void setBrightness(int brightness);
    void addEffect(int effect);
    void removeEffect(int effect);
    void removeAllEffects();
    void changeParent(QQuickItem* parent);
    void captureNextFrame();

private slots:
    void imageReceived();
};

#endif /* ROSCamera_H */

