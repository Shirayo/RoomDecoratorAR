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

struct ContentView : View {
    
    @State var progress: Double = 0.0
//    @State var currentSelectedIndex = 0.0 {
//        willSet {
//            if progress < self.currentSelectedIndex {
//                progress = self.currentSelectedIndex
//            }
//            if currentSelectedIndex == 1.0 {
//                progress = 0.0
//            }
//        }
//    }
    @State var isSheetOpened = true
    @StateObject var modelForDeletionManager = ModelDeletionManager()
    @StateObject var contentViewModel = ContentViewModel()
    @StateObject var roomItemsViewModel = RoomItemsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
                .environmentObject(contentViewModel)
                .environmentObject(modelForDeletionManager)
                .edgesIgnoringSafeArea(.all)
//            Spacer().background(.gray).edgesIgnoringSafeArea(.all)
            if progress != 1.0 || progress != 0.0 {
                ZStack(alignment: .center) {
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(GaugeProgressStyle())
                        .frame(width: 80, height: 80)
                        .contentShape(Rectangle())
                }
            }
            if contentViewModel.isPlacementEnabled {
                PlaceView(currentSelectedIndex: $progress)
                    .environmentObject(contentViewModel)
                    .environmentObject(roomItemsViewModel)
            }  else if modelForDeletionManager.entitySelectedForDeletion != nil {
                DeleteView()
                    .environmentObject(modelForDeletionManager)
                    .environmentObject(roomItemsViewModel)
            }
            else {
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        print("show aletsheet to delete all objects")
                    } label: {
                        Image("controls")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        print("show sheet with tab bar")
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
                        SheetView(contentViewModel: contentViewModel, roomItemsViewModel: roomItemsViewModel)
                    }
            }
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
