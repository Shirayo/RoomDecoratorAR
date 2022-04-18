//
//  ARViewContainer.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 12.04.22.
//

import SwiftUI
import RealityKit
import ARKit

struct ARVariables{
  static var arView: CustomARView!
}

struct ARViewContainer: UIViewRepresentable {
    
//    @Binding var modelToPresent: ModelEntity?
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    func makeUIView(context: Context) -> CustomARView {
        
        ARVariables.arView = CustomARView(frame: .zero, modelDeletionManager: modelDeletionManager)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
                
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        ARVariables.arView.session.run(config)
        self.contentViewModel.sceneObserver = ARVariables.arView.scene.subscribe(to: SceneEvents.Update.self
                                                                                 , { event in
            self.updateScene()
        })

        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = ARVariables.arView.session
        coachingOverlay.goal = .horizontalPlane
        ARVariables.arView.addSubview(coachingOverlay)
//        arView.debugOptions = [.showFeaturePoints]
        return ARVariables.arView
    }
    
    private func updateScene() {
        ARVariables.arView.focusEntity?.isEnabled = self.contentViewModel.selectedModel != nil
        if let confirmedModel = self.contentViewModel.confirmedModel, let entity = confirmedModel.entity {
            place(entity)
            self.contentViewModel.selectedModel = nil
            self.contentViewModel.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity) {
        let clonedEntity =  modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        ARVariables.arView.installGestures([.translation, .rotation], for: clonedEntity)
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        ARVariables.arView.scene.addAnchor(anchorEntity)
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
}

//struct ARViewContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ARViewContainer()
//    }
//}
