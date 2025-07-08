//
//  setter.swift
//  Colo
//
//  Created by Jakub Majka on 22/4/25.
//
import SwiftUI

//func setState(ip: String, state: OperationState) async -> Bool {
//    do {
//        let url = URL(string: "http://" + ip + "/set")!
//        var request = URLRequest(url: url)
//        
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        
//        let encoder = JSONEncoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        let data = try encoder.encode(state)
//        print(String(data: data, encoding: .utf8)!)
//                        
//        request.httpBody = data
//        
//        let (_, response) = try await URLSession.shared.data(for: request)
////        let (_, response) = try await URLSession.shared.upload(for: request, from: data)
//        
//        guard let httpResponse = response as? HTTPURLResponse else { return false }
//
//        return httpResponse.statusCode == 200
//    } catch {
//        print(error)
//        return false
//    }
//}

func WsSetStateProperty(client: WebSocketClient, name: String, state: Int) async -> Void{
//    Task{ @WebSocketActor in
        do{
            let payload: [String: Any] = [
                name: state
            ]
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8){
                print(jsonString)
                try await client.send(.string(jsonString))
            }
        }catch{
                print("Error serializing JSON: \(error)")
            }
}


func setStateProperty(ip: String, name: String, state: Int) async -> Bool{
    do {
        let url = URL(string: "http://" + ip + "/set")!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let payload: [String: Any] = [
            name: state
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
        
//        let data: Data = "{\"\(name)\":\"\(state)\"}"
                        
        request.httpBody = jsonData
        print("setter run")
        print(String(data: jsonData, encoding: .utf8)!)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { return false }

        return httpResponse.statusCode == 200
    } catch {
        print(error)
        return false
    }
}
