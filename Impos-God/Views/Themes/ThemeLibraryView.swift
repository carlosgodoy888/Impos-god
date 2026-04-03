//
//  ThemeLibraryView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//



import SwiftUI

struct ThemeLibraryView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // MARK: - Estado de formulario
    @State private var newThemeName: String = ""
    @State private var newThemeWords: String = ""
    @State private var selectedCategory: ThemeCategory = .custom
    @State private var searchText: String = ""

    // MARK: - Estado de edición
    @State private var editingThemeID: UUID?

    // MARK: - Tema visual actual
    private var theme: AppTheme {
        AppTheme.make(for: appViewModel.appearanceMode)
    }

    // MARK: - Temas filtrados por búsqueda
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

    // MARK: - Saber si estamos editando
    private var isEditing: Bool {
        editingThemeID != nil
    }

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            List {
                searchSection
                createOrEditThemeSection
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

    var createOrEditThemeSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                Text(isEditing ? "Editar tema personalizado" : "Crear tema personalizado")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                Text(isEditing
                     ? "Modifica el nombre, las palabras y la categoría del tema."
                     : "Escribe un nombre, varias palabras y selecciona una categoría.")
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

                VStack(alignment: .leading, spacing: 8) {
                    Text("Categoría")
                        .font(.headline)
                        .foregroundStyle(theme.primaryText)

                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(ThemeCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Button {
                    saveOrUpdateTheme()
                } label: {
                    Text(isEditing ? "Guardar cambios" : "Guardar tema")
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

                if isEditing {
                    Button {
                        resetForm()
                    } label: {
                        Text("Cancelar edición")
                            .font(.headline)
                            .foregroundStyle(theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(theme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(theme.cardBorder, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
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
                Image(systemName: iconName(for: item.category))
                    .foregroundStyle(iconColor(for: item.category))
                    .frame(width: 24)

                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(theme.primaryText)

                Spacer()

                Text(item.category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.chipText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(iconColor(for: item.category).opacity(0.22))
                    .clipShape(Capsule())
            }

            Text(item.words.prefix(4).joined(separator: ", "))
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)
                .lineLimit(2)

            if item.isCustom {
                HStack(spacing: 10) {
                    Button {
                        startEditing(item)
                    } label: {
                        Label("Editar", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(role: .destructive) {
                        appViewModel.deleteCustomTheme(item)
                        if editingThemeID == item.id {
                            resetForm()
                        }
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
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

// MARK: - Lógica
private extension ThemeLibraryView {
    func saveOrUpdateTheme() {
        if let editingThemeID {
            appViewModel.updateCustomTheme(
                themeID: editingThemeID,
                newName: newThemeName,
                newWordsText: newThemeWords,
                newCategory: selectedCategory
            )
        } else {
            appViewModel.addCustomTheme(
                name: newThemeName,
                wordsText: newThemeWords,
                category: selectedCategory
            )
        }

        resetForm()
    }

    func startEditing(_ themeToEdit: Theme) {
        editingThemeID = themeToEdit.id
        newThemeName = themeToEdit.name
        newThemeWords = themeToEdit.words.joined(separator: ", ")
        selectedCategory = themeToEdit.category
    }

    func resetForm() {
        editingThemeID = nil
        newThemeName = ""
        newThemeWords = ""
        selectedCategory = .custom
    }
}

// MARK: - Helpers visuales
private extension ThemeLibraryView {
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
