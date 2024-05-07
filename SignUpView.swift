//
//  SignUpView.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//
import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var showingSheet: Bool = false
    
    
    var body: some View {
        
        NavigationView {
                    Form {
                        Section {
                            TextField("Email", text: $emailAddress)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                            SecureField("Password", text: $password)
                        }
                        Section {
                            Button(action: {
                                // Sign Up to Firebase
                                authModel.signUp(emailAddress: emailAddress, password: password)
                            }) {
                                Text("Registrate").bold()
                                }
                        }
                        Section(header: Text("Entra si tienes cuenta: ")) {
                            Button(action: {
                                    // Sign In to Firebase
                                authModel.signIn(emailAddress: emailAddress, password: password)
                            }) {
                                Text("Sign In").bold()
                                }
                        }
                        
                        //Login con Google
                        
                            Button(action: {
                                    // Sign In con cuenta de Google
                                //Es necesario cambiar a región España antes de autenticar, para evitar errores en desfases de tiempo
                                authModel.signInWithGoogle()
                            }) {
                                HStack{
                                    Image("logoGoogle")
                                        .scaleEffect(0.5)
                                    Text("Entra con Google").bold()
                                }
                            }
                    }.navigationTitle("Bienvenido!")
                    .toolbar {
                                ToolbarItemGroup(placement: .cancellationAction) {
                                    Button {
                                        showingSheet.toggle()
                                    } label: {
                                                Text("Forgot password?")
                                            }
                    .sheet(isPresented: $showingSheet) {
                            ForgotPasswordView()
                    }
                                }
                    }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
