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
    @State private var randomThemeEnabled: Bool = false

    @State private var generatedSession: GameSession?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    private var resolvedImpostorsCount: Int {
        playersCount > 5 ? 2 : 1
    }

    private var selectedTheme: Theme? {
        appViewModel.allThemes.first { $0.id == selectedThemeID }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.12),
                    Color(red: 0.13, green: 0.09, blue: 0.28),
                    Color(red: 0.08, green: 0.13, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

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
                                }
                            }
                        }
                    }

                    sectionCard(title: "Impostores", icon: "person.fill.questionmark") {
                        HStack {
                            Text("Número asignado automáticamente")
                                .foregroundStyle(.secondary)

                            Spacer()

                            Text("\(resolvedImpostorsCount)")
                                .font(.title3.bold())
                                .foregroundStyle(.orange)
                        }

                        Text(
                            playersCount > 5
                            ? "Con más de 5 jugadores habrá 2 impostores."
                            : "Con 5 o menos jugadores habrá 1 impostor."
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

                                Text("La carta usará las imágenes guardadas en Assets.")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    sectionCard(title: "Resumen", icon: "checkmark.seal.fill") {
                        summaryRow("Jugadores", value: "\(playersCount)")
                        summaryRow("Impostores", value: "\(resolvedImpostorsCount)")
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
    }

    private func startGame() {
        if !randomThemeEnabled && selectedTheme == nil {
            alertMessage = "Selecciona un tema o activa la opción de tema aleatorio."
            showAlert = true
            return
        }

        guard let session = GameFactory.makeSession(
            playersCount: playersCount,
            impostorsCount: resolvedImpostorsCount,
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
        .background(.white.opacity(0.95))
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
