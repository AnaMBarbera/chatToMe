//
//  Model.swift
//  chatToMe
//
//  Created by Jose on 7/5/24.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore

struct Mensaje: Codable, Identifiable, Equatable, Hashable {
    @DocumentID var id: String?// Identificador único de FireStore
    var texto: String
    var usuarioE: String
    @ServerTimestamp var timestamp: Timestamp?
}
