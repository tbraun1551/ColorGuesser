//
//  MyStoreObserver.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/19/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import Foundation
import StoreKit

class MyStoreObserver: NSObject, SKPaymentTransactionObserver {
    
    
    //Initialize the observer
    override init() {
        super.init()
    }
    
    //Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle transaction states here.
    }
    
    
}
