//
//  Project_IdeaApp.swift
//  Project-Idea
//
//  Created by Tom Brophy on 10/03/2026.
//  This is the lock screen of the program.

import SwiftUI
import SwiftData

@main
struct Project_IdeaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    

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

    @State private var hasFinishedSplash = false
    @State private var isUnlocked = false
    @State private var showPasswordFallback = false

    var body: some Scene {
        WindowGroup {

            let isUITesting = ProcessInfo.processInfo.arguments.contains("-uitesting")
            Group {
                if !hasFinishedSplash && !isUITesting {
                    SplashView(isFinished: $hasFinishedSplash)
                } else  if !isUnlocked && !isUITesting {
                    VStack(spacing: 20) {
                        Image(systemName: "lock.shield")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text("Program Locked")
                            .font(.headline)

                        Button("Unlock with Face ID") {
                            tryToUnlock()
                        }
                        .buttonStyle(.borderedProminent)

                        if showPasswordFallback {
                            Button("Enter Master Password") {
                                withAnimation { isUnlocked = true }
                            }
                            .padding(.top)
                        }
                    }
                    // .onAppear {
                    //    if !isUnlocked {
                    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    //            tryToUnlock()
                    //        }
                    //    }
                    //}
                } else {
                    ContentView(onLock: {
                        if !isUITesting { withAnimation { isUnlocked = false } }
                    })
                    .transition(.move(edge: .bottom))
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .background {
                    isUnlocked = false
                    showPasswordFallback = false
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
