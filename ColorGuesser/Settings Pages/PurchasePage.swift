//
//  PurchasePage.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/8/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI
import StoreKit
import Foundation
import SwiftyStoreKit
import Network

struct PurchasePage: View {
	
	
	var body: some View {
		VStack {
			Text("Support Me")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding()
				.multilineTextAlignment(.leading)
				.offset(x: -75)
			Text("""
		If you've really enjoyed Iris thus far, you can leave extra tips to support the developer and further advancements to the game. While any tip is appreciated there is no obligation to do so.
	
""")
				.multilineTextAlignment(.leading)
				.padding(.horizontal)
			
			Group {
				tipButton(type: "Nice Tip", price: 0, index: 0)
				tipButton(type: "Kind Tip", price: 2, index: 1)
				tipButton(type: "Generous Tip", price: 4, index: 2)
				tipButton(type: "Awesome Tip", price: 9, index: 3)
				tipButton(type: "Superhuman Tip", price: 19, index: 4)
				tipButton(type: "Full Send Tip", price: 99, index: 5)
			}
//			.padding(.vertical, 8.0)
			.padding()
			.navigationBarTitle(Text(""), displayMode: .inline)
			Spacer()
		}
	}
}


struct tipButton: View {
	
	// let iapObserver = StoreObserver.shared
	//    let observer = StoreObserver()
	
	let swifty = SwiftyStore()
	let monitor = NWPathMonitor()
	var type: String
	var price: Int
	var index: Int
	
	var body: some View {
		
		HStack {
			Text(type)
			Spacer()
			Button(action: {
				//In app purchase functionality
				print("Purchasing \(self.type)")
				self.swifty.purchase(at: self.index)
				
			}) {
				Text("$\(price).99")
					.fontWeight(.bold)
			}
			.padding(5.0)
			.background(Color(hue: 1.0, saturation: 0.0, brightness: 0.75))
			.clipShape(Capsule())
		}
		//        }
	}
}

struct PurchasePage_Previews: PreviewProvider {
	static var previews: some View {
		PurchasePage()
	}
}
