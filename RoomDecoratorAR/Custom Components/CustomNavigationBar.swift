//
//  CustomNavigationBar.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 12.04.22.
//

import SwiftUI

struct CustomNavigationBar: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let title: String
    let isBackButtonVisible: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            if isBackButtonVisible {
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
                Text(title).font(.system(size: 24, weight: .bold))
                Spacer()
                Spacer().frame(width: 30, height: 30).padding()
            } else {
                Spacer()
                Text(title).font(.system(size: 24, weight: .bold))
                Spacer()
            }
        }.frame(height: 60).border(width: 1, edges: [.bottom], color: .gray.opacity(0.5))
    }
}

//struct CustomNavigationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavigationBar()
//    }
//}
