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
    @Published var selectedModel: String? = nil
    @Published var transitionY: CGFloat = 0
    
    
    private var isModelSelected: AnyPublisher<CGFloat, Never> {
        $selectedModel
            .map { input in
                if input != nil {
                    return UIScreen.screenHeight
                } else {
                    return 0
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isModelSelected2: AnyPublisher<Bool, Never> {
        $selectedModel
            .map { input in
                return input != nil
            }
            .eraseToAnyPublisher()
    }
    
    
    init() {
        isModelSelected
            .receive(on: RunLoop.main)
            .assign(to: &$transitionY)
        isModelSelected2
            .receive(on: RunLoop.main)
            .assign(to: &$isPlacementEnabled)
    }
}
