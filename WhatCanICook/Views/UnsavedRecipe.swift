//
//  UnsavedRecipe.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 11/10/2023.
//

import SwiftUI

struct UnsavedRecipe: View {
    /// Name passed through to struct
    var name: String
    /// Ingredient passed through to struct
    var ingredient: String
    /// Method passed through to struct
    var method: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100) // Adjusted height
                    .foregroundColor(Color.green.opacity(0.4))
                    .overlay {
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 30) // Adjusted height
                    .foregroundColor(Color.green.opacity(0.4))
                    .overlay {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                
                Text(ingredient)
                
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
                
                Text(method)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20) // Added horizontal padding
            .frame(maxWidth: .infinity)
        }
    }}

struct UnsavedRecipe_Previews: PreviewProvider {
    static var previews: some View {
        UnsavedRecipe(name: "Example that is a longer title", ingredient: "Example", method: "Example")
    }
}
