//
//  extensions.swift
//  Colo
//
//  Created by Jakub Majka on 8/7/25.
//

import SwiftUI


extension View {
    func connectionColor(_ connectionState: ConnectionState) -> some View {
        switch connectionState {
        case .connected:
            return self.foregroundColor(.green)
        case .connecting:
            return self.foregroundColor(.yellow)
        case .disconnected:
            return self.foregroundColor(.red)
        }
    }
    
    func blink() -> some View {
        modifier(BlinkAnimation())
    }
}

extension WebSocketClient{
    func sendProperty(name: String, state: Int){
        Task{ @WebSocketActor in
            do{
                let payload: [String: Any] = [
                    name: state
                ]
                let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    print(jsonString)
                    try await self.send(.string(jsonString))
                }
            }catch{
                print("Error serializing JSON: \(error)")
            }
        }
    }
}
