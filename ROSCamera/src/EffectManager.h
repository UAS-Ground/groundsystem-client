#ifndef EFFECTMANAGER_H
#define EFFECTMANAGER_H




#include <opencv2/highgui/highgui.hpp>
#include <opencv2/videoio/videoio_c.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgproc/types_c.h>
#include <opencv2/objdetect.hpp>

// IMPORTANT: Only add new effects BEFORE the NUMBER_OF_TYPES element. This contains the count of types
enum Effect { FACE_DETECTION, LICENSE_DETECTION, GUN_DETECTION, NUMBER_OF_TYPES };


class EffectManager {
private:
    int * effects;
    cv::CascadeClassifier face_cascade;
    cv::CascadeClassifier eyes_cascade;
    cv::CascadeClassifier body_cascade;
public:
    EffectManager(int * effects);
    void addEffect(Effect effect);
    void removeEffect(Effect effect);
    // For debugging
    void printEffectBits();
    static Effect convertIntToEffect(int num);
    bool effectIsSet(Effect effect);
    void applyActiveEffects(cv::Mat& image);

};


#endif //EFFECTMANAGER_H
