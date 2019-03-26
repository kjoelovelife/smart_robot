# Smart_robot

<p align="center">
  <img src="https://github.com/kjoelovelife/smart_robot/blob/master/smart_robot.jpg" width="280"/>
</p>

## Introduction

This repository contains all the software that runs on the Smart robot , makerlab design.

* makerlab : https://www.makerlab.tw/

Smart robot is a low-cost platform base on raspberry pi 3, comes with rpi3 official camera , ReSpeaker 4-Mic Array , ultrasonic and also a Omini wheels driver. 

Microcontroller on Motor-controller is STM32F103RCT6 , with sensor MPU-9250 . 

The system is use Raspbian , Download image from https://www.raspberrypi.org/downloads/raspbian/ . 

If you buy " Smart robot "　from IcShop ( https://www.icshop.com.tw/product_info.php/products_id/27051 ) , will contain the " Raspbian " system and can use ROS . The password is our telephone number " 5564686 ".   

## How to buy the part cmponents?

you can buy theese all cmponents on it : https://www.icshop.com.tw/index.php

## reference

Install ROS Kinetic on Raspbian with Raspberry Pi 3 : https://www.intorobotics.com/how-to-install-ros-kinetic-on-raspberry-pi-3-running-raspbian-stretch-lite/ 

Turtlebot3 e-Manual : http://emanual.robotis.com/docs/en/platform/turtlebot3/autonomous_driving/#turtlebot3-autorace

pocketsphinx setup  : https://github.com/cmusphinx/pocketsphinx-python

ROS and pocketsphinx (source): https://github.com/UTNuclearRoboticsPublic/pocketsphinx 
                    
ROS and pocketsphinx (blog)  : http://blog.michaelchi.net/2017/03/raspberry-pi-3pocketsphinxnode.html

Another module of language with pocketsphinx   : https://tw.saowen.com/a/691d0d7f77ba1f9c497c54e636c5ce4ced21a5f0880a99870397e81cf550abe4

## Developer

*Wei-Chih, Lin (kjoelovelife@gmail.com)

# Usage & Tutorial on PI

## The  Startup sequence of the smart robort

* Step 1. Start the motor-controller   

* Step 2. Start Raspberry pi    

## creat environment for using smart_robot 

* Step 1. install Dependencies

Open the terminal on PI , then change directory to " smart_robot " ,then source " dependencies_for_smartRobot_pi_ws_tools.sh "

  ` cd ~/smart_roboot && source  dependencies_for_smartRobot_pi_ws_tools.sh `

* Step 2. build work space

  ` cd ~/smart_roboot/catkin_ws && catkin_make `

## move the smart_robot

* Step 1. Running ROS across multiple machines

If you don't understand how to use it , you can visit these website : 

For Mandarin chinese : https://www.makerlab.tw/blog/_ros2

For Emglish          : https://www.intorobotics.com/how-to-setup-ros-kinetic-to-communicate-between-raspberry-pi-3-and-a-remote-linux-pc/

And In this example , we use laptop to be the Master. 

* Step 2. Run Master on laptop

Open the terminal on laptop , and enter 

  ` roscore `

* Step 3. Run node " smart_robot_teleop_key.py " on laptop

  ` rosrun driver smart_robot_teleop_key.py	`

* Step 4. Run node " smart_robot_teleop_key.py " on raspberry pi 

  ` rosrun driver smart_robot_twist.py `

After you finish Step 4 , then you can use keyboard on laptop to control the smart robot , remember and check you are use the terminal of smart_robot_teleop_key.py , and it will show you how to use.   

## use speech recognition to control smart robot

* Step 1. Running ROS across multiple machines

More information can read step 1 in " moving the smart_robot "

* Step 2. Run Master on laptop

Open the terminal on laptop , and enter 

  ` roscore `

* Step 3. Run launch file  " pocketsphinx.launch " on raspberrypi

  ` roslaunch pocketsphinx pocketsphinx.launch `

* Step 4. Run node " smart_robot_twist.py " on raspberry pi 

  ` rosrun driver smart_robot_twist.py `

After you finish Step 4 , now you can speak sonething let smart robot to recongnize . You can find " voice_cmd.kwlist " in package " pocketsphinx/vocab " ,and then search what word can smart robot recongnize. if you say the key word , such as " go " , smart robot will go foward . 

* Step 5. use topic " /pocketsphinx_recognizer/output  " on laptop to find what word smart robot recongnize

  ` rostopic echo /pocketsphinx_recognizer/output `

## use image recognition to go on the simulation road ( AutoRace )

* Step 1. design your road 

There are two color lines  on The road : Yellow and White .

And you just need to note one important thing : yellow line should be placed on the left side of the robot, and of course, white line should be placed on the right side of the smart robot.

More information can read " 智慧機器人使用手冊_20190220_V1.pdf " , chapter 8-1 .

* Step 2. Running ROS across multiple machines

More information can read step 1 in " moving the smart_robot "

* Step 3. Run Master on laptop

Open the terminal on laptop , and enter 

    ` roscore `

* Step 4. Run launch file  " turtlebot3_autorace_detect_lane_intrinsic.launch  "  on raspberrypi

  ` roslaunch turtlebot3_autorace_camera turtlebot3_autorace_detect_lane_intrinsic.launch `

* Step 5. Run launch file  " turtlebot3_autorace_control_lane.launch  "  on laptop

  ` roslaunch turtlebot3_autorace_control turtlebot3_autorace_control_lane.launch `

* Step 6. Run node " smart_robot_twist.py " on raspberry pi 

  ` rosrun driver smart_robot_twist.py `

After finish Step 6 , smart robot will start moving.

if you want to modified the paramter to adjust smart robot , you can search " automove.yaml " , in package " turtlebot3_autorace_control/param/control_lane "
