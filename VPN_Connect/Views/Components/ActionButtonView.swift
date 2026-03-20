//
//  ActionButtonView.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI

struct ActionButtonView: View {
    let title: String
    let systemImage: String
    let isDisabled: Bool
    let tintColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(tintColor)
        .disabled(isDisabled)
    }
}
