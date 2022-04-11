//
//  ShopView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct ShopView: View {
    
    @ObservedObject var vm: ContentViewModel
    @StateObject var recentModels = RecentModelsViewModel()
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .topLeading) {
                    Image("apartments")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                    Color.black.opacity(0.25)
                    Text("Good morning")
                        .foregroundColor(.white)
                        .font(.system(size: 32, weight: .semibold))
                        .padding(.top, 20)
                        .padding(.leading, 20)
                }.frame(height: 250)
                ScrollView(.vertical, showsIndicators: false) {
                    //categories
                    ShopByCategoryView(vm: vm)
                        .environmentObject(recentModels)
                        .environmentObject(favouritesViewModel)

                    //brands
                    ShopByBrandView(vm: vm)
                        .environmentObject(recentModels)
                        .environmentObject(favouritesViewModel)

                    //recentry viewed
                    VStack(alignment: .leading) {
                        Text("Recently viewed")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(recentModels.models!.items, id: \.id) { model in
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
                            }.padding(.horizontal)
                        }
                    }

                }.navigationBarHidden(true)
            }.background(.white)
        }.onAppear {
            print("heh")
        }
    }
}

//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopView(vm: .init()).environmentObject(FavouritesViewModel())
//    }
//}
