//
//  ContentView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: VPNViewModel
    @State private var showHelp = false

    var body: some View {
        VStack(spacing: 20) {
            WorldMapView(
                servers: viewModel.servers,
                selectedServer: viewModel.selectedServer,
                selectedMarkerColor: viewModel.connectionAccentColor
            )
            .frame(minHeight: 220, idealHeight: 280, maxHeight: 360)
            .frame(maxWidth: .infinity)

            StatusCardView(
                title: viewModel.statusTitle,
                subtitle: viewModel.statusSubtitle,
                systemImage: viewModel.status.systemImage,
                tint: viewModel.status.tint,
                isLoading: viewModel.status.isBusy
            )

            HStack(alignment: .top, spacing: 20) {
                ServerListCardView(
                    title: "Servers",
                    selection: viewModel.selectedServer,
                    servers: viewModel.servers,
                    selectionTint: viewModel.connectionAccentColor,
                    onSelect: { server in
                        viewModel.selectServer(server)
                    }
                )
                .frame(minWidth: 320, maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                VStack(spacing: 16) {
                    ActionButtonView(
                        title: viewModel.actionTitle,
                        systemImage: viewModel.actionButtonIcon,
                        isDisabled: viewModel.isActionDisabled,
                        tintColor: viewModel.actionButtonColor,
                        action: viewModel.toggleConnection
                    )

                    if viewModel.isConnected {
                        VStack(spacing: 4) {
                            Text("Connected for")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TimelineView(.periodic(from: .now, by: 1)) { context in
                                Text(viewModel.connectionDurationText(at: context.date))
                                    .font(.system(.title3, design: .monospaced))
                                    .fontWeight(.semibold)
                            }

                            Text("Original IP address")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)

                            Text(viewModel.originalIPAddress)
                                .font(.system(.callout, design: .monospaced))
                                .fontWeight(.medium)
                        }
                    }

                    Text(viewModel.footerText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 260)

                    Spacer(minLength: 0)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(maxHeight: .infinity, alignment: .top)

            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(minWidth: 760, minHeight: 640, alignment: .top)
        .background(WindowAccessor(minSize: NSSize(width: 760, height: 640)))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                SettingsLink {
                    Label("Settings", systemImage: "gearshape")
                }

                Button {
                    showHelp = true
                } label: {
                    Label("Help", systemImage: "questionmark.circle")
                }
            }
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
    }
}
