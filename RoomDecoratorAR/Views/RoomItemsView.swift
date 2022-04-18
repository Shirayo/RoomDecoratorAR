//
//  RoomItemsView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct RoomItemsView: View {
    
    @ObservedObject var contentViewModel: ContentViewModel
    @ObservedObject var roomItemsViewModel: RoomItemsViewModel
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "Room Items", isBackButtonVisible: false)
            if roomItemsViewModel.models.count == 0 {
                Spacer()
                Text("There are no room items yet")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(roomItemsViewModel.models, id: \.id) { model in
                            Button {
                                contentViewModel.selectedModel = .init(name: model.name, category: model.category, brand: model.brand, scaleCompensation: model.scaleCompensation)
                            } label: {
                                HStack(spacing: 8) {
                                    ZStack() {
                                        Color.gray.opacity(0.5).frame(width: 100, height: 100, alignment: .center).cornerRadius(12)
                                        Image(uiImage: UIImage(data: model.thumbnail)!)
                                            .resizable()
                                            .frame(width: 98, height: 98)
                                            .cornerRadius(12)
                                    }
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .top) {
                                            Text(model.name)
                                                .font(.system(size: 14))
                                                .foregroundColor(.black)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            if !favouritesViewModel.models.items.contains(where: { $0.name == model.name }) {
                                                Button {
                                                    favouritesViewModel.addModel(model)
                                                } label: {
                                                    Image("heart")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .foregroundColor(.black)
                                                }
                                                .frame(width: 20, height: 20)
                                            } else {
                                                Button {
                                                    favouritesViewModel.deleteModel(model)
                                                } label: {
                                                    Image("heart")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .foregroundColor(.red)
                                                }
                                                .frame(width: 20, height: 20)
                                            }
                                        }
                                       
                                        Text("by \(model.brand)")
                                            .font(.system(size: 12, weight: .light))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }.padding(.vertical, 8)
                                }.frame(height: 116).padding(.horizontal, 8)
                            }
                        }
                    }
                }
            }
        }
    }
}
//
//struct RoomItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomItemsView()
//    }
//}
