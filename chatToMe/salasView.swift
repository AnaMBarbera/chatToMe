//
//  salasView.swift
//  chatToMe
//
//  Created by Jose on 14/5/24.
//

import SwiftUI

struct salasView: View {
    
    
    @State var salaName : String = ""
    
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var salasFB : [Coleccion] = []
    //Inicializamos la colección de salas
    @ObservedObject private var salasVM = ColeccionesViewModel()
    
    var body: some View {
    NavigationView{
    ZStack{
        VStack{
            
            CabeceraView()
            
                .onChange(of: salasVM.coleccionesDB) { nuevasSalas in
                        salasFB = nuevasSalas
                    }
            
            Text("SALAS DISPONIBLES: ")
                .padding()
            
                ScrollView {
                        //Muy importante agregar el id: \.self para que identifique los cambios en el array y se refresque el scroll
                    
                    VStack {
                        ForEach(salasFB, id: \.self){  elemento in
                            NavigationLink(destination: ConversacionView(msgViewModel: MensajesViewModel(nombreColeccion: elemento.nombre)).environmentObject(authModel)){
                                    Text("Sala: \(elemento.nombre)")
                            }
                        }
                    }
                }
            //.padding()
            Button(action:{
                
            }){
                Text("ENTRAR")
            }
            .padding()
            Text("CREA TU PROPIA SALA")
            TextField("Nombre de la sala:",text: $salaName,onCommit: {
                //let tiempo = Timestamp(date: Date())
                
                let salaNueva = Coleccion(nombre: salaName, usuarioE: authModel.user?.email ?? "Vacío")
                salasVM.addSala(sala: salaNueva)
                //msgViewModel.fetchMensajes()
                //Actualizamos mensajesOrdenados para que el Scroll baje
                salasFB.append(salaNueva)
                //No hace falta, porque he agregado un onChange al ppio de la vista

                salaName = ""
                //focusEnMensaje = true
            })
            Spacer()
        }
        
            
        }
    .onAppear {
        //focusEnMensaje = true //Ponemos a true esta variable, para que el user no tenga que pulsar sobre el mensaje para poder escribir
        //msgViewModel.fetchMensajes()
        salasVM.fetchSalas()
        salasVM.startListeningSalas()
        
        // Utilizamos el método map para obtener un array de String con el campo texto de cada mensaje y ordenados por la marca de tiempo
        //Cargamos en la variable, los mensajes ordenados
        salasFB = salasVM.coleccionesDB
        
        DispatchQueue.main.async {
                salasFB = salasVM.coleccionesDB
            }
        
        //Tampoco hace falta, al agregar el onChange al ppio de la vista
        
        // Iniciar temporizador para ocultar la imagen después de 3 segundos
        /*Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){}
                mostrarImagenInicial = false
            }
            
        }*/
    }
    .onDisappear {
               salasVM.stopListeningSalas()
    }
    }
    }
}

struct salasView_Previews: PreviewProvider {
    static var previews: some View {
        salasView()
    }
}
