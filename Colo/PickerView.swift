//
//  PickerView.swift
//  Colo
//
//  Created by Jakub Majka on 19/4/25.
//

import SwiftUI

struct PickerView<O: CaseIterable & Identifiable & Hashable & RawRepresentable>: View where O.AllCases: RandomAccessCollection{
    @EnvironmentObject var client: WebSocketClient
    let headline: String
    let name: String
    
    @Binding var selection: O
    
    init(_ headline: String, _ selection: Binding<O>, name: String) {
        self.headline = headline
        self._selection = selection
        self.name = name
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            Text(headline)
                .font(.system(size: 12))
                .foregroundColor(.white)
            //                .opacity(0.85)
            Picker(headline, selection: $selection) {
                ForEach(O.allCases) { mode in
                    Text(String(describing: mode))
                        .tag(mode)
                        .foregroundColor(.white)
                        .frame(height: 44)
                }
            }
            .background(Color(.systemGray6).opacity(0.6))
            .pickerStyle(.segmented)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .tint(.white)
            
        }.padding(.horizontal, 20)
            .onChange(of: selection){ oldState, newState in
                if oldState != newState {
                    Task{ @WebSocketActor in
                        await WsSetStateProperty(client: client, name: name, state: newState.rawValue as! Int)
                    }
                }
            }
    }
}

//#Preview {
//    PickerView()
//}
