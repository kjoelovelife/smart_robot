#!/usr/bin/env bash

# Shell script scripts to install ROS-kinetic on Raspbian (Version: Stretch) 
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
# This script is part of webiste with ROS install 
# Visit http://wiki.ros.org/kinetic/Installation/Ubuntu
# -------------------------------------------------------------------------

if [[ `id -u` -eq 0 ]] ; then
    echo "Do not run this with sudo (do not run random things with sudo!)." ;
    exit 1 ;
fi

# setup ROS Repositories
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -

sudo apt-get update

# install Bootstrap Dependencies
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
sudo apt install dirmngr

# initializing rosdep
sudo rosdep init
rosdep update

sudo apt-get update

# install
# Create a catkin Worlspace
mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws

#fetch the core packages
rosinstall_generator desktop --rosdistro kinetic --deps --wet-only --tar > kinetic-desktop-wet.rosinstall
wstool init src kinetic-desktop-wet.rosinstall

# Resolving Dependencies with rosdep
rosdep install -y --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:stretch
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j1

# source the new installation
source /opt/ros/kinetic/setup.bash
echo 'source /opt/ros/kinetic/setup.bash' >> ~/.bashrc

# create a catkin Workspace and building the catkin workspace
mkdir -p ~/catkin_workspace/src
cd catkin_workspace/src
catkin_init_workspace
cd ~/catkin_workspace/
catkin_make
source ~/catkin_workspace/devel/setup.bash
echo 'source ~/catkin_workspace/devel/setup.bash' >> ~/.bashrc
export | grep ROS
# None of this should be needed. Next time you think you need it, let me know and we figure it out. -AC
# sudo pip install --upgrade pip setuptools wheel
