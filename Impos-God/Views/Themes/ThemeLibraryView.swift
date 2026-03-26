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
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.06, blue: 0.14),
                    Color(red: 0.12, green: 0.10, blue: 0.26),
                    Color(red: 0.08, green: 0.14, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Buscar")
                            .font(.title3.bold())
                            .foregroundStyle(.white)

                        TextField("Buscar tema o palabra", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.white.opacity(0.08))
                }

                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Crear tema personalizado")
                            .font(.title3.bold())
                            .foregroundStyle(.white)

                        TextField("Nombre del tema", text: $newThemeName)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        TextField("Palabras separadas por comas", text: $newThemeWords)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        Button {
                            appViewModel.addCustomTheme(name: newThemeName, wordsText: newThemeWords)
                            newThemeName = ""
                            newThemeWords = ""
                        } label: {
                            Text("Guardar tema")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [.green, .mint],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.white.opacity(0.08))
                }

                Section("Temas disponibles") {
                    ForEach(filteredThemes, id: \.id) { theme in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 12) {
                                Image(systemName: iconName(for: theme.category))
                                    .foregroundStyle(iconColor(for: theme.category))
                                    .frame(width: 24)

                                Text(theme.name)
                                    .font(.headline)

                                Spacer()

                                Text(theme.category.rawValue)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(iconColor(for: theme.category))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(iconColor(for: theme.category).opacity(0.12))
                                    .clipShape(Capsule())
                            }

                            Text(theme.words.prefix(4).joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)

                            if theme.isCustom {
                                Button(role: .destructive) {
                                    appViewModel.deleteCustomTheme(theme)
                                } label: {
                                    Label("Eliminar tema", systemImage: "trash")
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(iconColor(for: theme.category).opacity(0.10))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(iconColor(for: theme.category).opacity(0.20), lineWidth: 1)
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Biblioteca")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func iconName(for category: ThemeCategory) -> String {
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

    private func iconColor(for category: ThemeCategory) -> Color {
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

