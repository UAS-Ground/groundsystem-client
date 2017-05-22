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
 * @file CameraThread.cpp
 * @brief Listens to the camera in a separate thread
 * @author Ayberk Özgür
 * @version 1.0
 * @date 2014-09-23
 */
/**
 * MODIFIED BY: CSULA UAS Ground Systems Team
 * @date Spring 2017
 */
#include"CameraThread.h"
#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using boost::asio::ip::udp;
using namespace std;
using namespace cv;

#define FRAME_HEIGHT 720
#define FRAME_WIDTH 1280
#define FRAME_INTERVAL (1000/30)
#define PACK_SIZE 4096 //udp pack size; note that OSX limits < 8100 bytes
#define ENCODE_QUALITY 80
#define UDPMAX 65507

udp::endpoint remote_endpoint;
std::vector<uchar> videoBuffer;
char *buff = NULL;



ROSCameraTask::ROSCameraTask(
    QVideoFrame* videoFrame, 
    unsigned char* cvImageBuf, 
    int width, 
    int height, 
    int * brightness, 
    float * contrast, 
    int * effects,
    bool * captureNext,
    int * currentImageIndex )
{
    std::cout << "in  ROSCameraTask::ROSCameraTask()...\n";
    this->running = true;
    this->videoFrame = videoFrame;
    this->cvImageBuf = cvImageBuf;
    this->width = width;
    this->height = height;
    this->brightness = brightness;
    this->contrast = contrast;
    this->effects = effects;
    this->effectManager = new EffectManager(effects);
    this->captureNext = captureNext;
    this->currentImageIndex = currentImageIndex;
}
void ROSCameraTask::doWork()
{
    std::cout << "in  ROSCameraTask::doWork()...\n";
/* do boost stuff  */
    char buffer[65507];
    boost::asio::io_service io_service;
    udp::socket socket(io_service, udp::endpoint(udp::v4(), 8080));
    int recvMsgSize;
    int counter = 0;


    if(videoFrame)
        videoFrame->map(QAbstractVideoBuffer::ReadOnly);
    #ifndef ANDROID //Assuming desktop, RGB camera image and RGBA QVideoFrame
        cv::Mat screenImage;
        if(videoFrame)
        {
            screenImage = cv::Mat(height,width,CV_8UC4,videoFrame->bits());
        }
        else
        {
            std::cout << "in  ROSCameraTask::doWork(), NO VIDEO FRAME!?...\n";
        }
    #endif

    while(running)
    {
        if(counter < 50)
        {
            //std::cout << "in  ROSCameraTask::doWork() iteration " << (++counter) << "...\n";

        }
        boost::array<char, UDPMAX> recv_buf;
        udp::endpoint remote_endpoint;
        boost::system::error_code error;
        int inner_count = 0;
        do {
            if(inner_count < 50)
            {
                //std::cout << "in  ROSCameraTask::doWork() do-while, iteration " << (++inner_count) << "...\n";

            }
            recvMsgSize = socket.receive_from(boost::asio::buffer(buffer, 65507), remote_endpoint, 0, error);
//sock.recvFrom(buffer, BUF_LEN, sourceAddress, sourcePort);
        } while (recvMsgSize > sizeof(int));
        int total_pack = ((int * ) buffer)[0];
        //cout << "expecting length of packs:" << total_pack << endl;
        char * longbuf = new char[PACK_SIZE * total_pack];
        for (int i = 0; i < total_pack; i++) {
            recvMsgSize = socket.receive_from(boost::asio::buffer(buffer, 65507), remote_endpoint, 0, error);
            if (recvMsgSize != PACK_SIZE) {
                cerr << "Received unexpected size pack:" << recvMsgSize << endl;
                continue;
            }
            memcpy( & longbuf[i * PACK_SIZE], buffer, PACK_SIZE);
        }
        //cout << "Received packet from " << remote_endpoint.address().to_string() << ":" << remote_endpoint.port() << endl;
        Mat rawData = Mat(1, PACK_SIZE * total_pack, CV_8UC1, longbuf);
        Mat frame = imdecode(rawData, CV_LOAD_IMAGE_COLOR);
        if (frame.size().width == 0) {
            cerr << "decode failure!" << endl;
            continue;
        }
        int count = 0;
        std::ofstream logFile;
        float contrastControl = 2.6;
        int brightnessControl = 88;
        bool savedImg = false;
        cv::Mat customMat;
        logFile.open("/home/tyler/UAV_LOG_FILE.txt");
        unsigned char* cameraFrame = frame.data;
        #ifdef ANDROID
            memcpy(frame.data,cameraFrame,height*width);
            convertUVsp2UVp(cameraFrame + height*width, frame.data + height*width, height/2*width/2);
        #else
            cv::Mat tempMat(height,width,CV_8UC3,cameraFrame);
            cv::Mat frame_gray;
            cv::cvtColor(tempMat,customMat,cv::COLOR_RGB2RGBA);
            
            customMat.convertTo(screenImage, -1, *(this->contrast), *(this->brightness));   
            count++;
        #endif
        if(cvImageBuf){
            #ifdef ANDROID //Assume YUV420sp camera image
                    memcpy(cvImageBuf,cameraFrame,height*width*3/2);
            #else //Assuming desktop, RGB camera image
                    memcpy(cvImageBuf,cameraFrame,height*width*3);
            #endif
        } else {
            //std::cout << "cvImageBuf is NULL!\n";
        }
        if(*(this->captureNext))
        {
            *(this->captureNext) = false;

            std::vector<int> compression_params;
            compression_params.push_back(CV_IMWRITE_PNG_COMPRESSION);
            compression_params.push_back(9);
            std::stringstream ss;
            ss << "captured_imgs/image" << ++(*(this->currentImageIndex)) << ".png";



            try {
                cv::imwrite(ss.str(), screenImage, compression_params);
            }
            catch (std::runtime_error& ex) {
                fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
                continue;
            }
        }
        emit imageReady();
    }
}


void ROSCameraTask::stop()
{
    running = false;
}
CameraThread::CameraThread(
    QVideoFrame* videoFrame, 
    unsigned char* cvImageBuf, 
    int width, int height, int * brightness, 
    float * contrast, 
    int * effects,
    bool * captureNext,
    int * currentImageIndex)
{

    std::cout << "in CameraThread()...\n";
    printf("\trolling with height %d, and width: %d\n", height, width);

    std::cout << "in CameraThread(), making rosTask...\n";
    rosTask = new ROSCameraTask(
        videoFrame,
        cvImageBuf,
        width,height, 
        brightness, 
        contrast, 
        effects,
        captureNext,
        currentImageIndex
    );
    std::cout << "in CameraThread(), rosTask created...\n";
    rosTask->moveToThread(&rosCameraThread);
    std::cout << "in CameraThread(), rosTask moved to thread...\n";
    connect(&rosCameraThread, SIGNAL(started()), rosTask, SLOT(doWork()));
    std::cout << "in CameraThread(), rosTask slots connected with thread signals...\n";
    connect(rosTask, SIGNAL(imageReady()), this, SIGNAL(imageReady()));
    std::cout << "in CameraThread(), rosTask signals connected with thread signals...\n";
    
}
CameraThread::~CameraThread()
{
    stop();
    delete rosTask;
}
void CameraThread::start()
{
    rosCameraThread.start();
}
void CameraThread::stop()
{
    if(rosTask != NULL)
    {
        rosTask->stop();
    }
    rosCameraThread.quit();
    rosCameraThread.wait();
}
