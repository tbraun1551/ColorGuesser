//
//  SwiftyStore.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 1/12/20.
//  Copyright © 2020 Thomas Braun. All rights reserved.
//

import Foundation
import SwiftyStoreKit

class SwiftyStore {
	
	func purchase(at index: Int) {
		
		let keyword: String
        
        switch index {
            case 0: keyword = "com.Braun.ColorGuesser.NiceTip"
            case 1: keyword = "com.Braun.ColorGuesser.KindTip"
            case 2: keyword = "com.Braun.ColorGuesser.GenerousTip"
            case 3: keyword = "com.Braun.ColorGuesser.AwesomeTip"
            case 4: keyword = "com.Braun.ColorGuesser.SuperhumanTip"
            case 5: keyword = "com.Braun.ColorGuesser.FullSendTip"
            default: keyword = ""
        }
		
		SwiftyStoreKit.purchaseProduct(keyword, quantity: 1, atomically: true) { result in
			switch result {
			case .success(let purchase):
				print("Purchase Success: \(purchase.productId)")
			case .error(let error):
				switch error.code {
				case .unknown: print("Unknown error. Please contact support")
				case .clientInvalid: print("Not allowed to make the payment")
				case .paymentCancelled: break
				case .paymentInvalid: print("The purchase identifier was invalid")
				case .paymentNotAllowed: print("The device is not allowed to make the payment")
				case .storeProductNotAvailable: print("The product is not available in the current storefront")
				case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
				case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
				case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
				default: print((error as NSError).localizedDescription)
				}
			}
		}
	}
}
