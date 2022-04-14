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
    @StateObject var modelForDeletionManager = ModelDeletionManager()
    @StateObject var contentViewModel = ContentViewModel()
    @StateObject var roomItemsViewModel = RoomItemsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer().environmentObject(contentViewModel).environmentObject(modelForDeletionManager).edgesIgnoringSafeArea(.all)
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
                ZStack(){
                    LinearGradient(colors: [.black.opacity(0.5), .clear, .clear, .clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(contentViewModel.selectedModel?.name ?? "").foregroundColor(.white)
                                Text("by \(contentViewModel.selectedModel?.brand ?? "")").font(.system(size: 12, weight: .light)).foregroundColor(.white)
                            }
                           
                            Spacer()
                            
                            Button {
                                contentViewModel.selectedModel = nil
                            } label: {
                                Image("close")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            }
                        }.padding(.horizontal, 16)
                        
                        Spacer()

                        Button {
                            contentViewModel.isPlacementEnabled = false
                            let modelName = contentViewModel.selectedModel!.name.replacingOccurrences(of: " ", with: "_")
                            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName).usdz") { fileUrl in
                                DispatchQueue.main.async {
                                    var cancellable: AnyCancellable? = nil
                                    cancellable = ModelEntity.loadModelAsync(contentsOf: fileUrl).sink { completion in
                                        cancellable?.cancel()
                                    } receiveValue: { entity in
                                        contentViewModel.selectedModel?.entity = entity
                                        contentViewModel.selectedModel?.entity?.scale *= contentViewModel.selectedModel!.scaleCompensation
                                        contentViewModel.confirmedModel = contentViewModel.selectedModel
                                        if let selectedModel = contentViewModel.selectedModel {
                                            roomItemsViewModel.models.append(selectedModel)
                                        }
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
                                    .cornerRadius(12)
                                Text("Tap to place item")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }.padding(.vertical)
                }
            }  else if modelForDeletionManager.entitySelectedForDeletion != nil {
                HStack(alignment: .center) {
                    Spacer()
                    
                    Button {
                        print("cancel")
                        modelForDeletionManager.entitySelectedForDeletion = nil
                    } label: {
                        Image("close")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()

                    Button {
                        guard let anchor = modelForDeletionManager.entitySelectedForDeletion?.anchor else { return }
                        if let index = roomItemsViewModel.models.firstIndex(where: { model in
                            model.entity == modelForDeletionManager.entitySelectedForDeletion
                        }) {
                            print("FOUND")
                            roomItemsViewModel.models.remove(at: index)
                        }
                        anchor.removeFromParent()
                        
                        modelForDeletionManager.entitySelectedForDeletion = nil
                    } label: {
                        Image("trash")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }.padding(.bottom, 20)
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
