//
//  ARViewContainer.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 27/03/26.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var isMuted: Bool
    @Binding var isPlaced: Bool
    @Binding var isSnowy: Bool

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic

        arView.session.run(config)

        context.coordinator.setup(arView: arView)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if isMuted {
            context.coordinator.audioPlayer?.pause()
        } else if isPlaced {
            context.coordinator.audioPlayer?.play()
        }
        if isPlaced {
            context.coordinator.updateWeather(isSnowy: isSnowy)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isPlaced: $isPlaced)
    }
}
