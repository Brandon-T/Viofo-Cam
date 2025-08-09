//
//  MediaPlayer.swift
//  Viofo
//
//  Created by Brandon on 2025-08-05.
//

import MobileVLCKit
import SwiftUI

class VLCPlayerModel: ObservableObject {
    let player: VLCMediaPlayer
    let playerView: UIView
    
    init(url: URL) {
        let player = VLCMediaPlayer()
        player.media = VLCMedia(url: url)
        player.media?.addOptions([
            "rtsp-tcp": true
        ])
        
        self.player = player
        
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        
        player.drawable = view
        view.isUserInteractionEnabled = false
        self.playerView = view
    }
    
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
        return Coordinator(player: model.player)
    }
    
    class Coordinator: NSObject, VLCMediaPlayerDelegate {
        let player: VLCMediaPlayer
        
        init(player: VLCMediaPlayer) {
            self.player = player
        }
        
        func mediaPlayerStateChanged(_ aNotification: Notification) {
            switch player.state {
            case .error:
                print("❌ VLC player encountered an error.")
            case .stopped:
                print("✅ VLC stream ended.")
                
                player.stop()
                player.play()
            case .buffering:
                print("⌛ VLC is buffering...")
            case .playing:
                print("▶️ VLC is playing.")
            default:
                break
            }
        }
    }
}
