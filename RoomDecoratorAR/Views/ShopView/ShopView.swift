//
//  ShopView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct ShopView: View {
    
    
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
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Shop by category")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Categories.allCases, id: \.self) { category in
                                    NavigationLink {
                                        CategoriesView(vm: vm, category: category.label)
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
                        }.padding(.top, 0)
                    }
                    VStack(alignment: .leading) {
                        Text("Shop by brand")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Brands.allCases, id: \.self) { brand in
                                    NavigationLink {
                                        CategoriesView(vm: vm, brand: brand.label)
                                    } label: {
                                        VStack {
                                            Image(brand.label)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(15)
                                            Text(brand.label)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
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
