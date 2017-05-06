//
//  LTInitialInterfaceController.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 3/23/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit
import WatchKit

class LTInitialInterfaceController: WKInterfaceController{

    var exercises: [LTExercise]!
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        exercises =  [LTExercise]()
        exercises.append(LTExercise(displayName: "Biceps", type: .biceps, countGoal: nil))
        exercises.append(LTExercise(displayName: "Hammer Biceps", type: .hammerBiceps, countGoal: nil))
        
        tableView.setNumberOfRows(exercises.count, withRowType: "WorkoutRow")
        
        for index in 0..<tableView.numberOfRows {
            if let controller = tableView.rowController(at: index) as? LTWorkoutRowController {
                controller.exercise = exercises[index]
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let exercise = exercises[rowIndex]
        presentController(withName: "LTExercise", context: exercise)
    }

}
