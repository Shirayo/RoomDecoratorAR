//
//  CustomProgressView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import Foundation
import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.white.opacity(0.7)
    var strokeWidth = 6.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(fractionCompleted))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

// A view letting you adjust the progress with tap gestures
struct testProgressBar: View {
    @State private var progress = 0.2

    var body: some View {
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(GaugeProgressStyle())
            .frame(width: 50, height: 50)
            .contentShape(Rectangle())
            .onTapGesture {
                if progress < 1.0 {
                    withAnimation {
                        progress += 0.2
                    }
                }
            }
    }
}

struct testProgressBar_Previews : PreviewProvider {
    static var previews: some View {
        testProgressBar().previewDevice("iPhone 13 Pro").background(.gray)
    }
}
