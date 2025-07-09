//
//  setAngle.swift
//  Colo
//
//  Created by Jakub Majka on 9/7/25.
//

import SwiftUI

func setAngle(value: CGFloat, config: Config) -> CGFloat{
    let fixedAngle = (value - config.minimumValue) / ((config.maximumValue - config.minimumValue) * 4 / 3) * (2.0 * .pi)
    
    let angleValue = fixedAngle * 180 / .pi
    
    if(angleValue < 0) { return 0 }
    if(angleValue > 270){ return 270 }
    return angleValue
}
