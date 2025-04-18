//
//  config.swift
//  Colo
//
//  Created by Jakub Majka on 19/4/25.
//

import Foundation
import SwiftUI

struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
//    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
    let name: String
    let unit: String
    let gradient: AngularGradient
}

struct statusData{
    let ambientTemperature: Double
    let humidity: Int
    let coolantTemperature: Double
    let pad0: PowerState
    let pad1: PowerState
    let selectedMode: OperationMode
    let autoPreset: AutoPreset
    let fanSpeedMode: SpeedMode
    let pumpSpeedMode: SpeedMode
}
