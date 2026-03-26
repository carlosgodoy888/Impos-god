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
        useRandomTheme: Bool
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

        return GameSession(
            themeName: theme.name,
            secretWord: word,
            playersCount: playersCount,
            impostorIndexes: impostorIndexes
        )
    }
}
