//
//  PlaceView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 21.04.22.
//

import SwiftUI
import Combine
import RealityKit

struct PlaceView: View {
    
    
    @EnvironmentObject var contentViewModel: ContentViewModel
    @EnvironmentObject var roomItemsViewModel: RoomItemsViewModel
    @Binding var currentSelectedIndex: Double
    var body: some View {
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
                                    selectedModel.entity?.name = selectedModel.name
                                    roomItemsViewModel.models.append(selectedModel)
                                }
                                cancellable?.cancel()
                            }
                        }
                        print(fileUrl.path)
                    } loadProgress: { progress in
                        if self.currentSelectedIndex < progress {
                            self.currentSelectedIndex = progress
                        }
                        if self.currentSelectedIndex == 1.0 {
                            self.currentSelectedIndex = 0.0
                        }
//                        print("LOADING: \(self.progress)")
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

    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(currentSelectedIndex: .constant(0.0))
    }
}
