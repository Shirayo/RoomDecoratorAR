//
//  Model.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import Foundation
import Combine
import RealityKit

class Model {
    var name: String
    var Entity: ModelEntity?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(entity: ModelEntity) {
        self.name = "test"
        self.Entity = entity
    }
    
    init(modelName: String) {
        self.name = modelName
        let fileName = modelName + ".usdz"
        ModelEntity.loadModelAsync(named: fileName).sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print("oopsie doopsie: \(error)")
            }
        } receiveValue: { modelEntity in
            self.Entity = modelEntity
            print("DEBUG: successfully loaded modelEntity for modelName")
        }.store(in: &cancellable)

        
    }
    
}
