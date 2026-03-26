//
//  SettingsView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel

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

    private var hasHomeLogo: Bool {
        UIImage(named: "logo_baja") != nil
    }

    private var hasImpostorLogo: Bool {
        UIImage(named: "logo_impostor") != nil
    }

    private var hasImpostorPhoto: Bool {
        UIImage(named: "foto_impostor") != nil
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.05, blue: 0.14),
                    Color(red: 0.10, green: 0.09, blue: 0.28),
                    Color(red: 0.07, green: 0.15, blue: 0.20)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ajustes del impostor")
                            .font(.title3.bold())

                        Text("Aquí controlas la pista suave y compruebas que los recursos visuales estén bien cargados desde Assets.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Pista suave") {
                    Toggle("Activar pista para el impostor", isOn: hintsEnabledBinding)

                    if appViewModel.impostorHintsEnabled {
                        Picker("Tipo de pista", selection: hintStyleBinding) {
                            ForEach(ImpostorHintStyle.allCases) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }

                        Text(appViewModel.impostorHintStyle.helperText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Recursos visuales") {
                    statusRow(title: "Logo Home", ok: hasHomeLogo)
                    statusRow(title: "Logo impostor", ok: hasImpostorLogo)
                    statusRow(title: "Foto impostor", ok: hasImpostorPhoto)

                    Text("Nombres esperados: logo_baja, logo_impostor y foto_impostor.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statusRow(title: String, ok: Bool) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(ok ? "OK" : "Falta")
                .foregroundStyle(ok ? .green : .red)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppViewModel())
    }
}
