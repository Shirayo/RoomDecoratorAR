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

enum ModelCategory: String, CaseIterable {
    case tables
    case chairs
    case sofas
    case lights
    
    var label: String {
        get {
            switch self {
            case .tables:
                return "Tables"
            case .chairs:
                return "Chairs"
            case .sofas:
                return "Sofas"
            case .lights:
                return "Lights"
            }
        }
    }
}


class Model: ObservableObject, Identifiable {
//    var entity: ModelEntity?
    var id: String = UUID().uuidString
    var name: String
    var category: ModelCategory
    @Published var thumbnail: UIImage
    var scaleCompensation: Float
    
    private var cancellable = Set<AnyCancellable>()
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0 ) {
        self.name = name
        self.category = category
        self .thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
        
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "thumbnails/\(self.name).jpeg") { fileUrl in
            do {
                let imageData = try Data(contentsOf: fileUrl)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            } catch {
                
            }
        } loadProgress: { progress in
            
        }
    }
    
}
