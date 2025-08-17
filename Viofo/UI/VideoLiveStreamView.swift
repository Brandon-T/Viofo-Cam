//
//  VideoLiveStreamView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-05.
//

import SwiftUI
import AVKit

#if canImport(MobileVLCKit)
import MobileVLCKit
#else
import VLCKit
#endif

struct VideoLiveStreamView: View {
    @State private var isMicrophone = false
    @State private var isRecording = false
    @State private var statusMessage = ""
    @State private var showControls = true
    @State private var lastInteraction = Date()
    @State private var showMenu = false
    @State private var isFill = false
    @State private var showFiles = false
    @State private var showSettings = false
    @State private var containerSize: CGSize = .zero
    @Namespace private var controlsNamespace
    
    @State private var liveStreamURL: URL?
    @ObservedObject private var eventListener: ViofoEventListener = .init()
    @ObservedObject private var heartbeatModel = HeartbeatModel()
    @ObservedObject private var playerModel = VLCPlayerModel()
    @ObservedObject private var filePlayerModel = VLCPlayerModel()
    
    private let autoHideDelay: TimeInterval = 3.0
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            playerView.ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            if showControls {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isFill.toggle()
                    }) {
                        let idiom = UIDevice.current.userInterfaceIdiom
                        
                        Image(systemName: isFill ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                            .foregroundColor(.white)
                            .font(idiom == .pad ? .title : .body)
                            .padding(idiom == .pad ? 12.0 : 10.0)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
        .overlay(alignment: .bottom) {
            if showControls {
                HStack {
                    ViewThatFits {
                        HStack(spacing: 16) { overlayButtons.transition(.opacity.combined(with: .scale)) }
                        VStack(spacing: 16) { overlayButtons.transition(.opacity.combined(with: .scale)) }
                    }
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showControls)
                    
                    Spacer()
                    
                    Button {
                        showMenu = true
                    } label: {
                        let idiom = UIDevice.current.userInterfaceIdiom
                        
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .frame(width: idiom == .pad ? 48.0 : 30.0, height: idiom == .pad ? 48.0 : 30.0)
                            .foregroundColor(.white)
                            .padding(.leading, 8.0)
                    }
                    .confirmationDialog("Camera", isPresented: $showMenu, titleVisibility: .visible) {
                        Button("View Files") {
                            showFiles = true
                        }
                        
                        Button("Settings") {
                            showSettings = true
                        }
                        
                        Button("Cancel", role: .destructive) {}
                    }
                }
                .padding()
                .background(
                    LinearGradient(colors: [Color.black.opacity(0.6), .clear],
                                   startPoint: .bottom, endPoint: .top)
                )
            } else {
                HStack(spacing: 16.0) {
                    let idiom = UIDevice.current.userInterfaceIdiom
                    HStack {
                        if isMicrophone {
                            PulsingIcon(systemName: "microphone.fill", enabled: true)
                                .font(idiom == .pad ? .title : .body)
                        } else {
                            Image(systemName: "microphone.slash")
                                .font(idiom == .pad ? .title : .body)
                        }
                    }
                    .padding(.horizontal, idiom == .pad ? 18.0 : 12.0)
                    .padding(.vertical, idiom == .pad ? 12.0 : 8.0)
                    .background(.ultraThinMaterial)
                    .foregroundColor(isMicrophone ? Color.green : Color.red)
                    .clipShape(Circle())
                    .matchedGeometryEffect(id: "microphone_button", in: controlsNamespace)
                    
                    HStack {
                        if isRecording {
                            PulsingIcon(systemName: "record.circle.fill", enabled: true)
                                .font(idiom == .pad ? .title : .body)
                        } else {
                            ZStack {
                                Image(systemName: "record.circle")
                                    .font(idiom == .pad ? .title : .body)
                                
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: idiom == .pad ? 40.0 : 20.0, height: 2.0)
                                    .rotationEffect(.degrees(45.0))
                            }
                        }
                    }
                    .padding(.horizontal, idiom == .pad ? 18.0 : 12.0)
                    .padding(.vertical, idiom == .pad ? 12.0 : 8.0)
                    .background(.ultraThinMaterial)
                    .foregroundColor(isRecording ? Color.green : Color.red)
                    .clipShape(Circle())
                    .matchedGeometryEffect(id: "record_button", in: controlsNamespace)
                    
                    HStack {
                        EmptyView()
                    }
                    .matchedGeometryEffect(id: "photo_button", in: controlsNamespace)
                    .matchedGeometryEffect(id: "change_camera_button", in: controlsNamespace)
                    .hidden()
                    
                    Spacer()
                }
                .padding()
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showControls)
                .background(
                    LinearGradient(colors: [Color.black.opacity(0.6), .clear],
                                   startPoint: .bottom, endPoint: .top)
                )
            }
        }
        .sheet(isPresented: $showFiles) {
            FilesGridView(playerModel: filePlayerModel)
        }
        .sheet(isPresented: $showSettings) {
            SettingsScreen()
        }
        .task {
            startAutoHideTimer()
            
            do {
                heartbeatModel.start()
                
                let cameraKit = try await CameraKit.shared()
                let streamData = try await cameraKit.getLiveViewUrl()
                liveStreamURL = URL(string: streamData.movieLiveViewLink.replacingOccurrences(of: "/xxx", with: "\(Client.cameraIP)/xxx"))
                
//                try await Client.startLiveView()
//                try await Client.changeToPlayBackMode2()
                
                let settings = try await cameraKit.getAllSettingStatus()
                if let recordingSetting = settings.first(where: { $0.cmd == cameraKit.command.MOVIE_RECORD }) {
                    isRecording = recordingSetting.status == 1
                }
                
                if let recordingAudioSetting = settings.first(where: { $0.cmd == cameraKit.command.MICROPHONE }) {
                    isMicrophone = recordingAudioSetting.status == 1
                }
            } catch {
                print("ERROR: \(error)")
            }
        }
        .onTapGesture {
            showControls = true
            lastInteraction = Date()
        }
        .onChange(of: showMenu) { isOpen in
            if isOpen {
                showControls = true
                lastInteraction = Date()
            }
        }
//        .onChange(of: eventListener.status) { value in
//            if value == 1 {
//                isRecording = true
//            } else if value == 2 {
//                isRecording = false
//            } else if value == 4 {
//                isMicrophone = true
//            } else if value == 5 {
//                isMicrophone = false
//            }
//        }
        .onChange(of: heartbeatModel.status) {
            print("Heartbeat: \($0)")
        }
    }
    
    @ViewBuilder
    private var playerView: some View {
        VLCPlayerView(model: playerModel)
            .persistentSystemOverlays(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .onTapGesture {
                showControls.toggle();
                lastInteraction = Date()
            }
            .onChange(of: liveStreamURL) {
                playerModel.setMediaURL($0)
                playerModel.player.play();
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: {
                containerSize = $0;
            }
            .modifier(FitOrFillScale(isFill: isFill, videoSize: playerModel.player.videoSize, containerSize: containerSize))
//            .overlay {
//                if !playerModel.isRendering {
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                        .controlSize(.large)
//                        .tint(Color.white)
//                }
//            }
    }
    
    private var overlayButtons: some View {
        Group {
            styledButton(
                label: isMicrophone ? "Mic On" : "Mic Off",
                systemImage: isMicrophone ? "microphone.fill" : "microphone.slash",
                color: isMicrophone ? .green : .gray,
                canPulse: isMicrophone
            ) {
                Task {
                    do {
                        if isMicrophone {
                            _ = try await CameraKit.shared().stopRecordingAudio()
                        } else {
                            _ = try await CameraKit.shared().startRecordingAudio()
                        }
                        
                        isMicrophone.toggle()
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .matchedGeometryEffect(id: "microphone_button", in: controlsNamespace)
            
            styledButton(
                label: isRecording ? "Stop Recording" : "Recording Off",
                systemImage: isRecording ? "stop.circle.fill" : "record.circle.fill",
                color: isRecording ? .red : .red,
                canPulse: isRecording
            ) {
                Task {
                    do {
                        if isRecording {
                            _ = try await CameraKit.shared().stopRecording()
                        } else {
                            _ = try await CameraKit.shared().startRecording()
                        }
                        
                        isRecording.toggle()
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .matchedGeometryEffect(id: "record_button", in: controlsNamespace)
            
            styledButton(
                label: "Photo",
                systemImage: "camera.fill",
                color: .blue,
                canPulse: false
            ) {
                Task { @MainActor in
                    do {
                        _ = try await CameraKit.shared().takeSnapshot()
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .matchedGeometryEffect(id: "photo_button", in: controlsNamespace)
            
            styledButton(
                label: "Change Camera",
                systemImage: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill",
                color: .orange,
                canPulse: false
            ) {
                Task {
                    do {
                        _ = try await CameraKit.shared().toggleLiveVideoSource()
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .matchedGeometryEffect(id: "change_camera_button", in: controlsNamespace)
        }
    }
    
    private func startAutoHideTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if showControls && !showMenu && Date().timeIntervalSince(lastInteraction) > autoHideDelay {
                withAnimation { showControls = false }
            }
        }
    }
    
    private func styledButton(label: String, systemImage: String, color: Color, canPulse: Bool, action: @escaping () -> Void) -> some View {
        let idiom = UIDevice.current.userInterfaceIdiom
        
        return Button(action: action) {
            HStack {
                if canPulse {
                    PulsingIcon(systemName: systemImage, enabled: canPulse)
                        .font(idiom == .pad ? .title : .body)
                } else {
                    Image(systemName: systemImage)
                        .font(idiom == .pad ? .title : .body)
                }
                
                Text(label)
                    .font(idiom == .pad ? .title : .body)
            }
            .padding(.horizontal, idiom == .pad ? 18.0 : 12.0)
            .padding(.vertical, idiom == .pad ? 12.0 : 8.0)
            .background(.ultraThinMaterial)
            .foregroundColor(color)
            .clipShape(Capsule())
        }
    }
    
    struct PulsingIcon: View {
        let systemName: String
        var enabled: Bool = true
        @State private var on = false

        var body: some View {
            Image(systemName: systemName)
                .scaleEffect(enabled && on ? 1.15 : 1.0)
                .opacity(enabled && on ? 1.0 : 0.6)
                .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: on)
                .onAppear { if enabled { on = true } }
                .onDisappear { on = false }
        }
    }
}
