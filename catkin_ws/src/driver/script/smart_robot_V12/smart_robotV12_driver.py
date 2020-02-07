#!/usr/bin/env python
# coding=UTF-8

# Copyright (c) 2011, Willow Garage, Inc.
# All rights reserved.
#
# Developer : Lin Wei-Chih , kjoelovelife@gmail.com , on 2020-02-04
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
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


## import library
import numpy as np
import time , struct ,binascii ,math
from serial import Serial , SerialException


class smart_robotV12():
    def __init__(self,port,baud):

        ## setup connected parameter
        self.param = {}
        self.param["device_port"] = port
        self.param["baudrate"]    = baud
        self.imu_decode = {"accel":[0,0,0] , "gyro":[0,0,0]}
        self.odom_decode = [0,0,0]
        self.odom_seq = 0
        self.cmd_decode = [0 ,0 ,0]
        self.cmd_seq = 0
        self.connected = False
        self.start = False

    def connect(self):
        print("Try to connect the Smart Robot")
        try:
            self.device = Serial(self.param["device_port"] , self.param["baudrate"])
            self.connected = True
            print("Connect done!!")
        except:
            print("Error! Please check smart robot.")

    ## close port
    def disconnect(self):
        if self.connected == True:
            self.device.close() 
            self.connected = False  

    ## Start smartbot and choose "omnibot" or "Mecanum"
    def set_mode(self, vehicle):
        start_cmd = bytearray(b'\xFF\xFE')
        start_cmd.append(0x80)
        start_cmd.append(0x80)
        start_cmd.append(0x09)
        start_cmd += struct.pack('>h',0 ) # 2-bytes , reserved bit                 
        # 2-bytes , first is mode set ; second is vehicle of robot , 0 for omnibot , 1 for Mecanum  
        start_cmd += struct.pack('>h',vehicle) 
        start_cmd.append(0x00)            # 1-bytes , reserved bit    
	#debug
	#print(binascii.hexlify(serial_cmd)) 
        if self.connected == True:
            self.device.write(start_cmd)

    # send vel_cmd
    def vel(self, veh_cmd):
      
        clamp = lambda n, minn, maxn: max(min(maxn, n), minn)
        speed = bytearray(b'\xFF\xFE')
        speed.append(0x01)
        speed += struct.pack('>h',clamp( abs(veh_cmd[1]), 0, 65536 ) ) # 2-bytes , velocity for x axis 
        speed += struct.pack('>h',clamp( abs(veh_cmd[0]), 0, 65536 ))  # 2-bytes , velocity for y axis 
        speed += struct.pack('>h',clamp( abs(veh_cmd[2]), 0, 65536 ))  # 2-bytes , velocity for z axis 

        if veh_cmd[1] > 0:
            direction_x = 4
        else:
            direction_x = 0
        if veh_cmd[0] > 0:
            direction_y = 0
        else:
            direction_y = 2
        if veh_cmd[2] > 0:
            direction_z = 0
        else:
            direction_z = 1

        direction = direction_x + direction_y + direction_z
        
        # 1-bytes , direction for x(bit2) ,y(bit1) ,z(bit0) ,and 0 : normal , 1 : reverse
        speed += struct.pack('>b',direction)  
            
        # debug
        #print(binascii.hexlify(speed))
        if self.connected == True:       
            self.device.write(speed)
            print("Direction: {}".format(direction))

    def load_setting(self):
        cmd = bytearray(b'\xFF\xFE') # Tx[0] , Tx[1]
        cmd.append(0x80) # Tx[2]
        cmd.append(0x80) # Tx[3]
        cmd.append(0x00) # Tx[4]
        cmd.append(0x80) # Tx[5]
        cmd.append(0x00) # Tx[6]
        cmd.append(0x00) # Tx[7]
        cmd.append(0x01) # Tx[8]
        cmd.append(0x00) # Tx[9]
        if self.connected == True:       
            self.device.write(cmd)
            print("OmniboardV12 load setting!!")

    def load_initial(self):
        cmd = bytearray(b'\xFF\xFE') # Tx[0] , Tx[1]
        cmd.append(0x80) # Tx[2]
        cmd.append(0x80) # Tx[3]
        cmd.append(0x00) # Tx[4]
        cmd.append(0x80) # Tx[5]
        cmd.append(0x00) # Tx[6]
        cmd.append(0x00) # Tx[7]
        cmd.append(0x02) # Tx[8]
        cmd.append(0x00) # Tx[9]
        if self.connected == True:       
            self.device.write(cmd)
            print("Initialize OmniboradV12.")

    def write_setting(self):
        cmd = bytearray(b'\xFF\xFE') # Tx[0] , Tx[1]
        cmd.append(0x80) # Tx[2]
        cmd.append(0x80) # Tx[3]
        cmd.append(0x00) # Tx[4]
        cmd.append(0x80) # Tx[5]
        cmd.append(0x00) # Tx[6]
        cmd.append(0x00) # Tx[7]
        cmd.append(0x03) # Tx[8]
        cmd.append(0x00) # Tx[9]
        if self.connected == True:       
            self.device.write(cmd)
            print("Omniboard writing setting and don't do anything , include shutdown the power , it will take 20 seconds ....... ")
            time.sleep(20)
            print("You can restart OmniboardV12 now!")


    #================================================
    # vehicle         : 0 -> omnibot   , 1 -> Mecanum
    # motor           : 0 -> normal    , 1 -> reverse
    # encode          : 0 -> normal    , 1 -> reverse
    # imu_calibration : 0 -> not ot do , 1 -> do it
    # command         : 0 -> control   , 1 -> APP
    #================================================
    def set_system_mode(self,vehicle=0,motor=0,encoder=0,imu_calibration=1,command=0):      
        # calculate
        value = {}
        if vehicle == 1:
            value["vehicle"] = math.pow(2,0)
        else:
            value["vehicle"] = 0
        if motor == 1:
            value["motor"] = math.pow(2,4)
        else:
            value["motor"] = 0
        if encoder == 1:
            value["encoder"] = math.pow(2,5)
        else:
            value["encoder"] = 0
        if imu_calibration == 1:
            value["imu_calibration"] = math.pow(2,6)
        else:
            value["imu_calibration"] = 0
        if command == 1:
            value["command"] = math.pow(2,7)
        else:
            value["command"] = 0

        mode = value["vehicle"] + value["motor"] + value["encoder"] +  value["imu_calibration"] + value["command"]
        cmd = bytearray(b'\xFF\xFE') # Tx[0] , Tx[1]
        cmd.append(0x80) # Tx[2]
        cmd.append(0x80) # Tx[3]
        cmd.append(0x09) # Tx[4]
        cmd.append(0x00) # Tx[5]
        cmd.append(0x00) # Tx[6]
        cmd += struct.pack('>h',mode) # Tx[8] ,Tx[8]
        print("Omniboard write setting!")
        cmd.append(0x00) # Tx[9]
        if self.connected == True:       
            self.device.write(cmd)
            print("Send to omniboardV12 : {}".format(binascii.hexlify(cmd)))



     




