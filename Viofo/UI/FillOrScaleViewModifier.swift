//
//  FillOrScaleViewModifier.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

import SwiftUI

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
