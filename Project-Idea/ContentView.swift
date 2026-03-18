//
//  ContentView.swift
//  Project-Idea
//
//  Created by Tom Brophy on 10/03/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]

    @State private var inputTitle = ""
    @State private var inputPassword = ""
    @State private var current2FACode = "------"
    @State private var tempEmail = "No Email Generated"

    var body: some View {
        NavigationSplitView {
            List {
                Section("Add New Password") {
                    TextField("Title", text: $inputTitle)
                    SecureField("Password", text: $inputPassword)
                }

                Button(action: addItem) {
                    Text("Save to Vault")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(inputTitle.isEmpty || inputPassword.isEmpty)

                Section("Saved Items") {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Secure Data: \(item.secureData)")
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.timestamp, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("My Passwords")
        } detail: {
            Text("Select an item")
        }
        .navigationSplitViewStyle(.balanced)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(title: "New Password Entry", serviceType: "Login", secureData: "EncryptedData", timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
