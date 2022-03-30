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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                if let modelsByCategory = categoriesViewModel.models.filter({ $0.category == category}) {
                    VStack {
                        Text("category")
                        ScrollView(.horizontal, showsIndicators: false) {
                            ForEach(modelsByCategory, id: \.name) { model in
                                itemButton(model: model, vm: vm)
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            categoriesViewModel.fetchData()
        }
    }
}

struct itemButton: View {
    @ObservedObject var model: Model
    @ObservedObject var vm: ContentViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            vm.selectedModel = model
            dismiss()
        } label: {
            VStack{
                Image(uiImage: model.thumbnail)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .background(.red)
                Text(model.name)
            }
        }
    }
}

//struct CategotyView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategotyView(.init())
//    }
//}
