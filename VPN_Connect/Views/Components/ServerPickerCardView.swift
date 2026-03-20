//
//  ServerPickerCardView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct ServerPickerCardView: View {
    let title: String
    @Binding var selection: VPNServer
    let servers: [VPNServer]
    let isEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            Picker("Server", selection: $selection) {
                ForEach(servers) { server in
                    Text(server.name).tag(server)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .disabled(!isEnabled)

            Text("Choose the VPN endpoint for your secure connection")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(.quaternary)
        }
    }
}
