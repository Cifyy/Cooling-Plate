//
//  ContentView.swift
//  TemperatureControl
//
//  Created by Jakub Majka on 19/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var client: WebSocketClient
    @EnvironmentObject var plateState: PlateState
    
    let coolantConfig = coolantDefaultConfig
    let humidityConfig = humidityDefaultConfig
    let ambientTemperatureConfig = ambientDefaultTemperatureConfig
    
    @State var connectionState: ConnectionState = .disconnected
    @State var showSettingsSheet = false
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.init(red: 34/255, green: 30/255, blue: 47/255)).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        showSettingsSheet.toggle()
                    }) {
                        Image(systemName: "slider.vertical.3").font(.system(size: 23)).foregroundStyle(.white)
                    }.padding(15)
                }
                ConnectionStateView(connectionState: $connectionState).padding(.top, 218)
                Spacer()
            }
            VStack(spacing: 3){
                AutoView().opacity(plateState.selectedMode == .Off && connectionState == .connected ? 0.6 : 1)
                
                HStack{
                    Spacer()
                    Gauge(value: $plateState.coolantTemperature, config: coolantConfig)
                    Spacer()
                    Gauge(value: $plateState.humidity, config: humidityConfig)
                    Spacer()
                    Gauge(value: $plateState.ambientTemperature, config: ambientTemperatureConfig)
                    Spacer()
                }
//                .opacity(plateState.selectedMode == .Off ? 0.6 : 1)
                
                
                PickerView("Mode", $plateState.selectedMode, name: "mode")

                if(plateState.selectedMode == .Manual){
                    
                    PickerView("Fan",   $plateState.fanSpeedMode,   name: "fan_speed"   ).padding(.top,25)
                    PickerView("Pump",  $plateState.pumpSpeedMode,  name: "pump_speed"  ).padding(.top,8)
                    PickerView("Pad 1", $plateState.pad0,           name: "pad_0"       ).padding(.top,20)
                    PickerView("Pad 2", $plateState.pad1,           name: "pad_1"       ).padding(.top,8)
                    
                }else if (plateState.selectedMode == .Auto){
                    
                    PickerView("Preset",$plateState.autoPreset,name: "auto_preset").padding(.top,25)
                    
                }
                Spacer()
            }.frame(maxWidth: 500)
                .onAppear(){
                    Task{ @WebSocketActor in
                        client.onConnectionStateChange = { state in
                            Task{ @MainActor in
                                connectionState = await client.connectionState
                                print("Connection state: \(state)")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showSettingsSheet) {
                    SettingsView()
                        .presentationDetents([.fraction(0.3)])
                        .presentationDragIndicator(.visible)
                }
                .opacity(connectionState != .connected ? 0.6 : 1)
                
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

