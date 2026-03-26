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

    var allowedImpostors: [Int] {
        playersCount <= 4 ? [1] : [1, 2]
    }

    var body: some View {
        Form {
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

            Section {
                Button("Continuar") {
                    print("Siguiente bloque: preparación de partida")
                }
            }
        }
        .navigationTitle("Nueva partida")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SetupView()
            .environmentObject(AppViewModel())
    }
}
