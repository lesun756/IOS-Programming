//
//  ItemStore.swift
//  Homepwner
//
//  Created by 杨丽婧 on 2020/2/21.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    // caller of this function is free to ignore the result of calling this function.
    // e.g. itemStore.createItem() is OK.
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
}
