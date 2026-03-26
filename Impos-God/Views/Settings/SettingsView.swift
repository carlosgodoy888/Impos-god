//
//  SettingsView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//
import SwiftUI
import PhotosUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isLoadingPhoto = false

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

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personalización del impostor")
                        .font(.title3.bold())

                    Text("Aquí decides cómo se verá la carta del impostor y qué ayuda suave recibirá al comenzar la ronda.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Pista suave")) {
                Toggle("Activar ayuda para el impostor", isOn: hintsEnabledBinding)

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

            Section(header: Text("Carta personalizada del impostor")) {
                if let data = appViewModel.impostorImageData,
                   let uiImage = UIImage(data: data) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vista previa")
                            .font(.headline)

                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.vertical, 4)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No hay foto seleccionada")
                            .font(.headline)

                        Text("Cuando el impostor vea su carta, aparecerá esta imagen arriba de su mensaje.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Label("Elegir foto desde la galería", systemImage: "photo.on.rectangle")
                }

                if isLoadingPhoto {
                    ProgressView("Cargando imagen...")
                }

                if appViewModel.impostorImageData != nil {
                    Button(role: .destructive) {
                        appViewModel.clearImpostorImage()
                    } label: {
                        Label("Eliminar foto actual", systemImage: "trash")
                    }
                }
            }

            Section(header: Text("Resumen actual")) {
                HStack {
                    Text("Pista impostor")
                    Spacer()
                    Text(appViewModel.impostorHintsEnabled ? "Activada" : "Desactivada")
                        .foregroundStyle(.secondary)
                }

                if appViewModel.impostorHintsEnabled {
                    HStack {
                        Text("Modo de pista")
                        Spacer()
                        Text(appViewModel.impostorHintStyle.rawValue)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack {
                    Text("Foto personalizada")
                    Spacer()
                    Text(appViewModel.impostorImageData != nil ? "Cargada" : "No")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }

            isLoadingPhoto = true

            Task {
                do {
                    if let data = try await newItem.loadTransferable(type: Data.self) {
                        await MainActor.run {
                            appViewModel.saveImpostorImage(data: data)
                        }
                    }
                } catch {
                    print("Error cargando imagen: \(error)")
                }

                await MainActor.run {
                    isLoadingPhoto = false
                    selectedPhotoItem = nil
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppViewModel())
    }
}
