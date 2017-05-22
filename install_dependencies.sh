#!/bin/bash

sudo echo "Root permission obtained."
./build-scripts/install_ros.sh
./build-scripts/install_opencv.sh
./build-scripts/install_qt.sh

echo "Ground System dependencies installed"
