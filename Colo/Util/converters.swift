//
//  converters.swift
//  Colo
//
//  Created by Jakub Majka on 22/4/25.
//

import SwiftUI

func setSpeed(speed: Binding<SpeedMode>, val: Int) {
    switch val {
    case 0:
        speed.wrappedValue = .zero
    case 1...20:
        speed.wrappedValue = .one
    case 21...40:
        speed.wrappedValue = .two
    case 41...60:
        speed.wrappedValue = .three
    case 61...80:
        speed.wrappedValue = .four
    case 81...100:
        speed.wrappedValue = .five
    default:
        speed.wrappedValue = .zero
    }
}

func setPad(pad: Binding<PowerState>, state: Bool){
    switch state{
    case true:
        pad.wrappedValue = .On
    case false:
        pad.wrappedValue = .Off
    }
}

func setAutoPreset(autoPreset: Binding<AutoPreset>, preset: Int){
    switch preset{
    case 1:
        autoPreset.wrappedValue = .Eco
    case 2:
        autoPreset.wrappedValue = .Silent
    case 3:
        autoPreset.wrappedValue = .Normal
    case 4:
        autoPreset.wrappedValue = .Strong
    case 5:
        autoPreset.wrappedValue = .Blast
    default:
        autoPreset.wrappedValue = .Normal
    }
}

func setOperationMode(operationMode: Binding<OperationMode>, mode: Int){
    switch mode{
    case 0:
        operationMode.wrappedValue = .Off
    case 1:
        operationMode.wrappedValue = .Auto
    case 2:
        operationMode.wrappedValue = .Manual
    default:
        operationMode.wrappedValue = .Off
    }
}
