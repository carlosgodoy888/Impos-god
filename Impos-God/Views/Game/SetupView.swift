//
//  SetupView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//



import SwiftUI

struct SetupView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var selectedThemeIDs: Set<UUID> = []
    @State private var playersCount: Int = 4
    @State private var impostorsCount: Int = 1

    @State private var generatedSession: GameSession?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private let maxPlayers: Int = 24

    private var selectedThemes: [Theme] {
        appViewModel.allThemes.filter { selectedThemeIDs.contains($0.id) }
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

                        Text("La app elegirá aleatoriamente el jugador inicial, el impostor y el tema dentro de los temas que marques.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.white.opacity(0.08))
                }

                Section("Temas") {
                    NavigationLink(destination: ThemeMultiPickerView(selectedThemeIDs: $selectedThemeIDs)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Elegir temas para esta partida")
                                .font(.headline)

                            Text(selectedThemeIDs.isEmpty
                                 ? "Toca aquí para seleccionar uno o varios"
                                 : "\(selectedThemeIDs.count) tema(s) seleccionados")
                                .foregroundStyle(selectedThemeIDs.isEmpty ? .secondary : .primary)
                        }
                        .padding(.vertical, 4)
                    }

                    Text("La partida sacará un tema aleatorio solo dentro de esta selección.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
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
                    summaryRow("Temas marcados", "\(selectedThemeIDs.count)")
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
        if selectedThemeIDs.isEmpty {
            alertMessage = "Selecciona al menos un tema para la partida."
            showAlert = true
            return
        }

        guard let session = GameFactory.makeSession(
            playersCount: playersCount,
            impostorsCount: impostorsCount,
            selectedThemes: selectedThemes,
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
