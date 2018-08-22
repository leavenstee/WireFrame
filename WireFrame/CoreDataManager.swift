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
    private lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()

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
    
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        
        var managedObject = self.getItemWithID(dictonary["id"] as! UUID, name: name) // Check if we have an object already
        
        if (managedObject == nil) {
            managedObject = NSManagedObject(entity: entity!, insertInto: context) // Create New Object
        }
        
        for item in dictonary {
            managedObject!.setValue(item.value, forKey: item.key) // Assign Values to items
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
    func delete(name: String, dictonary:Dictionary<String, Any>) {
        let managedObject = self.getItemWithID(dictonary["id"] as! UUID, name: name) // Check if we have an object already

        if (managedObject != nil) {
            do {
                context.delete(managedObject!)
                try context.save()
            } catch {
                print("Failed saving")
            }
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
    public func getDataFromTable(_ name: String) -> Array<DrawingBoard> {
        var items : Array<DrawingBoard> = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let tempObject = DrawingBoard()
                tempObject.title = data.value(forKey: "title") as? String
                tempObject.date = data.value(forKey: "date") as? Date
                tempObject.id = data.value(forKey: "id") as? UUID
                tempObject.image = UIImage(data: (data.value(forKey: "image") as? Data)!)
                items.insert(tempObject, at: 0)
            }
        } catch {
            print("Failed")
        }
        return items
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
    private func getItemWithID(_ id: UUID, name:String) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let tempID = data.value(forKey: "id") as? UUID
                if (tempID == id) {
                    return data
                }
            }
        } catch {
            print("Failed")
        }
        return nil
    }
    
}
