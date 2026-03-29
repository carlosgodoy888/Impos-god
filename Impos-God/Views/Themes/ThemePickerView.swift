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

    // Tema visual actual según Ajustes
    private var theme: AppTheme {
        AppTheme.make(for: appViewModel.appearanceMode)
    }

    // Temas filtrados por búsqueda
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
                selectedSummarySection
                themesSection
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Elegir tema")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Secciones
private extension ThemePickerView {
    var searchSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("Buscar")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                Text("Encuentra rápidamente el tema que quieres usar en esta partida.")
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

    var selectedSummarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tema actual")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                if let currentTheme = currentSelectedTheme {
                    HStack(spacing: 12) {
                        Image(systemName: iconName(for: currentTheme.category))
                            .foregroundStyle(iconColor(for: currentTheme.category))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentTheme.name)
                                .font(.headline)
                                .foregroundStyle(theme.primaryText)

                            Text("Este será el único tema posible en la partida.")
                                .font(.subheadline)
                                .foregroundStyle(theme.secondaryText)
                        }

                        Spacer()
                    }
                } else {
                    Text("Todavía no has seleccionado un tema.")
                        .font(.subheadline)
                        .foregroundStyle(theme.secondaryText)
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(theme.sectionBackground)
    }

    var themesSection: some View {
        Section {
            ForEach(filteredThemes, id: \.id) { item in
                Button {
                    selectedThemeID = item.id
                    dismiss()
                } label: {
                    rowView(for: item)
                }
                .buttonStyle(.plain)
            }
        } header: {
            Text("Temas disponibles")
                .foregroundStyle(theme.primaryText)
        }
    }
}

// MARK: - Fila de tema
private extension ThemePickerView {
    func rowView(for item: Theme) -> some View {
        let isSelected = selectedThemeID == item.id

        return HStack(spacing: 12) {
            Image(systemName: iconName(for: item.category))
                .foregroundStyle(iconColor(for: item.category))
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(theme.primaryText)

                Text(item.words.prefix(4).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryText)
                    .lineLimit(2)
            }

            Spacer()

            VStack(spacing: 8) {
                Text(item.category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.chipText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(iconColor(for: item.category).opacity(0.22))
                    .clipShape(Capsule())

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? theme.successAccent : theme.tertiaryText)
                    .font(.title3)
            }
        }
        .padding(14)
        .background(theme.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? theme.successAccent.opacity(0.55) : iconColor(for: item.category).opacity(0.16), lineWidth: isSelected ? 2 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: theme.shadowColor, radius: 6, x: 0, y: 3)
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

// MARK: - Helpers
private extension ThemePickerView {
    var currentSelectedTheme: Theme? {
        appViewModel.allThemes.first { $0.id == selectedThemeID }
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
        ThemePickerView(selectedThemeID: .constant(nil))
            .environmentObject(AppViewModel())
    }
}
