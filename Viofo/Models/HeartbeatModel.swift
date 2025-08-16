//
//  HeartbeatModel.swift
//  Viofo
//
//  Created by Brandon on 2025-08-16.
//

import SwiftUI

@MainActor
final class HeartbeatModel: ObservableObject {
    private var task: Task<Void, Never>?
    
    enum Status {
        case connected
        case disconnected
    }
    
    @Published
    private(set) var status: Status = .disconnected

    func start(interval seconds: Double = 3) {
        stop()
        task = Task {
            let interval: Duration = .seconds(seconds)
            while !Task.isCancelled {
                do {
                    _ = try await Client.heartBeat()
                    status = .connected
                } catch {
                    status = .disconnected
                }
                
                try? await Task.sleep(for: interval)
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    deinit { task?.cancel() }
}
