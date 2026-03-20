//
//  VPNStatus.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

enum VPNStatus: Equatable {
    case disconnected
    case disconnecting
    case connecting
    case connected

    var title: String {
        switch self {
        case .disconnected:
            return "Disconnected"
        case .disconnecting:
            return "Disconnecting…"
        case .connecting:
            return "Connecting…"
        case .connected:
            return "Connected"
        }
    }

    func subtitle(serverName: String, previousServerName: String?) -> String {
        switch self {
        case .disconnected:
            return "Your connection is currently not protected"
        case .disconnecting:
            if let previousServerName {
                return "Disconnecting from \(previousServerName)"
            }
            return "Closing secure connection"
        case .connecting:
            return "Establishing secure connection to \(serverName)"
        case .connected:
            return "Protected via \(serverName)"
        }
    }

    var actionTitle: String {
        switch self {
        case .disconnected:
            return "Connect"
        case .disconnecting:
            return "Disconnecting…"
        case .connecting:
            return "Connecting…"
        case .connected:
            return "Disconnect"
        }
    }

    var systemImage: String {
        switch self {
        case .disconnected:
            return "shield.slash"
        case .disconnecting:
            return "bolt.horizontal.circle"
        case .connecting:
            return "lock.rotation"
        case .connected:
            return "checkmark.shield.fill"
        }
    }

    var tint: Color {
        switch self {
        case .disconnected:
            return .secondary
        case .disconnecting:
            return .orange
        case .connecting:
            return .orange
        case .connected:
            return .green
        }
    }

    var isConnected: Bool {
        self == .connected
    }

    var isBusy: Bool {
        self == .connecting || self == .disconnecting
    }
}
