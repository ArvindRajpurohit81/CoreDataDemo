//
//  DataController.swift
//  CoreDataDemo
//
//  Created by Arvind on 26/03/20.
//  Copyright © 2020 . All rights reserved.
//


import Foundation
import CoreData

class DataController {
    let persistentContainer = NSPersistentContainer(name: "LibraryDataModelVC")
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func initalizeStack(completion: @escaping () -> Void) {
        //self.setStore(type: NSInMemoryStoreType)
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }
            print("store loaded")
            completion()
        }
    }
    
    func setStore(type: String) {
        let description = NSPersistentStoreDescription()
        description.type = type // types: NSInMemoryStoreType, NSSQLiteStoreType, NSBinaryStoreType
        
        if type == NSSQLiteStoreType || type == NSBinaryStoreType {
            description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent("database")
        }
        
        self.persistentContainer.persistentStoreDescriptions = [description]
    }
    
    func fetchUsers() throws -> [User] {
        let users = try self.context.fetch(User.fetchRequest() as NSFetchRequest<User>)
        return users
    }

    func fetchUsers(withName name: String) throws -> [User] {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "firstName == %@", name)
        
        let users = try self.context.fetch(request)
        return users
    }
    
    func insert(user: User, withBook: Bool) throws {

        if withBook {
            let book = Book(context: self.context)
            book.title = "I am IOS Developer"
            user.addToBooks(book)
        }
        
        self.context.insert(user)
        try self.context.save()
    }

    func update(user: User) throws {
      //  user.firstName = "Jack"
        try self.context.save()
    }
    
    func delete(user: User) throws {
        self.context.delete(user)
        try self.context.save()
    }
    
    func deleteUsers(withName name: String) throws {
        let fetchRequest = User.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "firstName == %@", name)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try self.context.execute(deleteRequest)
        try self.context.save()
    }
}


