//
//  HomeView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.9), .blue.opacity(0.8), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 10) {
                        Text("ImposGod")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Prepara rondas de impostor de forma rápida, privada y divertida.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal)
                    }

                    Spacer()

                    VStack(spacing: 16) {
                        NavigationLink(destination: SetupView()) {
                            HomeButton(title: "Nueva partida", icon: "play.fill")
                        }

                        NavigationLink(destination: ThemeLibraryView()) {
                            HomeButton(title: "Biblioteca de temas", icon: "books.vertical.fill")
                        }

                        NavigationLink(destination: SettingsView()) {
                            HomeButton(title: "Ajustes", icon: "gearshape.fill")
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

private struct HomeButton: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)

            Text(title)
                .font(.headline)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .background(.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
}
