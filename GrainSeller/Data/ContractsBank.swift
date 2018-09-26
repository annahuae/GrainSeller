//
//  ContractsBank.swift
//  GrainSeller
//
//  Created by Natalia Kryukovskaya on 26/09/2018.
//  Copyright © 2018 Natalia Kryukovskaya. All rights reserved.
//

import Foundation
import CoreData

class ContractsBank {
    
    var contracts = [Contract]()
    var currentId : Int64 = 0
    
    init(context: NSManagedObjectContext) {
        
        // Barley
        addContract(buyer: "MITS", commodity: "Barley", specification: nil, volume: 60000, price: 222, shipmentFrom: "16/09/2018", shipmentTo: "30/09/2018", basis: "CFR", destination: "JORDAN", closed: false, context: context)
        addContract(buyer: "SAGO", commodity: "Barley", specification: nil, volume: 60000, price: 223, shipmentFrom: "01/09/2018", shipmentTo: "15/09/2018", basis: "CFR", destination: "KSA RED", closed: true, context: context)
        addContract(buyer: "SAGO", commodity: "Barley", specification: nil, volume: 60000, price: 223, shipmentFrom: "01/09/2018", shipmentTo: "15/09/2018", basis: "CFR", destination: "KSA RED", closed: true, context: context)
        addContract(buyer: "SAGO", commodity: "Barley", specification: nil, volume: 60000, price: 226, shipmentFrom: "01/10/2018", shipmentTo: "15/10/2018", basis: "CFR", destination: "KSA RED", closed: false, context: context)
        addContract(buyer: "SAGO", commodity: "Barley", specification: nil, volume: 60000, price: 228, shipmentFrom: "01/10/2018", shipmentTo: "15/10/2018", basis: "CFR", destination: "KSA RED", closed: false, context: context)

        // Wheat 10.5%
        addContract(buyer: "Phoenix", commodity: "Wheat", specification: "10.5%", volume: 60000, price: 228, shipmentFrom: "01/10/2018", shipmentTo: "15/10/2018", basis: "CFR", destination: "KSA RED", closed: false, context: context)
        addContract(buyer: "VAIT", commodity: "Wheat", specification: "10.5%", volume: 50000, price: 198, shipmentFrom: "05/09/2018", shipmentTo: "20/09/2018", basis: "FOB", destination: "Philippines", closed: true, context: context)
        addContract(buyer: "Agrocorp", commodity: "Wheat", specification: "10.5%", volume: 65000, price: 195, shipmentFrom: "15/09/2018", shipmentTo: "30/09/2018", basis: "FOB", destination: nil, closed: false, context: context)
        addContract(buyer: "Agrocorp", commodity: "Wheat", specification: "10.5%", volume: 65000, price: 195, shipmentFrom: "05/09/2018", shipmentTo: "20/09/2018", basis: "FOB", destination: "Vietnam", closed: false, context: context)
        addContract(buyer: "Agromond", commodity: "Wheat", specification: "10.5%", volume: 65000, price: 196, shipmentFrom: "25/08/2018", shipmentTo: "10/09/2018", basis: "FOB", destination: "Vietnam", closed: true, context: context)
        addContract(buyer: "Midstar", commodity: "Wheat", specification: "10.5%", volume: 60000, price: 213, shipmentFrom: "01/10/2018", shipmentTo: "15/10/2018", basis: "FOB", destination: "Philippines", closed: false, context: context)
        addContract(buyer: "Midstar", commodity: "Wheat", specification: "10%", volume: 60000, price: 202.5, shipmentFrom: "01/09/2018", shipmentTo: "16/09/2018", basis: "FOB", destination: "Philippines", closed: true, context: context)
        addContract(buyer: "Agrocorp", commodity: "Wheat", specification: "10.5%", volume: 65000, price: 199.25, shipmentFrom: "05/08/2018", shipmentTo: "03/09/2018", basis: "FOB", destination: "Vietnam", closed: true, context: context)
        addContract(buyer: "Ulusoy", commodity: "Wheat", specification: "10.5%", volume: 63000, price: 190.5, shipmentFrom: "10/08/2018", shipmentTo: "20/08/2018", basis: "FOB", destination: "Vietnam", closed: true, context: context)
        
        // Wheat 11.5%
        addContract(buyer: "Ulusoy", commodity: "Wheat", specification: "11.5%", volume: 55000, price: 208, shipmentFrom: "15/10/2018", shipmentTo: "30/10/2018", basis: "FOB", destination: "Indonesia", closed: false, context: context)
        addContract(buyer: "Ulusoy", commodity: "Wheat", specification: "11.5%", volume: 55000, price: 208, shipmentFrom: "15/10/2018", shipmentTo: "30/10/2018", basis: "FOB", destination: nil, closed: false, context: context)
        addContract(buyer: "Horus", commodity: "Wheat", specification: "11.5%", volume: 40000, price: 215, shipmentFrom: "05/09/2018", shipmentTo: "20/09/2018", basis: "CIF", destination: "Egypt", closed: true, context: context)
        addContract(buyer: "Agrocorp", commodity: "Wheat", specification: "11.5%", volume: 55000, price: 206, shipmentFrom: "16/09/2018", shipmentTo: "30/09/2018", basis: "FOB", destination: nil, closed: false, context: context)
        addContract(buyer: "Agrocorp", commodity: "Wheat", specification: "11.5%", volume: 60000, price: 208, shipmentFrom: "01/09/2018", shipmentTo: "30/09/2018", basis: "FOB", destination: nil, closed: false, context: context)
        addContract(buyer: "Agrocorp", commodity: "Wheat", specification: "11.5%", volume: 60000, price: 214, shipmentFrom: "01/10/2018", shipmentTo: "30/10/2018", basis: "FOB", destination: nil, closed: false, context: context)
        addContract(buyer: "Ulusoy", commodity: "Wheat", specification: "11.5%", volume: 55000, price: 216, shipmentFrom: "15/09/2018", shipmentTo: "05/10/2018", basis: "FOB", destination: nil, closed: false, context: context)
        addContract(buyer: "Midstar", commodity: "Wheat", specification: "11.5%", volume: 10000, price: 214, shipmentFrom: "15/08/2018", shipmentTo: "30/08/2018", basis: "FOB", destination: "Oman", closed: true, context: context)
        addContract(buyer: "ASM", commodity: "Wheat", specification: "11.5%", volume: 25000, price: 211, shipmentFrom: "25/08/2018", shipmentTo: "10/09/2018", basis: "FOB", destination: "Lebanon", closed: true, context: context)
        addContract(buyer: "Grainbow", commodity: "Wheat", specification: "11.5%", volume: 50000, price: 222, shipmentFrom: "01/09/2018", shipmentTo: "15/09/2018", basis: "FOB", destination: nil, closed: true, context: context)

    }
    
    func addContract(buyer: String, commodity: String, specification: String?, volume: Int64, price: Float, shipmentFrom: String, shipmentTo: String, basis: String?, destination: String?, closed: Bool, context: NSManagedObjectContext) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let contract = Contract(context: context)
        self.currentId += 1
        
        contract.id = self.currentId
        contract.commodity = commodity
        contract.specification = specification
        contract.buyer = buyer
        contract.volume = volume
        contract.price = price
        contract.shipmentFrom = formatter.date(from: shipmentFrom)
        contract.shipmentTo = formatter.date(from: shipmentTo)
        contract.basis = basis
        contract.destination = destination
        contract.closed = closed
        self.contracts.append(contract)
    }
    
}
