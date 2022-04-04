//
//  Categories.swift
//  RoomDecoratorAR
//
//  Created by Shirayo on 01.04.2022.
//

import Foundation

enum Categories: String, CaseIterable {
    case tables
    case chairs
    case sofas
    case lights
    case coffetables

    var label: String {
        get {
            switch self {
            case .tables:
                return "Tables"
            case .chairs:
                return "Chairs"
            case .sofas:
                return "Sofas"
            case .lights:
                return "Lights"
            case .coffetables:
                return "Coffee Tables"
            }
        }
    }
}
