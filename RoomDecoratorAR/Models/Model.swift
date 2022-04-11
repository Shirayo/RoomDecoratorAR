//
//  Model.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import Foundation
import Combine
import SwiftUI
import RealityKit
import RealmSwift

class Model: ObservableObject, Identifiable {
//    var entity: ModelEntity?
    var id: String = UUID().uuidString
    var name: String
    var brand: String
    var category: String
    @Published var thumbnail: Data//UIImage?
    var scaleCompensation: Float
    
    private var cancellable = Set<AnyCancellable>()
    
    init(name: String, category: String, brand: String, scaleCompensation: Float = 1.0 ) {
        self.name = name
        self.brand = brand
        self.category = category
        self .thumbnail = Data()
        self.scaleCompensation = scaleCompensation
        
        let modelName = self.name.replacingOccurrences(of: " ", with: "_")
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "thumbnails/\(modelName).png") { fileUrl in
            do {
                let imageData = try Data(contentsOf: fileUrl)
                self.thumbnail = imageData
            } catch {
                print("Error while loading thumbnails")
            }
        } loadProgress: { progress in }
    }
}

class RealmModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var brand: String
    @Persisted var category: String
    @Persisted var thumbnail: Data
    @Persisted var scaleCompensation: Float
    @Persisted(originProperty: "items") var group: LinkingObjects<Group>
    
}

final class Group: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Group. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The collection of Items in this group.
    @Persisted var items = RealmSwift.List<RealmModel>()
}
