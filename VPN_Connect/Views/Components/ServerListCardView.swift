//
//  ServerListCardView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct ServerListCardView: View {
    let title: String
    let selection: VPNServer
    let servers: [VPNServer]
    let selectionTint: Color
    let onSelect: (VPNServer) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(servers) { server in
                        serverRow(for: server)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(.quaternary)
        )
    }

    @ViewBuilder
    private func serverRow(for server: VPNServer) -> some View {
        let isSelected = server == selection
        let rowBackgroundColor = isSelected
            ? selectionTint.opacity(0.12)
            : Color.primary.opacity(0.04)

        Button {
            onSelect(server)
        } label: {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(server.name)
                        .font(.body)
                        .foregroundStyle(.primary)

                    Text(server.coordinatesText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(selectionTint)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(rowBackgroundColor)
            )
        }
        .buttonStyle(.plain)
    }
}

private extension VPNServer {
    var coordinatesText: String {
        let latText = latitude.formatted(.number.precision(.fractionLength(1)))
        let lonText = longitude.formatted(.number.precision(.fractionLength(1)))
        return "\(latText), \(lonText)"
    }
}
