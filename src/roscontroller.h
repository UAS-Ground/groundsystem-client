#ifndef ROSCONTROLLER_H
#define ROSCONTROLLER_H

#include <QObject>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QMap>
#include <QNetworkSession>
#include "searchrequest.pb.h"
#include "navgoalcommand.pb.h"

class ROSController : public QObject
{
    Q_OBJECT
public:
    explicit ROSController(QObject *parent = 0);
    ~ROSController();

signals:
private slots:
    void readImageFrames();
public slots:
    Q_INVOKABLE void sendCommand(float,float,float);
private:
    QTcpSocket * commandSocket;
    QUdpSocket * rosCameraSocket;
    QMap<QString, QUdpSocket> sensorSockets;
    SearchRequest searchRequest;
    NavGoalCommand navGoalCommand;
};

#endif // ROSCONTROLLER_H
