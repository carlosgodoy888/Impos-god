//
//  AppViewModel.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import Foundation
import Combine

final class AppViewModel: ObservableObject {
    @Published var builtInThemes: [Theme] = ThemeCatalog.all
    @Published var customThemes: [Theme] = []
    @Published var impostorHintsEnabled: Bool = true
    @Published var impostorHintStyle: ImpostorHintStyle = .verySoft

    private let customThemesKey = "customThemes"
    private let impostorHintsEnabledKey = "impostorHintsEnabled"
    private let impostorHintStyleKey = "impostorHintStyle"

    var allThemes: [Theme] {
        builtInThemes + customThemes
    }

    init() {
        loadCustomThemes()
        loadHintSettings()
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
        saveCustomThemes()
    }

    func deleteCustomTheme(_ theme: Theme) {
        customThemes.removeAll { $0.id == theme.id }
        saveCustomThemes()
    }

    func setImpostorHintsEnabled(_ enabled: Bool) {
        impostorHintsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: impostorHintsEnabledKey)
    }

    func setImpostorHintStyle(_ style: ImpostorHintStyle) {
        impostorHintStyle = style
        UserDefaults.standard.set(style.rawValue, forKey: impostorHintStyleKey)
    }

    private func saveCustomThemes() {
        do {
            let data = try JSONEncoder().encode(customThemes)
            UserDefaults.standard.set(data, forKey: customThemesKey)
        } catch {
            print("Error guardando temas personalizados: \(error)")
        }
    }

    private func loadCustomThemes() {
        guard let data = UserDefaults.standard.data(forKey: customThemesKey) else { return }

        do {
            customThemes = try JSONDecoder().decode([Theme].self, from: data)
        } catch {
            print("Error cargando temas personalizados: \(error)")
            customThemes = []
        }
    }

    private func loadHintSettings() {
        if UserDefaults.standard.object(forKey: impostorHintsEnabledKey) != nil {
            impostorHintsEnabled = UserDefaults.standard.bool(forKey: impostorHintsEnabledKey)
        }

        if let rawValue = UserDefaults.standard.string(forKey: impostorHintStyleKey),
           let style = ImpostorHintStyle(rawValue: rawValue) {
            impostorHintStyle = style
        }
    }
}
