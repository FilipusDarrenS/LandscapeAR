//
//  GlassButton.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 25/03/26.
//

import SwiftUI

struct GlassButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Borel-Regular", size: 12))
                .tracking(2)
                .foregroundColor(.black)
                .shadow(color: Color(.warmGold).opacity(0.35), radius: 12, x: 0, y: 0)
                .shadow(color: Color(.warmGold).opacity(0.6), radius: 4, x: 0, y: 0)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .offset(y: 4)
                .padding(.vertical, 15)
                .background(
                    Capsule()
                        .fill(Color.white)
                        .opacity(0.8)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                )
                .colorScheme(.dark)
        }
        .buttonStyle(.plain)
    }
}
