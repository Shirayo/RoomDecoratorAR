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
    var category: String?
    var brand: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("left-arrow")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                    Spacer()
                    Text(category ?? brand ?? "nihya").font(.system(size: 24, weight: .bold))
                    Spacer()
                    Spacer().frame(width: 30, height: 30).padding()
                }.frame(height: 60).border(width: 1, edges: [.bottom], color: .gray.opacity(0.5))
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: proxy.size.width / 2 - 20, maximum: 600), spacing: -20),
                    ], spacing: 0, content: {
                        ForEach(categoriesViewModel.models, id: \.name) { model in
                            itemButton(model: model, vm: vm, width: proxy.size.width / 2 - 20)
                        }
                    })
                }
            }
        }.onAppear() {
            if let category = category {
                categoriesViewModel.fetchData(category: category, brand: nil)
            }
            if let brand = brand {
                categoriesViewModel.fetchData(category: nil, brand: brand)
            }
        }.navigationBarHidden(true)
            
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
                        Spacer().frame(width: width - 8, height: width - 8)
                            .background(.white)
                            .cornerRadius(12)
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

struct CategotyView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(vm: ContentViewModel(), category: "tables")
            .environmentObject(ContentViewModel())
            .environmentObject(CategoriesViewModel())
    }
}
