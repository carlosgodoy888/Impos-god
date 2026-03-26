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

        let hintText = hintEnabled
            ? makeHint(theme: theme, secretWord: word, style: hintStyle)
            : nil

        return GameSession(
            themeName: theme.name,
            secretWord: word,
            playersCount: playersCount,
            impostorIndexes: impostorIndexes,
            impostorHintText: hintText
        )
    }

    private static func makeHint(theme: Theme, secretWord: String, style: ImpostorHintStyle) -> String {
        switch style {
        case .themeOnly:
            return "Tema: \(theme.name)"

        case .themeAndLength:
            let length = cleanedCharacterCount(for: secretWord)
            return "Tema: \(theme.name)\nLongitud aproximada: \(length) caracteres"

        case .themeAndExample:
            let candidates = theme.words.filter { normalized($0) != normalized(secretWord) }

            if let example = candidates.randomElement() {
                return "Tema: \(theme.name)\nEjemplo del tema: \(example)"
            } else {
                return "Tema: \(theme.name)"
            }
        }
    }

    private static func cleanedCharacterCount(for text: String) -> Int {
        text.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }.count
    }

    private static func normalized(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
