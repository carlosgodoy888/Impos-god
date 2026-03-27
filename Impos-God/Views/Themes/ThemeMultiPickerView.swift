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

    private var filteredThemes: [Theme] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

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
                    Color(red: 0.07, green: 0.07, blue: 0.16),
                    Color(red: 0.12, green: 0.10, blue: 0.28),
                    Color(red: 0.07, green: 0.14, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            List {
                Section {
                    TextField("Buscar tema o palabra", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundStyle(.white)
                } header: {
                    Text("Buscar")
                        .foregroundStyle(.white)
                }

                Section {
                    ForEach(filteredThemes, id: \.id) { theme in
                        Button {
                            toggle(theme.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: iconName(for: theme.category))
                                    .foregroundStyle(iconColor(for: theme.category))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(theme.name)
                                        .foregroundStyle(.white)
                                        .font(.headline)

                                    Text(theme.words.prefix(4).joined(separator: ", "))
                                        .foregroundStyle(.white.opacity(0.75))
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }

                                Spacer()

                                Image(systemName: selectedThemeIDs.contains(theme.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedThemeIDs.contains(theme.id) ? .green : .white.opacity(0.5))
                                    .font(.title3)
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Color.white.opacity(0.08))
                    }
                } header: {
                    Text("Selecciona los temas disponibles para esta partida")
                        .foregroundStyle(.white)
                }

                Section {
                    HStack {
                        Text("Temas seleccionados")
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(selectedThemeIDs.count)")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                }
                .listRowBackground(Color.white.opacity(0.08))
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Temas de la partida")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(_ id: UUID) {
        if selectedThemeIDs.contains(id) {
            selectedThemeIDs.remove(id)
        } else {
            selectedThemeIDs.insert(id)
        }
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
        ThemeMultiPickerView(selectedThemeIDs: .constant([]))
            .environmentObject(AppViewModel())
    }
}
