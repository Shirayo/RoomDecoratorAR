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

class Model: ObservableObject, Identifiable {
//    var entity: ModelEntity?
    var id: String = UUID().uuidString
    var name: String
    var brand: String
    var category: Categories
    @Published var thumbnail: UIImage?
    var scaleCompensation: Float
    
    private var cancellable = Set<AnyCancellable>()
    
    init(name: String, category: Categories, brand: String, scaleCompensation: Float = 1.0 ) {
        self.name = name
        self.brand = brand
        self.category = category
        self .thumbnail = UIImage(named: name) //?? UIImage(systemName: "bag")!
        self.scaleCompensation = scaleCompensation
        
        let modelName = self.name.replacingOccurrences(of: " ", with: "_")
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "thumbnails/\(modelName).png") { fileUrl in
            do {
                let imageData = try Data(contentsOf: fileUrl)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            } catch {
                
            }
        } loadProgress: { progress in }
    }
    
}
