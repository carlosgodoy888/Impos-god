//
//  AppViewModel.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import Foundation
import Combine

final class AppViewModel: ObservableObject {
    // MARK: - Modo visual general de la app
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

    // MARK: - Temas base cargados desde el catálogo
    @Published var builtInThemes: [Theme] = ThemeCatalog.all

    // MARK: - Temas personalizados del usuario
    @Published var customThemes: [Theme] = []

    // MARK: - Configuración del impostor
    @Published var impostorHintsEnabled: Bool = true
    @Published var impostorHintStyle: ImpostorHintStyle = .verySoft

    // MARK: - Configuración visual
    @Published var appearanceMode: AppearanceMode = .darkBlue

    // MARK: - Claves de persistencia
    private let customThemesKey = "customThemes"
    private let impostorHintsEnabledKey = "impostorHintsEnabled"
    private let impostorHintStyleKey = "impostorHintStyle"
    private let appearanceModeKey = "appearanceMode"

    // MARK: - Todos los temas disponibles
    var allThemes: [Theme] {
        builtInThemes + customThemes
    }

    init() {
        loadCustomThemes()
        loadHintSettings()
        loadAppearanceSettings()
    }

    // MARK: - Gestión de temas personalizados
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

    // MARK: - Configuración de pistas
    func setImpostorHintsEnabled(_ enabled: Bool) {
        impostorHintsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: impostorHintsEnabledKey)
    }

    func setImpostorHintStyle(_ style: ImpostorHintStyle) {
        impostorHintStyle = style
        UserDefaults.standard.set(style.rawValue, forKey: impostorHintStyleKey)
    }

    // MARK: - Configuración visual
    func setAppearanceMode(_ mode: AppearanceMode) {
        appearanceMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: appearanceModeKey)
    }

    // MARK: - Persistencia: temas personalizados
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

    // MARK: - Persistencia: pistas
    private func loadHintSettings() {
        if UserDefaults.standard.object(forKey: impostorHintsEnabledKey) != nil {
            impostorHintsEnabled = UserDefaults.standard.bool(forKey: impostorHintsEnabledKey)
        }

        if let rawValue = UserDefaults.standard.string(forKey: impostorHintStyleKey),
           let style = ImpostorHintStyle(rawValue: rawValue) {
            impostorHintStyle = style
        }
    }

    // MARK: - Persistencia: apariencia
    private func loadAppearanceSettings() {
        if let rawValue = UserDefaults.standard.string(forKey: appearanceModeKey),
           let mode = AppearanceMode(rawValue: rawValue) {
            appearanceMode = mode
        }
    }
}
