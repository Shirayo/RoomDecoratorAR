//
//  RoundedCorner.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
