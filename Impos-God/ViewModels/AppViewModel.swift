//
//  AppViewModel.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import Foundation
import Combine

final class AppViewModel: ObservableObject {
    @Published var builtInThemes: [Theme] = [
        Theme(
            name: "Futbolistas top actuales",
            words: ["Mbappé", "Vinicius Jr.", "Bellingham", "Rodrygo", "Valverde"],
            category: .actualidad
        ),
        Theme(
            name: "La que se avecina - personajes",
            words: ["Amador Rivas", "Coque Calatrava", "Antonio Recio", "Berta Escobar", "Maite Figueroa"],
            category: .series
        ),
        Theme(
            name: "Comida rápida",
            words: ["Pizza", "Hamburguesa", "Hot dog", "Kebab", "Tacos"],
            category: .general
        )
    ]

    @Published var customThemes: [Theme] = []
    @Published var impostorHintsEnabled: Bool = true
    @Published var impostorHintStyle: ImpostorHintStyle = .themeOnly

    var allThemes: [Theme] {
        builtInThemes + customThemes
    }

    func addCustomTheme(name: String, wordsText: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        let cleanedWords = wordsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !cleanedName.isEmpty else { return }
        guard !cleanedWords.isEmpty else { return }

        let newTheme = Theme(
            name: cleanedName,
            words: cleanedWords,
            category: .custom,
            isCustom: true
        )

        customThemes.append(newTheme)
    }

    func deleteCustomTheme(_ theme: Theme) {
        customThemes.removeAll { $0.id == theme.id }
    }

    func setImpostorHintsEnabled(_ enabled: Bool) {
        impostorHintsEnabled = enabled
    }

    func setImpostorHintStyle(_ style: ImpostorHintStyle) {
        impostorHintStyle = style
    }
}
