//
//  CoreDataManager.swift
//  WireFrame
//
//  Created by Steven Lee on 8/9/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    // Private
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**
        Singleton Instance
     */
    static let sharedManager = CoreDataManager()
    
    
    /**
     Saves an item to an entity
     
     - Parameters:
     - name: The name of the entity
     - dictonary: The dictonary of the items to save
     
     - Returns: nothing
     */
    public func saveToEntity(name: String, dictonary:Dictionary<String, Any>) {
        let context = self.appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        let newBoard = NSManagedObject(entity: entity!, insertInto: context)
        
        for item in dictonary {
            newBoard.setValue(item.value, forKey: item.key)
        }
    
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     - Parameters:
     - style: The style of the bicycle
     - gearing: The gearing of the bicycle
     - handlebar: The handlebar of the bicycle
     - frameSize: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle,
     custom-built just for you.
     */
    func delete(){
        
    }
    
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     - Parameters:
     - style: The style of the bicycle
     - gearing: The gearing of the bicycle
     - handlebar: The handlebar of the bicycle
     - frameSize: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle,
     custom-built just for you.
     */
    public func updateItemInEntity(name: String, dictonary:Dictionary<String, Any>) {
        let context = self.appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        let newBoard = NSManagedObject(entity: entity!, insertInto: context)
        
        for item in dictonary {
            newBoard.setValue(item.value, forKey: item.key)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     - Parameters:
     - style: The style of the bicycle
     - gearing: The gearing of the bicycle
     - handlebar: The handlebar of the bicycle
     - frameSize: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle,
     custom-built just for you.
     */
    func get(){
        
    }
    
}
