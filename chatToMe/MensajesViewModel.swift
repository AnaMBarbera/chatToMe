//
//  MensajesViewModel.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//

import Foundation

import SwiftUI
import Foundation
import Combine
import FirebaseFirestore

class MensajesViewModel: ObservableObject {

    var databaseReference = Firestore.firestore().collection("mensajes")
    @Published var mensajesDB: [Mensaje] = []
    
func fetchMensajes() {
    databaseReference.getDocuments { querySnapshot, error in
        if let error = error {
            /*Contemplo error de conexión*/print(error)
            return
        }
    //Si hay mensajes en Firebase, los guardo en documents, sino print a consola
        guard let documents = querySnapshot?.documents else {
            return
        }
        if documents.isEmpty {
            // La colección está vacía
        } else {
            // La colección no está vacía, asignamos al array mensajesDB
            self.mensajesDB = documents.compactMap { document in
                do {
                    let mensaje = try document.data(as: Mensaje.self)
                    return mensaje
                }catch {
                    return nil
                }
        }
    }
    }
}
    
    func addMensaje(mensaje: Mensaje) {
            do {
                _ = try databaseReference.addDocument(from: mensaje)
            } catch {
                print("Error adding restaurant: \(error)")
            }
        }

}
