//
//  FavouritesView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    @ObservedObject var contentViewModel: ContentViewModel
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "Favourites", isBackButtonVisible: false)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(favouritesViewModel.models.items, id: \.id) { model in
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
                                        Button {
                                            favouritesViewModel.deleteModel(model)
                                            print("delete from favourites")
                                        } label: {
                                            Image("heart")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.red)
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

//struct FavouritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavouritesView(vm: ContentViewModel()).environmentObject(FavouritesViewModel())
//    }
//}
