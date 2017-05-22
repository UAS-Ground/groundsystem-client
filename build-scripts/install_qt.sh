#!/bin/bash
sudo echo "Root obtained."
sudo apt-get -y install libpulse-dev
INITIAL_DIR=$(pwd)
cd $HOME/Downloads
wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
chmod +x qt-unified-linux-x64-online.run
./qt-unified-linux-x64-online.run
cd $INITIAL_DIR

