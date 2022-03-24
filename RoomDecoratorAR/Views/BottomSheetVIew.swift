//
//  BottomSheetVIew.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 23.03.22.
//

import SwiftUI
import RealityKit

struct BottomSheetVIew: View {
    
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
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
            .frame(height: proxy.size.height - 50)
            .background(.white)
            .cornerRadius(30, corners: [.topLeft, .topRight])
            .offset(y: 50 + vm.transitionY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if value.translation.height > 0 {
                            vm.transitionY = value.translation.height
                        }
                    })
                    .onEnded({ value in
                        if value.translation.height > 150 {
                            vm.transitionY = proxy.size.height
                        } else {
                            vm.transitionY = 0
                        }
                    })
            )
            .animation(.easeOut, value: vm.transitionY)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BottomSheetVIew_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetVIew(vm: .init())
            .background(.blue)
    }
}
