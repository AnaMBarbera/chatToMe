//
//  chatToMeApp.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
  }
}

@main
struct chatToMeApp: App {
    
    var dB: Void = FirebaseApp.configure()
    
    // Registramos antes que nada AppDelegate, para que primero se llame a FirebaseApp.configure()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //var almacenInicial = SettingStore()
    
    // Crear una instancia de RestaurantViewModel y pasarle el almacen
    //let viewModel = RestaurantViewModel(almacen: SettingStore())
    
    var body: some Scene {
        WindowGroup {
            HolderView().environmentObject(AuthViewModel())
        }
    }
}
