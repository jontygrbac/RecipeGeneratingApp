//
//  AllergiesCoreItem.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 14/10/2023.
//

import Foundation
import CoreData
///Class to represent the allergies
public class AllergiesCoreItem: NSManagedObject {
    /// Unique id for user's  allergy
    @NSManaged public var id: UUID
    /// Sting for user's  allergy
    @NSManaged public var name: String
}
