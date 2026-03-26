//
//  Theme.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import Foundation

struct Theme: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var words: [String]
    var category: ThemeCategory
    var isCustom: Bool

    init(
        id: UUID = UUID(),
        name: String,
        words: [String],
        category: ThemeCategory = .general,
        isCustom: Bool = false
    ) {
        self.id = id
        self.name = name
        self.words = words
        self.category = category
        self.isCustom = isCustom
    }
}
