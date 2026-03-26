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

    private let maxPlayers: Int = 20

    private var selectedTheme: Theme? {
        appViewModel.allThemes.first { $0.id == selectedThemeID }
    }

    private var allowedImpostors: [Int] {
        playersCount > 5 ? [1, 2] : [1]
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.18),
                    Color(red: 0.14, green: 0.10, blue: 0.32),
                    Color(red: 0.08, green: 0.15, blue: 0.26)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Configura la ronda")
                            .font(.title3.bold())
                            .foregroundStyle(.white)

                        Text("Elige el tema, ajusta jugadores e impostores y prepara el reparto.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.white.opacity(0.08))
                }

                Section("Tema") {
                    Toggle("Tema aleatorio", isOn: $randomThemeEnabled)

                    if !randomThemeEnabled {
                        NavigationLink(destination: ThemePickerView(selectedThemeID: $selectedThemeID)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Elegir tema")
                                    .font(.headline)

                                Text(selectedTheme?.name ?? "Toca aquí para seleccionar un tema")
                                    .foregroundStyle(selectedTheme == nil ? .secondary : .primary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Jugadores") {
                    Stepper("Número de jugadores: \(playersCount)", value: $playersCount, in: 1...maxPlayers)

                    Text("Puedes jugar hasta \(maxPlayers) jugadores.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Impostores") {
                    if playersCount > 5 {
                        Picker("Número de impostores", selection: $impostorsCount) {
                            ForEach(allowedImpostors, id: \.self) { count in
                                Text("\(count)").tag(count)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        HStack {
                            Text("Número de impostores")
                            Spacer()
                            Text("1")
                                .fontWeight(.semibold)
                                .foregroundStyle(.orange)
                        }
                    }

                    Text(playersCount > 5
                         ? "Con más de 5 jugadores puedes elegir 1 o 2 impostores."
                         : "Con 5 o menos jugadores la partida usa 1 impostor.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Pistas del impostor") {
                    NavigationLink(destination: SettingsView()) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Configurar pistas")
                                .font(.headline)

                            Text(appViewModel.impostorHintsEnabled
                                 ? "Modo actual: \(appViewModel.impostorHintStyle.rawValue)"
                                 : "Actualmente desactivadas")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Resumen") {
                    summaryRow("Jugadores", "\(playersCount)")
                    summaryRow("Impostores", "\(impostorsCount)")
                    summaryRow("Tema", randomThemeEnabled ? "Aleatorio" : (selectedTheme?.name ?? "Sin seleccionar"))
                }

                Section {
                    Button {
                        startGame()
                    } label: {
                        Text("Preparar reparto")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
        }
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
        .onChange(of: playersCount) { _, _ in
            if !allowedImpostors.contains(impostorsCount) {
                impostorsCount = allowedImpostors.first ?? 1
            }
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
            alertMessage = "No se ha podido crear la partida. Revisa la configuración e inténtalo otra vez."
            showAlert = true
            return
        }

        generatedSession = session
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SetupView()
            .environmentObject(AppViewModel())
    }
}
