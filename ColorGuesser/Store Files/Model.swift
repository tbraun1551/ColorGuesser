//
//  Model.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/28/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import Foundation
import StoreKit

class Model {
    
    var products = [SKProduct]()
    
    func getProduct(containing keyword: String) -> SKProduct? {
       // print("The array of SKProducts in Model getProduct is \(products)")
       // let test = products.filter { $0.productIdentifier.contains(keyword) }.first
        print("The products are: \(products)")
        print(products.filter { $0.productIdentifier.contains(keyword) }.first)
        return products.filter { $0.productIdentifier.contains(keyword) }.first
    }
}
