//
//  CollectionViewModel.swift
//  WireFrame
//
//  Created by Steven Lee on 1/2/19.
//  Copyright © 2019 leavenstee. All rights reserved.
//

import Foundation

protocol CollectionViewModel {
    // MARK: Type
    associatedtype Item
    // MARK: Varibles
    var items: [Item] { get set }
    // MARK: Functions
    func loadData(completion: (Bool) -> Void)
    func itemAtIndex(_ indexPath: IndexPath) -> Item
    func numberOfItems() -> Int
}
