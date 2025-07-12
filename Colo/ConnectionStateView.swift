//
//  ConnectionStatusView.swift
//  Colo
//
//  Created by Jakub Majka on 11/7/25.
//

import SwiftUI

struct ConnectionStateView: View {
    
    @Binding var connectionState: ConnectionState
    
    var body: some View {
        HStack(spacing: 3){
            Spacer()
            Circle()
                .frame(height: 12)
                .blink()
                .connectionColor(connectionState)
            Text(connectionState.rawValue)
                .font(.system(size: 10))
                .foregroundColor(.white)
                .fontWeight(.semibold)
            Spacer()
        }.offset(y: -34)    }
}

//#Preview {
//    ConnectionStatusView()
//}
