//
//  CategotyView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 24.03.22.
//

import SwiftUI

struct CategotyView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sofas")
                .font(.system(size: 24))
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1..<8) { _ in
                        Button {
                            
                        } label: {
                            VStack {
                                Image("apartments")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(20)
                                Text("Sample")
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

struct CategotyView_Previews: PreviewProvider {
    static var previews: some View {
        CategotyView()
    }
}
