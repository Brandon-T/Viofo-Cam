//
//  FilesGridView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import AVKit
import UIKit
import SwiftUI

struct FilesGridView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var files = [CameraFile]()
    @State private var selectedFile: CameraFile?
    
    @State private var isScrolling: Bool = false
    @State private var showControls = true
    @State private var lastInteraction = Date()
    @State private var isFill = false
    @State private var containerSize: CGSize = .zero
    @State private var selectedTab: MediaType = .videos
    
    @StateObject var playerModel: VLCPlayerModel
    
    private let autoHideDelay: TimeInterval = 3.0

    private let adaptiveCols = [
        GridItem(
            .adaptive(minimum: 120.0, maximum: .infinity),
            spacing: 16.0
        )
    ]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Media").font(.headline)
                Spacer()
            }
            .padding([.top, .horizontal], 16.0)
            
            Picker("Media Type", selection: $selectedTab) {
                Text("Videos").tag(MediaType.videos)
                Text("Images").tag(MediaType.images)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16.0)
            
            switch selectedTab {
            case .videos:
                gridView(files: files.filter({ $0.isVideo }))
            case .images:
                gridView(files: files.filter({ $0.isImage }))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Fixes a huge animation delay issue when tapping the buttons
            UIScrollView.appearance().delaysContentTouches = false
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 1.0)
            .onChanged { _ in
                isScrolling = true
            }.onEnded { _ in
                isScrolling = false
            }
        )
        .fullScreenCover(isPresented: shouldShowPlayer) {
            if let file = selectedFile, let url = file.fileURL {
                if file.isImage {
                    RemoteImageViewer(url: url)
                } else {
                    PlayerView(playerModel: playerModel, url: url)
                }
            } else {
                Text("ERROR - The requested file could not be found")
            }
        }
        .task {
            let files = (try? await Client.getFileList()) ?? []
            self.files = files.sorted(by: { a, b in
                a.timeCode > b.timeCode
            })
        }
    }
    
    private var shouldShowPlayer: Binding<Bool> {
        .init(get: {
            selectedFile != nil
        }, set: { value in
            if !value {
                selectedFile = nil
            }
        })
    }
    
    @ViewBuilder
    private func gridView(files: [CameraFile]) -> some View {
        let grouped = Dictionary(grouping: files) { file in
            SectionBucket.bucket(for: file.timeCodeDate)
        }

        ScrollView {
            LazyVStack(spacing: 16.0, pinnedViews: .sectionHeaders) {
                ForEach(SectionBucket.allCases, id: \.self) { bucket in
                    if let items = grouped[bucket], !items.isEmpty {
                        Section {
                            LazyVGrid(columns: adaptiveCols, spacing: 16.0) {
                                ForEach(items, id: \.filePath) { file in
                                    buttonView(file: file)
                                }
                            }
                        } header: {
                            HStack {
                                Text(bucket.title)
                                    .font(.headline)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8.0)
                            .padding(.vertical, 4.0)
                            .background(.regularMaterial)
                            .containerShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                        }
                    }
                }
            }
            .padding(16.0)
        }
    }
    
    @ViewBuilder
    private func buttonView(file: CameraFile) -> some View {
        Button {
            selectedFile = file
        } label: {
            VStack(spacing: 6.0) {
                ZStack {
                    ThumbnailView(file: file)
                        .aspectRatio(16.0/9.0, contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
                        .shadow(radius: 1.0, y: 1.0)
                    
                    if !file.isImage {
                        Image(systemName: "play.circle.fill")
                            .imageScale(.large)
                            .font(.title)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2.0, y: 1.0)
                    }
                }
                
                Text(file.name)
                    .font(.caption)
                    .lineLimit(2)
                    .truncationMode(.middle)
                    .foregroundStyle(.secondary)
            }
            .padding(6.0)
            .background(
                RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(PlayButtonStyle())
        .disabled(isScrolling)
    }
    
    struct PlayButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        }
    }
}

// MARK: - Private

private enum MediaType {
    case videos
    case images
}

private enum SectionBucket: CaseIterable {
    case today, yesterday, last7, last14, last30, last365, other

    var title: String {
        switch self {
        case .today:   return "Today"
        case .yesterday: return "Yesterday"
        case .last7:   return "Past 7 days"
        case .last14:  return "Past 14 days"
        case .last30:  return "Past Month"
        case .last365: return "Past Year"
        case .other: return "Very Old"
        }
    }
    
    static func bucket(for date: Date, now: Date = Date()) -> SectionBucket? {
        let cal = Calendar.current
        let startToday = cal.startOfDay(for: now)
        let startYesterday = cal.date(byAdding: .day, value: -1, to: startToday)!
        let start7 = cal.date(byAdding: .day, value: -7, to: startToday)!
        let start14 = cal.date(byAdding: .day, value: -14, to: startToday)!
        let start30 = cal.date(byAdding: .day, value: -30, to: startToday)!
        let start365 = cal.date(byAdding: .day, value: -365, to: startToday)!

        switch date {
        case startToday...:                     return .today
        case startYesterday..<startToday:       return .yesterday
        case start7..<startYesterday:           return .last7
        case start14..<start7:                  return .last14
        case start30..<start14:                 return .last30
        case start365..<start30:                return .last365
        default:                                return .other
        }
    }
}
