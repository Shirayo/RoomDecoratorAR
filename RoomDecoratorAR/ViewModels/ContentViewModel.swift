//
//  ContentViewModel.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import Foundation
import CoreImage
import Combine
import UIKit


class ContentViewModel: ObservableObject {
    
    @Published var isPlacementEnabled: Bool = true
    @Published var selectedModel: Model? = nil
    
    private var isModelSelected: AnyPublisher<Bool, Never> {
        $selectedModel
            .map { input in
                return input != nil
            }
            .eraseToAnyPublisher()
    }
    
    
    init() {
        isModelSelected
            .receive(on: RunLoop.main)
            .assign(to: &$isPlacementEnabled)
    }
}
