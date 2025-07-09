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

