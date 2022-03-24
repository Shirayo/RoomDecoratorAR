//
//  BottomSheetVIew.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit

struct BottomSheetVIew: View {
    
    @Binding var translationY: CGFloat
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                TabBarView()
            }
            .frame(height: proxy.size.height - 50)
            .background(.white)
            .cornerRadius(30, corners: [.topLeft, .topRight])
            .offset(y: 50 + translationY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if value.translation.height > 0 {
                            translationY = value.translation.height
                        }
                    })
                    .onEnded({ value in
                        if value.translation.height > 150 {
                            translationY = proxy.size.height
                        } else {
                            translationY = 0
                        }
                    })
            )
            .animation(.easeOut, value: translationY)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BottomSheetVIew_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetVIew(translationY: .constant(0))
            .background(.blue)
    }
}
