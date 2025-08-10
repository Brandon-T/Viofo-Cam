//
//  PlayerView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-09.
//

import SwiftUI

struct PlayerView: View {
    @StateObject
    private var playerModel: VLCPlayerModel
    
    private var url: URL
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var showControls: Bool = false
    
    @State
    private var lastInteraction: Date = .now
    
    @State
    private var containerSize: CGSize = .zero
    
    @State
    private var isFill: Bool = false
    
    private var autoHideDelay: TimeInterval = 3.0
    
    init(playerModel: VLCPlayerModel, url: URL) {
        self._playerModel = .init(wrappedValue: playerModel)
        self.url = url
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VLCPlayerView(model: playerModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .onTapGesture {
                    showControls.toggle();
                    lastInteraction = Date()
                }
                .onAppear {
                    playerModel.setMediaURL(url)
                    playerModel.player.play();
                }
                .onDisappear {
                    playerModel.player.stop()
                    playerModel.setMediaURL(nil)
                }
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: {
                    containerSize = $0;
                }
                .modifier(FitOrFillScale(isFill: isFill, videoSize: playerModel.player.videoSize, containerSize: containerSize))
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            if showControls {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 3.0)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isFill.toggle()
                    }) {
                        Image(systemName: isFill ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                            .foregroundColor(.white)
                            .padding(10.0)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
        .overlay(alignment: .bottom) {
            if showControls {
                PlayerControls(model: playerModel)
                    .padding(.bottom, 8.0)
                    .opacity(showControls ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2), value: showControls)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if showControls && Date().timeIntervalSince(lastInteraction) > autoHideDelay {
                    withAnimation { showControls = false }
                }
            }
        }
        .onTapGesture {
            showControls.toggle()
            lastInteraction = Date()
        }
    }
}

private struct PlayerControls: View {
    @ObservedObject
    var model: VLCPlayerModel
    
    @ObservedObject
    private var observer: VLCPlayerObserver

    @State
    private var isScrubbing: Bool = false
    
    @State
    private var sliderPosition: Double = 0.0
    
    init(model: VLCPlayerModel) {
        self.model = model
        self._observer = .init(initialValue: VLCPlayerObserver(player: model.player))
        self._sliderPosition = .init(initialValue: Double(model.player.position))
    }

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 36.0) {
                Button { skip(seconds: -10.0) } label: {
                    Image(systemName: "gobackward.10").font(.system(size: 28.0))
                }
                Button {
                    togglePlay()
                } label: {
                    Image(systemName: observer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 54.0))
                }
                Button { skip(seconds: +10.0) } label: {
                    Image(systemName: "goforward.10").font(.system(size: 28.0))
                }
            }
            .tint(.white)
            .padding(.bottom, 24.0)
            
            if observer.isSeekable {
                HStack(spacing: 10.0) {
                    Text(formatTime(isScrubbing ? observer.duration * sliderPosition : observer.elapsedTime))
                        .foregroundStyle(.white)
                    
                    Slider(
                        value: $sliderPosition,
                        in: 0...1,
                        onEditingChanged: { isEditing in
                            isScrubbing = isEditing
                            if !isEditing {
                                seek(toPosition: sliderPosition)
                            }
                        }
                    )
                    .tint(.white)
                    .onChange(of: observer.position) { newPosition in
                        if !isScrubbing {
                            sliderPosition = Double(newPosition)
                        }
                    }
                    
                    Text(formatTime(isScrubbing ? observer.duration - (observer.duration * sliderPosition) : observer.remainingTime))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Player interactions

    private func togglePlay() {
        if model.player.isPlaying {
            model.player.pause()
        } else {
            model.player.play()
        }
    }

    private func skip(seconds: Double) {
        if seconds > 0.0 {
            model.player.jumpForward(Int32(seconds))
        } else {
            model.player.jumpBackward(Int32(-seconds))
        }
    }

    private func seek(toPosition pos: Double) {
        model.player.position = Float(pos)
    }

    // MARK: - Utils

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "00:00" }
        let total = Int(abs(seconds).rounded())
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s)
                      : String(format: "%02d:%02d", m, s)
    }
}
