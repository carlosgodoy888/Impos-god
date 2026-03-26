//
//  ThemePickerView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import SwiftUI

struct ThemePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel

    @Binding var selectedThemeID: UUID?
    @State private var searchText: String = ""

    private let orderedCategories: [ThemeCategory] = [.actualidad, .series, .general, .custom]

    private var filteredThemes: [Theme] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return appViewModel.allThemes
        }

        let query = searchText.lowercased()

        return appViewModel.allThemes.filter { theme in
            theme.name.lowercased().contains(query) ||
            theme.words.joined(separator: " ").lowercased().contains(query)
        }
    }

    private var groupedThemes: [ThemeCategory: [Theme]] {
        Dictionary(grouping: filteredThemes, by: \.category)
    }

    var body: some View {
        List {
            ForEach(orderedCategories) { category in
                let themes = groupedThemes[category] ?? []

                if !themes.isEmpty {
                    Section {
                        ForEach(themes) { theme in
                            ThemeCardView(
                                theme: theme,
                                isSelected: selectedThemeID == theme.id
                            ) {
                                selectedThemeID = theme.id
                                dismiss()
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.systemImage)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Buscar tema o palabra")
        .navigationTitle("Elegir tema")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.insetGrouped)
    }
}

#Preview {
    NavigationStack {
        ThemePickerView(selectedThemeID: .constant(nil))
            .environmentObject(AppViewModel())
    }
}
