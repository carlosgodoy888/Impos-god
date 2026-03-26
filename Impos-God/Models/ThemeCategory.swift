//
//  ThemeCategory.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI

enum ThemeCategory: String, CaseIterable, Codable, Hashable, Identifiable {
    case actualidad = "Actualidad"
    case series = "Series y universos"
    case general = "Generalistas"
    case custom = "Personalizados"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .actualidad:
            return "bolt.fill"
        case .series:
            return "sparkles.tv.fill"
        case .general:
            return "globe.europe.africa.fill"
        case .custom:
            return "slider.horizontal.3"
        }
    }
}
