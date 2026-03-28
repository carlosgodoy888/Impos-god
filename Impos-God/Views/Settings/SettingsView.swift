//
//  SettingsView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // Binding controlado para guardar cambios de forma limpia en UserDefaults
    private var hintsEnabledBinding: Binding<Bool> {
        Binding(
            get: { appViewModel.impostorHintsEnabled },
            set: { appViewModel.setImpostorHintsEnabled($0) }
        )
    }

    private var hintStyleBinding: Binding<ImpostorHintStyle> {
        Binding(
            get: { appViewModel.impostorHintStyle },
            set: { appViewModel.setImpostorHintStyle($0) }
        )
    }

    private var appearanceBinding: Binding<AppViewModel.AppearanceMode> {
        Binding(
            get: { appViewModel.appearanceMode },
            set: { appViewModel.setAppearanceMode($0) }
        )
    }

    var body: some View {
        ZStack {
            backgroundGradient

            List {
                introSection
                appearanceSection
                hintsSection
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Secciones principales
private extension SettingsView {
    var introSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Personaliza la experiencia")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Text("Aquí puedes ajustar el estilo visual de la app y cómo de fuerte o suave quieres que sean las pistas del impostor.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var appearanceSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Apariencia", icon: "paintpalette.fill")

                Picker("Tema visual", selection: appearanceBinding) {
                    ForEach(AppViewModel.AppearanceMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                modePreviewCard(
                    title: appViewModel.appearanceMode.rawValue,
                    subtitle: appViewModel.appearanceMode.descriptionText,
                    accent: appViewModel.appearanceMode == .darkBlue ? .blue : .cyan
                )

                Text("En el siguiente paso aplicaremos este estilo a Home, Nueva partida y Biblioteca para que todo quede coherente.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }

    var hintsSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Pistas del impostor", icon: "wand.and.stars")

                Toggle("Activar pistas para el impostor", isOn: hintsEnabledBinding)
                    .tint(.blue)

                if appViewModel.impostorHintsEnabled {
                    Picker("Intensidad de pista", selection: hintStyleBinding) {
                        ForEach(ImpostorHintStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)

                    hintExplanationCard(
                        title: appViewModel.impostorHintStyle.rawValue,
                        explanation: hintExplanation(for: appViewModel.impostorHintStyle)
                    )
                } else {
                    hintExplanationCard(
                        title: "Sin pistas activas",
                        explanation: "El impostor no recibirá ninguna ayuda. Es el modo más difícil y también el más desafiante."
                    )
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.white.opacity(0.08))
    }
}

// MARK: - Helpers visuales
private extension SettingsView {
    var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.06, blue: 0.14),
                Color(red: 0.10, green: 0.10, blue: 0.28),
                Color(red: 0.08, green: 0.15, blue: 0.22)
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

    func modePreviewCard(title: String, subtitle: String, accent: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(accent.opacity(0.22))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "circle.lefthalf.filled")
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

    func hintExplanationCard(title: String, explanation: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)

            Text(explanation)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.78))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func hintExplanation(for style: ImpostorHintStyle) -> String {
        switch style {
        case .none:
            return "No se muestra ninguna ayuda. El impostor tendrá que improvisar completamente."
        case .verySoft:
            return "Solo recibe una orientación muy general. Sirve para no ir totalmente perdido, pero sigue siendo difícil."
        case .soft:
            return "Recibe una ayuda breve sobre el tipo de elemento. Aporta equilibrio entre dificultad y diversión."
        case .medium:
            return "Recibe una pista algo más clara. Sigue sin revelar la respuesta, pero ayuda bastante más que el resto."
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppViewModel())
    }
}
