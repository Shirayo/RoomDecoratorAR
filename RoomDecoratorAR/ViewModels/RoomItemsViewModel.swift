//
//  RoomItemsViewModel.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 12.04.22.
//

import Foundation

class RoomItemsViewModel: ObservableObject {
    
    @Published var models = [Model]()
    
    func addModelToRoomItems(_ model: Model) {
        models.append(model)
    }
    
    func eraseAllRoomItems() {
        models.removeAll()
    }
}
