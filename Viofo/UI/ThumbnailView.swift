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
            
            if let cached = await VideoThumbCache.shared.image(for: url) {
                image = cached
                return
            }
            
            if file.isImage == true {
                var request = URLRequest(url: url)
                request.timeoutInterval = 30

                do {
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let http = response as? HTTPURLResponse,
                          (200..<300).contains(http.statusCode),
                          !data.isEmpty else {
                        return
                    }
                    
                    if let img = UIImage(data: data) {
                        await VideoThumbCache.shared.set(img, for: url)
                        image = img
                    }
                } catch {
                    // leave placeholder
                    print("FAILED TO DOWNLOAD IMAGE")
                }
                
                return
            }
            
            do {
                let img = try await Self.firstFrame(url: url)
                await VideoThumbCache.shared.set(img, for: url)
                image = img
            } catch {
                // leave placeholder
                print("FAILED TO DOWNLOAD IMAGE")
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
