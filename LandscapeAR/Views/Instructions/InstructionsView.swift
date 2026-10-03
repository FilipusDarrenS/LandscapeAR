//
//  InstructionsView.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 26/03/26.
//

import SwiftUI

struct InstructionsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var navigateToAR = false
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 20

    var body: some View {
        ZStack {
            SunsetBackground()

            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                startPoint: UnitPoint(x: 0.5, y: 0.75),
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 6) {
                    Text("BEFORE YOU BEGIN")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .tracking(5)
                        .foregroundColor(Color(.warmGold).opacity(0.8))

                    Text("How it works")
                        .font(.custom("BoogielandPERSONALUSEONLY!", size: 45))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)

                VStack(spacing: 12) {
                    InstructionStepRow(
                        number: 1,
                        icon: "arrow.up.and.down.and.arrow.left.and.right",
                        title: "Find a flat surface",
                        subtitle: "Point your camera at a floor or table"
                    )

                    InstructionStepRow(
                        number: 2,
                        icon: "hand.tap",
                        title: "Tap to place",
                        subtitle: "Press the yellow circle to place the winter world"
                    )

                    InstructionStepRow(
                        number: 3,
                        icon: "speaker.wave.2",
                        title: "Listen and Discover",
                        subtitle: "Put on headphones for the full experience and enjoy the scenery by walking around"
                    )

                    InstructionStepRow(
                        number: 4,
                        icon: "move.3d",
                        title: "Scale and Explore",
                        subtitle: "Scale with two fingers, and drag with one to look around"
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 16) {
                    GlassButton(title: "BEGIN") {
                        navigateToAR = true
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 48)
                .padding(.horizontal, 24)
            }
            .opacity(contentOpacity)
            .offset(y: contentOffset)

            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(16)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 50)
            .padding(.leading, 10)
        }
        .ignoresSafeArea()
        .navigationDestination(isPresented: $navigateToAR) {
            ARPageView()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                contentOpacity = 1.0
                contentOffset = 0
            }
        }
    }
}
