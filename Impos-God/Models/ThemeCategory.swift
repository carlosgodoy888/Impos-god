//
//  ThemeCategory.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import Foundation

enum ThemeCategory: String, CaseIterable, Codable, Identifiable {
    case actualidad = "Actualidad"
    case series = "Series y universos"
    case general = "Generalistas"
    case custom = "Personalizados"

    var id: String { rawValue }
}
