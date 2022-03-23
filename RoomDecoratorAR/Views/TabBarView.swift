//
//  TabBarView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ShopView()
                .tabItem {
                    Image("house")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Shop")
                }
            FavouritesView()
                .tabItem {
                    Image("heart")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Favourites")
                }
            RoomItemsView()
                .tabItem {
                    Image("layers")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Room Items")
                }
        }
    }
}



//struct TabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarView()
//    }
//}
