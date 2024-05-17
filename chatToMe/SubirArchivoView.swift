//
//  SubirArchivoView.swift
//  chatToMe
//
//  Created by Jose on 13/5/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import FirebaseStorage //Import para que funcione Firebase Storage
import UniformTypeIdentifiers //Import para selector de archivos


struct SubirArchivoView: View {
    @State private var fileURL: URL?
    @State private var isShowingDocumentPicker = false
    
    var body: some View {
        VStack {
            Text("Archivo seleccionado: \(fileURL?.lastPathComponent ?? "Ningún archivo seleccionado")")
            
            Button("Seleccionar archivo") {
                isShowingDocumentPicker.toggle()
            }
            
            
            Button("Subir archivo seleccionado") {
                            if let fileURL = fileURL {
                                uploadFile(fileURL: fileURL)
                            } else {
                                print("No se ha seleccionado ningún archivo")
                            }
            }
        
        
         /*   Button("Subir archivo predeterminado") {
                // Llama a la función uploadFile con la URL del archivo predeterminado
                if let defaultFileURL = Bundle.main.url(forResource: "/Users/jose/Desktop/chatToMe/chatToMe/SubirArchivoView", withExtension: "swift") {
                    uploadFile(fileURL: defaultFileURL)
                } else {
                    print("No se encontró el archivo predeterminado")
                }
            } */
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPickerViewController(fileURL: $fileURL)
        }
    }
    
    func uploadFile(fileURL: URL) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("files/\(UUID().uuidString)")
        
        fileRef.putFile(from: fileURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error al subir el archivo: \(error.localizedDescription)")
                return
            }
            
            print("Archivo subido con éxito")
        }
    }
}

struct DocumentPickerViewController: UIViewControllerRepresentable {
    @Binding var fileURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let viewController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerViewController

        init(parent: DocumentPickerViewController) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.fileURL = url
            }
        }
    }
}

/*struct SubirArchivoView: View {
    @State private var fileURL: URL?
    @State private var isShowingDocumentPicker = false
    
    var body: some View {
        VStack {
            Text("Archivo seleccionado: \(fileURL?.lastPathComponent ?? "Ningún archivo seleccionado")")
            
            Button("Seleccionar archivo") {
                // Seleccionar un archivo desde el dispositivo
                // Abrir un selector de archivos
                // y asignar el URL del archivo seleccionado a la variable fileURL
                isShowingDocumentPicker.toggle()
            }
            
            /*if let fileURL = fileURL {
                Button("Subir archivo") {
                    uploadFile(fileURL: fileURL)
                }
            }*/
        }.sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPickerViewController(fileURL: $fileURL)
        }
    }
    
    func uploadFile(fileURL: URL) {
        // Referencia al almacenamiento de Firebase Cloud Storage
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Referencia al archivo que se va a subir
        let fileRef = storageRef.child("files/\(UUID().uuidString)")
        
        // Subir el archivo al almacenamiento en la nube
        fileRef.putFile(from: fileURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error al subir el archivo: \(error.localizedDescription)")
                return
            }
            
            // El archivo se ha subido correctamente
            print("Archivo subido con éxito")
        }
    }
}

struct DocumentPickerViewController: UIViewControllerRepresentable {
    @Binding var fileURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let viewController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerViewController

        init(parent: DocumentPickerViewController) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.fileURL = url
            }
        }
    }
}

struct SubirArchivoView_Previews: PreviewProvider {
    static var previews: some View {
        SubirArchivoView()
    }
}*/
