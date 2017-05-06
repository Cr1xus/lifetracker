//
//  WorkoutRowController.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 3/31/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit
import WatchKit

class LTWorkoutRowController: NSObject {
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var exerciseNameLbl: WKInterfaceLabel!
    
    
    var exercise: LTExercise? {
        didSet {
            if let exercise = exercise {
                exerciseNameLbl.setText(exercise.displayName)
            }
        }
    }
}
