//
//  ios_ec_0712App.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

@main
struct ios_ec_0712App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
