//
//  ContentView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
        
    @State private var screenHeight: CGFloat = 0 //UIScreen.screenHeight
//    @State var hhh: Bool = false
    @State var modelForPlacement: Model?
    
    private var models: [Model] = {
        let fileManager = FileManager.default
        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        var availableModels: [Model] = []
        for file in files where file.hasSuffix("usdz") {
            let modelName = file.replacingOccurrences(of: ".usdz", with: "")
            availableModels.append(Model(modelName: modelName))
        }
        return availableModels
    }()
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(model: $modelForPlacement).edgesIgnoringSafeArea(.all)
            HStack(alignment: .center) {
                Spacer()
                Button {
                    print("show aletsheet to delee all objects")
                } label: {
                    Image("controls")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)

                }
                Spacer()
                Button {
                    print("show sheet with tab bar")
                    screenHeight = 0
//                    hhh = true
                } label: {
                    Image("plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)

                }
                Spacer()
                Button {
                    print("take a screenshot")
                    modelForPlacement = nil
                    modelForPlacement = models.first
                } label: {
                    Image("photo-camera")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                Spacer()

            }.padding(.bottom, 20)
//                .sheet(isPresented: $hhh) {
//
//                } content: {
//                    TabBarView()
//                }

            BottomSheetVIew(translationY: $screenHeight)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var model: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
                
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        
        
//        arView.debugOptions = [.showFeaturePoints]

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = model {
            if let modelEntity = model.Entity {
                let anchorEntity = AnchorEntity()//(plane: .any)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity.clone(recursive: true))
            } else {
                //error handling...
            }
        }
        
    }
    
}


#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView().previewDevice("iPhone 13 Pro").background(.gray)
//    }
//}
#endif
