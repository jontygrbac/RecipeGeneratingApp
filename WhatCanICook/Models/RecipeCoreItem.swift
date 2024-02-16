//
//  RecipeCoreItem.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 10/10/2023.
//

import Foundation
import CoreData

enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
}

/// A class representing a core item for a recipe.
public class RecipeCoreItem: NSManagedObject {
    
    /// The unique identifier for the recipe.
    @NSManaged public var id: UUID
    
    /// The name of the recipe.
    @NSManaged public var name: String
    
    /// The cooking method for the recipe.
    @NSManaged public var method: String
    
    /// The list of ingredients needed for the recipe.
    @NSManaged public var ingredients: String
    
    /// The name of the icon associated with the recipe.
    @NSManaged public var icon: String
    
    /// The priority level of the recipe.
    @NSManaged public var priorityNum: Int32
}

/// An extension for `RecipeCoreItem` to conform to the `Identifiable` protocol.
extension RecipeCoreItem: Identifiable {
    
    /// The priority level of the recipe.
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
    
    /// The priority level of a recipe.
    enum Priority: Int {
        case low = 0
        case normal = 1
        case high = 2
    }
}
