//
//  AppViewModel.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//



import Foundation
import Combine

final class AppViewModel: ObservableObject {
    enum AppearanceMode: String, CaseIterable, Identifiable, Codable {
        case darkBlue = "Azul oscuro"
        case lightBlue = "Azul claro"

        var id: String { rawValue }

        var descriptionText: String {
            switch self {
            case .darkBlue:
                return "Fondo oscuro con contraste alto. Ideal para que el texto blanco se vea mejor."
            case .lightBlue:
                return "Fondo azul claro y aspecto más limpio. Ideal para un estilo más suave."
            }
        }
    }

    @Published var builtInThemes: [Theme] = ThemeCatalog.all
    @Published var customThemes: [Theme] = []

    @Published var impostorHintsEnabled: Bool = true
    @Published var impostorHintStyle: ImpostorHintStyle = .verySoft

    @Published var appearanceMode: AppearanceMode = .darkBlue

    private let customThemesKey = "customThemes"
    private let impostorHintsEnabledKey = "impostorHintsEnabled"
    private let impostorHintStyleKey = "impostorHintStyle"
    private let appearanceModeKey = "appearanceMode"

    var allThemes: [Theme] {
        builtInThemes + customThemes
    }

    init() {
        loadCustomThemes()
        loadHintSettings()
        loadAppearanceSettings()
    }

    func addCustomTheme(name: String, wordsText: String) {
        addCustomTheme(name: name, wordsText: wordsText, category: .custom)
    }

    func addCustomTheme(name: String, wordsText: String, category: ThemeCategory) {
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
            category: category,
            isCustom: true
        )

        customThemes.append(newTheme)
        saveCustomThemes()
    }

    func updateCustomTheme(themeID: UUID, newName: String, newWordsText: String, newCategory: ThemeCategory) {
        let cleanedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)

        let cleanedWords = newWordsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !cleanedName.isEmpty else { return }
        guard !cleanedWords.isEmpty else { return }
        guard let index = customThemes.firstIndex(where: { $0.id == themeID }) else { return }

        customThemes[index].name = cleanedName
        customThemes[index].words = cleanedWords
        customThemes[index].category = newCategory
        customThemes[index].isCustom = true

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

    func setAppearanceMode(_ mode: AppearanceMode) {
        appearanceMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: appearanceModeKey)
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

    private func loadAppearanceSettings() {
        if let rawValue = UserDefaults.standard.string(forKey: appearanceModeKey),
           let mode = AppearanceMode(rawValue: rawValue) {
            appearanceMode = mode
        }
    }
}
