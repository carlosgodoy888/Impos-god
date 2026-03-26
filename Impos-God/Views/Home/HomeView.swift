//
//  HomeView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI
import UIKit

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.95), .blue.opacity(0.82), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    if UIImage(named: "HomeLogo") != nil {
                        Image("HomeLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 110)
                            .shadow(radius: 12)
                    } else {
                        Image(systemName: "theatermasks.fill")
                            .font(.system(size: 66))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 10) {
                        Text("ImposGod")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Prepara rondas privadas, rápidas y mucho más divertidas.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal)
                    }

                    Spacer()

                    VStack(spacing: 16) {
                        NavigationLink(destination: SetupView()) {
                            HomeButton(title: "Nueva partida", icon: "play.fill", color: .blue)
                        }

                        NavigationLink(destination: ThemeLibraryView()) {
                            HomeButton(title: "Biblioteca de temas", icon: "books.vertical.fill", color: .purple)
                        }

                        NavigationLink(destination: SettingsView()) {
                            HomeButton(title: "Ajustes", icon: "gearshape.fill", color: .orange)
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
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)

            Text(title)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.bold))
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(
            LinearGradient(
                colors: [color.opacity(0.9), color.opacity(0.55)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: color.opacity(0.25), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    HomeView()
}
