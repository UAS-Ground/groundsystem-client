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
 * @file CameraThread.h
 * @brief Listens to the camera in a separate thread
 * @author Ayberk Özgür
 * @version 1.0
 * @date 2014-09-23
 */

/**
 * MODIFIED BY: CSULA UAS Ground Systems Team
 * @date Spring 2017
 */

#ifndef CAMERATHREAD_H
#define CAMERATHREAD_H

#include <QDebug>
#include <QThread>
#include <QObject>
#include <QElapsedTimer>
#include <QVideoFrame>
#include <QUdpSocket>

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/videoio/videoio_c.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgproc/types_c.h>
#include <opencv2/objdetect.hpp>

#include <vector>
#include <iostream>
#include <fstream>

#include "EffectManager.h"

class ROSCameraTask : public QObject{
Q_OBJECT

public:

    ROSCameraTask(
        QVideoFrame* videoFrame, 
        unsigned char* cvImageBuf, 
        int width, 
        int height, 
        int * brightness, 
        float * contrast,
        int * effects,
        bool * captureNext,
        int * currentImageIndex
    );

    void stop();


private:
    EffectManager * effectManager;
    int * brightness; 
    float * contrast;
    int * effects;
    int image_index = 0;
    bool * captureNext;
    int * currentImageIndex;
    QUdpSocket * rosCameraSocket = NULL;
    int width;                                  ///< Width of the camera image
    int height;                                 ///< Height of the camera image
    bool running = false;                       ///< Whether the worker thread is running
    QVideoFrame* videoFrame;                    ///< Place to draw camera image to
    unsigned char* cvImageBuf;          

public slots:
    
    void doWork();


signals:
    void imageReady();
};


class CameraThread : public QObject{
Q_OBJECT

public:
    CameraThread(
        QVideoFrame* videoFrame, 
        unsigned char* cvImageBuf, 
        int width, int height, 
        int * brightness, 
        float * contrast, 
        int * effects,
        bool * captureNext,
        int * currentImageIndex
    );

    virtual ~CameraThread();
    void start();
    void stop();

private:
    QThread rosCameraThread;
    ROSCameraTask* rosTask = NULL;

signals:
    void imageReady();
};


#endif /* CAMERATHREAD_H */