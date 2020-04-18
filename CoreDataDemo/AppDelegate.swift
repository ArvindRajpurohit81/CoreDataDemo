//
//  AppDelegate.swift
//  CoreDataDemo
//
//  Created by Arvind on 22/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

    }
}

