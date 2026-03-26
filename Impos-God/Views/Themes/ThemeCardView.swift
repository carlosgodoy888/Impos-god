//
//  ThemeCardView.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import SwiftUI

struct ThemeCardView: View {
    let theme: Theme
    var isSelected: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    content
                }
                .buttonStyle(.plain)
            } else {
                content
            }
        }
    }

    private var content: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(theme.category.tint.opacity(0.18))
                    .frame(width: 42, height: 42)

                Image(systemName: theme.category.systemImage)
                    .foregroundStyle(theme.category.tint)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(theme.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(previewWords)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(theme.category.tint)
                    .font(.title3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    theme.category.gradientStart.opacity(0.22),
                    theme.category.gradientEnd.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? theme.category.tint : .clear, lineWidth: 2)
        )
    }

    private var previewWords: String {
        let firstWords = Array(theme.words.prefix(3)).joined(separator: ", ")
        return theme.words.count > 3 ? "\(firstWords)..." : firstWords
    }
}

extension ThemeCategory {
    var systemImage: String {
        switch self {
        case .actualidad:
            return "bolt.fill"
        case .series:
            return "sparkles.tv.fill"
        case .general:
            return "globe.europe.africa.fill"
        case .custom:
            return "slider.horizontal.3"
        }
    }

    var tint: Color {
        switch self {
        case .actualidad:
            return .orange
        case .series:
            return .purple
        case .general:
            return .blue
        case .custom:
            return .green
        }
    }

    var gradientStart: Color {
        switch self {
        case .actualidad:
            return .orange
        case .series:
            return .purple
        case .general:
            return .blue
        case .custom:
            return .green
        }
    }

    var gradientEnd: Color {
        switch self {
        case .actualidad:
            return .red
        case .series:
            return .pink
        case .general:
            return .cyan
        case .custom:
            return .mint
        }
    }
}
