//
//  WorldMapView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct WorldMapView: View {
    let servers: [VPNServer]
    let selectedServer: VPNServer
    let selectedMarkerColor: Color

    @Environment(\.colorScheme) private var colorScheme

    private let mapImageSize = CGSize(width: 2048, height: 836)
    private let topLatitude: Double = 83
    private let bottomLatitude: Double = -58

    var body: some View {
        GeometryReader { geometry in
            let outerPadding: CGFloat = 20
            let containerRect = CGRect(
                x: outerPadding,
                y: outerPadding,
                width: max(0, geometry.size.width - outerPadding * 2),
                height: max(0, geometry.size.height - outerPadding * 2)
            )

            let mapRect = fittedRect(
                for: mapImageSize,
                in: containerRect
            )

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(backgroundColor)

                Image("world_map_light")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(mapImageSize.width / mapImageSize.height, contentMode: .fit)
                    .foregroundStyle(mapColor)
                    .frame(width: mapRect.width, height: mapRect.height)
                    .position(x: mapRect.midX, y: mapRect.midY)

                ForEach(servers) { server in
                    marker(for: server)
                        .position(position(for: server, in: mapRect))
                }

                Label(selectedServer.name, systemImage: "mappin.circle.fill")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.regularMaterial, in: Capsule())
                    .padding(16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func marker(for server: VPNServer) -> some View {
        let isSelected = server == selectedServer
        let markerColor = isSelected ? selectedMarkerColor : Color.secondary.opacity(0.75)

        return Circle()
            .fill(markerColor)
            .frame(width: isSelected ? 12 : 8, height: isSelected ? 12 : 8)
            .overlay {
                Circle()
                    .stroke(backgroundColor, lineWidth: 2)
            }
            .shadow(
                color: isSelected ? selectedMarkerColor.opacity(0.6) : .clear,
                radius: isSelected ? 8 : 0
            )
    }

    private var mapColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04)
    }

    private func fittedRect(for imageSize: CGSize, in container: CGRect) -> CGRect {
        guard imageSize.width > 0, imageSize.height > 0,
              container.width > 0, container.height > 0 else {
            return .zero
        }

        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = container.width / container.height

        let width: CGFloat
        let height: CGFloat

        if containerAspect > imageAspect {
            height = container.height
            width = height * imageAspect
        } else {
            width = container.width
            height = width / imageAspect
        }

        let x = container.midX - width / 2
        let y = container.midY - height / 2

        return CGRect(x: x, y: y, width: width, height: height)
    }

    private func position(for server: VPNServer, in mapRect: CGRect) -> CGPoint {
        let normalizedX = (server.longitude + 180.0) / 360.0
        let clampedLat = min(max(server.latitude, bottomLatitude), topLatitude)
        let normalizedY = (topLatitude - clampedLat) / (topLatitude - bottomLatitude)

        return CGPoint(
            x: mapRect.minX + mapRect.width * normalizedX,
            y: mapRect.minY + mapRect.height * normalizedY
        )
    }
}
