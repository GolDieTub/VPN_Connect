//
//  VPNServer.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import Foundation

struct VPNServer: Identifiable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    static func == (lhs: VPNServer, rhs: VPNServer) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
