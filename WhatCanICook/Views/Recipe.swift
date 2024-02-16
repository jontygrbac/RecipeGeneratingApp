//
//  Recipe.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 4/10/2023.
//

import SwiftUI

struct Recipe: View {
    /// Recipe Core Item passed to struct
    var recipe: RecipeCoreItem
    
    ///Main view for the recipes
    /// - View is inside the saved recipes once you click on a recipe
    var body: some View {
        ///Scrollview to show the information to the user easily
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundColor(Color.green.opacity(0.4))
                    .overlay {
                        ///Text to display the recipe name
                        Text(recipe.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 30)
                    .foregroundColor(Color.green.opacity(0.4))
                    .overlay {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                ///Text to display each recipe's ingredients
                Text(recipe.ingredients)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 30) // Adjusted height
                    .foregroundColor(Color.green.opacity(0.4))
                    .overlay {
                        Text("Method")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                ///Text to display the steps in completing the recipe
                Text(recipe.method)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.2))
        }
        }
}

struct Recipe_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

