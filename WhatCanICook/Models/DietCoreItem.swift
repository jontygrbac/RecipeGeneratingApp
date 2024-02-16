//
//  DietCoreItem.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 14/10/2023.
//

import Foundation
import CoreData
///Class representing DietCoreItem
public class DietCoreItem: NSManagedObject {
    ///Unique identifier of diet type
    @NSManaged public var id: UUID
    ///Diet type name
    @NSManaged public var name: String
}
