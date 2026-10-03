//
//  SunsetBackground.swift
//  LandscapeAR
//
//  Created by Filipus Darren Siswanto on 25/03/26.
//

import SwiftUI

struct SunsetBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.deepPurple),
                Color(.midPurple),
                Color(.burntOrange),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
