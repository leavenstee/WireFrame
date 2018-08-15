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
    
    // TODO docs
    public func save() {
        let manager = CoreDataManager.sharedManager
        if self.image.pngData() != nil {
            let dictionary: Dictionary<String, Any> = [
                "title" : self.title,
                "date" : self.date,
                "id" : self.id,
                "image" : self.image.pngData()!
            ]
            manager.saveToEntity(name: "Boards", dictonary: dictionary)
        } else {
            print("ERROR: No Image data!")
        }
    }
    
    
    public func delete() {
        let manager = CoreDataManager.sharedManager
        if self.image.pngData() != nil {
            let dictionary: Dictionary<String, Any> = [
                "title" : self.title,
                "date" : self.date,
                "id" : self.id,
                "image" : self.image.pngData()!
            ]
            manager.delete(name: "Boards", dictonary: dictionary)
        } else {
            print("ERROR: No Image data!")
        }
    }
}
