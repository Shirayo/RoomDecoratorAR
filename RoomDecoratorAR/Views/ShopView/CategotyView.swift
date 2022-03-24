//
//  CategotyView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import SwiftUI
import Kingfisher

struct SofaModel {
    var name: String
    var image: String
    var modelURL: String
}

struct CategotyView: View {
    
    var models: [SofaModel] = [
        .init(name: "Retro TV",
              image: "https://developer.apple.com/augmented-reality/quick-look/models/retrotv/retrotv.jpg",
              modelURL: "https://developer.apple.com/augmented-reality/quick-look/models/retrotv/tv_retro.usdz"),
        .init(name: "guitar",
              image: "https://developer.apple.com/augmented-reality/quick-look/models/stratocaster/stratocaster.jpg",
              modelURL: "https://developer.apple.com/augmented-reality/quick-look/models/stratocaster/fender_stratocaster.usdz"),
        .init(name: "robot",
              image: "https://developer.apple.com/augmented-reality/quick-look/models/vintagerobot2k/vintagerobot2k.jpg",
              modelURL: "https://developer.apple.com/augmented-reality/quick-look/models/vintagerobot2k/toy_robot_vintage.usdz"),
        .init(name: "chair",
              image: "https://developer.apple.com/augmented-reality/quick-look/models/redchair/redchair.jpg",
              modelURL: "https://developer.apple.com/augmented-reality/quick-look/models/redchair/chair_swan.usdz")
    ]
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sofas")
                .font(.system(size: 24))
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(models, id: \.name) { model in
                        Button {
                            vm.selectedModel = nil
                            vm.selectedModel = model.modelURL
                        } label: {
                            VStack {
                                KFImage(URL(string: model.image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(20)
                                Text(model.name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }.padding(.horizontal)
            }
        }.padding(.top)
    }
}

//struct CategotyView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategotyView(.init())
//    }
//}
