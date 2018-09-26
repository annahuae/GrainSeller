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
    
    func perfomStatusFilter(items: [Contract])->[Contract] {
        if filter.sections[filter.status].selected.count == filter.sections[filter.status].items.count {
            return items
        } else {
            return items.filter { (filter.sections[filter.status].selected.first! == "Opened" && !$0.closed) ||
                (filter.sections[filter.status].selected.first! == "Closed" && $0.closed) }
        }
    }
    
    func perfomNominatedFilter(items: [Contract])->[Contract] {
        if filter.sections[filter.nominated].selected.count == filter.sections[filter.nominated].items.count {
            return items
        } else {
            return items.filter { (filter.sections[filter.nominated].selected.first! == "Nominated" && $0.vessel != nil) ||
                (filter.sections[filter.nominated].selected.first! == "Feautured" && $0.vessel == nil) }
        }
    }

    func perfomBuyerFilter(items: [Contract])->[Contract] {
        if filter.sections[filter.buyers].selected.count == filter.sections[filter.buyers].items.count {
            return items
        } else {
            return items.filter { filter.sections[filter.buyers].selected.contains($0.buyer!) }
        }
    }

    func perfomCommodityFilter(items: [Contract])->[Contract] {
        if filter.sections[filter.commodities].selected.count == filter.sections[filter.commodities].items.count {
            return items
        } else {
            return items.filter { filter.sections[filter.commodities].selected.contains($0.commodity!) }
        }
    }

    func applyFiler() {
        tableViewDataSource.headers.removeAll()
        tableViewDataSource.items.removeAll()
        
        var filteredItems = contracts
        
        // Applying filter
        
        filteredItems = perfomStatusFilter(items: filteredItems)
        filteredItems = perfomNominatedFilter(items: filteredItems)
        filteredItems = perfomBuyerFilter(items: filteredItems)
        filteredItems = perfomCommodityFilter(items: filteredItems)

        switch filter.sections[filter.sort].selected.first {
//        case filter.sections[filter.date].header:
//            // This week
//            let thisWeekItems = contracts.filter{
//
//                $0.shipmentFrom! <= Date() && $0.shipmentTo! >= Date()
//            }
//            // This month
//            // Next month
//            // Rest
//            print ("here")
//
            
        // Sorting items by sections
            
        case filter.sections[filter.commodities].header:
            // Filter empty sections and remove duplicates
            tableViewDataSource.headers = Array(Set(filteredItems.map{ $0.commodity! })).sorted{ $0 < $1 }
            // Fill section items
            tableViewDataSource.headers.forEach{ section in
                tableViewDataSource.items.append(filteredItems.filter{ $0.commodity == section }.sorted{ $0.shipmentTo! < $1.shipmentTo! })
            }
        case filter.sections[filter.buyers].header:
            // Filter empty sections and remove duplicates
            tableViewDataSource.headers = Array(Set(filteredItems.map{ $0.buyer! })).sorted{ $0 < $1 }
            // Fill section items
            tableViewDataSource.headers.forEach{ section in
                tableViewDataSource.items.append(filteredItems.filter{ $0.buyer == section }.sorted{ $0.shipmentTo! < $1.shipmentTo! })
            }
        case filter.sections[filter.nominated].header:
            // Filter empty sections and remove duplicates
            tableViewDataSource.headers = Array(Set(filteredItems.map{ $0.vessel ==  nil ? "Feautured" : "Nominated" }))
            // Fill section items
            tableViewDataSource.headers.forEach{ section in
                tableViewDataSource.items.append(filteredItems.filter{
                    (section == "Feautured" && $0.vessel == nil) ||
                    (section == "Nominated" && $0.vessel != nil)
                }.sorted{ $0.shipmentTo! < $1.shipmentTo! })
            }
        case filter.sections[filter.status].header:
            // Filter empty sections and remove duplicates
            tableViewDataSource.headers = Array(Set(filteredItems.map{ !$0.closed ? "Opened" : "Closed" }))
            // Fill section items
            tableViewDataSource.headers.forEach{ section in
                tableViewDataSource.items.append(filteredItems.filter{
                    (section == "Opened" && !$0.closed) ||
                    (section == "Closed" && $0.closed)
                }.sorted{ $0.shipmentTo! < $1.shipmentTo! })
            }
        default:
            print("Unknown sort option: \(filter.sections[filter.sort].selected)")
        }
    
    }
    
}
