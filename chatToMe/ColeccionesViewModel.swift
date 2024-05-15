//
//  ColeccionesViewModel.swift
//  chatToMe
//
//  Created by Jose on 15/5/24.
//

import Foundation

import SwiftUI
import Foundation
import Combine
import FirebaseFirestore

class ColeccionesViewModel: ObservableObject {
    
    
    private var listener: ListenerRegistration?
//Creamos referencia a bbdd de Firebase, pero sin la colección, que pasará como argumento, para crear la sala
    var dbR = Firestore.firestore().collection("salas")
    @Published var coleccionesDB : [Coleccion] = []


    func startListeningSalas() {
            listener = dbR.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.coleccionesDB = documents.compactMap { document in
                    do {
                        let mensaje = try document.data(as: Coleccion.self)
                        return mensaje
                    }catch {
                        return nil
                    }
            }
        }
    }
    
    func stopListeningSalas() {
           listener?.remove()
       }
    
    
    func addSala(sala: Coleccion) {
            do {
                _ = try dbR.addDocument(from: sala)
            } catch {
                print("Error adding restaurant: \(error)")
            }
        }
    
    func fetchSalas() {
        dbR.getDocuments { querySnapshot, error in
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
                self.coleccionesDB = documents.compactMap { document in
                    do {
                        let coleccion = try document.data(as: Coleccion.self)
                        return coleccion
                    }catch {
                        return nil
                    }
            }
        }
        }
    }
        
}
