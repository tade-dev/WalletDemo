//
//  ContentView.swift
//  WalletDemo
//
//  Created by BSTAR on 23/05/2026.
//

import SwiftUI
import PassKit

struct ContentView: View {

    @State private var showAddPassSheet = false
    @State private var loadedPass: PKPass?
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Dark background to match the Linear/Vercel aesthetic you like
            Color(red: 0.06, green: 0.06, blue: 0.07)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Header
                VStack(spacing: 8) {
                    Text("Tade Dev Pass")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Your developer pass for Apple Wallet")
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                // Wallet icon
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 80, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Spacer()

                // Add to Wallet button
                Button {
                    addToWallet()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add to Apple Wallet")
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(AddWalletButtonStyle())
                .padding(.horizontal, 24)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red.opacity(0.9))
                        .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .sheet(isPresented: $showAddPassSheet) {
            if let loadedPass {
                AddPassView(pass: loadedPass) {
                    showAddPassSheet = false
                }
                .ignoresSafeArea()
            }
        }
    }

    private func addToWallet() {
        errorMessage = nil

        // Find the pass file in the app bundle
        guard let url = Bundle.main.url(forResource: "TadeDevPass", withExtension: "pkpass") else {
            errorMessage = "Couldn't find TadeDevPass.pkpass in the app bundle."
            return
        }

        // Load and parse it
        do {
            let data = try Data(contentsOf: url)
            let pass = try PKPass(data: data)
            loadedPass = pass
            showAddPassSheet = true
        } catch {
            errorMessage = "Couldn't load pass: \(error.localizedDescription)"
        }
    }
}

struct AddWalletButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

#Preview {
    ContentView()
}
