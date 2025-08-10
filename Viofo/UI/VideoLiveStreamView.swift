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
    @State private var isRecording = false
    @State private var statusMessage = ""
    @State private var showControls = true
    @State private var lastInteraction = Date()
    @State private var showMenu = false
    @State private var isFill = false
    @State private var showFiles = false
    @State private var containerSize: CGSize = .zero
    
    @ObservedObject private var playerModel = VLCPlayerModel(url: URL(string: "rtsp://\(Client.cameraIP)/live")!)
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
                        Image(systemName: isFill ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                            .foregroundColor(.white)
                            .padding(10)
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
                        HStack(spacing: 16) { overlayButtons }
                        VStack(spacing: 16) { overlayButtons }
                    }
                    
                    Spacer()
                    
                    Button {
                        showMenu = true
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable().frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .confirmationDialog("Camera", isPresented: $showMenu, titleVisibility: .visible) {
                        Button("Reboot Camera") {
                            Task { @MainActor in
                                try await Client.restartCamera()
                            }
                        }
                        
                        Button("View Files", role: .destructive) {
                            showFiles = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
                .padding()
                .background(
                    LinearGradient(colors: [Color.black.opacity(0.6), .clear],
                                   startPoint: .bottom, endPoint: .top)
                )
            }
        }
        .popover(isPresented: $showFiles) {
            FilesGridView(playerModel: filePlayerModel)
        }
        .onAppear {
            startAutoHideTimer()
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
    }
    
    @ViewBuilder
    private var playerView: some View {
        VLCPlayerView(model: playerModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .onTapGesture {
                showControls.toggle();
                lastInteraction = Date()
            }
            .onAppear {
                playerModel.player.play();
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: {
                containerSize = $0;
            }
            .modifier(FitOrFillScale(isFill: isFill, videoSize: playerModel.player.videoSize, containerSize: containerSize))
    }
    
    private var overlayButtons: some View {
        Group {
            styledButton(
                label: isRecording ? "Stop" : "Record",
                systemImage: isRecording ? "stop.circle.fill" : "record.circle.fill",
                color: .red
            ) {
                Task {
                    do {
                        if isRecording {
                            let statusMessage = try await Client.stopRecording()
                            print(statusMessage)
                        } else {
                            let statusMessage = try await Client.startRecording()
                            print(statusMessage)
                        }
                        
                        isRecording.toggle()
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
            
            styledButton(
                label: "Photo",
                systemImage: "camera.fill",
                color: .blue
            ) {
                Task { @MainActor in
                    do {
                        let statusMessage = try await Client.getGPSSignal()
                        print(statusMessage)
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
            
            styledButton(
                label: "Format",
                systemImage: "externaldrive.fill.badge.minus",
                color: .orange
            ) {
                Task {
                    do {
                        let statusMessage = try await Client.formatMemory()
                        print(statusMessage)
                    } catch {
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    private func startAutoHideTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if showControls && !showMenu && Date().timeIntervalSince(lastInteraction) > autoHideDelay {
                withAnimation { showControls = false }
            }
        }
    }
    
    private func styledButton(label: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(label)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .foregroundColor(color)
            .clipShape(Capsule())
        }
    }
}

struct FitOrFillScale: ViewModifier {
    let isFill: Bool
    let videoSize: CGSize
    let containerSize: CGSize

    func body(content: Content) -> some View {
        guard isFill,
              videoSize.width > 0, videoSize.height > 0,
              containerSize.width > 0, containerSize.height > 0
        else { return AnyView(content) }

        let vAR = videoSize.width / videoSize.height
        let cAR = containerSize.width / containerSize.height
        let scale = max(cAR / vAR, vAR / cAR)

        return AnyView(
            content
                .scaleEffect(scale, anchor: .center)
                .clipped()
        )
    }
}
