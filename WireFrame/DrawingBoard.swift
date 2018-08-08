//
//  DrawingBoard.swift
//  WireFrame
//
//  Created by Steven Lee on 8/6/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit
import CoreData

class DrawingBoard: NSObject {
    var title : String!
    var image : UIImage!
    var id : UUID!
    var date : Date!
    
    override init() {
        // Set Date
        self.date = Date()
        
        // Set Title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: self.date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        self.title = String(myStringafd)
        
        // Set UUID
        self.id = UUID()
        
        // Set IMage
        self.image = UIImage()
        
    }
    
    
    func save() {
        if (!findAndUpdate()){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Boards", in: context)
            let newBoard = NSManagedObject(entity: entity!, insertInto: context)
        
        
            newBoard.setValue(self.title, forKey: "title")
            newBoard.setValue(self.date, forKey: "date")
            newBoard.setValue(self.id, forKey: "id")
            newBoard.setValue(self.image.pngData(), forKey: "image")
        
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    
    func findAndUpdate() -> Bool {
        return false
    }
    
}
