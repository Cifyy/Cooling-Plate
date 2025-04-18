//
//  ContentView.swift
//  TemperatureControl
//
//  Created by Anik on 10/9/20.
//

import SwiftUI

//class OperationState: Encodable, Equatable, ObservableObject{
//    @Published var selectedMode: OperationMode = .Off
//    
//    @Published var fanSpeedMode: SpeedMode = .one
//    @Published var pumpSpeedMode: SpeedMode = .one
//    
//    @Published var pad0 = PowerState.Off
//    @Published var pad1 = PowerState.Off
//    
//    @Published var autoPreset: AutoPreset = .Normal
//    
//    static func == (lhs: OperationState, rhs: OperationState) -> Bool {
//        return lhs.selectedMode == rhs.selectedMode &&
//            lhs.fanSpeedMode == rhs.fanSpeedMode &&
//            lhs.pumpSpeedMode == rhs.pumpSpeedMode &&
//            lhs.pad0 == rhs.pad0 &&
//            lhs.pad1 == rhs.pad1 &&
//            lhs.autoPreset == rhs.autoPreset
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case selectedMode = "mode"
//        case fanSpeedMode = "fanSpeed"
//        case pumpSpeedMode = "pumpSpeed"
//        case pad0 = "pad_0"
//        case pad1 = "pad_1"
//        case autoPreset
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(selectedMode.rawValue, forKey: .selectedMode)
//        try container.encode(fanSpeedMode.rawValue, forKey: .fanSpeedMode)
//        try container.encode(pumpSpeedMode.rawValue, forKey: .pumpSpeedMode)
//        try container.encode(pad0.rawValue, forKey: .pad0)
//        try container.encode(pad1.rawValue, forKey: .pad1)
//        try container.encode(autoPreset.rawValue, forKey: .autoPreset)
//    }
//}



struct ContentView: View {
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    let coolantConfig = coolantDefaultConfig
    let humidityConfig = humidityDefaultConfig
    let ambientTemperatureConfig = ambientDefaultTemperatureConfig
    
//    @StateObject var state = OperationState()
//    @State private var lastSentState = OperationState()

    @State var selectedMode: OperationMode = .Off
    
    @State var fanSpeedMode: SpeedMode = .one
    @State var pumpSpeedMode: SpeedMode = .one
    
    @State var pad0 = PowerState.Off
    @State var pad1 = PowerState.Off
    
    @State var autoPreset: AutoPreset = .Normal
    @State var goalTemperature: CGFloat = 0
    
    @State var editLock: Int = 0
//
    @State var coolantTemperature: CGFloat = 60
    @State var humidity: CGFloat = 97
    @State var ambientTemperature: CGFloat = 28
    
    let ip = "192.168.1.108"
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
                .edgesIgnoringSafeArea(.all)
            VStack{
                AutoView(selectedMode: $selectedMode, temperatureValue: $goalTemperature).opacity(selectedMode == .Off ? 0.6 : 1)
                HStack{
                    Spacer()
                    gauge(value: $coolantTemperature, config: coolantConfig)
                    Spacer()
                    gauge(value: $humidity, config: humidityConfig)
                    Spacer()
                    gauge(value: $ambientTemperature, config: ambientTemperatureConfig)
                    Spacer()
                }.opacity(selectedMode == .Off ? 0.6 : 1)
                //wifi.exclamationmark
                PickerView("Mode", $selectedMode, name:"mode",ip: ip)

                if(selectedMode == .Manual){
                    PickerView("Fan", $fanSpeedMode,name: "fan_speed", ip: ip).padding(.top,30)
                    PickerView("Pump", $pumpSpeedMode,name: "pump_speed", ip: ip).padding(.top,10)
                    PickerView("Pad 1", $pad0,name: "pad_0",ip: ip).padding(.top,15)
                    PickerView("Pad 2", $pad1,name: "pad_1", ip: ip).padding(.top,10)
                    
                }else if (selectedMode == .Auto){
                    PickerView("Preset",$autoPreset,name: "auto_preset", ip: ip).padding(.top,30)
                }
                Spacer()
            }.frame(maxWidth: 500)
        }
        .onReceive(timer) { time in
            loadStatusData()
        }
        .onAppear{
              loadStatusData()
        }
        .onChange(of: selectedMode){ oldState, newState in
            if oldState != newState {
                editLock += 1
                Task{
                    if await setStateProperty(ip: ip,name: "mode", state: newState.rawValue){
                            do{sleep(2)}
                            editLock -= 1
                        //haptics
                    }
                }
            }
        }
    }
    
    func loadStatusData(){
        if editLock > 0{
            print(editLock)
            print("aborting")
            return
        }
        Task{
            do{
                let data = try await getStatus(ip: ip)
                coolantTemperature = data.coolantTemperature
                ambientTemperature = data.ambientTemperature
                humidity = CGFloat(data.humidity)
                setSpeed(speed: $fanSpeedMode, val: data.fanSpeed)
                setSpeed(speed: $pumpSpeedMode, val: data.pumpSpeed)
                setPad(pad: $pad0, state: data.pad0)
                setPad(pad: $pad1, state: data.pad1)
                setAutoPreset(autoPreset: $autoPreset, preset: data.autoPreset)
                setOperationMode(operationMode: $selectedMode, mode: data.operationMode)
                
            }catch{print(error)}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

