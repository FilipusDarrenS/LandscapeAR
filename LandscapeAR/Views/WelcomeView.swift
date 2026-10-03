//
//  WelcomeView.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 25/03/26.
//

import SwiftUI

struct WelcomeView: View {
    @State private var navigateToInstructions = false
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 30

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
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
                        VStack(spacing: 8) {
                            Text("AN AR EXPERIENCE")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .tracking(5)
                                .foregroundColor(Color(.warmGold).opacity(0.8))

                            Text("Arcadia")
                                .font(.custom("BoogielandPERSONALUSEONLY!", size: 82))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .lineSpacing(2)
                                .opacity(titleOpacity)
                                .offset(y: titleOffset)

                            Text("FIND YOUR MOMENT OF PEACE")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .tracking(3)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                        FloatingAnimalView()
                        Spacer()
                        VStack(spacing: 15) {
                            GlassButton(title: "ENTER THE WORLD") {
                                navigateToInstructions = true
                            }
                            .padding(.horizontal, 32)
                        }
                        .padding(.bottom, 48)
                    }
                    .padding(.horizontal, 24)
                }
                .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $navigateToInstructions) {
                InstructionsView()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2).delay(0.3)) {
                titleOpacity = 1.0
                titleOffset = 0
            }
        }
    }
}

#Preview {
    WelcomeView()
}
