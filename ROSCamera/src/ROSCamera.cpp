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
 * @file ROSCamera.cpp
 * @brief Implementation of the QML wrapper for OpenCV camera access
 * @author Ayberk Özgür
 * @version 1.0
 * @date 2014-09-22
 */
/**
 * MODIFIED BY: CSULA UAS Ground Systems Team
 * @brief 
 **** REMOVED OpenCV camera access
 **** ADDED OpenCV handling of UDP socket stream
 * @date Spring 2017
 */

#include"ROSCamera.h"



ROSCamera::ROSCamera(QQuickItem* parent) :
    QQuickItem(parent)
{
    //Build the list of available devices
    QList<QCameraInfo> cameras = QCameraInfo::availableCameras();
    for(const auto& cameraInfo : cameras){
        QString device;
        device += cameraInfo.deviceName();
        device += " - ";
        device += cameraInfo.description();
        deviceList << device;
    }
    emit deviceListChanged();

    std::cout << "in ROSCamera::ROSCamera constructor...\n";
    size = QSize(320,240);

    connect(this, &QQuickItem::parentChanged, this, &ROSCamera::changeParent);
    update();
}

ROSCamera::~ROSCamera()
{
    if(thread)
        thread->stop();
    delete thread;
}

void ROSCamera::changeParent(QQuickItem* parent)
{
    //FIXME: we probably need to disconnect the previous parent
    //TODO: probably a good idea to stop the camera (and restart it if we are auto-starting in this context)
}

int ROSCamera::getDevice() const
{
    return device;
}

int ROSCamera::getCurrentImageIndex() const
{
    return currentImageIndex;
}
void ROSCamera::setDevice(int device)
{
    if(device >= 0 && this->device != device){
        this->device = device;
        update();
    }
}

QSize ROSCamera::getSize() const
{
    return size;
}

void ROSCamera::setSize(QSize size)
{
    if(this->size.width() != size.width() || this->size.height() != size.height()){
        this->size = size;
        update();
        emit sizeChanged();
    }
}

QVariant ROSCamera::getCvImage()
{
    if(!exportCvImage){
        exportCvImage = true;
        update();
    }
    QVariant container(QVariant::UserType);
    container.setValue(cvImage);
    return container;
}

QStringList ROSCamera::getDeviceList() const
{
    return deviceList;
}

void ROSCamera::allocateCvImage()
{
    cvImage.release();
    delete[] cvImageBuf;
#ifdef ANDROID
    cvImageBuf = new unsigned char[size.width()*size.height()*3/2];
    cvImage = cv::Mat(size.height()*3/2,size.width(),CV_8UC1,cvImageBuf);
#else
    cvImageBuf = new unsigned char[size.width()*size.height()*3];
    cvImage = cv::Mat(size.height(),size.width(),CV_8UC3,cvImageBuf);
#endif
}

void ROSCamera::allocateVideoFrame()
{
#ifdef ANDROID
    videoFrame = new QVideoFrame(size.width()*size.height()*3/2,size,size.width(),VIDEO_OUTPUT_FORMAT);
#else
    videoFrame = new QVideoFrame(size.width()*size.height()*4,size,size.width()*4,VIDEO_OUTPUT_FORMAT);
#endif
}

void ROSCamera::update()
{
    printf("Opening camera %d, width: %d, height: %d", device, size.width(), size.height());

    //Destroy old thread, camera accessor and buffers
    delete thread;
    if(videoFrame && videoFrame->isMapped())
        videoFrame->unmap();
    delete videoFrame;
    videoFrame = NULL;
    delete[] cvImageBuf;
    cvImageBuf = NULL;

    //Create new buffers, camera accessor and thread
    if(exportCvImage)
        allocateCvImage();
    if(videoSurface)
        allocateVideoFrame();
    thread = new CameraThread(
        videoFrame,
        cvImageBuf,
        size.width(),
        size.height(), 
        &(this->brightness), 
        &(this->contrast), 
        &(this->effects), 
        &(this->captureNext), 
        &(this->currentImageIndex)
        );
    connect(thread,SIGNAL(imageReady()), this, SLOT(imageReceived()));

    //Open newly created device
    try{
        if(videoSurface){
            if(videoSurface->isActive())
                videoSurface->stop();
            if(!videoSurface->start(QVideoSurfaceFormat(size,VIDEO_OUTPUT_FORMAT)))
                std::cout << "Could not start QAbstractVideoSurface, error: %d",videoSurface->error();
        }
        thread->start();
        printf("Opened camera %d",device);
        
    }
    catch(int e){
        printf("Exception %d",e);
    }
}

void ROSCamera::imageReceived()
{
    //std::cout << "in ROSCamera::imageReceived()...\n";
    //Update VideoOutput
    if(videoSurface)
    {
        //std::cout << "in ROSCamera::imageReceived(), videoSurface is NOT NULL\n";
        if(!videoSurface->present(*videoFrame))
        {
            std::cout << "in ROSCamera::imageReceived(), Some error in videoSurface->present(*videoFrame)\n";
            printf("Could not present QVideoFrame to QAbstractVideoSurface, error: %d",videoSurface->error());
        }
        else
        {
            //std::cout << "in ROSCamera::imageReceived(), videoSurface->present(*videoFrame) was successful\n";

        }
    }
    else
    {
        //std::cout << "in ROSCamera::imageReceived(), videoSurface is NULL\n";

    }

    //Update exported CV image
    if(exportCvImage){
        emit cvImageChanged();
    }
}

QAbstractVideoSurface* ROSCamera::getVideoSurface() const
{
    return videoSurface;
}

void ROSCamera::setVideoSurface(QAbstractVideoSurface* surface)
{
    if(videoSurface != surface){
        videoSurface = surface;
        update();
    }
}


void ROSCamera::setBrightness(int brightness)
{
    qDebug() << "in ROSCamera::setBrightness(" << brightness << ")";
    this->brightness = brightness;
}
void ROSCamera::setContrast(float contrast)
{
    qDebug() << "in ROSCamera::setContrast(" << contrast << ")";
    this->contrast = contrast;
}
//bool * licenseDetectionActive
void ROSCamera::addEffect(int effect)
{
    std::cout << " in ROSCamera::addEffect(" << effect <<")...\n";

/*
    Effect effectToAdd = EffectManager::convertIntToEffect(effect);
    this->effectManager.addEffect(effectToAdd);
    this->effectManager.printEffectBits();
*/

    std::cout << "in ROSCamera::addEffect() with effect " << effect << "\n";
    int bit = 1 << effect;
    std::cout << "\tsetting bit represented by " << bit << "\n";
    this->effects |= bit;
}
void ROSCamera::removeEffect(int effect)
{
    std::cout << " in ROSCamera::removeEffect(" << effect <<")...\n";
/*
    Effect effectToRemove = EffectManager::convertIntToEffect(effect);
    this->effectManager.removeEffect(effectToRemove);
    this->effectManager.printEffectBits();
    */
    int bit = 1 << effect;
    this->effects &= ~bit;
}

void ROSCamera::removeAllEffects()
{
    this->effects = 0;
}

void ROSCamera::captureNextFrame()
{
    this->captureNext = true;
}