//
//  ImageViewer.swift
//  Viofo
//
//  Created by Brandon on 2025-08-09.
//

import SwiftUI

struct ImageViewer: View {
    let image: UIImage
    
    private let minZoom: CGFloat = 1.0
    private let maxZoom: CGFloat = 4.0
    
    @Environment(\.dismiss) private var dismiss
    @State private var zoom: CGFloat = 1.0
    @State private var committedZoom: CGFloat = 1.0
    
    @State private var pan: CGSize = .zero
    @State private var committedPan: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(nil, contentMode: .fit)
                    .scaleEffect(zoom, anchor: .center)
                    .offset(pan)
                    .simultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                zoom = committedZoom * value
                            }
                            .onEnded { _ in
                                normalizeZoomAndPan(in: geo)
                            }
                    )
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                pan = CGSize(
                                    width: committedPan.width + value.translation.width,
                                    height: committedPan.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                normalizeZoomAndPan(in: geo)
                            }
                    )
                
                VStack {
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
                        
                        Menu {
                            Button("1×") { setZoom(to: 1.0, in: geo) }
                            Button("2×") { setZoom(to: 2.0, in: geo) }
                            Button("4×") { setZoom(to: 4.0, in: geo) }
                        } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(10.0)
                                .background(.black.opacity(0.35), in: Circle())
                        }
                    }
                    .padding([.top, .trailing], 12.0)
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setZoom(to target: CGFloat, in geo: GeometryProxy) {
        withAnimation(.spring()) {
            let clamped = clamp(target, min: minZoom, max: maxZoom)
            committedZoom = clamped
            zoom = clamped
            committedPan = .zero
            pan = .zero
        }
    }
    
    private func normalizeZoomAndPan(in geo: GeometryProxy) {
        // 1) Clamp zoom
        let newZoom = clamp(zoom, min: minZoom, max: maxZoom)
        
        // 2) Compute the image size *as displayed when fit to container* (zoom = 1)
        let fit = fitScale(imageSize: image.size, in: geo.size)
        let baseWidth  = image.size.width * fit
        let baseHeight = image.size.height * fit
        
        // 3) Apply current zoom to get rendered size
        let renderedWidth  = baseWidth * newZoom
        let renderedHeight = baseHeight * newZoom
        
        // 4) Max pan is half of the overflow along each axis; if no overflow, pan is 0
        let maxX = max(0, (renderedWidth  - geo.size.width)  / 2)
        let maxY = max(0, (renderedHeight - geo.size.height) / 2)
        
        let clampedPan = CGSize(
            width: clamp(pan.width,  min: -maxX, max:  maxX),
            height: clamp(pan.height, min: -maxY, max:  maxY)
        )
        
        // 5) Commit and animate to normalized state
        committedZoom = newZoom
        committedPan = clampedPan
        
        withAnimation(.easeOut(duration: 0.2)) {
            zoom = newZoom
            pan = clampedPan
        }
    }
    
    // MARK: - Helpers
    
    /// Scale that fits the image entirely within the container at zoom = 1.
    private func fitScale(imageSize: CGSize, in container: CGSize) -> CGFloat {
        min(container.width / imageSize.width,
            container.height / imageSize.height)
    }
    
    private func clamp<T: Comparable>(_ x: T, min lo: T, max hi: T) -> T {
        max(lo, min(x, hi))
    }
}


struct RemoteImageViewer: View {
    let url: URL

    @State
    private var uiImage: UIImage?
    
    @State
    private var isLoading = true
    
    @State
    private var error: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let img = uiImage {
                ImageViewer(image: img)
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                    Text(error ?? "Failed to load image")
                        .foregroundStyle(.white)
                        .font(.footnote)
                }
                .padding()
            }
        }
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let img = UIImage(data: data) else {
                error = "Unsupported or corrupt image data."
                return
            }
            uiImage = img
        } catch {
            self.error = error.localizedDescription
        }
    }
}
