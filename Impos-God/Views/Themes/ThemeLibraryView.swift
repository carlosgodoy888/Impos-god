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

    var body: some View {
        List {
            Section(header: Text("Temas predefinidos")) {
                ForEach(appViewModel.builtInThemes) { theme in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(theme.name)
                            .font(.headline)

                        Text(theme.words.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section(header: Text("Crear tema personalizado")) {
                TextField("Nombre del tema", text: $newThemeName)
                TextField("Palabras separadas por comas", text: $newThemeWords)

                Button("Guardar tema") {
                    appViewModel.addCustomTheme(name: newThemeName, wordsText: newThemeWords)
                    newThemeName = ""
                    newThemeWords = ""
                }
            }

            Section(header: Text("Temas personalizados")) {
                if appViewModel.customThemes.isEmpty {
                    Text("Todavía no has creado temas personalizados.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(appViewModel.customThemes) { theme in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(theme.name)
                                .font(.headline)

                            Text(theme.words.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: appViewModel.deleteCustomThemes)
                }
            }
        }
        .navigationTitle("Biblioteca")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ThemeLibraryView()
            .environmentObject(AppViewModel())
    }
}
