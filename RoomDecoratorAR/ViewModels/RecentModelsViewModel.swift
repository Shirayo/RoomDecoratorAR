//
//  RecentModelsViewModel.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 6.04.22.
//

import Foundation
import RealmSwift

class RecentModelsViewModel: ObservableObject {
    private(set) var localRealm: Realm?
    @Published var models: Group?
    
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
                    if !models!.items.contains(where: { $0.name == recentModel.name }) {
                        models!.items.insert(recentModel, at: 0)
//                        let newItems = models!.items
//                        newItems.insert(recentModel, at: 0)
//                        localRealm.add(models!)
//                        models?.items.removeAll()
                        getTasks()
//                        updateItems()
                    }
                })
            } catch {
                print("Error adding model to Realm: \(error)")
            }
        }
    }
    
    func getTasks() {
        if let localRealm = localRealm {
            if let recentModels = localRealm.objects(Group.self).first {
                models = recentModels
            }
        }
    }
    
    func updateItems() {
        if let localRealm = localRealm {
            if let recentModels = localRealm.objects(Group.self).first {
                print("RECENT MODELS COUNT: \(recentModels.items.count)")
                recentModels.items.forEach { model in
                    models?.items.append(model)
                }
            }
        }
    }
}
