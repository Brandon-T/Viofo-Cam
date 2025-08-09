//
//  ThumbnailView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import AVKit
import UIKit
import SwiftUI

struct VideoGridPopover: View {
    let files: [CameraFiles.CameraFile]
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var selectedFile: CameraFiles.CameraFile?
    
    @State
    private var showVideoPlayer: Bool = false

    private let adaptiveCols = [GridItem(.adaptive(minimum: 120, maximum: .infinity), spacing: 16)]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Videos").font(.headline)
                Spacer()
            }
            .padding([.top, .horizontal], 16.0)

            ScrollView {
                LazyVGrid(columns: adaptiveCols, spacing: 16.0) {
                    ForEach(Array(files.enumerated()), id: \.offset) { offset, file in
                        Button {
                            selectedFile = file
                            showVideoPlayer = true
                        } label: {
                            VStack(spacing: 6) {
                                ZStack {
                                    VideoThumbView(url: file.fileURL)
                                        .aspectRatio(16.0/9.0, contentMode: .fill)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .shadow(radius: 1, y: 1)
                                    
                                    Image(systemName: "play.circle.fill")
                                        .imageScale(.large)
                                        .font(.title)
                                        .foregroundStyle(.white)
                                        .shadow(color: .black.opacity(0.5), radius: 2, y: 1)
                                }
                                
                                Text(file.name)
                                    .font(.caption)
                                    .lineLimit(2)
                                    .truncationMode(.middle)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(6.0)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(VideoPlayButtonStyle())
                    }
                }
                .padding(16.0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Fixes a huge animation delay issue when tapping the buttons
            UIScrollView.appearance().delaysContentTouches = false
        }
        .sheet(isPresented: $showVideoPlayer) {
            if let file = selectedFile?.fileURL {
                let player = AVPlayer(url: file)
                VideoPlayer(player: player)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(false)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                    }
            }
        }
    }
    
    struct VideoPlayButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        }
    }
}

private actor VideoThumbCache {
    static let shared = VideoThumbCache()
    private let memCache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        memCache.object(forKey: url as NSURL)
    }

    func set(_ img: UIImage, for url: URL) {
        memCache.setObject(img, forKey: url as NSURL)
    }
}

private struct VideoThumbView: View {
    let url: URL?
    
    @State
    private var image: UIImage?
    
    @State
    private var isLoading = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary.opacity(0.15))
            
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "video")
                    .imageScale(.large)
                    .foregroundStyle(.secondary)
            }
        }
        .task(id: url) {
            guard let url, image == nil else { return }
            isLoading = true
            defer { isLoading = false }
            if let cached = await VideoThumbCache.shared.image(for: url) {
                image = cached
                return
            }
            do {
                let img = try await Self.firstFrame(url: url)
                await VideoThumbCache.shared.set(img, for: url)
                image = img
            } catch {
                // leave placeholder
            }
        }
    }
    
    private static func firstFrame(url: URL, maxDimension: CGFloat = 240) async throws -> UIImage {
        let asset = AVURLAsset(url: url, options: [
            AVURLAssetPreferPreciseDurationAndTimingKey: true
        ])
        
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter  = .zero
        generator.maximumSize = CGSize(width: maxDimension, height: maxDimension)

        let time = CMTime(seconds: 0, preferredTimescale: 600)
        let (cg, _) = try await generator.image(at: time)
        return UIImage(cgImage: cg)
    }
}
