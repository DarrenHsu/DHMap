//
//  StoryEntity+CoreDataProperties.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/12/16.
//  Copyright © 2016 D.H. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension StoryEntity {

    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var type: NSNumber?
    @NSManaged var telephone: String?
    @NSManaged var country: String?
    @NSManaged var city: String?
    
}
