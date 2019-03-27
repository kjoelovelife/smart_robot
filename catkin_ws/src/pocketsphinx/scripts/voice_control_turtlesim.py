#!/usr/bin/env python
# coding=UTF-8

import rospy
from std_msgs.msg import String
from geometry_msgs.msg import Twist



## set key word list
key_word = {
             "go ":(2,0,0,0,0,0),
             "stop ":(0,0,0,0,0,0),
             "back ":(0,-2,0,0,0,0),
             "left ":(0,0,0,0,0,2),
             "right ":(0,0,0,0,0,-2)
           }


def callback(data):
    word = data.data
    if word in str(key_word.keys()):    
        print(word)
        twist.linear.x = key_word[word][0]
        twist.linear.y = key_word[word][1]
        twist.linear.z = key_word[word][2]
        twist.angular.x = key_word[word][3]
        twist.angular.y = key_word[word][4]
        twist.angular.z = key_word[word][5]
        pub.publish(twist)

if __name__ == '__main__':

    ## set Twist
    twist = Twist()
    twist.linear.x = 0  
    twist.linear.y = 0
    twist.linear.z = 0
    twist.angular.x = 0
    twist.angular.y = 0
    twist.angular.z = 0

    ## initialize
    rospy.init_node('voice_control', anonymous=True)
    pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size = 1)
    while(True):       
        if rospy.is_shutdown() == True:
            print''
            break
        else:
            rospy.Subscriber('pocketsphinx_recognizer/output', String, callback)
            rospy.spin()
