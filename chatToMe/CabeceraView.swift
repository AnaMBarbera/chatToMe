//
//  CebeceraView.swift
//  chatToMe
//
//  Created by Jose on 12/5/24.
//

import SwiftUI

struct CabeceraView: View {
    
    @State var mostrarModal : Bool = false
    
    var body: some View {
     
        HStack {
            ZStack {
                    Circle()
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 91, height: 91)
                    Image("chatlogo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle()) // Forma circular
                    .frame(width: 90, height: 90)
            }.padding(.leading)
            //Spacer()
            Button(action: {
                mostrarModal = true
            }){
               Text("SUBIR ARCHIVO")
            }

            ZStack{
                Rectangle()
                    .stroke(Color.gray, lineWidth: 4)
                    .frame(width: 91, height: 91)
                Image("tomachat")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
            }.padding(.trailing)
                .sheet(isPresented: $mostrarModal){
                    SubirArchivoView()
                }
      //  .navigationBarHidden(true)
        }
        //.edgesIgnoringSafeArea(.all)
    }
}

struct CabeceraView_Previews: PreviewProvider {
    static var previews: some View {
        CabeceraView()
    }
}
