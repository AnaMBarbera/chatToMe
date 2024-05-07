//
//  AuthViewModel.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

final class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener {
            [weak self] _, user in
                guard let self = self else {
                    return
                }
            self.user = user
    }
  }
   
    
    
// function to sign-in

    func signIn(emailAddress: String, password: String ){
        Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("Ha habido un error en SignIn: \(error.localizedDescription)")
                return
                }
        }
    }
    // function to create an account
    func signUp(emailAddress: String, password: String ){
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("Ha habido un error en SignUp: \(error.localizedDescription)")
                return
            }
        }
    }
    
// function to logout
    func signOut() {
        do {
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
            print("Error en logOut: %@", signOutError)
            
        }
    }
    
// function to reset password
    func resetPassword(emailAddress: String) {
            Auth.auth().sendPasswordReset(withEmail: emailAddress)
        }


//Función para entrar con Google

func signInWithGoogle(){
   
    guard let clientID = FirebaseApp.app()?.options.clientID else {return}
    
    //Capturamos la configuración con unestro IDCliente
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    //Cambiar a región España en el emulador para evitar errores en desfases de tiempo
    //como no estamos en una vista, sino en un ViewModel, hemos creado Application_utility, donde creamos una pantalla o vista del tipo UIViewController, sino pondríamos self en el parámetro withPresenting.
    
    GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) {user,error in
    
        if let error = error {
            print("ESTOY EN SIGNIN 1: \(error.localizedDescription)")
            return
        }
        
        guard let user = user?.user,
              let idToken =  user.idToken else {
                    print("ESTOY EN SIGNIN 2")
                    return
        }
        
        let accesToken = user.accessToken
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accesToken.tokenString)
        
        //Por último, nos autenticamos con las credenciales proporcionadas
        Auth.auth().signIn(with: credential) {res, error in
            if let error = error {
                print("ESTOY EN SIGNIN 3: \(error.localizedDescription)")
                return
            }
            guard let user = res?.user else {return}
            print("USUARIO dentro de SignIn: \(user)")
        }
    }
}
  
}

