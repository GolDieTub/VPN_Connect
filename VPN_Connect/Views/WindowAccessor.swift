//
//  WindowAccessor.swift
//  VPN_Connect
//
//  Created by  Uladzimir on 20.03.26.
//

import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable {
    let minSize: NSSize

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.minSize = minSize
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            if let window = nsView.window {
                window.minSize = minSize
            }
        }
    }
}
