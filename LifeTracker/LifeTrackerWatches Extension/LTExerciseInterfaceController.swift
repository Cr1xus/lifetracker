//
//  LTExerciseInterfaceController.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 4/2/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit
import WatchKit

protocol LTExerciseControllerProtocol: class {
    func updateTitleLabel(text: String)
}

class LTExerciseInterfaceController: WKInterfaceController, LTWorkoutManagerDelegate {
    
    var workoutManager: LTWorkoutManager!
    var active = false
    var exerciseCount = 0
    var exercise: LTExercise!
    
    @IBOutlet var countLbl: WKInterfaceLabel!
    @IBOutlet var titleLbl: WKInterfaceLabel!
    @IBOutlet var doneImg: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        if let exercise = context as? LTExercise { self.exercise = exercise }
        workoutManager = LTWorkoutManager(exercise: self.exercise)
        workoutManager.delegate = self
    }
    
    // MARK: WKInterfaceController
    
    override func willActivate() {
        super.willActivate()
        active = true
        
        // On re-activation, update with the cached values.
        updateLabels()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        active = false
    }
    
    // MARK: WorkoutManagerDelegate
    
    func didUpdateCount(manager: LTWorkoutManager, count: Int) {
        /// Serialize the property access and UI updates on the main queue.
        DispatchQueue.main.async {
            self.exerciseCount = count
            self.updateLabels()
        }
    }
    
    // MARK: Convenience
    
    func updateLabels() {
        if active {
            countLbl.setText("\(exerciseCount)")
            if exerciseCount >= exercise.countGoal{
                doneImg.setHidden(false)
            }
        }
    }
    
    func updateTitleLabel(text: String){
        titleLbl.setText(text)
    }

    @IBAction func startExercise() {
        updateTitleLabel(text: "Workout started")
        workoutManager.startWorkout()
    }
    @IBAction func stopExercise() {
        updateTitleLabel(text: "Workout stopped")
        workoutManager.stopWorkout()
    }
}
