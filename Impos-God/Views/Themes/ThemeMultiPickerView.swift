//
//  ThemeMultiPickerView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 27/3/26.
//



import SwiftUI

struct ThemeMultiPickerView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @Binding var selectedThemeIDs: Set<UUID>
    @State private var searchText: String = ""

    private var theme: AppTheme {
        AppTheme.make(for: appViewModel.appearanceMode)
    }

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

    private var selectedThemes: [Theme] {
        appViewModel.allThemes.filter { selectedThemeIDs.contains($0.id) }
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
        .navigationTitle("Temas de la partida")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ThemeMultiPickerView {
    var searchSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("Buscar")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                Text("Marca varios temas para que la app randomice solo dentro de esa selección.")
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
            VStack(alignment: .leading, spacing: 10) {
                Text("Selección actual")
                    .font(.title3.bold())
                    .foregroundStyle(theme.primaryText)

                HStack {
                    Text("Temas marcados")
                        .foregroundStyle(theme.secondaryText)

                    Spacer()

                    Text("\(selectedThemeIDs.count)")
                        .foregroundStyle(theme.primaryText)
                        .font(.title3.bold())
                }

                if selectedThemes.isEmpty {
                    Text("Todavía no has marcado ningún tema.")
                        .font(.subheadline)
                        .foregroundStyle(theme.secondaryText)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedThemes, id: \.id) { item in
                                Text(item.name)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(theme.chipText)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(iconColor(for: item.category).opacity(0.22))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.vertical, 2)
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
                Button {
                    toggle(item.id)
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

    func rowView(for item: Theme) -> some View {
        let isSelected = selectedThemeIDs.contains(item.id)

        return HStack(spacing: 12) {
            Image(systemName: item.category.systemImage)
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
                .stroke(
                    isSelected
                    ? theme.successAccent.opacity(0.55)
                    : iconColor(for: item.category).opacity(0.16),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: theme.shadowColor, radius: 6, x: 0, y: 3)
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    func toggle(_ id: UUID) {
        if selectedThemeIDs.contains(id) {
            selectedThemeIDs.remove(id)
        } else {
            selectedThemeIDs.insert(id)
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
        ThemeMultiPickerView(selectedThemeIDs: .constant([]))
            .environmentObject(AppViewModel())
    }
}
