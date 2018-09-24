//
//  ViewController.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 24/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    let filter = Filter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension TodayViewController: FilterDelegate {
    
    func filterUpdated(filter: Filter) {
        print("filter updated")
    }
    
}
