//
//  AppTheme.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 28/3/26.
//

import SwiftUI

/// Modelo visual centralizado para toda la app.
/// Aquí definimos TODOS los colores y estilos base
/// según el modo elegido en Ajustes.
///
/// Ventaja:
/// - no repetimos colores por pantalla
/// - cambiar la identidad visual luego es mucho más fácil
/// - las vistas futuras quedan mucho más limpias
struct AppTheme {
    // MARK: - Fondo principal de pantalla
    let backgroundGradient: LinearGradient

    // MARK: - Colores de texto
    let primaryText: Color
    let secondaryText: Color
    let tertiaryText: Color

    // MARK: - Fondos de bloques / tarjetas
    let sectionBackground: Color
    let cardBackground: Color
    let cardBorder: Color

    // MARK: - Inputs / formularios
    let fieldBackground: Color
    let fieldBorder: Color
    let fieldText: Color
    let placeholderText: Color

    // MARK: - Colores de acento
    let primaryAccent: Color
    let secondaryAccent: Color
    let dangerAccent: Color
    let successAccent: Color

    // MARK: - Chips / badges
    let chipBackground: Color
    let chipText: Color

    // MARK: - Sombras suaves
    let shadowColor: Color

    /// Fábrica principal.
    /// Genera el tema visual completo en función del modo
    /// seleccionado por el usuario en Ajustes.
    static func make(for mode: AppViewModel.AppearanceMode) -> AppTheme {
        switch mode {
        case .darkBlue:
            return AppTheme(
                backgroundGradient: LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.06, blue: 0.14),
                        Color(red: 0.10, green: 0.09, blue: 0.28),
                        Color(red: 0.07, green: 0.15, blue: 0.22)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),

                primaryText: .white,
                secondaryText: Color.white.opacity(0.82),
                tertiaryText: Color.white.opacity(0.68),

                sectionBackground: Color.white.opacity(0.08),
                cardBackground: Color.white.opacity(0.10),
                cardBorder: Color.white.opacity(0.12),

                fieldBackground: Color.white.opacity(0.12),
                fieldBorder: Color.white.opacity(0.10),
                fieldText: .white,
                placeholderText: Color.white.opacity(0.55),

                primaryAccent: .blue,
                secondaryAccent: .purple,
                dangerAccent: .red,
                successAccent: .green,

                chipBackground: Color.white.opacity(0.14),
                chipText: .white,

                shadowColor: Color.black.opacity(0.22)
            )

        case .lightBlue:
            return AppTheme(
                backgroundGradient: LinearGradient(
                    colors: [
                        Color(red: 0.82, green: 0.92, blue: 1.00),
                        Color(red: 0.73, green: 0.87, blue: 0.98),
                        Color(red: 0.67, green: 0.82, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),

                primaryText: Color(red: 0.10, green: 0.16, blue: 0.24),
                secondaryText: Color(red: 0.18, green: 0.24, blue: 0.34),
                tertiaryText: Color(red: 0.28, green: 0.35, blue: 0.45),

                sectionBackground: Color.white.opacity(0.42),
                cardBackground: Color.white.opacity(0.60),
                cardBorder: Color.white.opacity(0.35),

                fieldBackground: Color.white.opacity(0.78),
                fieldBorder: Color.white.opacity(0.42),
                fieldText: Color(red: 0.10, green: 0.16, blue: 0.24),
                placeholderText: Color(red: 0.26, green: 0.34, blue: 0.44),

                primaryAccent: Color(red: 0.11, green: 0.38, blue: 0.82),
                secondaryAccent: Color(red: 0.32, green: 0.40, blue: 0.86),
                dangerAccent: Color(red: 0.82, green: 0.22, blue: 0.26),
                successAccent: Color(red: 0.15, green: 0.62, blue: 0.36),

                chipBackground: Color.white.opacity(0.70),
                chipText: Color(red: 0.10, green: 0.16, blue: 0.24),

                shadowColor: Color.black.opacity(0.10)
            )
        }
    }
}

// MARK: - Helpers reutilizables de estilo
extension AppTheme {
    /// Fondo estándar para bloques tipo tarjeta.
    /// Lo usaremos mucho en Home, Setup, Biblioteca y Ajustes.
    func standardCard() -> some ShapeStyle {
        cardBackground
    }

    /// Fondo estándar de inputs.
    func standardField() -> some ShapeStyle {
        fieldBackground
    }
}

// MARK: - Modificadores reutilizables
extension View {
    /// Aplica el fondo global del tema a una pantalla completa.
    func appScreenBackground(_ theme: AppTheme) -> some View {
        self.background(theme.backgroundGradient.ignoresSafeArea())
    }

    /// Estilo estándar para un bloque tipo tarjeta.
    func appCardStyle(_ theme: AppTheme) -> some View {
        self
            .padding(14)
            .background(theme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(theme.cardBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 4)
    }

    /// Estilo estándar para un input o caja editable.
    func appFieldStyle(_ theme: AppTheme) -> some View {
        self
            .foregroundStyle(theme.fieldText)
            .padding(12)
            .background(theme.fieldBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(theme.fieldBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
