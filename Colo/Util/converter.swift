//
//  converters.swift
//  Colo
//
//  Created by Jakub Majka on 22/4/25.
//

import SwiftUI

func setSpeed(_ speed: inout SpeedMode,from val: Int){
    switch val {
    case 0:
        speed = .zero
    case 1...20:
        speed = .one
    case 21...40:
        speed = .two
    case 41...60:
        speed = .three
    case 61...80:
        speed = .four
    case 81...100:
        speed = .five
    default:
        speed = .zero
    }
}

func setPad(_ pad: inout PowerState,from state: Bool){
    switch state{
    case true:
        pad = .On
    case false:
        pad = .Off
    }
}

func setAutoPreset(_ autoPreset: inout AutoPreset,from preset: Int){
    switch preset{
    case 1:
        autoPreset = .Eco
    case 2:
        autoPreset = .Silent
    case 3:
        autoPreset = .Normal
    case 4:
        autoPreset = .Strong
    case 5:
        autoPreset = .Blast
    default:
        autoPreset = .Normal
    }
}

func setOperationMode(_ operationMode: inout OperationMode,from mode: Int){
    switch mode{
    case 0:
        operationMode = .Off
    case 1:
        operationMode = .Auto
    case 2:
        operationMode = .Manual
    default:
        operationMode = .Off
    }
}
