//
//  Calculator.swift
//  SwingWatch
//
//  Created by Sergey Spivakov on 3/30/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import CoreMotion

protocol LTCalculator {
    init(delegate: LTMotionManagerDelegate)
    func receivedMotionUpdate(deviceMotion: CMDeviceMotion)
}
