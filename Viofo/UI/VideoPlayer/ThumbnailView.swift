//
//  ThumbnailView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-09.
//

import AVKit
import UIKit
import SwiftUI

struct ThumbnailView: View {
    let file: CameraFile
    
    @State private var image: UIImage?
    @State private var isLoading = false

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
            }
        }
        .overlay(alignment: .topLeading) {
            Image(systemName: file.isImage ? "photo" : "video")
                .imageScale(.medium)
                .foregroundStyle(.white)
                .padding(8.0)
        }
        .task(id: file.filePath) {
            guard let url = file.fileURL, image == nil else { return }
            isLoading = true
            defer { isLoading = false }
            
            // first check cache
            if let cached = await VideoThumbCache.shared.image(for: url) {
                image = cached
                return
            }
            
            if let img = await fetchImage(url: url) {
                await VideoThumbCache.shared.set(img, for: url)
                image = img
            } else {
                print("FAILED after retries")
            }
        }
    }
    
    private func fetchImage(url: URL, maxRetries: Int = 3, delaySeconds: Double = 2.0) async -> UIImage? {
        for attempt in 1...maxRetries {
            do {
                if file.isImage == true {
                    var request = URLRequest(url: url)
                    request.timeoutInterval = 30
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let http = response as? HTTPURLResponse,
                          (200..<300).contains(http.statusCode),
                          !data.isEmpty else {
                        throw URLError(.badServerResponse)
                    }
                    
                    if let img = UIImage(data: data) {
                        return img
                    } else {
                        throw URLError(.cannotDecodeContentData)
                    }
                } else {
                    // video thumb
                    let img = try await Self.firstFrame(url: url)
                    return img
                }
            } catch {
                if attempt < maxRetries {
                    try? await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
                }
            }
        }
        return nil
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
