//
//  ThemeLibraryView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI

struct ThemeLibraryView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var newThemeName: String = ""
    @State private var newThemeWords: String = ""
    @State private var searchText: String = ""

    private var filteredThemes: [Theme] {
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if query.isEmpty {
            return appViewModel.allThemes
        }

        return appViewModel.allThemes.filter { theme in
            theme.name.lowercased().contains(query) ||
            theme.words.joined(separator: " ").lowercased().contains(query)
        }
    }

    var body: some View {
        List {
            Section("Buscar") {
                TextField("Buscar tema o palabra", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Crear tema personalizado") {
                TextField("Nombre del tema", text: $newThemeName)
                TextField("Palabras separadas por comas", text: $newThemeWords)

                Button("Guardar tema") {
                    appViewModel.addCustomTheme(name: newThemeName, wordsText: newThemeWords)
                    newThemeName = ""
                    newThemeWords = ""
                }
            }

            Section("Temas disponibles") {
                ForEach(filteredThemes, id: \.id) { theme in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(theme.name)
                            .font(.headline)

                        Text(theme.words.prefix(3).joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)

                        if theme.isCustom {
                            Button(role: .destructive) {
                                deleteTheme(theme)
                            } label: {
                                Label("Eliminar tema", systemImage: "trash")
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Biblioteca")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.insetGrouped)
    }

    private func deleteTheme(_ theme: Theme) {
        appViewModel.deleteCustomTheme(theme)
    }
}

#Preview {
    NavigationStack {
        ThemeLibraryView()
            .environmentObject(AppViewModel())
    }
}
