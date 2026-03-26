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
        selectedTheme: Theme?,
        allThemes: [Theme],
        useRandomTheme: Bool,
        hintEnabled: Bool,
        hintStyle: ImpostorHintStyle
    ) -> GameSession? {
        let chosenTheme: Theme?

        if useRandomTheme {
            chosenTheme = allThemes.randomElement()
        } else {
            chosenTheme = selectedTheme
        }

        guard let theme = chosenTheme else { return nil }
        guard let word = theme.words.randomElement() else { return nil }
        guard playersCount > 0 else { return nil }

        let safeImpostorsCount = max(1, min(impostorsCount, playersCount))
        let randomIndexes = Array(0..<playersCount).shuffled().prefix(safeImpostorsCount)
        let impostorIndexes = Set(randomIndexes)

        let hintText = hintEnabled ? makeHint(for: theme, style: hintStyle) : nil

        return GameSession(
            themeName: theme.name,
            secretWord: word,
            playersCount: playersCount,
            impostorIndexes: impostorIndexes,
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

        if name.contains("personajes") || name.contains("villanos") || name.contains("superheroes") {
            return "Es un personaje."
        }

        if name.contains("actores") || name.contains("actrices") || name.contains("cantantes") ||
            name.contains("streamers") || name.contains("youtubers") || name.contains("influencers") ||
            name.contains("tenistas") || name.contains("luchadores") || name.contains("futbolistas") ||
            name.contains("politica") || name.contains("politicos") || name.contains("f1 2026") ||
            name.contains("nba actual") || name.contains("ufc") {
            return "Es una persona."
        }

        if name.contains("clubes") || name.contains("escuderias") {
            return "Es un equipo o una entidad."
        }

        if name.contains("ciudades") || name.contains("paises") || name.contains("monumentos") {
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

        if name.contains("minecraft") || name.contains("call of duty") || name.contains("gta") ||
            name.contains("ea sports") || name.contains("fortnite") {
            return "Está relacionado con videojuegos."
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
