
#include "EffectManager.h"
#include <iostream>

EffectManager::EffectManager(int * effects) : effects(effects) 
{
    cv::String face_cascade_name = "/home/tyler/OpenCV/data/lbpcascades/lbpcascade_frontalface.xml";
    cv::String eyes_cascade_name = "/home/tyler/OpenCV/data/haarcascades/haarcascade_eye_tree_eyeglasses.xml";
    cv::String body_cascade_name = "/home/tyler/OpenCV/data/haarcascades/haarcascade_fullbody.xml";

    if( !face_cascade.load( face_cascade_name ) ){ printf("--(!)Error loading face cascade\n"); };
    if( !eyes_cascade.load( eyes_cascade_name ) ){ printf("--(!)Error loading eyes cascade\n");  };
    if( !body_cascade.load( body_cascade_name ) ){ printf("--(!)Error loading body_cascade \n");  };


};

void EffectManager::addEffect(Effect effect)
{
    std::cout << "in addEffect() with effect " << effect << "\n";
    int bit = 1 << effect;
    std::cout << "\tsetting bit represented by " << bit << "\n";
    *(this->effects) |= bit;
}
void EffectManager::removeEffect(Effect effect)
{

    int bit = 1 << effect;
    *(this->effects) &= ~bit;
}
// For debugging
void EffectManager::printEffectBits()
{
    std::vector<char> str;
    int effectIter = *(this->effects);
    int bitsChecked = 0;
    int bitsToCheck = sizeof(int) * 8;
    std::cout << " in printEffectBits(), about to check " << bitsToCheck << " bits\n";
    while(effectIter > 0)
    {
        std::cout << "\titeration " << bitsChecked << ", effectIter is " << effectIter << "\n";
        int bitCheck = effectIter & 1;
        std::cout << "\tbitCheck is " << bitCheck << "\n";
        char cur = bitCheck == 0 ? '0' : '1';
        effectIter >>= 1;
        str.insert(str.begin(), cur);
        bitsChecked++;
    }
    while(bitsChecked < bitsToCheck)
    {
        str.insert(str.begin(), '0');
        bitsChecked++;
    }

    std::cout << "Result:\n\t"; 
    for(int i = 0; i < str.size(); i++)
    {
        std::cout << str[i];
    }
    std::cout << "\n";  

}
Effect EffectManager::convertIntToEffect(int num)
{

    return static_cast<Effect>(num % NUMBER_OF_TYPES);
}

bool EffectManager::effectIsSet(Effect effect)
{
    return *(this->effects) & ~effect != 0;
}


void EffectManager::applyActiveEffects(cv::Mat& image)
{
    cv::Mat frame_gray;
    if(this->effectIsSet(FACE_DETECTION))
    {
        std::vector<cv::Rect> faces;

        cv::cvtColor( image, frame_gray, cv::COLOR_BGR2GRAY );
        cv::equalizeHist( frame_gray, frame_gray );

        //-- Detect faces

        face_cascade.detectMultiScale( frame_gray, faces, 1.1, 2, 0, cv::Size(80, 80) );

        for( size_t i = 0; i < faces.size(); i++ )
        {
            cv::Mat faceROI = frame_gray( faces[i] );
                //-- Draw the face
            cv::Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
            cv::ellipse( image, center, cv::Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, cv::Scalar( 255, 0, 0 ), 2, 8, 0 );

            std::vector<cv::Rect> eyes;

            //-- In each face, detect eyes
            eyes_cascade.detectMultiScale( faceROI, eyes, 1.1, 2, 0 |cv::CASCADE_SCALE_IMAGE, cv::Size(30, 30) );
            if( eyes.size() == 2)
            {
                //-- Draw the face
                cv::Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
                // cv::ellipse( customMat, center, cv::Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, cv::Scalar( 255, 0, 0 ), 2, 8, 0 );

                for( size_t j = 0; j < eyes.size(); j++ )
                { //-- Draw the eyes
                    cv::Point eye_center( faces[i].x + eyes[j].x + eyes[j].width/2, faces[i].y + eyes[j].y + eyes[j].height/2 );
                    int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25 );
                    cv::circle( image, eye_center, radius, cv::Scalar( 255, 0, 255 ), 3, 8, 0 );
                }
            }
            
        }
        
    }
}