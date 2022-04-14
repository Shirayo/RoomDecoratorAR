//
//  ModelDeletionManager.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 13.04.22.
//

import Foundation
import RealityKit

class ModelDeletionManager: ObservableObject {
    @Published var entitySelectedForDeletion: ModelEntity? = nil {
        willSet(newValue) {
            // Selecting new entitySelectedForDeletion, had a prior selection
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue {
                print("Selecting new entitySelectedForDeletion, no prior selection")
                
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if let previoslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue {
                //Un-highlight previouslySelectedModelEntity
                previoslySelectedModelEntity.modelDebugOptions = nil
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if newValue == nil {
                print("clearing entitySelectedForDeletion")
                self.entitySelectedForDeletion?.modelDebugOptions = nil
            }
        }
    }
}
