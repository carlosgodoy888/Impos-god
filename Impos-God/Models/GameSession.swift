//
//  GameSession.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import Foundation

struct GameSession: Identifiable, Hashable {
    let id: UUID
    let themeName: String
    let secretWord: String
    let playersCount: Int
    let impostorIndexes: Set<Int>

    init(
        id: UUID = UUID(),
        themeName: String,
        secretWord: String,
        playersCount: Int,
        impostorIndexes: Set<Int>
    ) {
        self.id = id
        self.themeName = themeName
        self.secretWord = secretWord
        self.playersCount = playersCount
        self.impostorIndexes = impostorIndexes
    }

    func isImpostor(playerIndex: Int) -> Bool {
        impostorIndexes.contains(playerIndex)
    }
}
