//
//  StatusCardView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct StatusCardView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let tint: Color
    let isLoading: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.14))
                    .frame(width: 54, height: 54)

                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isLoading {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(.quaternary)
        }
    }
}
