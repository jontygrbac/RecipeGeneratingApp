//
//  WhatCanICookApp.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 4/10/2023.
//

import SwiftUI

@main
struct WhatCanICook: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
