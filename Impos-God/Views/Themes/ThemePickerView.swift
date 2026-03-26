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
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.14),
                    Color(red: 0.12, green: 0.10, blue: 0.28),
                    Color(red: 0.07, green: 0.12, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

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
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Elegir tema")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ThemePickerView(selectedThemeID: .constant(nil))
            .environmentObject(AppViewModel())
    }
}
