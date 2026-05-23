//
//  AddPassView.swift
//  WalletDemo
//
//  Created by BSTAR on 23/05/2026.
//

import SwiftUI
import PassKit


struct AddPassView: UIViewControllerRepresentable {

    let pass: PKPass
    let onDismiss: () -> Void

    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        let vc = PKAddPassesViewController(pass: pass) ?? PKAddPassesViewController()
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {
        // No updates needed — this view controller is fire-and-forget.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }

    class Coordinator: NSObject, PKAddPassesViewControllerDelegate {
        let onDismiss: () -> Void

        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }

        func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
            onDismiss()
        }
    }
}
