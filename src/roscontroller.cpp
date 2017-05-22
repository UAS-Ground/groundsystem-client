#include "roscontroller.h"
#include <QHostInfo>
#include <QDataStream>
ROSController::ROSController(QObject *parent) : QObject(parent)
{

    GOOGLE_PROTOBUF_VERIFY_VERSION;

    this->commandSocket = new QTcpSocket(this);
    /*this->rosCameraSocket = new QUdpSocket(this);
    this->rosCameraSocket->bind(8080, QUdpSocket::ShareAddress);
    connect(this->rosCameraSocket, SIGNAL(readyRead()), this, SLOT(readImageFrames()));*/
}

void ROSController::sendCommand(float lat,float lon,float alt)
{

    qDebug() << "in sendCommand(), passed\n "
             << "\tlat" << lat
             << "\tlon" << lon
             << "\talt" << alt;


    this->navGoalCommand.Clear();
    this->navGoalCommand.set_x(lat);
    this->navGoalCommand.set_y(lon);
    this->navGoalCommand.set_z(alt);



    qDebug() << "in sendCommand(), protobuf\n "
             << "\t this->navGoalCommand.x()" <<  this->navGoalCommand.x()
             << "\t this->navGoalCommand.y()" <<  this->navGoalCommand.y()
             << "\t this->navGoalCommand.z()" <<  this->navGoalCommand.z();



//    this->searchRequest.Clear();
//    this->searchRequest.set_query("Hello this is a query");
//    this->searchRequest.set_page_number(8);
//    this->searchRequest.set_result_per_page(4);

    std::string myMessage;

    this->navGoalCommand.SerializeToString(&myMessage);

    //qDebug() << "before serializing, my message is " << QString::fromStdString(myMessage);


    QString LOCAL_HOST = QHostInfo::localHostName();
    //qDebug() << "in sendCommand() with message " << QString::fromStdString(myMessage) <<" connecting to " << LOCAL_HOST;
    QByteArray block;
    block.append(QString::fromStdString(myMessage));
    this->commandSocket->connectToHost(LOCAL_HOST, 5555);
    this->commandSocket->write(QByteArray::fromStdString(myMessage));
    this->commandSocket->close();



}


void ROSController::readImageFrames()
{

    while (this->rosCameraSocket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(this->rosCameraSocket->pendingDatagramSize());
        this->rosCameraSocket->readDatagram(datagram.data(), datagram.size());
        QString dat = tr("Received datagram: \"%1\"").arg(datagram.data());
        qDebug() << dat;
    }
}

ROSController::~ROSController()
{

    delete this->commandSocket;
    delete this->rosCameraSocket;
    google::protobuf::ShutdownProtobufLibrary();
}
