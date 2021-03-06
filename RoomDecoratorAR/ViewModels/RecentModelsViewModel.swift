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
    @Published var models = Group()
    private var key = "6257dcc69a3f851287c45393"
    init() {
        openRealm()
        getTasks()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            models._id = try ObjectId(string: key)
            print("________\(Realm.Configuration.defaultConfiguration.fileURL!)")
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
                        if !models.items.contains(where: { $0.name == recentModel.name }) {
                            models.items.insert(recentModel, at: 0)
                        }
                    } else {
                        let index = allModels.firstIndex(where: {$0.name == model.name})
                        let modelToAdd = allModels[index!]
                        if !models.items.contains(where: { $0.name == model.name }) {
                            models.items.insert(modelToAdd, at: 0)
                            localRealm.add(models)
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
            if let recentModels = localRealm.object(ofType: Group.self, forPrimaryKey: try! ObjectId(string: key)) {
                models = recentModels
            } else {
                do {
                    try localRealm.write({
                        localRealm.add(models)
                    })
                } catch {
                    
                }
            }
        }
    }
}
