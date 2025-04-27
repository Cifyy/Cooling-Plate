//
//  WebSocket.swift
//  Colo
//
//  Created by Jakub Majka on 28/6/25.
//

import Foundation
import Network

<<<<<<< HEAD
struct WebSocketConfiguration {
    var additionalHeaders: [String: String]
    var pingInterval: TimeInterval
    var pingTryReconnectCountLimit: Int

=======
struct WebSocketConfig{
    var additionalHeaders: [String: String]
    var pingInterval: TimeInterval
    var pingTryReconnectCountLimit: Int
    
>>>>>>> webSocket-support
    init(additionalHeaders: [String : String] = [:], pingInterval: TimeInterval = 20, pingTryReconnectCountLimit: Int = 3) {
        self.additionalHeaders = additionalHeaders
        self.pingInterval = pingInterval
        self.pingTryReconnectCountLimit = pingTryReconnectCountLimit
    }
}

<<<<<<< HEAD
enum ConnectionState {
=======
enum ConnectionState{
>>>>>>> webSocket-support
    case disconnected
    case connecting
    case connected
}

@globalActor actor WebSocketActor {
    static let shared = WebSocketActor()
<<<<<<< HEAD
=======
    
    
>>>>>>> webSocket-support
}

typealias WebSocketClientMessage = URLSessionWebSocketTask.Message

@WebSocketActor
<<<<<<< HEAD
class WebSocketClient: NSObject, Sendable {

    private let session: URLSession
    private let url: URL
    private let configuration: WebSocketConfiguration
=======
class WebSocketClient: NSObject, Sendable{
    
    private let session: URLSession
    private let url: URL
    private let configuration: WebSocketConfig
>>>>>>> webSocket-support
    
    private var monitor: NWPathMonitor?
    private var wsTask: URLSessionWebSocketTask?
    private var pingTask: Task<Void, Never>?
    private var pingTryCount = 0
    
<<<<<<< HEAD
    var onReceive: ((Result<WebSocketClientMessage, Error>) -> Void)?
    var onConnectionStateChange: ((ConnectionState) -> Void)?
    
    private(set) var connectionState = ConnectionState.disconnected {
        didSet {
=======
    var onRecive: ((Result<WebSocketClientMessage, Error>) -> Void)?
    var onConnectionStateChange: ((ConnectionState) -> Void)?
    
    private(set) var connectionState = ConnectionState.disconnected{
        didSet{
>>>>>>> webSocket-support
            onConnectionStateChange?(connectionState)
        }
    }
    
<<<<<<< HEAD
    nonisolated init(url: URL, configuration: WebSocketConfiguration, session: URLSession = .init(configuration: .default)) {
=======
    nonisolated init(url: URL, configuration: WebSocketConfig, session: URLSession = .init(configuration: .default)){
>>>>>>> webSocket-support
        self.url = url
        self.configuration = configuration
        self.session = session
    }
<<<<<<< HEAD
    
    func connect() {
        guard wsTask == nil else {
            print("WebSocket Task is already exists")
            return
        }
        
        var request = URLRequest(url: url)
=======
    func connect(){
        guard wsTask == nil else {
            print("websocket already exists")
            return}
        var request = URLRequest(url: url)
        
>>>>>>> webSocket-support
        configuration.additionalHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        wsTask = session.webSocketTask(with: request)
        wsTask?.delegate = self
        wsTask?.resume()
        
        connectionState = .connecting
        receiveMessage()
        startMonitorNetworkConnectivity()
        schedulePing()
<<<<<<< HEAD
        
=======
>>>>>>> webSocket-support
    }
    
    func send(_ message: WebSocketClientMessage) async throws {
        guard let task = wsTask, connectionState == .connected else {
            throw NSError(domain: "WebSocketClient", code: 1, userInfo: [NSLocalizedDescriptionKey: "WebSocket is not connected"])
        }
        try await task.send(message)
    }
    
<<<<<<< HEAD
    func disconnect() {
        disconnect(shouldRemoveNetworkMonitor: true)
    }
    
    private func disconnect(shouldRemoveNetworkMonitor: Bool) {
=======
    func disconnect(){
        disconnect(shouldRemoveNewtorkMonitor: true)
    }
    
    private func disconnect(shouldRemoveNewtorkMonitor: Bool) {
>>>>>>> webSocket-support
        self.wsTask?.cancel()
        self.wsTask = nil
        self.pingTask?.cancel()
        self.pingTask = nil
        self.connectionState = .disconnected
<<<<<<< HEAD
        if shouldRemoveNetworkMonitor {
=======
        if shouldRemoveNewtorkMonitor {
>>>>>>> webSocket-support
            self.monitor?.cancel()
            self.monitor = nil
        }
    }
    
<<<<<<< HEAD
    private func reconnect() {
        self.disconnect(shouldRemoveNetworkMonitor: false)
        self.connect()
    }
    
    private func receiveMessage() {
        self.wsTask?.receive { result in
            Task { @WebSocketActor [weak self] in
                guard let self else { return }
                self.onReceive?(result)
=======
    
    private func reconnect(){
        self.disconnect(shouldRemoveNewtorkMonitor: false)
        self.connect()
    }
    
    private func receiveMessage(){
        self.wsTask?.receive { result in
            Task { @WebSocketActor [weak self] in
                guard let self else { return }
                self.onRecive?(result)
>>>>>>> webSocket-support
                if self.connectionState == .connected {
                    self.receiveMessage()
                }
            }
        }
    }
    
<<<<<<< HEAD
    private func startMonitorNetworkConnectivity() {
=======
    private func startMonitorNetworkConnectivity(){
>>>>>>> webSocket-support
        guard monitor == nil else { return }
        monitor = .init()
        monitor?.pathUpdateHandler = { path in
            Task { @WebSocketActor [weak self] in
                guard let self else { return }
                if path.status == .satisfied, self.wsTask == nil {
                    self.connect()
                    return
                }
                
<<<<<<< HEAD
                if path.status != .satisfied {
                    self.disconnect(shouldRemoveNetworkMonitor: false)
=======
                if path.status != .satisfied{
                    self.disconnect(shouldRemoveNewtorkMonitor: false)
>>>>>>> webSocket-support
                }
            }
        }
        monitor?.start(queue: .main)
    }
    
<<<<<<< HEAD
    private func schedulePing() {
        pingTask?.cancel()
        pingTryCount = 0
        pingTask = Task { [weak self] in
=======
    private func schedulePing(){
        pingTask?.cancel()
        pingTryCount = 0
        
        pingTask = Task { [weak self] in
            
>>>>>>> webSocket-support
            while true {
                try? await Task.sleep(for: .seconds(self?.configuration.pingInterval ?? 5))
                guard !Task.isCancelled, let self, let task = self.wsTask else { break }
                
                if task.state == .running, self.pingTryCount < self.configuration.pingTryReconnectCountLimit {
                    self.pingTryCount += 1
<<<<<<< HEAD
                    print("Ping: Send")
                    task.sendPing { error in
                        if let error {
                            print("Ping Failed: \(error.localizedDescription)")
                        } else {
                            print("Ping: Pong Received")
                            Task { @WebSocketActor [weak self] in
                                self?.pingTryCount = 0
=======
                    print("Ping send")
                    task.sendPing { error in
                        if let error {
                            print("Ping failed: \(error.localizedDescription)")
                        } else{
                            print("Ping: Pong Received")
                            Task { @WebSocketActor [weak self] in
                                self?.pingTryCount = 0
                                
>>>>>>> webSocket-support
                            }
                        }
                    }
                } else {
                    self.reconnect()
                    break
                }
            }
        }
    }
<<<<<<< HEAD
    
}


extension WebSocketClient: URLSessionWebSocketDelegate {
    
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        Task { @WebSocketActor [weak self] in
            self?.connectionState = .connected
        }
    }
    
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        Task { @WebSocketActor [weak self] in
            self?.connectionState = .disconnected
        }
    }
    
=======
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        Task{ @WebSocketActor [weak self] in
            self?.connectionState = .disconnected
        }
    }
>>>>>>> webSocket-support
}
