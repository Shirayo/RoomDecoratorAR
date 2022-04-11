//
//  FavouritesViewModel.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 7.04.22.
//

import Foundation
import RealmSwift


class FavouritesViewModel: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var models = Group()
    
    init() {
        openRealm()
        getTasks()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addModel(_ model: Model) {
        if let localRealm = localRealm {
            do {
                try localRealm.write({
                    let recentModel = RealmModel(value: ["name": model.name,
                                                         "brand": model.brand,
                                                         "category": model.category,
                                                         "thumbnail": model.thumbnail,
                                                         "scaleCompensation": model.scaleCompensation
                                                        ])
                    if !models.items.contains(where: { $0.name == recentModel.name }) {
                        models.items.insert(recentModel, at: 0)
                        localRealm.add(models)
                        getTasks()
                    }
                    
                })
            } catch {
                print("Error adding model to Realm: \(error)")
            }
        }
    }
    
    func deleteModel(_ model: Model) {
        if let localRealm = localRealm {
            do {
                try localRealm.write({
                    let recentModel = RealmModel(value: ["name": model.name,
                                                         "brand": model.brand,
                                                         "category": model.category,
                                                         "thumbnail": model.thumbnail,
                                                         "scaleCompensation": model.scaleCompensation
                                                        ])
                    if let index = models.items.firstIndex(where: {$0.name == recentModel.name}) {
                        models.items.remove(at: index)
                        localRealm.add(models)
                        getTasks()
                    }
                })
            } catch {
                print("Error adding model to Realm: \(error)")
            }
        }
    }
    
    func getTasks() {
        if let localRealm = localRealm {
            if let favouritesModels = localRealm.objects(Group.self).last {
                models = favouritesModels
            }
        }
    }
}
