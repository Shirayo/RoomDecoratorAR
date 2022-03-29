//
//  BottomSheetVIew.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit

struct SheetView: View {
    
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
        GeometryReader {proxy in
            VStack{
                TabView {
                    ShopView(vm: vm)
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
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BottomSheetVIew_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(vm: .init())
            .background(.blue)
    }
}
