//
//  ConversacionView.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct ConversacionView: View {
    
    //@ObservedObject private var authModel = AuthViewModel()
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject var msgViewModel: MensajesViewModel
    @State private var mensaje : String = ""
    
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    ForEach(msgViewModel.mensajesDB){  item in
                        //Imprimo el usuario que ha subido el msg, no el que está loggeado!!
                        HStack{
                            Text("\(item.usuarioE) :")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading,5)
                            Text(item.texto)
                        }
                    }.border(Color.black)
                }.padding(5)
                
                TextField("Mensaje:", text: $mensaje)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color.black)
                    .padding(5)
                Button("Envía Mensaje"){
                    let tiempo = Timestamp(date: Date())
                    let msg = Mensaje(texto: mensaje,usuarioE: authModel.user?.email ?? "Vacío",timestamp: tiempo)
                    //msg.texto = mensaje
                    //msg.usuario = authModel.user
                    //print("EMAIL: \(authModel.user?.email)")
                    msgViewModel.addMensaje(mensaje: msg)
                    msgViewModel.fetchMensajes()
                    mensaje = ""
                }
                .navigationTitle("CONVERSACIONES")
                Spacer()
                }
        }.onAppear {
            msgViewModel.fetchMensajes()
            
        }
    }
}
struct ConversacionView_Previews: PreviewProvider {
    static var previews: some View {
        ConversacionView(msgViewModel: MensajesViewModel())
    }
}
