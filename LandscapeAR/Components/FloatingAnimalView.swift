//
//  FloatingAnimalView.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 25/03/26.
//

import SwiftUI

struct FloatingAnimalView: View {
    @State private var isFloating = false

    var body: some View {
        Text("🗻")
            .font(.system(size: 72))
            .offset(y: isFloating ? -12 : 0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isFloating)
            .onAppear {
                isFloating = true
            }
    }
}
