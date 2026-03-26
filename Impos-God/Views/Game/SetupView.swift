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

    var allowedImpostors: [Int] {
        playersCount <= 4 ? [1] : [1, 2]
    }

    private var selectedTheme: Theme? {
        appViewModel.allThemes.first { $0.id == selectedThemeID }
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Configura la ronda")
                        .font(.title3.bold())

                    Text("Elige el tema, el número de jugadores, los impostores y revisa cómo está personalizada la carta del impostor.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Tema")) {
                Toggle("Tema aleatorio", isOn: $randomThemeEnabled)

                if !randomThemeEnabled {
                    Picker("Selecciona un tema", selection: $selectedThemeID) {
                        Text("Elige un tema").tag(UUID?.none)

                        ForEach(appViewModel.allThemes) { theme in
                            Text(theme.name).tag(Optional(theme.id))
                        }
                    }
                }
            }

            Section(header: Text("Jugadores")) {
                Stepper("Número de jugadores: \(playersCount)", value: $playersCount, in: 1...12)
            }

            Section(header: Text("Impostores")) {
                Picker("Número de impostores", selection: $impostorsCount) {
                    ForEach(allowedImpostors, id: \.self) { count in
                        Text("\(count)").tag(count)
                    }
                }

                .onChange(of: playersCount) { _, _ in
                    if !allowedImpostors.contains(impostorsCount) {
                        impostorsCount = allowedImpostors.first ?? 1
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

            Section(header: Text("Personalización del impostor")) {
                NavigationLink(destination: SettingsView()) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Pista y carta del impostor")
                            .font(.headline)

                        Text(
                            appViewModel.impostorHintsEnabled
                            ? "Pista activada: \(appViewModel.impostorHintStyle.rawValue)"
                            : "Pista desactivada"
                        )
                        .foregroundStyle(.secondary)

                        Text(
                            appViewModel.impostorImageData != nil
                            ? "Foto personalizada cargada"
                            : "Sin foto personalizada"
                        )
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section(header: Text("Resumen")) {
                Text("Jugadores: \(playersCount)")
                Text("Impostores: \(impostorsCount)")
                Text(
                    randomThemeEnabled
                    ? "Tema: aleatorio"
                    : "Tema: \(selectedTheme?.name ?? "sin seleccionar")"
                )
                .foregroundStyle(
                    !randomThemeEnabled && selectedTheme == nil ? .red : .primary
                )
            }

            Section {
                Button("Preparar reparto") {
                    startGame()
                }
            }
        }
        .navigationTitle("Nueva partida")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $generatedSession) { session in
            RevealFlowView(session: session)
                .environmentObject(appViewModel)
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
}

#Preview {
    NavigationStack {
        SetupView()
            .environmentObject(AppViewModel())
    }
}
