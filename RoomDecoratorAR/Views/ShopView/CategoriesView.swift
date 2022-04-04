//
//  CategotyView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import SwiftUI

struct SofaModel {
    var name: String
    var image: String
    var modelURL: String
}

struct CategoriesView: View {
    
    @ObservedObject var vm: ContentViewModel
    @ObservedObject private var categoriesViewModel = CategoriesViewModel()
    let gridItem: GridItem = .init(.fixed(100), spacing: 4)
    var category: String
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: proxy.size.width / 2 - 20, maximum: 600), spacing: -20),
                ], spacing: 0, content: {
                    ForEach(categoriesViewModel.models, id: \.name) { model in
                        itemButton(model: model, vm: vm, width: proxy.size.width / 2 - 20)
                    }
                })
            }
        }.onAppear() {
            categoriesViewModel.fetchData(category: category)
        }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Categories.init(rawValue: category)!.label)
    }
}

struct itemButton: View {
    @ObservedObject var model: Model
    @ObservedObject var vm: ContentViewModel
    @Environment(\.dismiss) private var dismiss
    var width: CGFloat
    var body: some View {
        Button {
            vm.selectedModel = model
            dismiss()
        } label: {
            VStack(alignment: .leading) {
                ZStack() {
                    Color.gray.opacity(0.5).frame(width: width - 6, height: width - 6, alignment: .center).cornerRadius(12)
                    if let thumbnail = model.thumbnail  {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .frame(width: width - 8, height: width - 8)
                            .cornerRadius(12)
                    } else {
                        Spacer().frame(width: 118, height: 118)
                            .background(.white)
                    }
                   
                }
                Text(model.name)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("by \(model.brand)")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }.frame(width: width, height: width + 60)
        }
    }
}

//struct CategotyView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesView(vm: ContentViewModel(), category: "tables")
//    }
//}
