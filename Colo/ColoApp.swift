//
//  ColoApp.swift
//  Colo
//
//  Created by Jakub Majka on 18/4/25.
//

import SwiftUI
import SwiftData

@main
struct ColoApp: App {
    
    @State private var triggerFeedback = false
    @State var plateState = PlateState()
    @StateObject var client = WebSocketClient(url: URL(string: "ws://192.168.1.62")!,
                                              configuration: .init(additionalHeaders: [:],
                                                                   pingInterval: 2,
                                                                   pingTryReconnectCountLimit: 2))
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(client)
                .environmentObject(plateState)
                .onAppear{
                    startWebSocket()
                }
                .sensoryFeedback(.impact(weight: .light), trigger: triggerFeedback)
            
        }
    }
    
    func startWebSocket(){
        Task{ @WebSocketActor in
            print("Starting websocket")
            await client.connect()
            client.onReceive = { result in
                switch result{
                case .success(let message):
                    switch message{
                    case .string(let text):
                        print("Received: \(text)")
                        Task{ @MainActor in
                            if text == "ok"{
                                triggerFeedback.toggle()
                            }else{
                                plateState.update(from: text)
                            }
                        }
                    default: break
                    }
                case .failure(let error):
                    print("Receiving error: \(error)")
                }
            }
            //Request initial state
            //            client.send(message: WebSocketClientMessage())
        }
    }
}
