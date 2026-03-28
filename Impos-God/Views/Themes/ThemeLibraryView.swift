//
//  ThemeLibraryView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//



import SwiftUI

struct ThemeLibraryView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // MARK: - Estado local
    @State private var newThemeName: String = ""
    @State private var newThemeWords: String = ""
    @State private var searchText: String = ""

    // MARK: - Tema visual actual
    private var theme: AppTheme {
        AppTheme.make(for: appViewModel.appearanceMode)
    }

    // MARK: - Filtrado de temas
    // Si no hay texto, se muestran todos.
    // Si hay texto, se filtra por nombre y por palabras.
    private var filteredThemes: [Theme] {
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if query.isEmpty {
            return appViewModel.allThemes
        }

        return appViewModel.allThemes.filter { item in
            item.name.lowercased().contains(query) ||
            item.words.joined(separator: " ").lowercased().contains(query)
        }
    }

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            List {
                searchSection
                createThemeSection
                themesSection
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Biblioteca")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Secciones principales
private extension ThemeLibraryView {
    var searchSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("Buscar")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                Text("Encuentra temas por nombre o por alguna palabra incluida.")
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryText)

                TextField("Buscar tema o palabra", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .appFieldStyle(theme)
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(theme.sectionBackground)
    }

    var createThemeSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                Text("Crear tema personalizado")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                Text("Escribe un nombre y varias palabras separadas por comas.")
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryText)

                TextField("Nombre del tema", text: $newThemeName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .appFieldStyle(theme)

                TextField("Palabras separadas por comas", text: $newThemeWords)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .appFieldStyle(theme)

                Button {
                    saveCustomTheme()
                } label: {
                    Text("Guardar tema")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [theme.successAccent, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(theme.sectionBackground)
    }

    var themesSection: some View {
        Section {
            ForEach(filteredThemes, id: \.id) { item in
                themeRow(item)
            }
        } header: {
            Text("Temas disponibles")
                .foregroundStyle(theme.primaryText)
        }
    }
}

// MARK: - Fila de tema
private extension ThemeLibraryView {
    func themeRow(_ item: Theme) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                // Icono de categoría
                Image(systemName: iconName(for: item.category))
                    .foregroundStyle(iconColor(for: item.category))
                    .frame(width: 24)

                // Nombre del tema
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(theme.primaryText)

                Spacer()

                // Badge de categoría
                Text(item.category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.chipText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(iconColor(for: item.category).opacity(0.22))
                    .clipShape(Capsule())
            }

            // Vista previa de palabras
            Text(item.words.prefix(4).joined(separator: ", "))
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)
                .lineLimit(2)

            // Solo los personalizados se pueden eliminar
            if item.isCustom {
                Button(role: .destructive) {
                    appViewModel.deleteCustomTheme(item)
                } label: {
                    Label("Eliminar tema", systemImage: "trash")
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(theme.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(iconColor(for: item.category).opacity(0.18), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: theme.shadowColor, radius: 6, x: 0, y: 3)
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

// MARK: - Helpers
private extension ThemeLibraryView {
    func saveCustomTheme() {
        appViewModel.addCustomTheme(name: newThemeName, wordsText: newThemeWords)
        newThemeName = ""
        newThemeWords = ""
    }

    func iconName(for category: ThemeCategory) -> String {
        switch category {
        case .actualidad:
            return "bolt.fill"
        case .series:
            return "sparkles.tv.fill"
        case .general:
            return "globe.europe.africa.fill"
        case .custom:
            return "slider.horizontal.3"
        }
    }

    func iconColor(for category: ThemeCategory) -> Color {
        switch category {
        case .actualidad:
            return .orange
        case .series:
            return .purple
        case .general:
            return .blue
        case .custom:
            return .green
        }
    }
}

#Preview {
    NavigationStack {
        ThemeLibraryView()
            .environmentObject(AppViewModel())
    }
}
