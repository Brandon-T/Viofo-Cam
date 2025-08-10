//
//  Downloader.swift
//  Viofo
//
//  Created by Brandon on 2025-08-09.
//

import Foundation

enum DownloadState: Equatable, Hashable {
    case pending
    case running
    case succeeded(URL)
    case failed(String)
    case cancelled
}

struct DownloadItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let file: CameraFile
    var state: DownloadState = .pending
    
    var destination: URL? {
        if case let .succeeded(url) = state {
            return url
        }
        return nil
    }
}

actor Downloader {
    private let destinationDirectory: URL

    private var order: [UUID] = []
    private var items: [UUID: DownloadItem] = [:]

    private var workers: [Task<Void, Never>] = []
    private var runningIDs = Set<UUID>()
    private var cancelledIDs = Set<UUID>()
    private var isRunning = false

    init(destinationDirectory: URL) {
        self.destinationDirectory = destinationDirectory
    }

    func enqueue(_ items: [DownloadItem]) {
        for item in items {
            self.items[item.id] = item
            order.append(item.id)
        }
    }

    func currentSnapshot() -> [DownloadItem] {
        order.compactMap { items[$0] }
    }

    func start(concurrency: Int, onUpdate: @MainActor @escaping ([DownloadItem]) -> Void) {
        guard !isRunning else { return }
        isRunning = true
        
        for _ in 0..<max(1, concurrency) {
            workers.append(Task { [weak self] in
                guard let self else { return }
                await self.run(onUpdate: onUpdate)
            })
        }
    }

    func cancel(id: UUID) {
        cancelledIDs.insert(id)
        if var item = items[id], item.state == .pending || item.state == .running {
            item.state = .cancelled
            items[id] = item
        }
    }

    func cancelAll() {
        for id in order {
            cancel(id: id)
        }
    }

    private func nextPendingID() -> UUID? {
        for id in order where !cancelledIDs.contains(id) {
            if let item = items[id], item.state == .pending && !runningIDs.contains(id) {
                return id
            }
        }
        return nil
    }

    private func setState(_ id: UUID, state: DownloadState) {
        guard var item = items[id] else { return }
        item.state = state
        items[id] = item
    }

    private func notify(_ onUpdate: @MainActor @escaping ([DownloadItem]) -> Void) {
        let snapshot = currentSnapshot()
        Task { @MainActor in
            onUpdate(snapshot)
        }
    }

    private func download(id: UUID) async throws -> URL {
        guard let item = items[id] else {
            throw URLError(.unknown)
        }
        
        let fileManager = FileManager.default
        let destination = destinationDirectory.appendingPathComponent(item.file.name)

        // Skip if exists
        if fileManager.fileExists(atPath: destination.path) {
            return destination
        }

        guard let remote = item.file.fileURL else {
            throw URLError(.badURL)
        }

        // If user requested to cancel the download while queued/running, honour it
        if cancelledIDs.contains(id) { throw CancellationError() }

        // Download
        let (url, response) = try await URLSession.shared.download(from: remote)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        // Replace if needed
        try? fileManager.removeItem(at: destination)
        try fileManager.moveItem(at: url, to: destination)
        return destination
    }
    
    private func run(onUpdate: @MainActor @escaping ([DownloadItem]) -> Void) async {
        try? FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)

        while true {
            guard let id = nextPendingID() else {
                break
            }

            runningIDs.insert(id)
            setState(id, state: .running)
            notify(onUpdate)

            // If cancelled before start, skip right away
            if cancelledIDs.contains(id) {
                setState(id, state: .cancelled)
                runningIDs.remove(id)
                notify(onUpdate)
                continue
            }

            // State the download (with per-task cancellation)
            do {
                let saved = try await download(id: id)
                setState(id, state: .succeeded(saved))
            } catch is CancellationError {
                setState(id, state: .cancelled)
            } catch {
                setState(id, state: .failed(error.localizedDescription))
            }

            runningIDs.remove(id)
            notify(onUpdate)
        }
    }
}

@MainActor
final class DownloadQueue: ObservableObject {
    @Published
    private(set) var items: [DownloadItem] = []

    private let downloader: Downloader

    init(destinationDirectory: URL) {
        self.downloader = Downloader(destinationDirectory: destinationDirectory)
    }

    func load(files: [CameraFile]) {
        let jobs = files.map { DownloadItem(file: $0) }
        Task {
            await downloader.enqueue(jobs);
            items = await downloader.currentSnapshot()
        }
    }

    func start(concurrency: Int) {
        Task {
            await downloader.start(concurrency: concurrency) { [weak self] snapshot in
                self?.items = snapshot
            }
        }
    }

    func cancel(id: UUID) {
        Task {
            await downloader.cancel(id: id);
            items = await downloader.currentSnapshot()
        }
    }

    func cancelAll() {
        Task {
            await downloader.cancelAll();
            items = await downloader.currentSnapshot()
        }
    }

    var pending: [DownloadItem] {
        items.filter { $0.state == .pending }
    }
    
    var running: [DownloadItem] {
        items.filter { $0.state == .running }
    }
    
    var succeeded: [DownloadItem] {
        items.filter {
            if case .succeeded = $0.state {
                return true
            }
            return false
        }
    }
    
    var failed: [DownloadItem] {
        items.filter {
            if case .failed = $0.state {
                return true
            }
            return false
        }
    }
    
    var cancelled: [DownloadItem] {
        items.filter {
            $0.state == .cancelled
        }
    }
}
