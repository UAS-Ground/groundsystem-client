#!/bin/bash
sudo echo "Root permission obtained"
cd $HOME
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout v2.6.1
./autogen.sh
./configure
make
make check
sudo make install
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" >> $HOME/.bashrc

