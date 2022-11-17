//
//  PIA11coredataApp.swift
//  PIA11coredata
//
//  Created by Bill Martensson on 2022-11-17.
//

import SwiftUI

@main
struct PIA11coredataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
