#ifndef CVCONTROLLER_H
#define CVCONTROLLER_H

#include <QObject>
//#include <opencv2/core/core.hpp>
//#include <opencv2/highgui/highgui.hpp>

class CVController : public QObject
{
    Q_OBJECT
public:
    explicit CVController(QObject *parent = 0);
    //Q_INVOKABLE void processImageFrame(cv::Mat);

signals:

public slots:

private:
    int currentImageNum;
};

#endif // CVCONTROLLER_H
