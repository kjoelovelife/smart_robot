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
sudo apt-get install -y python-opencv
sudo apt-get install -y libopencv-dev
sudo apt-get install libbullet-dev

## They don't have apt source
cd ~/smart_robot/catkin_ws/src
git clone https://github.com/ros/geometry2.git

## install path: ~/ros_catkin_ws/src
#cd ~/ros_catkin_ws
#rosinstall_generator joy \
#                     teleop_twist_joy \
#                     teleop_twist_keyboard \
#                     laser_proc rgbd_launch \
#                     depthimage_to_laserscan \
#                     rosserial_arduino \ 
#                     rosserial_python \
#                     rosserial_server \
#                     rosserial_client  \
#                     rosserial_masgs \
#                     amcl \
#                     map_server \
#                     move_base \
#                     urdf \
#                     xacro \
#                     compressed_image_transport \
#                     rqt_image_view \
#                     gmapping \
#                     navigation \
#                     interactive_markers \
#                     joystick_drivers \
#                     image_transport \
#                     cv_bridge \
#                     vision_opencv \
#                     opencv3 \
#                     image_proc \
#                     --rosdistro kinetic --deps --wet-only --tar > ros_kinetic_smartRobot.rosinstall

#wstool merge -t src ros_kinetic_smartRobot.rosinstall
#wstool update -t src

#rosdep install --from-paths src --ignore-src --rosdistro kinetic -y -r --os=debian:stretch
#sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILED_TYPE=Release --install-space /opt/ros/kinetic

# ROS Control App : https://play.google.com/store/apps/details?id=com.robotca.ControlApp

# The following commands allow to use USB port for OpenCR without acquiring root permission.
#rosrun turtlebot3_bringup create_udev_rules

# None of this should be needed. Next time you think you need it, let me know and we figure it out. -AC
# sudo pip install --upgrade pip setuptools wheel