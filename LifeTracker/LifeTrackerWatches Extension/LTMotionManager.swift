/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the CoreMotion interactions and 
         provides a delegate to indicate changes in data.
 */

import Foundation
import CoreMotion
import WatchKit

/**
 `MotionManagerDelegate` exists to inform delegates of motion changes.
 These contexts can be used to enable application specific behavior.
 */
protocol LTMotionManagerDelegate: class {
    func didUpdateCount(count: Int)
}

class LTMotionManager: LTMotionManagerDelegate, LTWorkoutAlarmDelegate {
    // MARK: Properties
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left

    // The app is using 50hz data and the buffer is going to hold 1s worth of data.
    let sampleInterval = 1.0 / 50.0
    
    weak var delegate: LTMotionManagerDelegate?

    var calculator: LTCalculator?

    // MARK: Initialization
    
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }

    // MARK: Motion Manager

    func startUpdates(exercise: LTExercise) {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        calculator = LTCalculatorManager.getCalculator(motionManager: self, exerciseType: exercise.type)
        // Reset everything when we start.
       // resetAllState()

        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }

            if deviceMotion != nil {
                self.processDeviceMotion(deviceMotion!)
            }
        }
    }

    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    func workoutCompleted() {
        if let alarmDel = delegate as? LTWorkoutAlarmDelegate {
            alarmDel.workoutCompleted()
        }
    }

    // MARK: Motion Processing

    
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        calculator?.receivedMotionUpdate(deviceMotion: deviceMotion)
    }

    func didUpdateCount(count: Int) {
        delegate?.didUpdateCount(count:count)
    }
    
}
