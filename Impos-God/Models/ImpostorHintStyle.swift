//
//  ImpostorHintStyle.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import Foundation

enum ImpostorHintStyle: String, CaseIterable, Identifiable, Codable {
    case none = "Sin pista"
    case verySoft = "Muy suave"
    case soft = "Suave"
    case medium = "Media"

    var id: String { rawValue }

    var helperText: String {
        switch self {
        case .none:
            return "El impostor no recibe ninguna ayuda."
        case .verySoft:
            return "Solo recibe una orientación muy general."
        case .soft:
            return "Recibe orientación general y el tipo de elemento."
        case .medium:
            return "Recibe el tema y el tipo de elemento, sin revelar la respuesta."
        }
    }
}
