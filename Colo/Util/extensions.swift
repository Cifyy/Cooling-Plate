//
//  extensions.swift
//  Colo
//
//  Created by Jakub Majka on 8/7/25.
//

import SwiftUI

struct BlinkAnimation: ViewModifier {
    @State private var opacity: CGFloat = 0.2

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .animation(
                .easeInOut(duration: 1).repeatForever(),
                value: opacity
            )
            .onAppear(perform: { opacity = 1 })
    }
}

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
}

extension View {
    func blink() -> some View {
        modifier(BlinkAnimation())
    }
}
