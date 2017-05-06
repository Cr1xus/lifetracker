/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the HealthKit interactions and provides a delegate 
         to indicate changes in data.
 */

import Foundation
import HealthKit
import WatchKit
import WatchConnectivity


/**
 `WorkoutManagerDelegate` exists to inform delegates of swing data changes.
 These updates can be used to populate the user interface.
 */
protocol LTWorkoutManagerDelegate: class {
    func didUpdateCount(manager: LTWorkoutManager, count: Int)
}

protocol LTWorkoutAlarmDelegate: class {
    func workoutCompleted()
}

class LTWorkoutManager: NSObject, LTMotionManagerDelegate,LTWorkoutAlarmDelegate{
    // MARK: Properties
    let motionManager = LTMotionManager()
    let healthStore = HKHealthStore()
    
    weak var delegate: LTWorkoutManagerDelegate?
    var session: HKWorkoutSession?
    var exercise: LTExercise!

    // MARK: Initialization
    
    init(exercise: LTExercise) {
        super.init()
        motionManager.delegate = self
        self.exercise = exercise
        
    }

    // MARK: WorkoutManager
    
    func startWorkout() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }

        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .functionalStrengthTraining
        workoutConfiguration.locationType = .indoor

        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
        }

        // Start the workout session and device motion updates.
        healthStore.start(session!)
        self.exercise.startDate = Date()
        motionManager.startUpdates(exercise:self.exercise)
    }
    
    func workoutCompleted(){
        print("SOUND PLAYED")
        WKInterfaceDevice.current().play(WKHapticType.notification)
        stopWorkout()
        if let controller = delegate as? LTExerciseControllerProtocol{
            controller.updateTitleLabel(text: "Workout stopped")
        }
        
        sendExerciseData()
    }

    func stopWorkout() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }
        self.exercise.endDate = Date()
        // Stop the device motion updates and workout session.
        motionManager.stopUpdates()
        healthStore.end(session!)
        
        // Clear the workout session.
        session = nil
    }
    
    func sendExerciseData(){
        
        if WCSession.isSupported() {
            let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
            
            guard let wcSession = watchDelegate?.wcSession else{
                return
            }
            let name = exercise.displayName
            let type = exercise.type.rawValue
            let countGoal = NSNumber(integerLiteral: exercise.countGoal)
            
            let dayHourMinuteSecond = Set<Calendar.Component>([.day, .hour, .minute, .second])
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: exercise.startDate!, to: exercise.endDate!)
            //in seconds
            var time: Int = 0
            if let second = difference.second {
                time = time + second
            }
            if let minute = difference.minute {
                time = time + minute
            }
            if let hour = difference.hour {
                time = time + hour
            }
            
            let timeObj = NSNumber(integerLiteral: time)
            
            wcSession.sendMessage(["displayName": name,"type": type, "countGoal": countGoal, "time" : timeObj], replyHandler: { (response) -> Void in
                print("MESSAGE SENT")
            }, errorHandler: { (error) -> Void in
                // 6
                print(error)
            })
        }
    }
    

    // MARK: MotionManagerDelegate
    
    func didUpdateCount(count: Int) {
        delegate?.didUpdateCount(manager: self, count: count)
    }
}
