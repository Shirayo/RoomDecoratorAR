//
//  RecentModelsView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 12.04.22.
//

import SwiftUI
import RealmSwift

struct RecentModelsView: View {
    
    @ObservedObject var vm: ContentViewModel
    @EnvironmentObject var recentModels: RecentModelsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recently viewed")
                .font(.system(size: 20, weight: .medium))
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recentModels.models.items, id: \.id) { model in
                        Button {
                            vm.selectedModel = .init(name: model.name, category: model.category, brand: model.brand, scaleCompensation: model.scaleCompensation)
                        } label: {
                            VStack(alignment: .leading) {
                                ZStack() {
                                    Color.gray.opacity(0.5).frame(width: 100, height: 100, alignment: .center).cornerRadius(12)
                                    if model.thumbnail != Data() {
                                        Image(uiImage: UIImage(data: model.thumbnail)!)
                                            .resizable()
                                            .frame(width: 98, height: 98)
                                            .cornerRadius(12)
                                    } else {
                                        Image("placeholder-image")
                                            .resizable()
                                            .frame(width: 98, height: 98)
                                            .cornerRadius(12)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(model.name)
                                        .font(.system(size: 10))
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    Text("by \(model.brand)")
                                        .font(.system(size: 10, weight: .light))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }.frame(width: 100 , height: 160)
                        }

                    }
                }.padding(.horizontal)
            }
        }    }
}

struct RecentModelsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentModelsView(vm: ContentViewModel()).environmentObject(RecentModelsViewModel())
    }
}
