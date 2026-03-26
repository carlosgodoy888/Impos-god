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
    @EnvironmentObject var appViewModel: AppViewModel

    let session: GameSession

    @State private var currentPlayerIndex: Int = 0
    @State private var isCardVisible: Bool = false

    private var hasFinished: Bool {
        currentPlayerIndex >= session.playersCount
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .purple.opacity(0.85), .blue.opacity(0.75)],
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

                    Text("Ahora empezad a hablar del tema sin decir la palabra exacta y descubrid quién es el impostor.")
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 12) {
                Text("Tema elegido: \(session.themeName)")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.95))

                Text("La palabra no se muestra aquí para no estropear la ronda.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
            }

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
        roundedPanel {
            VStack(spacing: 18) {
                if let data = appViewModel.impostorImageData,
                   let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 52))
                        .foregroundStyle(.red)
                }

                Text("Eres el impostor")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("No recibirás palabra. Escucha al resto, improvisa y trata de no ser descubierto.")
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)

                Text("No enseñes esta pantalla.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
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
                impostorIndexes: [1]
            )
        )
        .environmentObject(AppViewModel())
    }
}
