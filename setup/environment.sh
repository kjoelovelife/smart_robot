#!/bin/bash

echo "Activating ROS..."
source /opt/ros/kinetic/setup.bash
echo "...done."

echo "Setting up PYTHONPATH."
export PYTHONPATH=~/smart_robot/catkin_ws/src:$PYTHONPATH

echo "Setup ROS_HOSTNAME."
source ~/smart_robot/setup/set_ros_master.sh
source ~/smart_robot/catkin_ws/devel/setup.bash


exec "$@" #Passes arguments. Need this for ROS remote launching to work.
