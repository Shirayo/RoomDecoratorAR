//
//  ShopView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct ShopView: View {
    
    @ObservedObject var contentViewModel: ContentViewModel

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
                    ShopByCategoryView(vm: contentViewModel)

                    //brands
                    ShopByBrandView(vm: contentViewModel)

                    //recentry viewed
                    RecentModelsView(vm: contentViewModel)
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
