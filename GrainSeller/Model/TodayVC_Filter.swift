//
//  TodayVC_Filter.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 25/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import Foundation

//
// Filter functions
//

extension TodayViewController: FilterDelegate {
    
    func filterUpdated(filter: Filter) {
        self.filter = filter
        
        applyFiler()
        
        tableView.reloadData()
        
        saveFilter()
    }
    
    func applyFiler() {
        tableViewDataSource.headers = []
        tableViewDataSource.items = []
        
        switch filter.sections[filter.sort].selected.first {
        case filter.sections[filter.commodities].header:
            filter.sections[filter.commodities].selected.forEach { (section) in
                let items = contracts.filter{ $0.commodity == section }
                if items.count > 0 {
                    tableViewDataSource.headers.append(section)
                    tableViewDataSource.items.append(items)
                }
            }
        case filter.sections[filter.buyers].header:
            filter.sections[filter.buyers].selected.forEach { (section) in
                let items = contracts.filter{ $0.buyer == section }
                if items.count > 0 {
                    tableViewDataSource.headers.append(section)
                    tableViewDataSource.items.append(items)
                }
            }
        case filter.sections[filter.nominated].header:
            if filter.sections[filter.nominated].selected.contains("Feautured") {
                let items = contracts.filter{ $0.vessel == nil }
                if items.count > 0 {
                    tableViewDataSource.headers.append("Feautured")
                    tableViewDataSource.items.append(items)
                }
            }
            if filter.sections[filter.nominated].selected.contains("Nominated") {
                let items = contracts.filter{ $0.vessel != nil }
                if items.count > 0 {
                    tableViewDataSource.headers.append("Nominated")
                    tableViewDataSource.items.append(items)
                }
            }
        case filter.sections[filter.status].header:
            if filter.sections[filter.status].selected.contains("Opened") {
                let items = contracts.filter{ $0.closed == false }
                if items.count > 0 {
                    tableViewDataSource.headers.append("Opened")
                    tableViewDataSource.items.append(items)
                }
            }
            if filter.sections[filter.status].selected.contains("Closed") {
                let items = contracts.filter{ $0.closed == true }
                if items.count > 0 {
                    tableViewDataSource.headers.append("Closed")
                    tableViewDataSource.items.append(items)
                }
            }
        default:
            print("Unknown sort option: \(filter.sections[filter.sort].selected)")
        }
        
    }
    
}
