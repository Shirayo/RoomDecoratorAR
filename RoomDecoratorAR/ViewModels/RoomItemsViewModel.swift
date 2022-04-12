//
//  RoomItemsViewModel.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 12.04.22.
//

import Foundation

class RoomItemsViewModel: ObservableObject {
    
    @Published var models = [RealmModel]()
    
    func addModelToRoomItems(_ model: RealmModel) {
        models.append(model)
    }
    
    func eraseAllRoomItems() {
        models.removeAll()
    }
}
