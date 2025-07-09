//
//  PlateState.swift
//  Colo
//
//  Created by Jakub Majka on 9/7/25.
//

import SwiftUI
import Observation

@Observable
class PlateState: Decodable, ObservableObject{
    var selectedMode: OperationMode = .Off
    
    var fanSpeedMode: SpeedMode = .one
    var pumpSpeedMode: SpeedMode = .one
    
    var pad0 = PowerState.Off
    var pad1 = PowerState.Off
    
    var autoPreset: AutoPreset = .Normal
    
    var currentTemperature: CGFloat = -1
    var coolantTemperature: CGFloat = -1
    var humidity: CGFloat = -1
    var ambientTemperature: CGFloat = -1
    var goalTemperature: CGFloat = -1

    private enum CodingKeys: CodingKey {
        case operationMode, fanSpeed, pumpSpeed, pad0, pad1, autoPreset,
             currentTemperature, coolantTemperature, humidity, ambientTemperature,
             goalTemperature
    }
    
    init() { }
    
//    convenience init(_ jsonDataString: String) throws{
//        guard let jsonData = jsonDataString.data(using: .utf8) else {
//            print("error converting string to data")
//            return
//        }
//
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//        do {
//            let decodedObject = try decoder.decode(PlateState.self, from: jsonData)
//                self.init()
//             self.selectedMode = decodedObject.selectedMode
//             self.fanSpeedMode = decodedObject.fanSpeedMode
//             self.pumpSpeedMode = decodedObject.pumpSpeedMode
//             self.pad0 = decodedObject.pad0
//             self.pad1 = decodedObject.pad1
//             self.autoPreset = decodedObject.autoPreset
//             self.currentTemperature = decodedObject.currentTemperature
//             self.coolantTemperature = decodedObject.coolantTemperature
//             self.humidity = decodedObject.humidity
//             self.ambientTemperature = decodedObject.ambientTemperature
//             self.goalTemperature = decodedObject.goalTemperature
//
//        } catch {
//            print("error decoding data: \(error)")
//        }
//
//
//    }
    func update(from jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("error converting string to data")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedObject = try decoder.decode(PlateState.self, from: jsonData)
            
            self.selectedMode = decodedObject.selectedMode
            self.fanSpeedMode = decodedObject.fanSpeedMode
            self.pumpSpeedMode = decodedObject.pumpSpeedMode
            self.pad0 = decodedObject.pad0
            self.pad1 = decodedObject.pad1
            self.autoPreset = decodedObject.autoPreset
            self.currentTemperature = decodedObject.currentTemperature
            self.coolantTemperature = decodedObject.coolantTemperature
            self.humidity = decodedObject.humidity
            self.ambientTemperature = decodedObject.ambientTemperature
            self.goalTemperature = decodedObject.goalTemperature
            
        } catch {
            print("Failed to update PlateState from JSON string: \(error)")
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        setSpeed(&self.fanSpeedMode, from: try container.decode(Int.self, forKey: .fanSpeed))
        setSpeed(&self.pumpSpeedMode, from: try container.decode(Int.self, forKey: .pumpSpeed))
        setPad(&self.pad0, from: try container.decode(Bool.self, forKey: .pad0))
        setPad(&self.pad1, from: try container.decode(Bool.self, forKey: .pad1))
        setAutoPreset(&self.autoPreset, from: try container.decode(Int.self, forKey: .autoPreset))
        setOperationMode(&self.selectedMode, from: try container.decode(Int.self, forKey: .operationMode))
        
        self.currentTemperature = try container.decode(CGFloat.self, forKey: .currentTemperature)
        self.coolantTemperature = try container.decode(CGFloat.self, forKey: .coolantTemperature)
        self.humidity = try container.decode(CGFloat.self, forKey: .humidity)
        self.ambientTemperature = try container.decode(CGFloat.self, forKey: .ambientTemperature)
        self.goalTemperature = try container.decode(CGFloat.self, forKey: .goalTemperature)
    }
}
