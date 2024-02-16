//
//  Persistence.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 10/10/2023.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    /// To add test data for preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let selection = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack", "Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
        let allergies = ["Peanuts", "Dairy"]
        
        for index in 0..<10 {
            let newItem = RecipeCoreItem(context: viewContext)
            newItem.id = UUID()
            newItem.name = "\(selection[index]) Recipe: \(index)"
            newItem.ingredients = "- 2 apples, preferably crisp varieties (e.g., Honeycrisp, Granny Smith) \n- 2 oranges \n- 1 tablespoon fresh lime juice \n- 2 tablespoons honey \n- 1/4 cup chopped fresh mint leaves (optional, for garnish) "
            newItem.method = "1. Peel the apples and oranges. Dice the apples into bite-sized pieces and section the oranges, removing any seeds. Place the diced apples and orange sections in a mixing bowl.  \n2. In a separate small bowl, whisk together the fresh lime juice and honey until well combined. Adjust the sweetness by adding more honey if desired.  \n3. Pour the honey-lime dressing over the diced apples and orange sections. Gently toss, ensuring all the fruit is coated in the dressing.  \n4. Allow the salad to marinate in the dressing for 10-15 minutes to enhance the flavors. This step is optional but recommended for a more pronounced taste.  \n5. Serve the fresh apple-orange salad on a dish or in individual bowls, garnished with freshly chopped mint leaves if desired. The mint adds a refreshing touch, enhancing the fruit flavors.  Enjoy this delightful and healthy Fresh Apple-Orange Salad as a light snack, side dish, or refreshing starter!"
            newItem.priority = .normal
            newItem.icon = selection[index]
            

        }
        
        for index in 0..<2{
            let newAllergies = AllergiesCoreItem(context: viewContext)
            newAllergies.id = UUID()
            newAllergies.name = allergies[index]
        }
        
        let newDiet = DietCoreItem(context: viewContext)
        newDiet.id = UUID()
        newDiet.name = "Keto"
        
        
        do {
            try viewContext.save()
        } catch {
            /// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WhatCanICook")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

