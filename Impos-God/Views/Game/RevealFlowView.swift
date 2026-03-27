//
//  RevealFlowView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI
import UIKit

struct RevealFlowView: View {
    @Environment(\.dismiss) private var dismiss

    let session: GameSession

    @State private var currentPlayerIndex: Int = 0
    @State private var isCardVisible: Bool = false

    private var hasFinished: Bool {
        currentPlayerIndex >= session.playersCount
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.16, green: 0.08, blue: 0.30),
                    Color(red: 0.08, green: 0.16, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    if hasFinished {
                        finishedView
                    } else if isCardVisible {
                        revealedCardView
                    } else {
                        passDeviceView
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle("Reparto privado")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(!hasFinished)
    }

    private var passDeviceView: some View {
        VStack(spacing: 24) {
            Text("Jugador \(currentPlayerIndex + 1)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            VStack(spacing: 12) {
                Text("Pasa el móvil a ese jugador.")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)

                Text("Nadie más debe mirar la pantalla.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .multilineTextAlignment(.center)

            roundedPanel {
                VStack(spacing: 14) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(.white)

                    Text("Cuando el jugador esté listo, pulsa el botón para ver su carta.")
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }

            Button {
                isCardVisible = true
            } label: {
                primaryButtonLabel("Ver carta del jugador \(currentPlayerIndex + 1)")
            }
        }
    }

    private var revealedCardView: some View {
        VStack(spacing: 24) {
            Text("Jugador \(currentPlayerIndex + 1)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            if session.isImpostor(playerIndex: currentPlayerIndex) {
                impostorCard
            } else {
                normalCard
            }

            Button {
                goToNextPlayer()
            } label: {
                primaryButtonLabel(
                    currentPlayerIndex == session.playersCount - 1
                    ? "Finalizar reparto"
                    : "Siguiente jugador"
                )
            }
        }
    }

    private var finishedView: some View {
        VStack(spacing: 24) {
            Text("Todo listo")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            roundedPanel {
                VStack(spacing: 16) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(.white)

                    Text("Todos los jugadores ya han visto su carta.")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Ahora empezad a hablar, dad pistas sin decir la palabra exacta y descubrid quién es el impostor.")
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }

            Text("Empieza: Jugador \(session.startingPlayerIndex + 1)")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Button {
                dismiss()
            } label: {
                primaryButtonLabel("Cerrar partida")
            }
        
        }
    }

    private var normalCard: some View {
        roundedPanel {
            VStack(spacing: 18) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.green)

                Text("Tu palabra es")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))

                Text(session.secretWord)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                VStack(spacing: 6) {
                    Text("Tema")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))

                    Text(session.themeName)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }

                Text("Memorízala y pasa el móvil.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
    }

    private var impostorCard: some View {
        ZStack(alignment: .bottom) {
            if UIImage(named: "foto_impostor") != nil {
                Image("foto_impostor")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 440)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                LinearGradient(
                    colors: [.red.opacity(0.9), .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 440)
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.22), .black.opacity(0.82)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 16) {
                if UIImage(named: "logo_impostor") != nil {
                    Image("logo_impostor")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 64)
                }

                Text("ERES EL IMPOSTOR")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("No conoces la palabra exacta. Escucha bien al resto e improvisa.")
                    .foregroundStyle(.white.opacity(0.95))
                    .multilineTextAlignment(.center)

                if let hint = session.impostorHintText {
                    VStack(spacing: 10) {
                        Text("Pista suave")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text(hint)
                            .foregroundStyle(.white.opacity(0.95))
                            .multilineTextAlignment(.center)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(.black.opacity(0.35))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                Text("No enseñes esta pantalla.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.78))
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        )
    }

    private func roundedPanel<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack {
            content()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        )
    }

    private func primaryButtonLabel(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.blue.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func goToNextPlayer() {
        isCardVisible = false
        currentPlayerIndex += 1
    }
}

#Preview {
    NavigationStack {
        RevealFlowView(
            session: GameSession(
                themeName: "Fútbol",
                secretWord: "Mbappé",
                playersCount: 4,
                impostorIndexes: [1],
                impostorHintText: "Tema: Futbolistas top actuales"
            )
        )
    }
}
