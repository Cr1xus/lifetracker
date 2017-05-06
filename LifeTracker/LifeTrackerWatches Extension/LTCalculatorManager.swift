//
//  CalculatorManager.swift
//  SwingWatch
//
//  Created by Sergey Spivakov on 3/30/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

class LTCalculatorManager{
    class func getCalculator(motionManager: LTMotionManager, exerciseType: LTExerciseType) -> LTCalculator{
        var calculator: LTCalculator!
        switch exerciseType {
        case .biceps:
            calculator = LTBicepsCalculator(delegate: motionManager)
        case .hammerBiceps:
            calculator = LTHammerBicepsCalculator(delegate: motionManager)
        }
        return calculator
    }
}
