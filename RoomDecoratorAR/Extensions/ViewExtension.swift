//
//  ViewExtension.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
            overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
        }
}

