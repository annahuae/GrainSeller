//
//  Filter.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 24/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import Foundation

class FilterOption {
    var header : String = ""
    var items : [String] = []
    var selected : [String] = []
    var multipleSelection : Bool = true
    var defaultValues : [String] = []
}

class Filter {
    var commodities = 0
    var buyers = 1
    var status = 2
    var sort = 3
    
    var sections : [FilterOption] = []
    
    init() {
        var filterOption = FilterOption()
        filterOption.header = "Commodity"
        self.sections.append(filterOption)
        
        filterOption = FilterOption()
        filterOption.header = "Buyer"
        self.sections.append(filterOption)

        filterOption = FilterOption()
        filterOption.header = "Status"
        filterOption.items = ["Opened", "Closed"]
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
        sections[0].selected = sections[0].items
        sections[1].selected = sections[1].items
        sections[2].selected = sections[2].items
        sections[3].selected = sections[3].defaultValues
    }
    
    func updateOptionItems(filterOption: FilterOption, items: [String]) {
        let oldItems = Set(filterOption.items)
        let oldSelection = Set(filterOption.selected)
        let newItems = Set(items)
        
        filterOption.items = items
        filterOption.selected = Array(newItems.intersection(oldSelection).union(newItems.subtracting(oldItems)))
    }
}
