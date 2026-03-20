//
//  VPNConnectApp.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

@main
struct VPNConnectApp: App {
    @StateObject private var viewModel = VPNViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }

        Settings {
            SettingsView()
        }

        MenuBarExtra {
            MenuBarContentView(viewModel: viewModel)
        } label: {
            Label("VPN Connect", systemImage: viewModel.menuBarIconName)
        }
    }
}

struct MenuBarContentView: View {
    @ObservedObject var viewModel: VPNViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.statusTitle)
                    .font(.headline)

                Text(viewModel.statusSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Servers")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                ForEach(viewModel.servers) { server in
                    Button {
                        viewModel.selectServer(server)
                    } label: {
                        HStack {
                            Text(server.name)
                            Spacer()
                            if server == viewModel.selectedServer {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            Button(viewModel.actionTitle) {
                viewModel.toggleConnection()
            }
            .disabled(viewModel.isActionDisabled)

            Button("Open Main Window") {
                NSApp.activate(ignoringOtherApps: true)
                NSApp.windows.first?.makeKeyAndOrderFront(nil)
            }

            Divider()

            SettingsLink {
                Text("Settings")
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(14)
        .frame(width: 280)
    }
}
