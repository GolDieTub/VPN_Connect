//
//  SettingsView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at login", isOn: .constant(false))
                Toggle("Reconnect automatically", isOn: .constant(true))
            }

            Section("Connection") {
                Toggle("Show connection status in menu bar", isOn: .constant(true))
            }
        }
        .padding(20)
    }
}
