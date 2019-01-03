//
//  MainViewModel.swift
//  WireFrame
//
//  Created by Steven Lee on 1/2/19.
//  Copyright © 2019 leavenstee. All rights reserved.
//

import UIKit
import CoreData

class MainViewModel: CollectionViewModel {
    
    typealias Item = DrawingBoard
    
    internal var items: [DrawingBoard] = []
    
    public func isNewVersion() -> Bool {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false 
        }
        let defaults = UserDefaults.standard
        let previousVersion = defaults.string(forKey: "Version")
        defaults.set(version, forKey: "Version")
        return version != previousVersion
    }
    
    public func itemAtIndex(_ indexPath: IndexPath) -> DrawingBoard {
        return items[indexPath.row]
    }
    
    public func numberOfItems() -> Int {
        return items.count
    }
    
    public func loadData(completion: (Bool) -> Void) {
        CoreDataManager.sharedManager.getDataFromTable("Boards") { (dataItems, error) in
            guard let dataItems = dataItems else {
                fatalError("No Data")
            }
            items = dataItems
            completion(true)
        }
    }

    public func createNewDrawingBoard(completion: (DrawViewController) -> Void) {
        let db = DrawingBoard()
        items.insert(db, at: 0)
        guard let firstItem = items.first else {
            fatalError("No Item In First Slot")
        }
        let drawVC = DrawViewController(boardObject: firstItem)
        completion(drawVC)
    }
}
