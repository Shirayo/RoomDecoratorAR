//
//  ShopByBrandView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 5.04.22.
//

import SwiftUI

struct ShopByBrandView: View {
    
    @ObservedObject var vm: ContentViewModel
    @EnvironmentObject var recentModelsViewModel: RecentModelsViewModel
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Shop by brand")
                .font(.system(size: 20, weight: .medium))
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Brands.allCases, id: \.self) { brand in
                        NavigationLink {
                            CategoriesView(vm: vm,/* recentModelsViewModel: recentModelsViewModel,*/ category: nil, brand: brand.label)
                                .environmentObject(recentModelsViewModel)
                                .environmentObject(favouritesViewModel)
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
        }
    }
}

//struct ShopByBrandView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopByBrandView(vm: ContentViewModel())
//    }
//}
