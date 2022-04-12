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
  static var arView: ARView!
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelToPresent: ModelEntity?
    
    func makeUIView(context: Context) -> ARView {
        
        ARVariables.arView = CustomARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
                
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        ARVariables.arView.session.run(config)
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = ARVariables.arView.session
        coachingOverlay.goal = .horizontalPlane
        ARVariables.arView.addSubview(coachingOverlay)
//        arView.debugOptions = [.showFeaturePoints]
        return ARVariables.arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelEntity = modelToPresent {
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
           
            uiView.scene.addAnchor(anchorEntity.clone(recursive: true))
            
            modelEntity.generateCollisionShapes(recursive: true)
            ARVariables.arView.installGestures([.rotation, .translation], for: modelEntity as Entity & HasCollision)
            //put model to nil maybe
        } else {
            print("ERROR TO LOAD MODEL OR MODEL DID NOT EXIST")
            //error handling...
        }
    }
    
}

//struct ARViewContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ARViewContainer()
//    }
//}
