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
//        readContext()
        let bank = ContractsBank(context: context)
        contracts = bank.contracts

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
        dateFormatter.dateFormat = "d MMM"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as! TodayTableViewCell
        cell.tag = Int(tableViewDataSource.items[indexPath.section][indexPath.row].id)
        
        let contract = tableViewDataSource.items[indexPath.section][indexPath.row]
        
        switch filter.sections[filter.sort].selected.first {
        case filter.sections[filter.commodities].header:
            cell.titleLabel.text = contract.buyer!
            if contract.specification != nil {
                cell.titleLabel.text = cell.titleLabel.text! + ", " + contract.specification!
            }
            cell.descriptionLabel.text = contract.basis! + " " + (contract.destination ?? "")
        case filter.sections[filter.buyers].header:
            cell.titleLabel.text = contract.commodity!
            if contract.specification != nil {
                cell.titleLabel.text = cell.titleLabel.text! + ", " + contract.specification!
            }
            cell.descriptionLabel.text = contract.basis! + " " + (contract.destination ?? "")
        default:
            cell.titleLabel.text = "Title"
            cell.descriptionLabel.text = "Description"
        }
        
        cell.dateFrom.text = dateFormatter.string(from: contract.shipmentFrom!)
        cell.dateTo.text = dateFormatter.string(from: contract.shipmentTo!)

        if contract.closed {
            // Closed contract
            cell.cellImage.image = UIImage(named: "done")
            cell.dateFrom.textColor = UIColor.lightGray
            cell.dateTo.textColor = UIColor.lightGray
        } else {
            // Open contract
            
            cell.cellImage.image = UIImage(named: "clock")
            if contract.shipmentFrom! <= Date() {
                // Shipment has started -> dark grey color
                cell.cellImage.image = UIImage(named: "play")
                cell.dateFrom.textColor = UIColor.darkGray
                // Marking red when shipment is over
                cell.dateTo.textColor = contract.shipmentTo! <= Date() ? UIColor.red : UIColor.darkGray
            } else {
                // Awaiting shipment -> light grey color
                cell.dateFrom.textColor = UIColor.lightGray
                cell.dateTo.textColor = UIColor.lightGray
            }
        }

        return cell
    }
    
}

extension TodayViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TodayTableViewCell
        selected.append(cell.tag)
        cell.colorView.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            selected = selected.filter{ $0 != cell.tag }
        }
    }
}


