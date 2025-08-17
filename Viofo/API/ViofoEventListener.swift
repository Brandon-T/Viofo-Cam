//
//  ViofoEventListener.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

import Foundation
import Network

class ViofoEventListener: ObservableObject {
    @Published
    private(set) var isConnected: Bool = false
    
    @Published
    private(set) var error: Error?
    
    @Published
    private(set) var status: Int = -1
    
    private let queue = DispatchQueue(label: "com.viofo.camkit.socket.manager")
    private var connection: NWConnection
    
    init() {
        let host = NWEndpoint.Host(Client.cameraIP)
        let port = NWEndpoint.Port(rawValue: UInt16(Client.cameraPort))!
        
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableFastOpen = true
        tcpOptions.enableKeepalive = true
        let params = NWParameters(tls: nil, tcp: tcpOptions)
        
        connection = NWConnection(host: host, port: port, using: params)
        connection.stateUpdateHandler = { [weak self] newState in
            Task { @MainActor in
                guard let self = self else { return }
                
                switch newState {
                case .ready:
                    self.isConnected = true
                    self.receiveData()
                    
                case .failed(let error):
                    self.error = error
                    self.isConnected = false
                    
                case .cancelled:
                    self.isConnected = false
                    
                case .setup, .waiting, .preparing:
                    break
                    
                @unknown default:
                    break
                }
            }
        }
        
        connection.start(queue: queue)
    }
    
    deinit {
        connection.cancel()
    }
    
    private func receiveData() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] (data, _, isComplete, error) in
            if let error = error {
                Task { @MainActor in
                    self?.error = error
                    self?.isConnected = false
                }
                return
            }

            guard let self = self, let data = data else {
                return
            }
            
            self.receivedData(data)

            if !isComplete {
                self.receiveData()
            }
        }
    }
    
    private func receivedData(_ data: Data) {
        do {
            print(String(data: data, encoding: .utf8)!)
            
            guard let response = try? XMLDecoder().decode(CommonResponse.self, from: data) else {
                throw NSError(domain: "SocketManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to parse XML."])
            }
            
            Task { @MainActor in
                self.status = response.status
            }
        } catch {
            self.error = error
        }
    }
}
