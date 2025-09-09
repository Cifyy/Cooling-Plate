//
//  options.swift
//  Colo
//
//  Created by Jakub Majka on 19/4/25.
//

enum OperationMode: Int, CaseIterable, Identifiable, Codable {
    case Off = 0
    case Auto
    case Manual

    var id: Self { self }
    

}

enum PowerState: Int, CaseIterable, Identifiable, Codable {
    case Off = 0
    case On = 1
    
    var id: Self { self }
    
    var name: String {
        return "state"
    }
}

enum AutoPreset: Int, CaseIterable, Identifiable, Codable {
    case Eco = 1
    case Silent
    case Normal
    case Strong
    case Blast

    var id: Self { self }
    
}

enum SpeedMode: Int, CaseIterable, Identifiable, CustomStringConvertible, Codable {
    case zero =  0
    case one
    case two
    case three
    case four
    case five
    
    var description: String {
        return String(self.rawValue)
    }
    
    var id: Self { self }
}
