//
//  VPNViewModel.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class VPNViewModel: ObservableObject {
    @Published var status: VPNStatus = .disconnected
    @Published var selectedServer: VPNServer
    @Published var servers: [VPNServer]
    @Published var previousServer: VPNServer?
    @Published var originalIPAddress: String = "Detecting..."

    private var transitionTask: Task<Void, Never>?
    private var connectedAt: Date?

    init() {
//        let items = [
//            VPNServer(name: "Germany", latitude: 52.5200, longitude: 13.4050),
//            VPNServer(name: "USA", latitude: 40.7128, longitude: -74.0060),
//            VPNServer(name: "Japan", latitude: 35.6762, longitude: 139.6503),
//            VPNServer(name: "Netherlands", latitude: 52.3676, longitude: 4.9041),
//            VPNServer(name: "France", latitude: 48.8566, longitude: 2.3522),
//            VPNServer(name: "United Kingdom", latitude: 51.5074, longitude: -0.1278),
//            VPNServer(name: "Spain", latitude: 40.4168, longitude: -3.7038),
//            VPNServer(name: "Italy", latitude: 41.9028, longitude: 12.4964),
//            VPNServer(name: "Poland", latitude: 52.2297, longitude: 21.0122),
//            VPNServer(name: "Sweden", latitude: 59.3293, longitude: 18.0686),
//            VPNServer(name: "Norway", latitude: 59.9139, longitude: 10.7522),
//            VPNServer(name: "Finland", latitude: 60.1699, longitude: 24.9384),
//            VPNServer(name: "Switzerland", latitude: 46.9480, longitude: 7.4474),
//            VPNServer(name: "Ukraine", latitude: 50.4501, longitude: 30.5234),
//            VPNServer(name: "Turkey", latitude: 41.0082, longitude: 28.9784),
//            VPNServer(name: "Canada", latitude: 43.6532, longitude: -79.3832),
//            VPNServer(name: "Mexico", latitude: 19.4326, longitude: -99.1332),
//            VPNServer(name: "Brazil", latitude: -23.5505, longitude: -46.6333),
//            VPNServer(name: "Argentina", latitude: -34.6037, longitude: -58.3816),
//            VPNServer(name: "South Korea", latitude: 37.5665, longitude: 126.9780),
//            VPNServer(name: "Singapore", latitude: 1.3521, longitude: 103.8198),
//            VPNServer(name: "India", latitude: 28.6139, longitude: 77.2090),
//            VPNServer(name: "UAE", latitude: 25.2048, longitude: 55.2708),
//            VPNServer(name: "Australia", latitude: -33.8688, longitude: 151.2093),
//            VPNServer(name: "South Africa", latitude: -26.2041, longitude: 28.0473)
//        ]
        
        let items = [
            VPNServer(name: "Germany", latitude: 52.5200, longitude: 13.4050),
            VPNServer(name: "USA", latitude: 40.7128, longitude: -74.0060),
            VPNServer(name: "Japan", latitude: 35.6762, longitude: 139.6503),
            VPNServer(name: "Netherlands", latitude: 52.3676, longitude: 4.9041)
        ]

        self.servers = items
        self.selectedServer = items[0]
        self.originalIPAddress = Self.detectIPAddress() ?? "Unavailable"
    }

    var statusTitle: String {
        status.title
    }

    var statusSubtitle: String {
        status.subtitle(
            serverName: selectedServer.name,
            previousServerName: previousServer?.name
        )
    }

    var actionTitle: String {
        status.actionTitle
    }

    var actionButtonIcon: String {
        status.isConnected ? "power" : "bolt.fill"
    }

    var isActionDisabled: Bool {
        status.isBusy
    }
    
    var connectionAccentColor: Color {
        switch status {
        case .disconnected:
            return .accentColor
        case .disconnecting, .connecting:
            return .orange
        case .connected:
            return .green
        }
    }
    
    var actionButtonColor: Color {
        switch status {
        case .connected:
            return .red
        case .connecting, .disconnecting:
            return .orange
        case .disconnected:
            return .accentColor
        }
    }

    var menuBarIconName: String {
        switch status {
        case .disconnected:
            return "shield"
        case .disconnecting:
            return "bolt.horizontal.circle"
        case .connecting:
            return "lock.rotation"
        case .connected:
            return "checkmark.shield"
        }
    }

    var footerText: String {
        switch status {
        case .disconnected:
            return "Select a server and start a secure connection"
        case .disconnecting:
            return "Disconnecting from the previous server before switching"
        case .connecting:
            return "Please wait while the secure tunnel is being established"
        case .connected:
            return "Your traffic is routed securely through \(selectedServer.name)"
        }
    }

    var isConnected: Bool {
        status.isConnected
    }

    var activeConnectionDuration: TimeInterval {
        guard let connectedAt else { return 0 }
        return max(0, Date().timeIntervalSince(connectedAt))
    }

    func connectionDurationText(at date: Date = Date()) -> String {
        guard let connectedAt else { return "00:00" }

        let totalSeconds = max(0, Int(date.timeIntervalSince(connectedAt)))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    func toggleConnection() {
        switch status {
        case .disconnected:
            connect()
        case .disconnecting, .connecting:
            break
        case .connected:
            disconnect()
        }
    }

    func connect() {
        guard !status.isBusy else { return }

        transitionTask?.cancel()
        stopTimer()
        previousServer = nil
        status = .connecting

        transitionTask = Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { return }
            status = .connected
            startTimer()
        }
    }

    func disconnect() {
        transitionTask?.cancel()
        stopTimer()
        previousServer = status.isConnected ? selectedServer : nil
        status = .disconnected
        previousServer = nil
    }

    func selectServer(_ server: VPNServer) {
        guard server != selectedServer else { return }
        guard !status.isBusy else { return }

        switch status {
        case .disconnected:
            selectedServer = server
        case .connected:
            reconnect(to: server)
        case .disconnecting, .connecting:
            break
        }
    }

    private func reconnect(to newServer: VPNServer) {
        transitionTask?.cancel()
        stopTimer()

        let oldServer = selectedServer
        previousServer = oldServer
        status = .disconnecting

        transitionTask = Task {
            try? await Task.sleep(nanoseconds: 700_000_000)
            guard !Task.isCancelled else { return }

            selectedServer = newServer
            status = .connecting

            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { return }

            previousServer = nil
            status = .connected
            startTimer()
        }
    }

    private func startTimer() {
        connectedAt = Date()
    }

    private func stopTimer() {
        connectedAt = nil
    }

    private static func detectIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return nil
        }

        defer {
            freeifaddrs(ifaddr)
        }

        let preferredInterfaces = ["en0", "en1", "en2", "bridge0", "pdp_ip0"]

        for interfaceName in preferredInterfaces {
            var pointer = firstAddr

            while true {
                let interface = pointer.pointee
                let addrFamily = interface.ifa_addr.pointee.sa_family

                if addrFamily == UInt8(AF_INET) {
                    let name = String(cString: interface.ifa_name)

                    if name == interfaceName {
                        var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(
                            interface.ifa_addr,
                            socklen_t(interface.ifa_addr.pointee.sa_len),
                            &host,
                            socklen_t(host.count),
                            nil,
                            0,
                            NI_NUMERICHOST
                        )

                        let value = String(cString: host)
                        if value != "127.0.0.1" {
                            address = value
                            return address
                        }
                    }
                }

                guard let next = interface.ifa_next else { break }
                pointer = next
            }
        }

        var pointer = firstAddr

        while true {
            let interface = pointer.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family

            if addrFamily == UInt8(AF_INET) {
                var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(
                    interface.ifa_addr,
                    socklen_t(interface.ifa_addr.pointee.sa_len),
                    &host,
                    socklen_t(host.count),
                    nil,
                    0,
                    NI_NUMERICHOST
                )

                let value = String(cString: host)
                if value != "127.0.0.1" {
                    address = value
                    return address
                }
            }

            guard let next = interface.ifa_next else { break }
            pointer = next
        }

        return nil
    }
}
