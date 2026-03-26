//
//  Theme.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var words: [String]
    var isCustom: Bool

    init(id: UUID = UUID(), name: String, words: [String], isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.words = words
        self.isCustom = isCustom
    }
}
