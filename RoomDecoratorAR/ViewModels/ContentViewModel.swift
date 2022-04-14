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
    
    @Published var isPlacementEnabled: Bool = false
    @Published var selectedModel: Model? = nil
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard newValue != nil else {
                print("clearing confirmed model")
                return
            }
        }
    }
    
    private var isModelSelected: AnyPublisher<Bool, Never> {
        $selectedModel
            .map { input in
                return input != nil
            }
            .eraseToAnyPublisher()
    }
    
    var sceneObserver: Cancellable?
    
    
    init() {
        isModelSelected
            .receive(on: RunLoop.main)
            .assign(to: &$isPlacementEnabled)
    }
}
