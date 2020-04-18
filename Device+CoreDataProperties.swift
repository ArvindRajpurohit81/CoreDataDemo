//
//  Device+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Arvind on 26/03/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var deviceType: String?
    @NSManaged public var name: String?

}
