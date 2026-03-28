//
//  SetupView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // MARK: - Modos de selección de tema
    enum ThemeSelectionMode: String, CaseIterable, Identifiable {
        case single = "Manual"
        case selectedRandom = "Aleatorio entre seleccionados"
        case allRandom = "Aleatorio entre todos"

        var id: String { rawValue }

        var descriptionText: String {
            switch self {
            case .single:
                return "Eliges un único tema concreto para la partida."
            case .selectedRandom:
                return "Marcas varios temas y la app escoge uno al azar entre ellos."
            case .allRandom:
                return "La app puede escoger aleatoriamente entre todos los temas disponibles."
            }
        }
    }

    // MARK: - Estado principal
    @State private var themeMode: ThemeSelectionMode = .single
    @State private var selectedSingleThemeID: UUID?
    @State private var selectedThemeIDs: Set<UUID> = []

    @State private var playersCount: Int = 4
    @State private var impostorsCount: Int = 1

    @State private var generatedSession: GameSession?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private let maxPlayers: Int = 24

    // MARK: - Computadas
    private var selectedSingleTheme: Theme? {
        appViewModel.allThemes.first { $0.id == selectedSingleThemeID }
    }

    private var selectedThemesForRandom: [Theme] {
        appViewModel.allThemes.filter { selectedThemeIDs.contains($0.id) }
    }

    private var allowedImpostors: [Int] {
        playersCount > 5 ? [1, 2] : [1]
    }

    /// Esta lista es la que realmente se envía al GameFactory.
    /// Así no rompemos la lógica ya existente.
    private var themesForMatch: [Theme] {
        switch themeMode {
        case .single:
            if let selectedSingleTheme {
                return [selectedSingleTheme]
            }
            return []

        case .selectedRandom:
            return selectedThemesForRandom

        case .allRandom:
            return appViewModel.allThemes
        }
    }

    var body: some View {
        ZStack {
            backgroundGradient

            Form {
                introSection
                themeModeSection
                playersSection
                impostorsSection
                hintsSection
                summarySection
                startButtonSection
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
}

// MARK: - Secciones
private extension SetupView {
    var introSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Configura la ronda")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text("Elige cómo quieres gestionar el tema, define jugadores e impostores y prepara el reparto.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var themeModeSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Temas", icon: "sparkles")

                Picker("Modo de tema", selection: $themeMode) {
                    ForEach(ThemeSelectionMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                Text(themeMode.descriptionText)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))

                switch themeMode {
                case .single:
                    NavigationLink(destination: ThemePickerView(selectedThemeID: $selectedSingleThemeID)) {
                        selectionCard(
                            title: "Elegir tema manual",
                            subtitle: selectedSingleTheme?.name ?? "Toca aquí para seleccionar un único tema",
                            accent: .blue
                        )
                    }

                case .selectedRandom:
                    NavigationLink(destination: ThemeMultiPickerView(selectedThemeIDs: $selectedThemeIDs)) {
                        selectionCard(
                            title: "Elegir temas para aleatorio",
                            subtitle: selectedThemeIDs.isEmpty
                                ? "Toca aquí para seleccionar varios temas"
                                : "\(selectedThemeIDs.count) tema(s) seleccionados",
                            accent: .purple
                        )
                    }

                case .allRandom:
                    infoCard(
                        title: "Modo aleatorio total",
                        subtitle: "La app podrá escoger cualquier tema disponible de toda tu biblioteca.",
                        accent: .green
                    )
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var playersSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle("Jugadores", icon: "person.3.fill")

                Stepper("Número de jugadores: \(playersCount)", value: $playersCount, in: 1...maxPlayers)

                Text("Puedes jugar hasta \(maxPlayers) jugadores.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var impostorsSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle("Impostores", icon: "person.fill.questionmark")

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
                            .foregroundStyle(.white)
                        Spacer()
                        Text("1")
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }

                Text(playersCount > 5
                     ? "Con más de 5 jugadores puedes elegir 1 o 2 impostores."
                     : "Con 5 o menos jugadores la partida usa 1 impostor.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var hintsSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle("Pistas del impostor", icon: "wand.and.stars")

                NavigationLink(destination: SettingsView()) {
                    selectionCard(
                        title: "Configurar pistas",
                        subtitle: appViewModel.impostorHintsEnabled
                            ? "Modo actual: \(appViewModel.impostorHintStyle.rawValue)"
                            : "Actualmente desactivadas",
                        accent: .orange
                    )
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var summarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle("Resumen", icon: "checkmark.seal.fill")

                summaryRow("Modo de tema", themeMode.rawValue)
                summaryRow("Jugadores", "\(playersCount)")
                summaryRow("Impostores", "\(impostorsCount)")

                switch themeMode {
                case .single:
                    summaryRow("Tema", selectedSingleTheme?.name ?? "Sin seleccionar")

                case .selectedRandom:
                    summaryRow("Temas marcados", "\(selectedThemeIDs.count)")

                case .allRandom:
                    summaryRow("Base aleatoria", "Todos los temas")
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var startButtonSection: some View {
        Section {
            Button {
                startGame()
            } label: {
                Text("Preparar reparto")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
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
}

// MARK: - Helpers visuales
private extension SetupView {
    var backgroundGradient: some View {
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
    }

    func sectionTitle(_ text: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.white)

            Text(text)
                .font(.title3.bold())
                .foregroundStyle(.white)
        }
    }

    func selectionCard(title: String, subtitle: String, accent: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(accent.opacity(0.22))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(accent)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func infoCard(title: String, subtitle: String, accent: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(accent.opacity(0.22))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "dice.fill")
                        .foregroundStyle(accent)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.82))

            Spacer()

            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Lógica
private extension SetupView {
    func startGame() {
        switch themeMode {
        case .single:
            guard selectedSingleTheme != nil else {
                alertMessage = "Selecciona un tema manual para continuar."
                showAlert = true
                return
            }

        case .selectedRandom:
            guard !selectedThemeIDs.isEmpty else {
                alertMessage = "Selecciona al menos un tema para el modo aleatorio entre seleccionados."
                showAlert = true
                return
            }

        case .allRandom:
            guard !appViewModel.allThemes.isEmpty else {
                alertMessage = "No hay temas disponibles para el modo aleatorio."
                showAlert = true
                return
            }
        }

        guard let session = GameFactory.makeSession(
            playersCount: playersCount,
            impostorsCount: impostorsCount,
            selectedThemes: themesForMatch,
            hintEnabled: appViewModel.impostorHintsEnabled,
            hintStyle: appViewModel.impostorHintStyle
        ) else {
            alertMessage = "No se ha podido crear la partida. Revisa la configuración e inténtalo otra vez."
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
