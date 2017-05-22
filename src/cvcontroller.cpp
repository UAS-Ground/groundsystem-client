#include "cvcontroller.h"
#include <QDebug>
//#include <opencv2/imgproc/imgproc.hpp>
//#include <opencv/cvwimage.h>
//#include <opencv/cv.hpp>
#include <vector>

CVController::CVController(QObject *parent) : QObject(parent), currentImageNum(0)
{

}


//void CVController::processImageFrame(cv::Mat frame)
//{
//    qDebug() << "Looking at cv::Mat = " << frame.data;
////    std::cout << "r (default) = \n" << frame << ";" << endl << endl;
////    std::cout << "r (c) = \n" << format(frame, cv::Formatter::FMT_C) << ";\n";

////    cv::Mat greyMat;
////    cv::cvtColor(frame, greyMat, cv::COLOR_BGR2GRAY);
////    //cv::Mat toDisplay(cv::Size(800, 600), CV_8UC3, cv::Scalar(50, 200, 50));
////    cv::imshow("Grayscale Test", greyMat);
////    cv::waitKey();

////    cv::String filename = "saved_image_";
////    filename += this->currentImageNum + ".jpg";
////    std::vector<int> params;
////    // cv::imwrite(filename, frame, params );
////    // cv::imwrite()

//}
