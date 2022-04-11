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
    @Published var models = Group()
    
    init() {
        openRealm()
        getTasks()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addModel(_ model: Model) {
        if let localRealm = localRealm {
            do {
                try localRealm.write({
                    let allModels = localRealm.objects(RealmModel.self)
                    if !allModels.contains(where: {$0.name == model.name}) {
                        let recentModel = RealmModel(value: ["name": model.name,
                                                             "brand": model.brand,
                                                             "category": model.category,
                                                             "thumbnail": model.thumbnail,
                                                             "scaleCompensation": model.scaleCompensation
                                                            ])
                        models.items.insert(recentModel, at: 0)
                    } else {
                        let index = allModels.firstIndex(where: {$0.name == model.name})
                        let modelToAdd = allModels[index!]
                        if !models.items.contains(where: { $0.name == model.name }) {
                            models.items.insert(modelToAdd, at: 0)
    //                        localRealm.add(models)
                        }
                    }
                    getTasks()
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
                    if let recentModels = localRealm.objects(Group.self).first, recentModels.items.contains(where: {$0.name == model.name}) {
                        if let index = models.items.firstIndex(where: {$0.name == model.name}) {
                            models.items.remove(at: index)
                        }
                    } else {
                        if let index = models.items.firstIndex(where: {$0.name == model.name}) {
                            let modelForDeletion = models.items[index]
                            models.items.remove(at: index)
                            localRealm.delete(modelForDeletion)
                        }
                    }
                    getTasks()
                })
            } catch {
                print("Error adding model to Realm: \(error)")
            }
        }
    }
    
    func deleteModel(_ model: RealmModel) {
        if let localRealm = localRealm {
            do {
                try localRealm.write({
                    if let recentModels = localRealm.objects(Group.self).first, recentModels.items.contains(where: {$0 == model}) {
                        if let index = models.items.firstIndex(where: {$0 == model}) {
                            models.items.remove(at: index)
                        }
                    } else {
                        if let index = models.items.firstIndex(where: {$0 == model}) {
                            let modelForDeletion = models.items[index]
                            models.items.remove(at: index)
                            localRealm.delete(modelForDeletion)
                        }
                    }
                    getTasks()
  
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
