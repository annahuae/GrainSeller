//
//  ViewController.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 24/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import UIKit
import CoreData

class TodayTableViewDataSource {
    
    var headers : [String] = []
    var items : [[Contract]] = [[]]
}

class TodayViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var filter = Filter()
    let filterPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Filter.plist")
    
    var contracts : [Contract] = []
    var selected : [Int] = []
    let tableViewDataSource = TodayTableViewDataSource()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        readContext()
        
        print("Loaded \(contracts.count) contracts")
        
        loadFilter()
        applyFiler()
        
    }

    
    //
    // Preparing segues
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilterViewController" {
            let filterVC = segue.destination as! FilterViewController
            
            filterVC.delegate = self
            
            let commodities = Array(Set(contracts.map{ $0.commodity! }))
            let buyers = Array(Set(contracts.map{ $0.buyer! })).sorted{ $0 < $1 }
            
            filter.sections[filter.commodities].updateItems(items: commodities)
            filter.sections[filter.buyers].updateItems(items: buyers)
            
            filterVC.filter = filter
        }
    }
    
    //
    //  Copy cell text to clipboard
    //
    
    @IBAction func copyAction(_ sender: Any) {
        var str = ""
        
        if selected.count > 0 {
            let selectedContracts = contracts.filter{ selected.contains(Int($0.id)) }
            selectedContracts.forEach{ contract in
                str += "\(contract.commodity!) \(contract.buyer!) \(contract.volume)\n"
            }
            UIPasteboard.general.string = str
            
            // Show alert
            let alert = UIAlertController(title: "Copy", message: "\(selected.count) contracts copied", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) { alert.dismiss(animated: true, completion: nil) }
        } else {
            let alert = UIAlertController(title: "Copy", message: "Please select contract(s)", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { alert.dismiss(animated: true, completion: nil) }
        }
        
    }

}


//
// TableView DataSource and Delegate functions
//

extension TodayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSource.headers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewDataSource.headers[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as! TodayTableViewCell
        cell.tag = Int(tableViewDataSource.items[indexPath.section][indexPath.row].id)
        
        let contract = tableViewDataSource.items[indexPath.section][indexPath.row]
        
        cell.buyerLabel.text = (arc4random_uniform(2) == 0 ? "[CIF] " : "[FOB] ") + contract.commodity! + (contract.specification != nil ? " \(contract.specification!)" : "")
        cell.commodityLabel.text = contract.buyer! + " to Philipines"
        
        if let dateFrom = contract.shipmentFrom {
            cell.dateFrom.text = dateFormatter.string(from: dateFrom)
        }
        if let dateTo = contract.shipmentTo {
            cell.dateTo.text = dateFormatter.string(from: dateTo)
        }

        return cell
    }
    
}

extension TodayViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            selected.append(cell.tag)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            selected = selected.filter{ $0 != cell.tag }
        }
    }
}


