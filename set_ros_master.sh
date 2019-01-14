#!/usr/bin/env bash

# Shell script scripts to set ROS_MASTER and ROS_HOSTNAME
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
# This script is part of nixCraft shell script collection (NSSC) , project of MIT　'duckietown' .
# Visit https://github.com/duckietown
# Visit http://linux-wiki.cn/wiki/zh-tw/Shell%E4%B8%AD%E8%8E%B7%E5%8F%96%E5%BD%93%E5%89%8DIP%E5%9C%B0%E5%9D%80
# -------------------------------------------------------------------------

echo "Setting ROS_MASTER_URI..."
if [ $# -gt 0 ]; then
	# provided a hostname, use it as ROS_MASTER_URI
	export ROS_MASTER_URI=http://$1.local:11311/
else
	echo "No hostname provided. Using $HOSTNAME."
	export ROS_MASTER_URI=http://$HOSTNAME.local:11311/
fi
IP=`ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | awk {'print $1'}`
export ROS_HOSTNAME=$IP
echo "ROS_MASTER_URI set to $ROS_MASTER_URI"
echo "ROS_HOSTNAME set to $IP"
