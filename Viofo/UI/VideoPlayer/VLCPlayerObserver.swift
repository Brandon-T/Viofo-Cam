//
//  VLCPlayerObserver.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

#if canImport(MobileVLCKit)
import MobileVLCKit
#else
import VLCKit
#endif

import SwiftUI
import Combine

class VLCPlayerObserver: ObservableObject {
    private var player: VLCMediaPlayer
    
    @Published var isPlaying: Bool = false
    @Published var isSeekable: Bool = false
    @Published var position: Float = 0.0
    @Published var duration: Double = 0.0
    @Published var elapsedTime: Double = 0.0
    @Published var remainingTime: Double = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?

    init(player: VLCMediaPlayer) {
        self.player = player

        // KVO doesn't seem to work well, if at all.
        // So we use a timer instead
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updatePublishedProperties()
        }
        
        /*cancellables.append(player.observe(\.position, options: [.initial, .new]) { [weak self] player, change in
            guard let self = self, let value = change.newValue else { return }
            self.position = Double(value) / 1000.0
        })
        
        cancellables.append(player.observe(\.time, options: [.initial, .new]) { [weak self] player, change in
            guard let self = self, let value = change.newValue else { return }
            self.elapsedTime = Double(value.intValue) / 1000.0
        })
        
        cancellables.append(player.observe(\.remainingTime, options: [.initial, .new]) { [weak self] player, change in
            guard let self = self, let value = change.newValue else { return }
            self.remainingTime = Double(value?.intValue ?? 0) / 1000.0
        })
        
        cancellables.append(player.observe(\.isPlaying, options: [.initial, .new]) { [weak self] player, change in
            guard let self = self, let value = change.newValue else { return }
            self.isPlaying = value
        })
        
        cancellables.append(player.observe(\.isSeekable, options: [.initial, .new]) { [weak self] player, change in
            guard let self = self, let value = change.newValue else { return }
            self.isSeekable = value
        })
        
        cancellables.append(player.observe(\.media, options: [.initial, .new]) { [weak self] player, change in
            guard let self = self, let value = change.newValue else { return }
            self.duration = Double(value?.length.intValue ?? 0) / 1000.0
        })*/
    }
    
    deinit {
        timer?.invalidate()
    }

    private func updatePublishedProperties() {
        self.isPlaying = self.player.isPlaying
        self.isSeekable = self.player.isSeekable
        self.position = self.player.position
        self.duration = Double(self.player.media?.length.intValue ?? 0) / 1000.0
        self.elapsedTime = Double(self.player.time.intValue) / 1000.0
        self.remainingTime = self.duration - self.elapsedTime
    }
}
