//
//  BicepsCalculator.swift
//  SwingWatch
//
//  Created by Sergey Spivakov on 3/30/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import CoreMotion

class LTHammerBicepsCalculator: LTCalculator{
    
    var counter: Int = 0
    var delegate: LTMotionManagerDelegate
    let changeMagnituteBuffer = LTRunningBuffer(size: 10)
    
    
    var atInitialPos = true
    var atEndPos = false
    var changeSumThreshold = 350.0
    var yawMaxThreshold = 15.0
    var yawMinThreshold = -10.0
    
    required init(delegate: LTMotionManagerDelegate){
        self.delegate = delegate
    }
    
    func receivedMotionUpdate(deviceMotion: CMDeviceMotion){
        let gravity = deviceMotion.gravity
        
        let myPitch = degrees(radians: gravity.x)
        changeMagnituteBuffer.addSample(myPitch)
        let myYaw = degrees(radians: gravity.z)

        let bufferSum = changeMagnituteBuffer.sum()

        if(myYaw > yawMinThreshold && myYaw < yawMaxThreshold){
            if (atInitialPos && (bufferSum < 0) && (bufferSum <= -changeSumThreshold)){
                incrementCount()
                changePos()
                print("INCREMENTED")
            }else if (atEndPos && (bufferSum > 0) && (bufferSum >= changeSumThreshold)){
                changePos()
                print("NEXT SET")
            }
        }
    }
    
    fileprivate func changePos(){
        if atInitialPos{
            atInitialPos = false
            atEndPos = true
        }else{
            atInitialPos = true
            atEndPos = false
        }
    }
    
    fileprivate func incrementCount(){
        counter = counter + 1
        delegate.didUpdateCount(count: counter)
        if counter == 8{
            if let alarmDel = delegate as? LTWorkoutAlarmDelegate{
                alarmDel.workoutCompleted()
            }
        }
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
    
}
