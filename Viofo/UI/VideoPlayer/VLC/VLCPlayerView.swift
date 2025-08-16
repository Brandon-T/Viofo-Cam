//
//  MediaPlayer.swift
//  Viofo
//
//  Created by Brandon on 2025-08-05.
//

#if canImport(MobileVLCKit)
import MobileVLCKit
#else
import VLCKit
#endif

import SwiftUI

class VLCPlayerModel: ObservableObject {
    let player: VLCMediaPlayer
    
    @Published
    fileprivate(set) var isLoading: Bool = false
    
    @Published
    fileprivate(set) var isRendering: Bool = false
    
    fileprivate let playerView: UIView
    
    init() {
        let player = VLCMediaPlayer()
        self.player = player
        
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        
        player.drawable = view
        view.isUserInteractionEnabled = false
        self.playerView = view
    }
    
    convenience init(url: URL) {
        self.init()
        player.media = VLCMedia(url: url)
        setMediaURL(url)
    }
    
    func setMediaURL(_ url: URL?) {
        if let url = url {
            player.media = VLCMedia(url: url)
        } else {
            player.media = nil
        }
        
        player.media?.addOptions([
            "network-caching": 0,
            "live-caching": 0,
            "rtsp-tcp": true
        ])
        
        player.media?.addOptions([
                    "network-caching": 500,
                    "sout-rtp-caching": 100,
                    ":rtp-timeout": 10000,
                    ":rtsp-tcp": true,
                    ":rtsp-frame-buffer-size": 1024,
                    ":rtsp-caching": 0,
                    ":live-caching": 0,
        ])
        
        player.media?.addOption(":codec=avcodec")
        player.media?.addOption(":vcodec=h264")
        player.media?.addOption("--file-caching=2000")
        player.media?.addOption("clock-jitter=0")
        player.media?.addOption("--rtsp-tcp")
        player.media?.clearStoredCookies()
        
        player.audio?.isMuted = false  // TODO.

    }
    
    #if canImport(MobileVLCKit)
    func setFullScreen(enabled: Bool, containerSize: CGSize) {
        if enabled {
            let size = player.videoSize
            let screen = containerSize
            let targetAspect = screen.width / screen.height

            if let geom = cropGeometry(for: size, targetAspect: targetAspect) {
                setCropGeometry(geom)
            } else {
                setCropGeometry(nil)
            }
        } else {
            setCropGeometry(nil)
        }
    }
    
    func cropGeometry(for source: CGSize, targetAspect: CGFloat) -> String? {
        let sw = Int(source.width), sh = Int(source.height)
        let sAR = source.width / source.height
        if abs(sAR - targetAspect) < 0.001 { return nil } // already matches

        if sAR > targetAspect {
            let cropW = Int(round(source.height * targetAspect))
            let x = max(0, (sw - cropW) / 2)
            return "\(cropW)x\(sh)+\(x)+0"
        } else {
            let cropH = Int(round(source.width / targetAspect))
            let y = max(0, (sh - cropH) / 2)
            return "\(sw)x\(cropH)+0+\(y)"
        }
    }
    
    /// Set aspect ratio (e.g. "16:9", "4:3", "1:1", "9:16"). Pass nil to reset.
    func setAspectRatio(_ ratio: String?) {
        if let ratio {
            ratio.withCString { cstr in
                player.videoAspectRatio = UnsafeMutablePointer(mutating: cstr)
            }
        } else {
            player.videoAspectRatio = nil
        }
    }
    
    /// Get current aspect ratio as Swift String (remember: getter allocates)
    func getAspectRatio() -> String? {
        guard let p = player.videoAspectRatio else { return nil }
        defer { free(p) }
        return String(cString: p)
    }
    
    /// Set crop geometry like "WxH+X+Y" (e.g. "1000x562+0+79"). Pass nil to unset.
    func setCropGeometry(_ geometry: String?) {
        if let geometry {
            geometry.withCString { cstr in
                player.videoCropGeometry = UnsafeMutablePointer(mutating: cstr)
            }
        } else {
            player.videoCropGeometry = nil
        }
    }
    
    /// Get current crop geometry as Swift String
    func getCropGeometry() -> String? {
        guard let p = player.videoCropGeometry else { return nil }
        defer { free(p) }
        return String(cString: p)
    }
    #endif
}

struct VLCPlayerView: UIViewRepresentable {
    private let model: VLCPlayerModel
    
    init(model: VLCPlayerModel) {
        self.model = model
    }

    func makeUIView(context: Context) -> UIView {
        model.player.delegate = context.coordinator
        return model.playerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(model: model)
    }
    
    class Coordinator: NSObject, VLCMediaPlayerDelegate {
        private weak var model: VLCPlayerModel?
        private var lastPTS: VLCTime?
        private var lastAdvanceAt = Date.distantPast
        
        init(model: VLCPlayerModel) {
            self.model = model
        }
        
        func mediaPlayerTimeChanged(_ note: Notification) {
            guard let model = model else { return }
            let player = model.player
            
            if let last = lastPTS, player.time.intValue > last.intValue {
                model.isRendering = true
                lastAdvanceAt = Date()
            } else {
                // If we're "playing" but time hasn't advanced for a bit, we're stalled
                if player.state == .playing && Date().timeIntervalSince(lastAdvanceAt) > 1.0 {
                    model.isRendering = false
                }
            }
            
            lastPTS = player.time
        }
        
        func mediaPlayerStateChanged(_ aNotification: Notification) {
            guard let model = model else { return }
            let player = model.player
            
            switch player.state {
            case .opening, .buffering:
                model.isLoading = true
                model.isRendering = false
                
            case .playing:
                model.isLoading = false
                
            case .paused:
                model.isLoading = false
                model.isRendering = false
                
            case .stopped, .ended, .error:
                model.isLoading = false
                model.isRendering = false
                lastPTS = nil
                lastAdvanceAt = .distantPast
                
                Task { @MainActor [weak model] in
                    try await Task.sleep(for: .milliseconds(2000))
                    model?.player.play()
                }
                
            default:
                break
            }
        }
    }
}
