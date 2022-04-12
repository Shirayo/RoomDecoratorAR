//
//  CategotyView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import SwiftUI

import Combine

struct CategoriesView: View {
    
    @ObservedObject var vm: ContentViewModel
    @StateObject private var categoriesViewModel = CategoriesViewModel()
    @EnvironmentObject var recentModelsViewModel: RecentModelsViewModel
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    
    var category: String?
    var brand: String?

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                CustomNavigationBar(title: category ?? brand ?? "nihya", isBackButtonVisible: true)
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: proxy.size.width / 2 - 20, maximum: 600), spacing: -20),
                    ], spacing: 0, content: {
                        ForEach(categoriesViewModel.models, id: \.name) { model in
                            itemButton(model: model, vm: vm, width: proxy.size.width / 2 - 20)
                                .environmentObject(recentModelsViewModel)
                                .environmentObject(favouritesViewModel)
                        }
                    })
                }
            }
        }.onAppear() {
            if let category = category {
                categoriesViewModel.fetchData(category: category, brand: nil)
            }
            if let brand = brand {
                categoriesViewModel.fetchData(category: nil, brand: brand)
            }
        }.navigationBarHidden(true)
                
    }
}

struct itemButton: View {
    @ObservedObject var model: Model
    @ObservedObject var vm: ContentViewModel
    @EnvironmentObject var recentModelsViewModel: RecentModelsViewModel
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel

    var width: CGFloat
    var body: some View {
        Button {
            vm.selectedModel = model
            recentModelsViewModel.addModel(model)
        } label: {
            VStack(alignment: .leading) {
                ZStack() {
                    Color.gray.opacity(0.5).frame(width: width - 6, height: width - 6, alignment: .center).cornerRadius(12)
                    if model.thumbnail != Data() {
                        Image(uiImage: UIImage(data: model.thumbnail)!)
                            .resizable()
                            .frame(width: width - 8, height: width - 8)
                            .cornerRadius(12)
                    } else {
                        Spacer().frame(width: width - 8, height: width - 8)
                            .background(.white)
                            .cornerRadius(12)
                    }
                    if !favouritesViewModel.models.items.contains(where: { $0.name == model.name }) {
                        Button {
                            favouritesViewModel.addModel(model)
                        } label: {
                            Image("heart")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.black)
                        }
                        .frame(width: 20, height: 20, alignment: .topLeading)
                        .position(x: 20, y: 20)
                    } else {
                        Button {
                            favouritesViewModel.deleteModel(model)
                        } label: {
                            Image("heart")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.red)
                        }
                        .frame(width: 20, height: 20, alignment: .topLeading)
                        .position(x: 20, y: 20)
                    }

                }
                Text(model.name)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("by \(model.brand)")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }.frame(width: width, height: width + 60)
        }
    }
}

//struct CategotyView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesView(vm: ContentViewModel(), category: "tables")
//            .environmentObject(CategoriesViewModel())
//    }
//}
