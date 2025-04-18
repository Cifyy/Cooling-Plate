//
//  fetcher.swift
//  Colo
//
//  Created by Jakub Majka on 19/4/25.
//
import Foundation
import SwiftUI

enum fetchError: Error{
    case invalidIP
    case invalidResponse
    case urlError
    case decodeError
}

struct ResponseStatus: Decodable{
    let operationMode: Int
    let autoPreset: Int
    let pad0: Bool
    let pad1: Bool
    let fanSpeed: Int
    let pumpSpeed: Int
    let coolantTemperature: Double
    let ambientTemperature: Double
    let humidity: Double
}

func getStatus(ip: String) async throws -> ResponseStatus{
    let endpoint = "http://" + ip + "/status"
    guard let url = URL(string: endpoint) else { throw fetchError.invalidIP }
    
    let(data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{ throw fetchError.urlError }
    
    do{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ResponseStatus.self, from: data)
    } catch {
        print(error)
        throw fetchError.decodeError
    }
}
    
    
    
//    
//    
//    
//    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//        guard let data = data else { return }
//        print(String(data: data, encoding: .utf8)!)
//        
//        if String(data: data, encoding: .utf8)! != "" {
//            data.
//        let setbright = getQueryStringParameter(url:(String(data: data, encoding: .utf8)!), param: "bright")
//        var setstatus = getQueryStringParameter(url:(String(data: data, encoding: .utf8)!), param: "status")
//        let seteffect = getQueryStringParameter(url:(String(data: data, encoding: .utf8)!), param: "cureffect")
//            if setstatus == "1"{
//                onOff = true
//                setstatus = "0"
//            }
//            if seteffect! != "" {
//                if Int(seteffect!) == 20 {
//                    currentPlaying = "None"
//                }else{
//                currentPlaying = effectsid[Int(seteffect!)!]
//                }
//                print(seteffect!)
//            }
//            brightness = (setbright! as NSString).doubleValue / 2.55
//        }else {
//            onOff = false
//        }
//    }
//    
//    task.resume()
//}
