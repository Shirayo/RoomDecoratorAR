//
//  DeleteView.swift
//  RoomDecoratorAR
//
//  Created by Vasili on 21.04.22.
//

import SwiftUI

struct DeleteView: View {
    
    @EnvironmentObject var modelForDeletionManager: ModelDeletionManager
    @EnvironmentObject var roomItemsViewModel: RoomItemsViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button {
                ARVariables.arView.gestureRecognizers?.removeAll()
                ARVariables.arView.enableObjectDeletion()
                modelForDeletionManager.entitySelectedForDeletion!.anchor?.position.y -= 0.05
                modelForDeletionManager.entitySelectedForDeletion = nil
            } label: {
                Image("close")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            
            Spacer()

            Button {
                guard let anchor = modelForDeletionManager.entitySelectedForDeletion?.anchor else { return }
                if let index = roomItemsViewModel.models.firstIndex(where: { model in
                    model.entity?.name == modelForDeletionManager.entitySelectedForDeletion?.name
                }) {
                    roomItemsViewModel.models.remove(at: index)
                }
                ARVariables.arView.gestureRecognizers?.removeAll()
                ARVariables.arView.enableObjectDeletion()
                anchor.removeFromParent()
                
                modelForDeletionManager.entitySelectedForDeletion = nil
            } label: {
                Image("trash")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }

            Spacer()
        }.padding(.bottom, 20)
    }
}

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView()
    }
}
