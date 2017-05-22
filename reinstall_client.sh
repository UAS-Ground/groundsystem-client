#!/bin/bash


sudo echo "Root permission obtained..."
PROJECT_ROOT_DIR=$(pwd)
if [ -d ROSCamera/build-desktop ]
	then 
		cd ROSCamera/build-desktop
else
		mkdir ROSCamera/build-desktop
		cd ROSCamera/build-desktop
fi

$HOME/Qt/5.8/gcc_64/bin/qmake ..
make
sudo make install

cd $PROJECT_ROOT_DIR
if [ -d build-desktop ]
	then
		rm -rf build-desktop
fi
mkdir build-desktop
cd build-desktop
$HOME/Qt/5.8/gcc_64/bin/qmake ../src
make
cd $PROJECT_ROOT_DIR
echo "Ground System client build complete. Binary executable located in 'build' directory."
