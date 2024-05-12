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
    @State private var mensajesOrdenados: [Mensaje] = []
    @State private var mostrarImagenInicial = true
    
    
    var body: some View {
        ZStack {//Este ZStack es para mostrar la imagen inicial
            VStack(alignment: .leading){
                CabeceraView()
                //Controlamos los cambios del array que se carga desde la bbdd, para asignarlos al array ordenado y así poder refrescar la vista
                .onChange(of: msgViewModel.mensajesDB) { nuevosMensajes in
                        mensajesOrdenados = nuevosMensajes.sorted(by: { ($0.timestamp?.dateValue() ?? Date()) < ($1.timestamp?.dateValue() ?? Date()) })
                    }
                //Necesitamos mostrar siempre el último elemento del array, por eso usamos crollViewReader dentro del ScrollView
                ScrollViewReader { scrollView in
                    ScrollView {
                            //Muy importante agregar el id: \.self para que identifique los cambios en el array y se refresque el scroll
                                ForEach(mensajesOrdenados, id: \.self){  item in
                                    //Imprimo el usuario que ha subido el msg, no el que está loggeado!!
                                    
                                    VStack(alignment: .leading) {
                                        Text(" > \(item.usuarioE)")
                                            .font(.footnote)
                                        ZStack(alignment: .bottomTrailing) {
                                            // Fondo azul con el texto del timestamp
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                            // Contenido del mensaje
                                            VStack(alignment: .trailing) {
                                                Text(item.texto)
                                                    .padding(.trailing,5)
                                                    .foregroundColor(.white)
                                                Text(item.timestamp?.dateValue().formatted() ?? Date().formatted())
                                                    //.font(.footnote)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom,5)
                                            }
                                        }
                                        .padding(.horizontal, 5)
                                        
                                    }
                                }
                                .onChange(of: mensajesOrdenados) { _ in
                                    scrollToBottom(scrollView: scrollView)
                                    }
                                
                            }.padding(5)
                            
                }
                    
                TextField("Escribe tu mensaje:", text: $mensaje, onCommit: {
                    let tiempo = Timestamp(date: Date())
                    let msg = Mensaje(texto: mensaje,usuarioE: authModel.user?.email ?? "Vacío",timestamp: tiempo)
                    msgViewModel.addMensaje(mensaje: msg)
                    msgViewModel.fetchMensajes()
                    //Actualizamos mensajesOrdenados para que el Scroll baje
                    //mensajesOrdenados.append(msg)
                    //No hace falta, porque he agregado un onChange al ppio de la vista

                    mensaje = ""
                })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color.black)
                    .padding(5)
                Spacer()
                
               /* if mostrarImagenInicial {
                    Color.black.edgesIgnoringSafeArea(.all)
                            Image("chatlogo1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                    }*/
            }
            
        .onAppear {
            msgViewModel.fetchMensajes()
            // Utilizamos el método map para obtener un array de String con el campo texto de cada mensaje y ordenados por la marca de tiempo
            //Cargamos en la variable, los mensajes ordenados
            //mensajesOrdenados = msgViewModel.mensajesDB.sorted(by: { ($0.timestamp?.dateValue() ?? Date()) < ($1.timestamp?.dateValue() ?? Date()) }).map { $0 }
            //Tampoco hace falta, al agregar el onChange al ppio de la vista
            
            // Iniciar temporizador para ocultar la imagen después de 3 segundos
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                            withAnimation {
                                mostrarImagenInicial = false
                            }
                        }
        }
      /*  Color.black.edgesIgnoringSafeArea(.all) // Fondo negro
            if mostrarImagenInicial {
                Image("chatlogo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }*/
        }
}

func scrollToBottom(scrollView: ScrollViewProxy) {
        guard let lastMessage = mensajesOrdenados.last else { return }
    print("ULTIMO MENSAJE: \(lastMessage)")
        
    
    withAnimation {
            DispatchQueue.main.async {
                // Utilizamos ScrollViewReader para hacer scroll al último elemento
                scrollView.scrollTo(lastMessage, anchor: .bottom)
            }
        }
    }
}

struct ConversacionView_Previews: PreviewProvider {
    static var previews: some View {
        ConversacionView(msgViewModel: MensajesViewModel())
    }
}
