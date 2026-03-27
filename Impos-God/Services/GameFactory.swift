//
//  GameFactory.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import Foundation

enum GameFactory {
    static func makeSession(
        playersCount: Int,
        impostorsCount: Int,
        selectedThemes: [Theme],
        hintEnabled: Bool,
        hintStyle: ImpostorHintStyle
    ) -> GameSession? {
        guard playersCount > 0 else { return nil }
        guard !selectedThemes.isEmpty else { return nil }

        guard let chosenTheme = selectedThemes.randomElement(),
              let chosenWord = chosenTheme.words.randomElement() else {
            return nil
        }

        let startingPlayerIndex = Int.random(in: 0..<playersCount)

        let safeImpostorsCount = max(1, min(impostorsCount, playersCount))
        let impostorIndexes = Set(Array(0..<playersCount).shuffled().prefix(safeImpostorsCount))

        let hintText = hintEnabled ? makeHint(for: chosenTheme, style: hintStyle) : nil

        return GameSession(
            themeName: chosenTheme.name,
            secretWord: chosenWord,
            playersCount: playersCount,
            impostorIndexes: impostorIndexes,
            startingPlayerIndex: startingPlayerIndex,
            impostorHintText: hintText
        )
    }

    private static func makeHint(for theme: Theme, style: ImpostorHintStyle) -> String? {
        switch style {
        case .none:
            return nil
        case .verySoft:
            return broadHint(for: theme)
        case .soft:
            return "\(broadHint(for: theme))\n\(elementHint(for: theme))"
        case .medium:
            return "Tema: \(theme.name)\n\(elementHint(for: theme))"
        }
    }

    private static func broadHint(for theme: Theme) -> String {
        switch theme.category {
        case .actualidad:
            return "Relacionado con actualidad, famosos o deporte."
        case .series:
            return "Relacionado con ficción, entretenimiento o sagas."
        case .general:
            return "Relacionado con cultura general o cosas cotidianas."
        case .custom:
            return "Relacionado con un tema personalizado."
        }
    }

    private static func elementHint(for theme: Theme) -> String {
        let name = normalized(theme.name)

        if name.contains("personajes") || name.contains("villanos") || name.contains("superhéroes") || name.contains("superheroes") {
            return "Es un personaje."
        }

        if name.contains("actores") || name.contains("actrices") || name.contains("cantantes") ||
            name.contains("streamers") || name.contains("youtubers") || name.contains("influencers") ||
            name.contains("tenistas") || name.contains("luchadores") || name.contains("futbolistas") ||
            name.contains("política") || name.contains("politica") {
            return "Es una persona."
        }

        if name.contains("clubes") || name.contains("escuderías") || name.contains("escuderias") {
            return "Es un equipo o una entidad."
        }

        if name.contains("ciudades") || name.contains("países") || name.contains("paises") || name.contains("monumentos") {
            return "Es un lugar."
        }

        if name.contains("comida") {
            return "Es comida."
        }

        if name.contains("animales") {
            return "Es un animal."
        }

        if name.contains("profesiones") {
            return "Es una profesión."
        }

        if name.contains("marcas") {
            return "Es una marca."
        }

        if name.contains("memes") {
            return "Es algo viral de internet."
        }

        return "Es algo muy reconocible dentro del tema."
    }

    private static func normalized(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
