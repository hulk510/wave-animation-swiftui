//
//  ContentView.swift
//  Copyright © 2021 hulk510. All rights reserved.
//

import SwiftUI

struct WaveForm: View {
    var color: Color
    var amplify: CGFloat
    var isReversed: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let angle = now.remainder(dividingBy: 2)
                let offset = angle * size.width

                context.translateBy(x: isReversed ? -offset : offset, y: 0)
                context.fill(getPath(size: size), with: .color(color))

                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))

                context.translateBy(x: size.width * 2 , y: 0)
                context.fill(getPath(size: size), with: .color(color))
            }
        }
    }

    func getPath(size: CGSize) -> Path {
        return Path { path in
            let midHeight = size.height / 2
            let width = size.width
            // moving the wave to center leading
            path.move(to: CGPoint(x: 0, y: midHeight))

            // curve
            path.addCurve(to: CGPoint(x: width, y: midHeight), control1:
                            CGPoint(x: width * 0.4, y: midHeight + amplify), control2:
                            CGPoint(x: width * 0.65, y: midHeight - amplify))

            // fill bottom area
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }

}

struct ContentView: View {
    @State private var waveOffset: CGFloat = 0.0

    var body: some View {
        ZStack {
            WaveForm(color: .purple.opacity(0.8), amplify: 30, isReversed: false)
            WaveForm(color: .purple.opacity(0.5), amplify: 10, isReversed: true)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
