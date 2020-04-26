//
//  Book+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Arvind on 26/04/20.
//  Copyright © 2020 Openapp. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var users: User?

}
