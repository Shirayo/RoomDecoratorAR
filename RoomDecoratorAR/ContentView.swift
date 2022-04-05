//
//  ContentView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARVariables{
  static var arView: ARView!
}

struct ContentView : View {
    
    @State var modelToPresent: ModelEntity?
    @State var progress: Double = 0.0
    @State var currentSelectedIndex = 0.0 {
        willSet {
            if progress < self.currentSelectedIndex {
                progress = self.currentSelectedIndex
            }
            if currentSelectedIndex == 1.0 {
                progress = 0.0
            }
        }
    }
    @State var isSheetOpened = true
    @StateObject var contentViewModel = ContentViewModel()
     
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelToPresent: $modelToPresent).edgesIgnoringSafeArea(.all)
            if progress != 1.0 || progress != 0.0 {
                ZStack(alignment: .center) {
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(GaugeProgressStyle())
                        .frame(width: 80, height: 80)
                        .contentShape(Rectangle())
                }
            }
            if contentViewModel.isPlacementEnabled {
                Button {
                    contentViewModel.isPlacementEnabled = false
                    let modelName = contentViewModel.selectedModel!.name.replacingOccurrences(of: " ", with: "_")
                    FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName).usdz") { fileUrl in
                        DispatchQueue.main.async {
                            var cancellable: AnyCancellable? = nil
                            cancellable = ModelEntity.loadModelAsync(contentsOf: fileUrl).sink { completion in
                                cancellable?.cancel()
                            } receiveValue: { entity in
                                modelToPresent = entity
                                modelToPresent?.scale *= contentViewModel.selectedModel!.scaleCompensation
                                cancellable?.cancel()
                            }
                        }
                        print(fileUrl.path)
                    } loadProgress: { progress in
                        self.currentSelectedIndex = progress
                        print("LOADING: \(self.progress)")
                    }
                } label: {
                    ZStack {
                        Color.black.opacity(0.5).frame(width: 150, height: 50, alignment: .center)
                            .cornerRadius(30)
                        Text("Tap to place item")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            } else {
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
                        modelToPresent = nil
                        isSheetOpened = true
                    } label: {
                        Image("plus")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)

                    }
                    Spacer()
                    Button {
                        print("take a screenshot")
                        ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                            // Compress the image
                            let compressedImage = UIImage(data: (image?.pngData())!)
                            // Save in the photo album
                            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                        }
                    } label: {
                        Image("photo-camera")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    Spacer()

                }.padding(.bottom, 20)
                    .sheet(isPresented: $isSheetOpened) {
                        SheetView(vm: contentViewModel)
                    }
            }
        }
    }
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
            let anchorEntity = AnchorEntity()//(plane: .any)
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


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 13 Pro").background(.gray)
            .environmentObject(ContentViewModel())
    }
}
#endif
