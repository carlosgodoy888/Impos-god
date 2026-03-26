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
        UIImage(named: "HomeLogo") != nil
    }

    private var hasImpostorBackground: Bool {
        UIImage(named: "ImpostorCardBackground") != nil
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ajustes del impostor")
                        .font(.title3.bold())

                    Text("La imagen del logo y el fondo del impostor ahora se gestionan directamente desde Assets.xcassets.")
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

            Section("Recursos visuales fijos") {
                HStack {
                    Text("Logo del Home")
                    Spacer()
                    Text(hasHomeLogo ? "OK" : "Falta")
                        .foregroundStyle(hasHomeLogo ? .green : .red)
                }

                HStack {
                    Text("Fondo impostor")
                    Spacer()
                    Text(hasImpostorBackground ? "OK" : "Falta")
                        .foregroundStyle(hasImpostorBackground ? .green : .red)
                }

                Text("Nombres esperados en Assets: HomeLogo e ImpostorCardBackground.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppViewModel())
    }
}
