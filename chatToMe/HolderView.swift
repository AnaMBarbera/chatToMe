//
//  HolderView.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//
import SwiftUI

struct HolderView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    var body: some View {
        Group{
            if authModel.user == nil {
                SignUpView()
            } else {
               // let almacenInicial = SettingStore()
                //let viewModel = MensajesViewModel()
                //ConversacionView(msgViewModel: viewModel).environmentObject(authModel)
                salasView().environmentObject(authModel)
            }
        }
        .onAppear {
            authModel.listenToAuthState()
        }
    }

}

struct HolderView_Previews: PreviewProvider {
    static var previews: some View {
        HolderView()
    }
}
