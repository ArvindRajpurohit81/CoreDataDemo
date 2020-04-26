//
//  Task+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Arvind on 26/04/20.
//  Copyright © 2020 Openapp. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var details: String?
    @NSManaged public var user: User?

}

