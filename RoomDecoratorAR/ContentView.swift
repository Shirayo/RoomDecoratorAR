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
    
//    @State private var screenHeight: CGFloat = 0 //UIScreen.screenHeight
    @State var modelToPresent: Model?
    @State var isModelLoading: Bool = false
    @State var progress: Double = 1.0
    @State var observation: NSKeyValueObservation?
    @ObservedObject var contentViewModel = ContentViewModel()
     
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelToPresent: $modelToPresent).edgesIgnoringSafeArea(.all)
            if progress != 1.0 {
                ZStack(alignment: .center) {
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(GaugeProgressStyle())
                        .frame(width: 80, height: 80)
                        .contentShape(Rectangle())
                }
            }
            
            if contentViewModel.isPlacementEnabled {
                Button {
                    if let url = URL(string: contentViewModel.selectedModel!) {
                        contentViewModel.isPlacementEnabled = false
                        loadFileAsync(url: url) { localURL, error in
                            guard let url = localURL else {
                                return
                            }
                            DispatchQueue.main.async {
                                var cancellable: AnyCancellable? = nil
                                cancellable = ModelEntity.loadModelAsync(contentsOf: url).sink { completion in
                                    cancellable?.cancel()
                                } receiveValue: { entity in
                                    modelToPresent = .init(entity: entity)
                                    cancellable?.cancel()
                                }
                            }
                            print(url.path)
                        }
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
                        withAnimation {
                            contentViewModel.transitionY = 0
                        }
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
            }
            BottomSheetVIew(vm: contentViewModel)
        }
    }
    
    func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                observation?.invalidate()
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl, error)
                                }
                                else
                                {
                                    completion(destinationUrl, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl, error)
                }
            })
            observation = task.progress.observe(\.fractionCompleted, changeHandler: { progress, _ in
                print(progress.fractionCompleted)
                self.progress = progress.fractionCompleted
            })
            task.resume()
        }
    }

}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelToPresent: Model?
    
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
        if let model = modelToPresent {
            if let modelEntity = model.Entity {
                let anchorEntity = AnchorEntity()//(plane: .any)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity.clone(recursive: true))
            } else {
                print("ERROR TO LOAD MODEL")
                //error handling...
            }
        }
        
    }
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 13 Pro").background(.gray)
    }
}
#endif
