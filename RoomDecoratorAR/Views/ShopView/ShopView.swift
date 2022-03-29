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
        VStack {
            ZStack(alignment: .topLeading) {
                Image("apartments")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                Color.black.opacity(0.25)
                Text("Good morning")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .semibold))
                    .padding(.top, 20)
                    .padding(.leading, 20)
            }.frame(height: 200)
            ScrollView(.vertical) {
                CategoriesView(vm: vm)
            }
        }.background(.white)
    }
}

struct ContentView_Previews2 : PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 13 Pro").background(.gray)
    }
}

//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopView()
//    }
//}
