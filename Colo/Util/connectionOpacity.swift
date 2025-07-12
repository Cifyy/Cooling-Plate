//
//  dotBlinkingAnimation.swift
//  Colo
//
//  Created by Jakub Majka on 9/7/25.
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
