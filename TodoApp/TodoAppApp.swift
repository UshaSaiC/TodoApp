//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Usha Sai Chintha on 23/09/22.
//

import SwiftUI

@main
struct TodoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(IconNames())
        }
    }
}
