//
//  Saved.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 4/10/2023.
//

import SwiftUI

struct Saved: View {
    /// Variable to hold Core Data context
    @Environment(\.managedObjectContext) var context
    
    /// Array holding saved Recipes, fetched from CoreData
    @FetchRequest(
        entity: RecipeCoreItem.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \RecipeCoreItem.priorityNum, ascending: false) ])
    var savedRecipes: FetchedResults<RecipeCoreItem>
    
    ///Create Variable for toggleview
    @State var toggleView = true
    
    var body: some View {
        ///Main body for the saved recipes view
        NavigationView {
            if toggleView {
                VStack {
                    ///Main title for the view
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text("Saved Recipes")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 10)
                    .background(Color(UIColor.lightGray).opacity(0.4))
                    ///List of saved user's recipes
                    List {
                        ///Saved Recipes data
                        ForEach(savedRecipes) { recipe in
                            NavigationLink(destination: Recipe(recipe: recipe)) {
                                HStack {
                                    Text(recipe.name)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(recipe.icon)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(UIColor.systemBackground).opacity(0.8))
                    .cornerRadius(10) // Rounded corners for the list
                    .padding(.horizontal, 10) // Adjusted horizontal padding
                }
                .padding(20)
                .background(Color.green.opacity(0.2))
                .shadow(radius: 5)
            }
        }
    }
    
    /**
        ## Description
        Function handling the deletion of core data value
     */
    private func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = savedRecipes[index]
            context.delete(itemToDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
                
            } catch {
                print(error)
            }
        }
    }
}


struct Saved_Previews: PreviewProvider {
    static var previews: some View {
        Saved().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}




