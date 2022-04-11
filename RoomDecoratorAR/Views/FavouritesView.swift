//
//  FavouritesView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    @ObservedObject var vm: ContentViewModel
    var body: some View {
        VStack {
            CustomNavigationBar(title: "Favourites", isBackButtonVisible: false)
            ScrollView {
                VStack {
                    ForEach(favouritesViewModel.models.items, id: \.id) { model in
                        Button {
                            vm.selectedModel = .init(name: model.name, category: model.category, brand: model.brand, scaleCompensation: model.scaleCompensation)
                        } label: {
                            VStack(alignment: .leading) {
                                ZStack() {
                                    Color.gray.opacity(0.5).frame(width: 100, height: 100, alignment: .center).cornerRadius(12)
                                    Image(uiImage: UIImage(data: model.thumbnail)!)
                                        .resizable()
                                        .frame(width: 98, height: 98)
                                        .cornerRadius(12)
                                }
                                Text(model.name)
                                    .font(.system(size: 10))
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                Text("by \(model.brand)")
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }.frame(width: 100 , height: 160)
                        }
                    }
                }
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(vm: ContentViewModel())
    }
}
