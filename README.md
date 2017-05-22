# Installation

These instructions assume you are running Ubuntu 16.04 LTS. If you'd like to develop on a newer version of Ubuntu, you will have to install the corresponding version of ROS, as ROS Kinetic depends of Ubuntu 16.04. 

## Methods of installation
1. Use install script
  * NOTE: Depending on your machine's connection and processing speeds, you may need to enter your root password more than once as the script executes to install dependencies

```bash
git clone https://github.com/UAS-Ground/front
cd front
./install_dependencies.sh
./reinstall_client.sh
```

**OR**

2. Install dependencies individually
---

### Method 1: Use install script
---

#### Navigate to home directory
```bash
cd $HOME
```

#### Clone UAS Ground System client repository
```bash
git clone https://github.com/UAS-Ground/front
```
#### Navigate to UAS Ground System client root directory
```bash
cd front
```

#### Execute install script
```bash
# Give execute permissions, if necessary, then run scripts
chmod +x install_dependencies.sh
./install_dependencies.sh
chmod +x reinstall_client.sh
./reinstall_client.sh
```
---

### Method 2: 
---

#### Prepare to use package manager

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential
```
Enter your password and confirm installation when prompted


#### Install ROS Kinetic

Follow instructions at [ROS Kinetic Ubuntu installation page](http://wiki.ros.org/kinetic/Installation/Ubuntu)

#### Install Google Protocol Buffers 2.6.1

* This package should ship by default with Ubuntu 16.04 LTS, which means **nothing needs to be done**
* If you see errors regarding this library, you may run these commands (which are also contained in the shell script install_protobuf.sh). The repo for this library is [on GitHub](https://github.com/google/protobuf/tree/v2.6.1) as well

```bash
cd ~
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout v2.6.1
./autogen.sh
./configure
make
make check
sudo make install
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" >> $HOME/.bashrc
```

#### Install Boost
* A sufficiently-current version of this package should ship by default with ROS Kinetic, which means **nothing needs to be done**
* If you encounter issues with this library, try installing it via APT:

```bash
sudo apt-get install libboost-all-dev

```

#### Install OpenCV

```bash
cd $HOME
sudo apt-get -y install build-essential
sudo apt-get -y install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get -y install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev
sudo apt-get -y install libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libv4l-dev
git clone https://github.com/opencv/opencv.git
mv opencv OpenCV
cd OpenCV/platforms
mkdir build-desktop
cd build-desktop
cmake ../.. -DCMAKE_INSTALL_PREFIX=/usr
make -j 5
sudo make install
```

#### Install Qt 5.8 Open Source

* Be sure to leave the default path when installing (ie $HOME/Qt/5.8), and only install version 5.8 to conserve disk space
* You will need to create a free Qt account  if you have not done so already. This can be done from the installer
* Run the installer wuith these commands, or use the shell script install_qt.sh

```bash
cd ~/Downloads
wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
chmod +x qt-unified-linux-x64-online.run
./qt-unified-linux-x64-online.run
```

# Development

## Coding

* Qt Quick (the framework used for this project) strictly separates front-end from back-end.

*For your conveniece, the shell script 'reinstall_client.sh' will rebuild and install the plug-in AND client application, placing the executable binary in the 'build-desktop' directory of the project (for desktop builds)

* There are three main places your code changes will take place:

1. Client-side GUI
  * All strictly front-end markup(QML) and logic(JavaScript) is contained in files within the 'src' directory of the client project
    * QML is Qt's markup language, with a structure similar to JSON. Many great examples for usage are contained in the 'Examples' that come with Qt Creator
    * A standard implementation of JavaScript runs in Qt's engine. **NOTE: ** Properties of QML elements can be declared using a much wider array of types than standard JS's `var`, such as `int`, `real`, `Rectangle`, and most QML element types. These properties can be accessed and mutated within JavaScript code, but not instantiated or declared.
  * All client back-end functionality handled within custom extensions of the QObject class (ie ROSController class), connected to front-end via **signals** and **slots**
  * Qt Creator can be used to make, test, and deploy changes when those changes are strictly concerning standard QML/JS user-interface files
  * Alternatively, you can build and deploy new changes from command-line. Navigate to the client root directory and run:

  ```bash
  # This command for desktop builds, for other platforms, create a `build-%PLATFORM%` directory and follow a similar pattern
  mkdir build-desktop
  cd build-desktop
  # Create Makefile using qmake
  $HOME/Qt/5.8/gcc_64/bin/qmake ../src
  # run Makefile
  make
  # if no errors, launch application
  ./UAS_GS_CLIENT
  ``` 
  * Useful References
    * [Qt's general QML tutorial](http://doc.qt.io/qt-5/qml-tutorial.html) **NOTE** our application makes little-to-no use of the "States and Transitions" features of Qt/QML, as our application currently runs all functionality in real-time
    * [Using JS within QML](http://doc.qt.io/qt-5/qtqml-javascript-expressions.html)
    * [Exposing C++ back-end objects to QML front-end views](http://doc.qt.io/qt-5/qtqml-cppintegration-contextproperties.html)

2. Custom GUI element(s)
  * The ROS Camera element is an example of a customized feature used within our QML; it is **not** a standard QML features, and therefore **must** be created/changed using QML plugins. You may make your own QML plug-ins following the pattern used in the ROSCamera plug-in, use a tutorial, or scaffold the boilerplate from Qt Creator
  * For example, if you make changes to the ROSCamera plug-in, you must reinstall the plugin before the changes can take effect:

  ```bash
    # create folder for shared library object files and enter the directory
	mkdir ROSCamera/build-desktop
	cd ROSCamera/build-desktop	
	# create Makefile using qmake
	$HOME/Qt/5.8/gcc_64/bin/qmake ..
	# run Makefile to build shared library object files
	make
	# Copy build shared library object files to appropriate location with proper permissions 
	sudo make install
  ```

  * Useful references
    * The ROSCamera plug-in is originally a fork of the [QML-CVCamera plug-in](https://github.com/chili-epfl/qml-cvcamera) which has well-commented code, but is slightly more complex than ROSCamera
    * [Qt's QML extension plug-in tutorial](http://doc.qt.io/qt-5/qtqml-modules-cppplugins.html)
    * The ROSCamera plug-in uses boost::asio for streaming video frames and OpenCV for image processing
      * [Boost Asio tutorial](http://www.boost.org/doc/libs/1_64_0/doc/html/boost_asio/tutorial.html)
      * [OpenCV tutorials](http://docs.opencv.org/2.4/doc/tutorials/tutorials.html)

  3. UAV and Server-side logic
    * After successfully installing the [uav-command-control](https://github.com/UAS-Ground/uav-command-control.git) project, a custom fork of the [hector_quadrotor](https://github.com/tu-darmstadt-ros-pkg/hector_quadrotor) project will be created in your home directory. This project is very large, and is a good source to understand how to use a large range of the ROS functions. However, the modules built by the CSULA team are located in the 'groundsystem_communication' package located in the `src/hector_quadrotor` directory
    * Any changes made to the code inside the ROS package must be built before they can be tested

  ```bash
    # After saving all code changes, go to project root
    cd $HOME/hector_quadrotor
    # Build project
    catkin_make
    # Run setup script to configure environment (usually not necessary if you have appended the following line into your '.bashrc' file, which should have been done by shell script install.sh)
    source devel/setup.bash
    # Run demo
    roslaunch groundsystem_communication groundsystem_demo.launch
  ```

  * Useful references
    * CSULA student developer Maria Perez has compiled notes and tutorials in her [GitHub repository](https://github.com/mperez13/ROS-Tutorials)
    * Tutorials on [ros.org](http://www.ros.org):
  * [Publisher and subscriber](http://wiki.ros.org/ROS/Tutorials/WritingPublisherSubscriber)
    * [actionlib tutorials](http://wiki.ros.org/actionlib/Tutorials)
    * The groundsystem_communication package uses the following packages to achieve server functionality:
      * [boost::asio](http://www.boost.org/doc/libs/1_64_0/doc/html/boost_asio/tutorial.html) for sending video frames and receiving commands
      * cv_bridge for translating ROS image frames to OpenCV matrices
      * [protobuf](https://developers.google.com/protocol-buffers/docs/cpptutorial) for deserializing received commands
      * [OpenCV's imgproc and imgcodecs](http://docs.opencv.org/3.0-beta/modules/imgcodecs/doc/reading_and_writing_images.html) for compressing camera frames

  4. Additional resources
  Many of our early challenges on this project were due to understanding the build/compile processes and tools for command-line and the general C++ workflow. 
  * [Start here](https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html) to get a general background on what the build tools (like qmake and catkin_make) and scripts are doing "under the hood". Understanding this process will help you debug build errors and write your own build scripts, if necessary
  * The `.pro` files in the source contain configuration information for `qmake` to generate the Makefile which builds/installs the source and library files. 
  * ROS uses 'catkin' for managing source code, creatng and building ROS nodes. Check out this [catkin tutorial](http://wiki.ros.org/catkin/Tutorials).
    * catkin uses `cmake` internally, and you will occasionally need to make edits to your package's `CMakeLists.txt` file to let catkin know about how/what to link and compile for your ROS node. For example, you must declare your node's official name and tell catkin what '.cpp' files to compile for it (only one of those files should contain your main() function). [Check out this tutorial for an overview of CMake functions in catkin](http://docs.ros.org/kinetic/api/catkin/html/howto/format2/building_libraries.html)

  5. Tips for fixing errors
  * *Start from the top*: When you encounter compile-time and runtime errors, find the **first** error that was printed to the console. C++ compilers will start to many errors as a result of one bug in your logic (for example, a malformed class definition will cause any code that uses that class to appear as errors, but fixing the class definition could fix all related errors at once).
  * Though we've attempted to configure all scripts to properly install dependencies and system components, there may be errors in our scripts. Most of these will be errors in pathnames, which differ for every developer's system. Namely, any path which stems from your home directory (since it contains your Linux username) will be different on each dev's machine. Find the lines in shell scripts and source code which link, include, or open files using pathnames that may be different for your configuration, and attempt to make them universal (ie by using the $HOME environment variable)