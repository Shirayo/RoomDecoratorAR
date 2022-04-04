//
//  CategoriesViewModel.swift
//  RoomDecoratorAR
//
//  Created by Shirayo on 29.03.2022.
//

import Foundation
import FirebaseFirestore

class CategoriesViewModel: ObservableObject {
    @Published var models = [Model]()
    
    private let db = Firestore.firestore()
    
    func fetchData(category: String) {
        db.collection("models").whereField("category", isEqualTo: category).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Firestore: no documents")
                return
            }
            self.models = documents.map { (queryDocumentSnapshot) -> Model in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let brand = data["brand"] as? String ?? ""
                let categoryText = data["category"] as? String ?? ""
                let category = Categories(rawValue: categoryText) ?? .sofas
                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0

                return Model(name: name, category: category, brand: brand, scaleCompensation: Float(scaleCompensation))
            }
        }
        
//        db.collection("models").addSnapshotListener{ (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("Firestore: no documents")
//                return
//            }
//
//            self.models = documents.map { (queryDocumentSnapshot) -> Model in
//                let data = queryDocumentSnapshot.data()
//                let name = data["name"] as? String ?? ""
//                let categoryText = data["category"] as? String ?? ""
//                let category = Categories(rawValue: categoryText) ?? .sofas
//                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0
//
//                return Model(name: name, category: category, scaleCompensation: Float(scaleCompensation))
//
//            }
//        }
    }
}
