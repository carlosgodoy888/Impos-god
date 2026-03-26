//
//  SettingsView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("Visual")) {
                Label("Aquí añadiremos la foto opcional del impostor", systemImage: "photo")
                Label("Aquí añadiremos preferencias estéticas", systemImage: "paintpalette")
            }

            Section(header: Text("Estado actual")) {
                Text("Base de navegación y estructura inicial completada.")
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
    }
}
