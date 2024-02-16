//
//  Preferences.swift
//  WhatCanICook
//
//  Created by Vadhthanak Vibol on 14/10/2023.
//

import SwiftUI

struct PreferencesView: View {//A view for managing the user's allergies preferences
    @State var newAllergy = "" //Private variable to hold each added allergies
    
    @Environment(\.managedObjectContext) var context //Core Data
    
    @FetchRequest( //Fetch allergies data from core data
        entity: AllergiesCoreItem.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \AllergiesCoreItem.id, ascending: false) ])
    var allergies: FetchedResults<AllergiesCoreItem>
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Allergies")
                .font(.title)
            
            TextField("Add Allergy", text: $newAllergy)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            Button(){
                saveAllergy()
            }label: {
                Text("Add Allergy")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            List {
                ForEach(allergies, id: \.self) { allergy in
                    Text(allergy.name)
                }.onDelete(perform: deleteTask)
            }
            .listStyle(PlainListStyle())
        }
        .padding()
        .background(Color.green.opacity(0.2).ignoresSafeArea())
        .navigationBarTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
    /**
     ##Description
     Function to save the user's allergies:
     It will save each allergy that the user inputs
     */
    func saveAllergy() {
        ///Create new allergies
        let newAllergySaved = AllergiesCoreItem(context: context)
        
        ///Save neccessary values
        newAllergySaved.id = UUID()
        newAllergySaved.name = newAllergy
        
        ///Store to context
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    /**
     ##Description
     Function for the user to delete the allergies that they previously inputed
     */
    private func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = allergies[index]
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




struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
