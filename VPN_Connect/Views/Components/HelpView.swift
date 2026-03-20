//
//  HelpView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Help")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Choose a server in the list, then press Connect to simulate a VPN connection. If you switch to another server while connected, the app disconnects from the current location and reconnects to the new one automatically.")
                .foregroundStyle(.secondary)

            Spacer()

            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: 420, height: 240)
    }
}
