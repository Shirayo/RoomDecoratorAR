//
//  ShopByCategoryView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 5.04.22.
//

import SwiftUI

struct ShopByCategoryView: View {
    
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
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
    }
}

struct ShopByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ShopByCategoryView(vm: ContentViewModel())
    }
}
