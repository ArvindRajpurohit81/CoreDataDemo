//
//  User+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Arvind on 26/04/20.
//  Copyright © 2020 Openapp. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var username: String?
    @NSManaged public var books: Set<Book>?
    @NSManaged public var task: Set<Task>?

}

// MARK: Generated accessors for books
extension User {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

// MARK: Generated accessors for task
extension User {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

//    @objc(removeTaskObject:)
//    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

//    @objc(removeTask:)
//    @NSManaged public func removeFromTask(_ values: NSSet)

}
