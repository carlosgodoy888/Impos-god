//
//  HomeView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    private var theme: AppTheme {
        AppTheme.make(for: appViewModel.appearanceMode)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                theme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer(minLength: 20)

                    logoSection

                    titleSection

                    Spacer(minLength: 10)

                    actionsSection

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
    }
}

// MARK: - Bloques principales
private extension HomeView {
    var logoSection: some View {
        Group {
            if UIImage(named: "logo_baja") != nil {
                Image("logo_baja")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .shadow(color: theme.shadowColor, radius: 14, x: 0, y: 8)
            } else {
                Image(systemName: "theatermasks.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(theme.primaryText)
                    .padding(22)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(theme.cardBorder, lineWidth: 1)
                    )
            }
        }
    }

    var titleSection: some View {
        VStack(spacing: 10) {
            Text("ImposGod")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(theme.primaryText)

            Text("Prepara rondas privadas, rápidas y mucho más divertidas.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(theme.secondaryText)
                .padding(.horizontal, 8)
        }
    }

    var actionsSection: some View {
        VStack(spacing: 16) {
            NavigationLink(destination: SetupView()) {
                HomeActionButton(
                    title: "Nueva partida",
                    subtitle: "Configura la ronda y prepara el reparto",
                    icon: "play.fill",
                    accent: theme.primaryAccent,
                    theme: theme
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: ThemeLibraryView()) {
                HomeActionButton(
                    title: "Biblioteca de temas",
                    subtitle: "Consulta y crea temas para jugar",
                    icon: "books.vertical.fill",
                    accent: theme.secondaryAccent,
                    theme: theme
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: SettingsView()) {
                HomeActionButton(
                    title: "Ajustes",
                    subtitle: "Pistas, apariencia y configuración general",
                    icon: "gearshape.fill",
                    accent: .orange,
                    theme: theme
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Botón principal del Home
private struct HomeActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let accent: Color
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.18))
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(theme.primaryText)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryText)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.bold))
                .foregroundStyle(theme.tertiaryText)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(theme.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(theme.cardBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppViewModel())
}
