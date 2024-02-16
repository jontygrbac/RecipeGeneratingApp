//
//  ContentView.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 4/10/2023.
//

import SwiftUI

///Main overall view of the application
struct ContentView: View {
    ///Core data management
    @Environment(\.managedObjectContext) var context
    ///Fetch Request for RecipeCoreItem
    @FetchRequest(
        entity: RecipeCoreItem.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \RecipeCoreItem.id, ascending: false) ])
    var todoItems: FetchedResults<RecipeCoreItem>
    
    ///State to show the welcome view/screen
    ///- Should always set to be true
    @State private var showWelcomeView = true
    
    var body: some View {
        ZStack {
            if showWelcomeView {
                WelcomeView(showWelcomeView: $showWelcomeView)
            } else {
                Color.green.opacity(0.2).ignoresSafeArea()
                ///3 main views of the application
                TabView(){
                    Fridge()
                        .tabItem {
                            Label("Fridge", systemImage: "fork.knife")
                        }
                    Saved()
                        .tabItem {
                            Label("Saved", systemImage: "heart.fill")
                        }
                    Profile()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
