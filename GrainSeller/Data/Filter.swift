//
//  Filter.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 24/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import Foundation

class FilterOption : Codable {
    var header : String = ""
    var items : [String] = []
    var selected : [String] = []
    var multipleSelection : Bool = true
    var defaultValues : [String] = []
    
    func updateItems(items: [String]) {
        let oldItems = Set(self.items)
        let oldSelection = Set(self.selected)
        let newItems = Set(items)
        
        self.items = items
        self.selected = Array(newItems.intersection(oldSelection).union(newItems.subtracting(oldItems)))
    }
}

class Filter : Codable {
    var commodities = 0
    var buyers = 1
    var nominated = 2
    var status = 3
    var sort = 4
    
    var sections : [FilterOption] = []
    
    init() {
        var filterOption = FilterOption()
        filterOption.header = "Commodity"
        self.sections.append(filterOption)
        
        filterOption = FilterOption()
        filterOption.header = "Buyer"
        self.sections.append(filterOption)

        filterOption = FilterOption()
        filterOption.header = "Nominated"
        filterOption.items = ["Feautured", "Nominated"]
        self.sections.append(filterOption)
        
        filterOption = FilterOption()
        filterOption.header = "Status"
        filterOption.items = ["Opened", "Closed"]
        filterOption.defaultValues = [filterOption.items[0]]
        self.sections.append(filterOption)

        filterOption = FilterOption()
        filterOption.header = "Sort"
        filterOption.items = ["Nominated", "Status", "Commodity", "Buyer"]
        filterOption.defaultValues = [filterOption.items[0]]
        filterOption.multipleSelection = false
        self.sections.append(filterOption)
        
        reset()
    }
    
    func reset() {
        sections.forEach { $0.selected = $0.defaultValues.count > 0 ? $0.defaultValues : $0.items }
    }
}
