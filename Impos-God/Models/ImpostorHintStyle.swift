//
//  ImpostorHintStyle.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import Foundation

enum ImpostorHintStyle: String, CaseIterable, Identifiable, Codable {
    case themeOnly = "Solo tema"
    case themeAndLength = "Tema y longitud"
    case themeAndExample = "Tema y ejemplo"

    var id: String { rawValue }

    var helperText: String {
        switch self {
        case .themeOnly:
            return "Solo revela la categoría general."
        case .themeAndLength:
            return "Muestra el tema y una longitud aproximada."
        case .themeAndExample:
            return "Muestra el tema y un ejemplo distinto."
        }
    }
}
