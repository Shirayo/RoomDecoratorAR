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
            ForEach(Categories.allCases, id: \.self) { category in
                if let modelsByCategory = categoriesViewModel.models.filter({ $0.category == category}) {
                    VStack(alignment: .leading) {
                        Text(category.label)
                            .font(.system(size: 18, weight: .bold))
                            .padding(.leading)
                            .padding(.top)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(modelsByCategory, id: \.name) { model in
                                    itemButton(model: model, vm: vm)
                                }
                            }.padding(.horizontal)
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
            VStack(alignment: .leading) {
                ZStack {
                    Color.gray.opacity(0.5).frame(width: 120, height: 120, alignment: .center).cornerRadius(12)
                    if let thumbnail = model.thumbnail  {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .frame(width: 118, height: 118)
                            .cornerRadius(12)
                    } else {
                        Spacer().frame(width: 118, height: 118)
                            .background(.white)
                    }
                   
                }
                Text(model.name)
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    
            }.frame(width: 120, height: 180)
        }
    }
}

//struct CategotyView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesView(vm: ContentViewModel())
//            .environmentObject(ContentViewModel())
//    }
//}
