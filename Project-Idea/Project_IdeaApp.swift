//
//  Project_IdeaApp.swift
//  Project-Idea
//
//  Created by Tom Brophy on 10/03/2026.
//

import SwiftUI
import SwiftData

@main
struct Project_IdeaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var isUnlocked = false
    @State private var showPasswordFallback = false

    var body: some Scene {
        WindowGroup {
            if isUnlocked {
                ContentView()
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 60))
                    Text("Program Locked")

                    Button("Unlock with Face ID") {
                        tryToUnlock()
                    }
                    .buttonStyle(.borderedProminent)

                    if showPasswordFallback {
                        Button("Enter Master Password") {
                            isUnlocked = true
                        }
                        .padding(.top)
                    }
                }
                .onAppear {
                    tryToUnlock()
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func tryToUnlock() {
        BiometricManager.authenticateUser { success in
            DispatchQueue.main.async {
                if success {
                    isUnlocked = true
                } else {
                    showPasswordFallback = true
                }
            }
        }
    }
}
