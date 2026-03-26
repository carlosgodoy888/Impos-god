//
//  SetupView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI

struct SetupView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var selectedThemeID: UUID?
    @State private var playersCount: Int = 4
    @State private var impostorsCount: Int = 1
    @State private var randomThemeEnabled: Bool = false

    @State private var generatedSession: GameSession?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var allowedImpostors: [Int] {
        playersCount <= 4 ? [1] : [1, 2]
    }

    private var selectedTheme: Theme? {
        appViewModel.allThemes.first { $0.id == selectedThemeID }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                sectionCard(title: "Tema", icon: "sparkles") {
                    Toggle("Tema aleatorio", isOn: $randomThemeEnabled)

                    if randomThemeEnabled {
                        Text("La app elegirá automáticamente un tema al empezar.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        NavigationLink(destination: ThemePickerView(selectedThemeID: $selectedThemeID)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Elegir tema")
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(selectedTheme?.name ?? "Toca aquí para seleccionar uno")
                                        .foregroundStyle(selectedTheme == nil ? .secondary : .primary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }

                sectionCard(title: "Jugadores", icon: "person.3.fill") {
                    LazyVGrid(columns: gridColumns, spacing: 10) {
                        ForEach(1...12, id: \.self) { count in
                            ChoiceChip(
                                title: "\(count)",
                                isSelected: playersCount == count,
                                color: .blue
                            ) {
                                playersCount = count
                                if !allowedImpostors.contains(impostorsCount) {
                                    impostorsCount = allowedImpostors.first ?? 1
                                }
                            }
                        }
                    }
                }

                sectionCard(title: "Impostores", icon: "person.fill.questionmark") {
                    HStack(spacing: 10) {
                        ForEach(allowedImpostors, id: \.self) { count in
                            ChoiceChip(
                                title: "\(count)",
                                isSelected: impostorsCount == count,
                                color: .orange
                            ) {
                                impostorsCount = count
                            }
                        }
                    }

                    Text(
                        playersCount <= 4
                        ? "Con 1 a 4 jugadores solo se permite 1 impostor."
                        : "Con 5 o más jugadores se permite 1 o 2 impostores."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                sectionCard(title: "Configuración del impostor", icon: "wand.and.stars") {
                    NavigationLink(destination: SettingsView()) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pista y visual del impostor")
                                .font(.headline)

                            Text(
                                appViewModel.impostorHintsEnabled
                                ? "Pista activada: \(appViewModel.impostorHintStyle.rawValue)"
                                : "Pista desactivada"
                            )
                            .foregroundStyle(.secondary)

                            Text("El fondo de la carta se toma desde Assets.")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }

                sectionCard(title: "Resumen", icon: "checkmark.seal.fill") {
                    summaryRow("Jugadores", value: "\(playersCount)")
                    summaryRow("Impostores", value: "\(impostorsCount)")
                    summaryRow("Tema", value: randomThemeEnabled ? "Aleatorio" : (selectedTheme?.name ?? "Sin seleccionar"))
                }

                Button {
                    startGame()
                } label: {
                    Text("Preparar reparto")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [.black.opacity(0.96), .purple.opacity(0.22), .blue.opacity(0.18)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Nueva partida")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $generatedSession) { session in
            RevealFlowView(session: session)
        }
        .alert("No se puede iniciar la partida", isPresented: $showAlert) {
            Button("Aceptar", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func startGame() {
        if !randomThemeEnabled && selectedTheme == nil {
            alertMessage = "Selecciona un tema o activa la opción de tema aleatorio."
            showAlert = true
            return
        }

        guard let session = GameFactory.makeSession(
            playersCount: playersCount,
            impostorsCount: impostorsCount,
            selectedTheme: selectedTheme,
            allThemes: appViewModel.allThemes,
            useRandomTheme: randomThemeEnabled,
            hintEnabled: appViewModel.impostorHintsEnabled,
            hintStyle: appViewModel.impostorHintStyle
        ) else {
            alertMessage = "No se ha podido crear la partida. Revisa los datos e inténtalo de nuevo."
            showAlert = true
            return
        }

        generatedSession = session
    }

    private func sectionCard<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)

                Text(title)
                    .font(.title3.bold())
            }

            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    private func summaryRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }
}

private struct ChoiceChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(isSelected ? color : Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SetupView()
            .environmentObject(AppViewModel())
    }
}
