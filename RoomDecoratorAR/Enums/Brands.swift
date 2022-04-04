//
//  Brands.swift
//  RoomDecoratorAR
//
//  Created by Shirayo on 01.04.2022.
//

import Foundation

enum Brands: String, CaseIterable {
    case ikea
    case thuma
    case polyAndbark
    case novogratz
    
    var label: String {
        get {
            switch self {
            case .ikea:
                return "Ikea"
            case .thuma:
                return "Thuma"
            case .polyAndbark:
                return "Poly & Bark"
            case .novogratz:
                return "Novogratz"
            }
        }
    }
}
