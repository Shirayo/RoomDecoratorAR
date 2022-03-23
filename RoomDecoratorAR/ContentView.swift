//
//  ContentView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
        
    @State private var screenHeight: CGFloat = 0 //UIScreen.screenHeight
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer().edgesIgnoringSafeArea(.all)
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
                } label: {
                    Image("plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)

                }
                Spacer()
                Button {
                    print("take a screenshot")
                } label: {
                    Image("photo-camera")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                Spacer()

            }.padding(.bottom, 20)
            BottomSheetVIew(translationY: $screenHeight)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView().previewDevice("iPhone 13 Pro").background(.gray)
//    }
//}
#endif
