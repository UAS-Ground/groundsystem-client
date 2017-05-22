#!/bin/bash
# Install OpenCV
INITIAL_DIR=$(pwd)
cd $HOME
sudo apt-get -y install build-essential
sudo apt-get -y install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get -y install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libv4l-dev
echo "UAS Installation: OpenCV dependencies complete"
git clone https://github.com/opencv/opencv.git
mv opencv OpenCV
cd OpenCV/platforms
if [ -d build-desktop ]
	then
		rm -rf build-desktop
fi
mkdir build-desktop
cd build-desktop
cmake ../.. -DCMAKE_INSTALL_PREFIX=/usr
make -j 5
sudo make install

cd $INITIAL_DIR
echo "UAS Installation: OpenCV install script complete"

