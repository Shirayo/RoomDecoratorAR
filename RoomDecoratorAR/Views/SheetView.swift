//
//  BottomSheetVIew.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit

struct SheetView: View {
    
    @ObservedObject var contentViewModel: ContentViewModel
    @ObservedObject var roomItemsViewModel: RoomItemsViewModel
    @StateObject var favouritesViewModel = FavouritesViewModel()
    @StateObject var recentModelsViewModel = RecentModelsViewModel()

    var body: some View {
        GeometryReader {proxy in
            VStack{
                TabView {
                    ShopView(contentViewModel: contentViewModel)
                        .environmentObject(favouritesViewModel)
                        .environmentObject(recentModelsViewModel)
                        .tabItem {
                            Image("house")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Shop")
                        }
                    FavouritesView(contentViewModel: contentViewModel)
                        .environmentObject(favouritesViewModel)
                        .tabItem {
                            Image("heart")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Favourites")
                        }
                    RoomItemsView(contentViewModel: contentViewModel, roomItemsViewModel: roomItemsViewModel)
                        .environmentObject(favouritesViewModel)
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

//struct BottomSheetVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetView(vm: .init())
//            .environmentObject(RecentModelsViewModel())
//            .background(.blue)
//    }
//}
