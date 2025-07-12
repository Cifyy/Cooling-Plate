//
//  SettingsView.swift
//  Colo
//
//  Created by Jakub Majka on 11/7/25.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var client: WebSocketClient
    @AppStorage("serverIp") var ip: String = "0.0.0.0"
    
    var body: some View {
        List{
            HStack{
                Text("Ip address")
                Spacer()
                TextField("192.168.x.x", text: $ip).fixedSize()
            }
        }.onChange(of: ip){
            do{
                try client.changeUrl(ip)
            }catch{
                print("Cannot change url + \(error)")
            }
        }
    }
}

#Preview {
    SettingsView()
}
