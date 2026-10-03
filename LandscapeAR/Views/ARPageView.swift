//
//  ARPageView.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 27/03/26.
//

import SwiftUI
import AVFoundation

struct ARPageView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isPlaced = false
    @State private var isMuted = false
    @State private var showARHints = true
    @State private var isSnowy = false

    var body: some View {
        ZStack {
            ARViewContainer(isMuted: $isMuted, isPlaced: $isPlaced, isSnowy: $isSnowy)
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 12) {
                    ZStack(alignment: .center) {
                        if isPlaced {
                            Text(isSnowy ? "Weather: Snowy" : "Weather: Sunny")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .tracking(1)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(.ultraThinMaterial).opacity(0.9))
                                .overlay(Capsule().strokeBorder(Color.white.opacity(0.3), lineWidth: 1))
                                .transition(.opacity)
                        }

                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .overlay(Circle().strokeBorder(Color.white.opacity(0.3), lineWidth: 1))
                            }

                            Spacer()

                            Button(action: {
                                isMuted.toggle()
                            }) {
                                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .overlay(Circle().strokeBorder(Color.white.opacity(0.3), lineWidth: 1))
                            }
                        }
                    }

                    if isPlaced {
                        Button {
                            isSnowy.toggle()
                        } label: {
                            Image(systemName: isSnowy ? "cloud.snow.fill" : "sun.max.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(Circle().fill(.ultraThinMaterial).opacity(0.9))
                                .overlay(Circle().strokeBorder(Color.white.opacity(0.3), lineWidth: 1))
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 0)

                Spacer()

                if !isPlaced {
                    Text("Wait for a yellow circle and tap it to place")
                        .font(.custom("BoogielandPERSONALUSEONLY!", size: 18))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .opacity(0.8)
                        )
                        .overlay(
                            Capsule().strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.bottom, 60)
                        .transition(.opacity)
                } else if showARHints {
                    VStack(spacing: 4) {
                        Text("Scale with two fingers and drag with one")
                            .font(.custom("BoogielandPERSONALUSEONLY!", size: 16))

                        Text("Walk around to enjoy the scene. Hint will dissappear in 10 seconds")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .opacity(0.8)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                    )
                    .overlay(
                        Capsule().strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.bottom, 60)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                            withAnimation(.easeOut(duration: 1.0)) {
                                showARHints = false
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.8), value: isPlaced)
            .navigationBarBackButtonHidden(true)
        }
    }
}
