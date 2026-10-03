//
//  InstructionStepRow.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 26/03/26.
//

import SwiftUI

struct InstructionStepRow: View {
    let number: Int
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 48, height: 48)

                Circle()
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                    .frame(width: 48, height: 48)

                Text("\(number)")
                    .font(.custom("Borel-Regular", size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(x: 0, y: 6)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("BoogielandPERSONALUSEONLY!", size: 19))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: icon)
                .font(.system(size: 22, weight: .thin))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
}
