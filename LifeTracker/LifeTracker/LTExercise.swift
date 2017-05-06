//
//  Exercise.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 3/31/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit

class LTExercise {
    var displayName: String
    var type: LTExerciseType
    var countGoal = 8
    var time: Int64?
    
    var startDate: Date?
    var endDate: Date?
    init(displayName: String, type: LTExerciseType, countGoal: Int!){
        self.displayName = displayName
        self.type = type
        if let cGoal = countGoal {
            self.countGoal = cGoal
        }
    }
}
