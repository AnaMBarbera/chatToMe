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
                .padding(.bottom, 10) 
            
                .onChange(of: salasVM.coleccionesDB) { nuevasSalas in
                        salasFB = nuevasSalas
                    }
            //Spacer()
            
            Text("SALAS DISPONIBLES")
                .padding(5)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], alignment: .center, spacing: 10) {
                    ForEach(salasFB, id: \.self) { elemento in
                        NavigationLink(destination: ConversacionView(msgViewModel: MensajesViewModel(nombreColeccion: elemento.nombre)).environmentObject(authModel)) {
                            Text(elemento.nombre)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                    }
                }
                .frame(height: 140)
                .background(Image("fondochats").opacity(0.7))
                //.padding(.vertical, 5)
            }
            .cornerRadius(40)
            .padding(.horizontal)
           
            Text("CREA TU PROPIA SALA")
                .padding(5)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
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
            .padding([.horizontal,.vertical])
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
                    .shadow(radius: 3)
            )
            .padding([.horizontal,.vertical])
            .padding(.bottom,40)
            
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
