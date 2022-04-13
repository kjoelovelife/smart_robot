#!/usr/bin/env bash

# Shell script scripts to install dependencies of smart Robot.
# -------------------------------------------------------------------------
#Copyright © 2018 Wei-Chih Lin , kjoelovelife@gmail.com 

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
# -------------------------------------------------------------------------
# This script is part of project Turtlebot3 , ROBOTIS 
# Visit https://github.com/robotis-git/turtlebot3
# Visit http://emanual.robotis.com/docs/en/platform/turtlebot3/getting_started/
# -------------------------------------------------------------------------


if [[ `id -u` -eq 0 ]] ; then
    echo "Do not run this with sudo (do not run random things with sudo!)." ;
    exit 1 ;
fi

## Use APT to download
sudo apt-get install -y \
             python-opencv \
             libopencv-dev \
             libbullet-dev \
             libpulse-dev \
             libasound2-dev \
             libgstreamer1.0-* \
             libgstreamer-* \
             build-essential \
             gstreamer0.10-* \
             python-gst* \
             python-pyaudio \
             python-dev \
             python-pip \
             git \
             swig \
             mplayer

## ReSpeaker 4 Mic Array
#cd ~/smart_robot
#git clone https://github.com/respeaker/seeed-voicecard.git
#cd ~/smart_robot/seeed-voicecard.git
#sudo ./install.sh 

## They don't have apt source
cd ~/smart_robot/catkin_ws/src
git clone https://github.com/ros/geometry2.git
# about voice recognition
#git clone https://github.com/ros-drivers/audio_common.git
#git clone https://github.com/UTNuclearRoboticsPublic/pocketsphinx.git
#sudo mkdir -p /usr/share/pocketsphinx/model/hmm/en_US/
#sudo cp -r ~/smart_robot/catkin_ws/src/pocketsphinx/model/hub4wsj_sc_8k /usr/share/pocketsphinx/model/hmm/en_US/

# Download and copy the hub4wsj_sc_8k language model to /usr/share/pocketsphinx/model/hmm/en_US/. It can be found here : https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/Archive/US%20English%20HUB4WSJ%20Acoustic%20Model/

## Use pip to install library with python.
#sudo pip install pocketsphinx

## Use .dep to install
#sudo dpkg -i ~/smart_robot/audio_common_dependence/raspberrypi/libsphinxbase1_0.8-6_armhf.deb
#sudo dpkg -i ~/smart_robot/audio_common_dependence/raspberrypi/libpocketsphinx1_0.8-5_armhf.deb
#sudo dpkg -i ~/smart_robot/audio_common_dependence/raspberrypi/gstreamer0.10-pocketsphinx_0.8-5_armhf.deb

## add rule for usb device
#sudo cp ~/smart_robot/uno.rules /etc/udev/rules.d/uno.rules.d
#sudo udevadm control --reload-rules 
#sudo udevadm trigger

cd ~/smart_robot/catkin_ws

## install path: ~/ros_catkin_ws/src
ros_version=kinetic
sudo apt install ros-$ros_version-joy \
                 ros-$ros_version-teleop-twist-joy \
                 ros-$ros_version-teleop-twist-keyboard \
                 ros-$ros_version-depthimage-to-laserscan \
                 ros-$ros_version-rosserial-arduino\
                 ros-$ros_version-rosserial-python \
                 ros-$ros_version-rosserial-server \
                 ros-$ros_version-rosserial-msgs \
                 ros-$ros_version-amcl \
                 ros-$ros_version-map-server \
                 ros-$ros_version-move-base \
                 ros-$ros_version-urdf \
                 ros-$ros_version-xacro \
                 ros-$ros_version-compressed-image-transport\
                 ros-$ros_version-rqt-image-view \
                 ros-$ros_version-gmapping \
                 ros-$ros_version-navigation \
                 ros-$ros_version-interactive-markers \
                 ros-$ros_version-joystick-drivers \
                 ros-$ros_version-image-transport \
                 ros-$ros_version-cv-bridge \
                 ros-$ros_version-vision-opencv \
                 ros-$ros_version-opencv3 \
                 ros-$ros_version-image-proc

# ROS Control App : https://play.google.com/store/apps/details?id=com.robotca.ControlApp

# The following commands allow to use USB port for OpenCR without acquiring root permission.
#rosrun turtlebot3_bringup create_udev_rules

# None of this should be needed. Next time you think you need it, let me know and we figure it out. -AC
# sudo pip install --upgrade pip setuptools wheel