//
//  Profile.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 4/10/2023.
//

import SwiftUI

struct Profile: View { ///View created for the profile
    
    @State private var newAllergy = ""  /// Variable to store new allergy input
    
    @Environment(\.managedObjectContext) var context
    
    /// Fetch request for the DietCoreItem entity.
    @FetchRequest(
        entity: DietCoreItem.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \DietCoreItem.id, ascending: false) ])
    var diet: FetchedResults<DietCoreItem>
    
    /// Animation state for the user's profile picture.
    @State private var isExpanded = false
    /// State for choosing user's diet
    @State private var selectedDiet = "Default" //Default is the first choice due to the most common diet type
    /// 5 different types of diet for now, as these are the common diet types
    var dietTypes = ["Default", "Vegan", "Paleo", "Keto", "Vegetarian"]
    
    ///Main view for the profile section
    var body: some View {
        ///Navigation view for the diet choice and allergies
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                ///The user's profile image
                Image("profpic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: isExpanded ? 300 : 150, height: isExpanded ? 300 : 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .gesture(LongPressGesture()//Long press gesture to zoom in the profile picture
                        .onChanged { _ in
                            withAnimation {
                                isExpanded = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isExpanded = false
                            }
                        }
                    )
                
                
                Text("User") //Username
                    .font(.title)
                ///Case if no diet preference isn't found
                if (diet.count == 0){
                    Text("Preference")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                else {///Else, Display preference text along with the diet type chosen
                    Text("Preference: \(diet[0].name)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                HStack{ ///A picker menu where you get to choose our own diet out of the 5 diet types
                    Picker("Select Diet", selection: $selectedDiet) {
                        ForEach(dietTypes, id: \.self) { diet in
                            Text(diet)
                                .font(.headline)
                        }
                    }
                    ///The style is menu picker due to you can only pick one type (If you want to change your diet type, simply go back and change it in the profile again)
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    Spacer()
                    
                    Button() { ///Button to save your diet type and also display it
                        saveDiet()
                    } label: {
                        Text("Save")
                    }.padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.title2)
                }
                
                ///For the allergies button which leads you to customize your avoided ingredients
                CustomLayout(linkdes: PreferencesView(), label: "Allergies", imageName: "pref")
                
                Spacer()
            }
            .padding()
            .background(Color.green.opacity(0.2).ignoresSafeArea()) /// Nature theme (green background)
            .navigationBarTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {///Tap gesture for expand animation
                if isExpanded {
                    withAnimation {
                        isExpanded = false
                    }
                }
            }
        }
    }
    /**
     ##Description
     Function to save the user's diet type which are 5 diet types:
     "Default", "Vegan", "Paleo", "Keto", "Vegetarian"
     */
    func saveDiet() {
        ///Save new diet core data
        let newDietSaved = DietCoreItem(context: context)
        
        ///Save neccessary values
        newDietSaved.id = UUID()
        newDietSaved.name = selectedDiet
        
        ///Store to context
        if diet.count == 1 {
            context.delete(diet[0])
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
///Custom Layout for the allergies section (So you can easily click either the picture or the text to go to the allergies section)
struct CustomLayout<Destination: View>: View {
    var linkdes: Destination
    var label: String
    var imageName: String
    
    var body: some View {
        NavigationLink(destination: linkdes) {
            HStack { ///Put the allergies text to the side and the image to the left
                Text(label)///Text lable for customlayout
                    .foregroundColor(.blue)
                    .padding(20)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(15)
                
                Spacer()
                
                Image(imageName) ///Image for the customlayout
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
            }
        }
        .padding(.bottom, 15)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
