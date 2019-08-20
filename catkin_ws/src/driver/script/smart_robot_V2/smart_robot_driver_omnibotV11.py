#!/usr/bin/env python
# coding=UTF-8

# Copyright (c) 2011, Willow Garage, Inc.
# All rights reserved.
#
# Developer : Lin Wei-Chih , kjoelovelife@gmail.com 
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the Willow Garage, Inc. nor the names of its
#      contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THEV1
# POSSIBILITY OF SUCH DAMAGE.


## import library
import time ,struct ,binascii
import numpy as np
from serial import Serial

class Smart_robot():
    def __init__(self,port,baud):
    
        ## setup parameter
        self.param = {}
        self.param["device_port"] = port
        self.param["baudrate"] = baud
        self.param["vel_cmd"] = (0,0,0)
        self.param["tx_freq"] = float(5)
        self.param["odom_freq"] = float(10)
        self.param["imu_freq"] = float(100)
        self.param["vel_gain"] = float(70)
        self.param["omg_gain"] = float(500)
        self.param["timeout"] = float(10)
        self.imu_decode = {"accel":[0,0,0] , "gyro":[0,0,0]}
        self.odom_decode = [0,0,0]
        self.odom_seq = 0
        self.cmd_decode = [0 ,0 ,0]
        self.cmd_seq = 0
        self.connected = False
        self.start = False

        ## set send signal
    
    def connect(self):
        print("Try to connect the Smart Robot")
        try:
            self.device = Serial(self.param["device_port"] , self.param["baudrate"])
            self.device.reset_input_buffer()
            init_msg = self.device.readline()
            for number in range(0 ,3):
                init_msg = self.device.readline() ## Note: try restart motor board if error
                print( init_msg.encode('ascii')[0:(len(init_msg)-1 )]) 
            self.connected = True
        except:
            print("error")
            self.connected = False
            self.device.close()
        
        # sent start signal
        self.device.write( "SSSS".encode('ascii') )
        self.start = True
        print("Now you can move the smart_robot. Start status : {}".format(self.start))

    ## close port
    def disconnect(self):
        if self.start == True:
            self.device.write("P".encode('ascii'))
            self.device.close() 
            self.start = False
        self.device.close()
        self.connected = False  

    ## print receive data from omniborV11 , can visit -> https://docs.python.org/3/library/struct.html
    def receive_data(self):
        reading = self.device.read(2)
        #====== imu data packet ===========#
        if reading[0] == '\xFF' and reading[1] == '\xFA':
            try:
                self.imu = self.device.read(12)
                self.imu_decode["accel"][0] = struct.unpack('>h',self.imu[0:2])[0] # signed short , 2B
                self.imu_decode["accel"][1] = struct.unpack('>h',self.imu[2:4])[0]
                self.imu_decode["accel"][2] = struct.unpack('>h',self.imu[4:6])[0]
                self.imu_decode["gyro"][0] = struct.unpack('>h',self.imu[6:8])[0]
                self.imu_decode["gyro"][1] = struct.unpack('>h',self.imu[8:10])[0]
                self.imu_decode["gyro"][2] = struct.unpack('>h',self.imu[10:12])[0]
                print(" Accel:[ {} , {} , {} ] , Gyro:[ {} , {} , {}] ".format(self.imu_decode["accel"][0],self.imu_decode["accel"][1],self.imu_decode["accel"][2],self.imu_decode["gyro"][0],self.imu_decode["gyro"][1],self.imu_decode["gyro"][2]))
            except Exception:
                print("Receive imu data error")
        #====== encoder data packet==========#
        elif reading[0] == '\xFF' and reading[1] == '\xFB':
            try:
                self.odom = self.device.read(7)
                self.odom_decode[0] = struct.unpack('>h',self.odom[0:2])[0] # signed short , 2B  
                self.odom_decode[1] = struct.unpack('>h',self.odom[2:4])[0]  
                self.odom_decode[2] = struct.unpack('>h',self.odom[4:6])[0]  
                self.odom_seq = (struct.unpack('B',self.odom[6:7])[0]) % 256
                print("odom_seq :{} , odom : {}".format(self.odom_seq , self.odom_decode))
            except Exception:  
                print("Receive odom data error")
        #====== command data packet ( in 5HZ data )==========#
        elif reading[0] == '\xFF' and reading[1] == '\xFC' :
            try:
                self.cmd = self.device.read(13)
                self.cmd_decode[0] = struct.unpack('>f',self.cmd[0:4])[0]  
                self.cmd_decode[1] = struct.unpack('>f',self.cmd[4:8])[0]
                self.cmd_decode[2] = struct.unpack('>f',self.cmd[8:12])[0]
                self.cmd_seq = (struct.unpack('B',self.cmd[12:13])[0]) % 256
                print("cmd_seq :{} , cmd : {}".format(self.cmd_seq , self.cmd_decode))
            except Exception:  
                print("Receive command data error")
        else:
            print("Receive data error")


    # send signal 
    def send_signal(self,signal):
        if self.connected == True:
            self.device.write(signal.encode('ascii'))  
            time.sleep(0.5)
            self.device.reset_input_buffer()
            receive_msg = self.device.readline()
            if receive_msg[0] == 'P' and receive_msg[1] == 'a':
                self.start = False
            else:
                self.start = True

    # send vel_cmd
    def send_vel_cmd(self, veh_cmd):
        if self.start == True:
            serial_cmd = bytearray(b'\xFF\xFE')
            serial_cmd.append(0x01)			
    
            # base vector mode
            clamp = lambda n, minn, maxn: max(min(maxn, n), minn)
            serial_cmd += struct.pack('>h',clamp( veh_cmd[0], -37268, 32767 ) ) #2-bytes 
            serial_cmd += struct.pack('>h',clamp( veh_cmd[1], -37268, 32767 ) )
            serial_cmd += struct.pack('>h',clamp( veh_cmd[2], -37268, 32767 ) )

	    #debug
	    #print(binascii.hexlify(serial_cmd))
            
            self.device.write( serial_cmd )	


