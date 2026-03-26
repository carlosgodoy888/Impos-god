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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case words
        case category
        case isCustom
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        words = try container.decode([String].self, forKey: .words)
        category = try container.decodeIfPresent(ThemeCategory.self, forKey: .category) ?? .custom
        isCustom = try container.decodeIfPresent(Bool.self, forKey: .isCustom) ?? true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(words, forKey: .words)
        try container.encode(category, forKey: .category)
        try container.encode(isCustom, forKey: .isCustom)
    }
}
