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
        Theme(name: "Historia", words: ["Roma", "Napoleón", "Egipto", "Castillo", "Revolución"]),
        Theme(name: "Geografía", words: ["Montaña", "Río", "España", "Desierto", "Isla"]),
        Theme(name: "Ciencia", words: ["Átomo", "Energía", "Planeta", "ADN", "Gravedad"]),
        Theme(name: "Tecnología", words: ["iPhone", "Servidor", "WiFi", "Código", "Robot"]),
        Theme(name: "Películas y series", words: ["Batman", "Avatar", "Friends", "Shrek", "Gladiator"]),
        Theme(name: "Videojuegos", words: ["Minecraft", "Zelda", "Fortnite", "Mario", "FIFA"]),
        Theme(name: "Comida", words: ["Pizza", "Hamburguesa", "Paella", "Sushi", "Tortilla"])
    ]

    @Published var customThemes: [Theme] = []
    @Published var impostorImageData: Data?

    var allThemes: [Theme] {
        builtInThemes + customThemes
    }

    init() {
        loadCustomThemes()
        loadImpostorImage()
    }

    func addCustomTheme(name: String, wordsText: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        let cleanedWords = wordsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !cleanedName.isEmpty else { return }
        guard !cleanedWords.isEmpty else { return }

        let newTheme = Theme(name: cleanedName, words: cleanedWords, isCustom: true)
        customThemes.append(newTheme)
        saveCustomThemes()
    }

    func deleteCustomThemes(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            customThemes.remove(at: index)
        }
        saveCustomThemes()
    }

    func saveImpostorImage(data: Data?) {
        impostorImageData = data
        UserDefaults.standard.set(data, forKey: "impostorImageData")
    }

    private func saveCustomThemes() {
        do {
            let data = try JSONEncoder().encode(customThemes)
            UserDefaults.standard.set(data, forKey: "customThemes")
        } catch {
            print("Error guardando temas personalizados: \(error)")
        }
    }

    private func loadCustomThemes() {
        guard let data = UserDefaults.standard.data(forKey: "customThemes") else { return }

        do {
            customThemes = try JSONDecoder().decode([Theme].self, from: data)
        } catch {
            print("Error cargando temas personalizados: \(error)")
        }
    }

    private func loadImpostorImage() {
        impostorImageData = UserDefaults.standard.data(forKey: "impostorImageData")
    }
}
