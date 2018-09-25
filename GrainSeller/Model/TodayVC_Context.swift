//
//  ContentView.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 25/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import Foundation
import CoreData

//
// Context operations
//

extension TodayViewController {
    
    func loadFilter() {
        if let data = try? Data(contentsOf: filterPath!) {
            let decoder = PropertyListDecoder()
            do {
                filter = try decoder.decode(Filter.self, from: data)
            } catch {
                print("Error decoding filter options from plist \(error)")
            }
        }
    }
    
    func saveFilter() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(filter)
            try data.write(to: filterPath!)
        } catch {
            print("Error encoding filter options to plist \(error)")
        }
    }
    
    func readContext() {
        let request : NSFetchRequest<Contract> = Contract.fetchRequest()
        do {
            contracts = try context.fetch(request)
        } catch {
            print("Error reading context \(error)")
        }
        
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func clearContext(item: Contract) {
        context.delete(item)
    }
    
}
