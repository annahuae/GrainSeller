//
//  FilterTableViewController.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 24/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func filterUpdated(filter: Filter)
}

class FilterViewController: UITableViewController {

    var filter = Filter()
    
    var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        filter.reset()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filter.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filter.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filter.sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = filter.sections[indexPath.section].items[indexPath.row]
        
        if filter.sections[indexPath.section].selected.contains(filter.sections[indexPath.section].items[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemSelected = filter.sections[indexPath.section].items[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if filter.sections[indexPath.section].multipleSelection {
                
                // Multiple choices section: Commodity, Buyer, Status. One selection remain
                if cell.accessoryType == .none {
                    filter.sections[indexPath.section].selected.append(itemSelected)
                    cell.accessoryType = .checkmark
                } else {
                    if filter.sections[indexPath.section].selected.count >= 2 { // MARK: Doubts
                        filter.sections[indexPath.section].selected = filter.sections[indexPath.section].selected.filter { $0 != itemSelected }
                        cell.accessoryType = .none
                    }
                }
                // Sorting selected values before sending it back
                if filter.sections[indexPath.section].selected.count > 0 {
                    filter.sections[indexPath.section].selected = filter.sections[indexPath.section].selected.sorted{ $0 < $1 }
                }
            } else {
                
                // Single choice section: Sort
                if cell.accessoryType == .none {
                    for i in 0...tableView.numberOfRows(inSection: indexPath.section)-1 {
                        if let sectionCell = tableView.cellForRow(at: [indexPath.section, i]) {
                            if indexPath == [indexPath.section, i] {
                                filter.sections[indexPath.section].selected = [itemSelected]
                                sectionCell.accessoryType = .checkmark
                            } else {
                                sectionCell.accessoryType = .none
                            }
                        }
                    }
                }
            }
        }
        
        delegate?.filterUpdated(filter: filter)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
