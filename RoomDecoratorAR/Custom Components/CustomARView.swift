//
//  CustomARView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import Foundation
import ARKit
import RealityKit
import FocusEntity
import RealmSwift

class CustomARView: ARView {

    var focusEntity: FocusEntity?
    var modelForDeletionManager: ModelDeletionManager
    
    required init(frame frameRect: CGRect, modelDeletionManager: ModelDeletionManager) {
        self.modelForDeletionManager = modelDeletionManager
        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        self.setupConfig()
        
        self.enableObjectDeletion()
    }
    
    func setupConfig() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        session.run(config)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
}

extension CustomARView {
    func enableObjectDeletion() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressGesture.name = "longPress"
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        print("long press on locaion: \(location)")

        if let entity = self.entity(at: location) as? ModelEntity {
            print("entity captured")
            let index = self.gestureRecognizers?.firstIndex(where: { gesture in
                gesture.name == "longPress"
            })
            self.gestureRecognizers![index!].isEnabled = false
            modelForDeletionManager.entitySelectedForDeletion = entity
            modelForDeletionManager.entitySelectedForDeletion!.anchor?.position.y += 0.025
            self.installGestures([.translation, .rotation], for: modelForDeletionManager.entitySelectedForDeletion!)
        }
    }
}
