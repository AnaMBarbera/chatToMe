//
//  ConversacionView.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//

import SwiftUI

struct ConversacionView: View {
    
    @ObservedObject private var authModel = AuthViewModel()
    @State private var mensaje : String = ""
    
    var body: some View {
        NavigationView{
        Text("AQUÍ VAN A IR LOS MENSAJES")
            
            TextField("Mensaje:", text: $mensaje)
            
        }.navigationTitle("CONVERSACIONES")
    }
}

struct ConversacionView_Previews: PreviewProvider {
    static var previews: some View {
        ConversacionView()
    }
}
