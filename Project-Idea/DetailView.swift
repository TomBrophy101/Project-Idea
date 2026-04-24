//
//  DetailView.swift
//  Project-Idea
//
//  Created by Tom Brophy on 21/04/2026.
//  This is the screen for the list of saved accounts.

import SwiftUI
import LocalAuthentication

struct DetailView: View {
    let item: Item

    @State private var decryptedData: String?
    @State private var isUnlocked = false
    @State private var showingError = false

    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(isUnlocked ? .green : .red)
                .padding(.top, 40)

            Text(item.title)
                .font(.largeTitle)
                .bold()

            if isUnlocked {
                VStack(alignment: .leading, spacing: 15) {
                    if let data = decryptedData {
                        Text(data)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(12)
                            .textSelection(.enabled)

                        Button(action: {
                            if let dataToCopy = decryptedData, !dataToCopy.isEmpty {

                                UIPasteboard.general.string = ""

                                UIPasteboard.general.string = dataToCopy

                                let generator = UINotificationFeedbackGenerator()
                                generator.prepare()
                                generator.notificationOccurred(.success)

                                print("Successfully copied: \(dataToCopy)")
                            } else {
                                print("Copy failed: decryptedData is empty or nil")
                            }
                        }) {
                            Label("Copy to Clipboard", systemImage: "doc.on.doc.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }
                }
                .padding()
            } else {
                Text("This information is encrypted")
                    .foregroundColor(.gray)

                Button(action: authenticate) {
                    Label("Reveal Sensitive Data", systemImage: "faceid")
                        .padding()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Account Details")
        .navigationBarTitleDisplayMode(.inline)
        //.onAppear {
        //    if !isUnlocked {
        //        authenticate()
        //    }
        //}
    }

    func authenticate() {
        BiometricManager.authenticateUser { success in
            DispatchQueue.main.async {
                if success {
                    decrypt()
                } else {
                    self.showingError = true
                }
            }
        }
    }

    func decrypt() {
        let key = KeychainManager.getOrCreateMasterKey()

        if let decrypted = EncryptionManager.decrypt(item.secureData, key: key) {
            DispatchQueue.main.async {
                self.decryptedData = decrypted
                self.isUnlocked = true
            }
        }
    }
}
