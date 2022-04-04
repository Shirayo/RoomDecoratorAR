//
//  ShopView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct ShopView: View {
    
    
//    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ContentViewModel
    
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
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        Text("Shop by category")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.leading)
                            .padding(.top)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Categories.allCases, id: \.self) { category in
                                    NavigationLink {
                                        CategoriesView(vm: vm, category: category.rawValue)
//                                        SelectedCategoryView()
                                    } label: {
                                        VStack {
                                            Image(category.label)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(15)
                                            Text(category.label)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
                                    }
                                    
                                }
                            }.padding(.horizontal)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Shop by brand")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.leading)
                            .padding(.top)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Brands.allCases, id: \.self) { category in
                                    VStack {
                                        Image(category.label)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(15)
                                        Text(category.label)
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                }
                            }.padding(.horizontal)
                        }
                    }.navigationBarHidden(true)
                }
            }.background(.white)
        }
    }
}

//struct ContentView_Previews2 : PreviewProvider {
//    static var previews: some View {
//        ContentView().previewDevice("iPhone 13 Pro").background(.gray)
//    }
//}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(vm: .init())
    }
}
