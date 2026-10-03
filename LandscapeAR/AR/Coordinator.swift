//
//  Coordinator.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 27/03/26.
//

import SwiftUI
import RealityKit
import ARKit
import AVFoundation
import Combine

class Coordinator: NSObject {
    @Binding var isPlaced: Bool

    weak var arView: ARView?
    var reticleEntity: ModelEntity?
    var placementAnchor: AnchorEntity?
    var audioPlayer: AVAudioPlayer?

    var cancellables = Set<AnyCancellable>()
    var mountainEntity: ModelEntity?
    var snowEmitter: Entity?
    var lastSnowyState: Bool = false

    init(isPlaced: Binding<Bool>) {
        self._isPlaced = isPlaced
    }

    func setup(arView: ARView) {
        self.arView = arView

        let reticleMesh = MeshResource.generateCylinder(height: 0.005, radius: 0.15)

        let reticleMaterial = SimpleMaterial(color: UIColor(resource: .warmGold).withAlphaComponent(0.6), isMetallic: false)
        reticleEntity = ModelEntity(mesh: reticleMesh, materials: [reticleMaterial])

        placementAnchor = AnchorEntity(world: .zero)
        placementAnchor?.addChild(reticleEntity!)
        arView.scene.addAnchor(placementAnchor!)

        arView.scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
            self?.updateReticlePosition()
        }.store(in: &cancellables)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
    }

    func startAmbientAudio() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("❌ ERROR setting up audio session: \(error.localizedDescription)")
        }

        guard let url = Bundle.main.url(forResource: "ambient", withExtension: "mp3") else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌ ERROR loading audio: \(error.localizedDescription)")
        }
    }

    func updateReticlePosition() {
        guard !isPlaced, let arView = arView, let reticle = reticleEntity, let anchor = placementAnchor else { return }

        let screenCenter = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)

        if let hitResult = arView.raycast(from: screenCenter, allowing: .estimatedPlane, alignment: .horizontal).first {
            anchor.transform.matrix = hitResult.worldTransform
            reticle.isEnabled = true
        } else {
            reticle.isEnabled = false
        }
    }

    @objc func handleTap() {
        guard !isPlaced, let arView = arView, let reticle = reticleEntity, let anchor = placementAnchor else { return }

        if reticle.isEnabled {
            isPlaced = true
            startAmbientAudio()
            reticle.removeFromParent()

            guard let mountain = try? ModelEntity.loadModel(named: "Edited") else {
                print("❌ ERROR: Could not load the mountain.")
                return
            }

            anchor.addChild(mountain)
            mountain.generateCollisionShapes(recursive: true)
            self.mountainEntity = mountain

            for _ in 1...20 {
                if let bird = try? ModelEntity.loadModel(named: "birds") {
                    bird.scale = [0.1, 0.1, 0.1]

                    let startX = Float.random(in: -500.0...500.0)
                    let startZ = Float.random(in: -500.0...500.0)
                    let cruisingAltitude = Float.random(in: 150.0...200.0)

                    bird.position = [startX, cruisingAltitude, startZ]

                    if let flapAnimation = bird.availableAnimations.first {
                        bird.playAnimation(flapAnimation.repeat())
                    }

                    mountain.addChild(bird)
                    flyToRandomSpot(bird: bird, mountain: mountain)
                } else {
                    print("❌ ERROR: Could not load the birds.")
                }
            }

            arView.installGestures([.translation, .rotation, .scale], for: mountain)

            let sunLight = DirectionalLight()
            sunLight.light.color = UIColor(resource: .warmGold)
            sunLight.light.intensity = 5000
            sunLight.light.isRealWorldProxy = false
            sunLight.shadow = DirectionalLightComponent.Shadow(maximumDistance: 5.0, depthBias: 0.1)
            sunLight.position = [2.0, 0.2, 2.0]
            sunLight.look(at: [0, 0, 0], from: sunLight.position, relativeTo: nil)

            let fillLight = DirectionalLight()
            fillLight.light.color = UIColor(resource: .midPurple)
            fillLight.light.intensity = 2000
            fillLight.light.isRealWorldProxy = false
            fillLight.position = [-2.0, 1.0, -2.0]
            fillLight.look(at: [0, 0, 0], from: fillLight.position, relativeTo: nil)

            anchor.addChild(sunLight)
            anchor.addChild(fillLight)
        }
    }

    // MARK: - New Flight Logic

    func flyToRandomSpot(bird: ModelEntity, mountain: ModelEntity) {
        let randomX = Float.random(in: -500.0...500.0)
        let randomZ = Float.random(in: -500.0...500.0)

        let targetPosition: SIMD3<Float> = [randomX, bird.position.y, randomZ]

        bird.look(at: targetPosition, from: bird.position, relativeTo: mountain)

        let flightDuration = Double.random(in: 100.0...150.0)

        var targetTransform = bird.transform
        targetTransform.translation = targetPosition

        bird.move(to: targetTransform, relativeTo: mountain, duration: flightDuration, timingFunction: .easeInOut)

        DispatchQueue.main.asyncAfter(deadline: .now() + flightDuration) { [weak self] in
            self?.flyToRandomSpot(bird: bird, mountain: mountain)
        }
    }

    // MARK: - Weather System

    func updateWeather(isSnowy: Bool) {
        guard let mountain = mountainEntity else { return }

        guard isSnowy != lastSnowyState else { return }
        lastSnowyState = isSnowy

        if isSnowy {
            if snowEmitter == nil {
                addSnow(to: mountain)
            }
        } else {
            snowEmitter?.removeFromParent()
            snowEmitter = nil
        }
    }

    func addSnow(to mountain: ModelEntity) {
        let emitter = Entity()

        var particles = ParticleEmitterComponent.Presets.snow

        particles.emitterShape = .box
        particles.emitterShapeSize = [500.0, 0.1, 500.0]

        particles.mainEmitter.birthRate = 100
        particles.mainEmitter.lifeSpan = 15
        particles.mainEmitter.size = 0.015

        emitter.components.set(particles)

        emitter.position = [0, 270, 0]

        mountain.addChild(emitter)
        self.snowEmitter = emitter
    }
}
