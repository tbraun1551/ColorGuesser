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

struct PurchasePage: View {
    
    var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Support Me")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.leading)
                .offset(x: -75)
            Text("""
    If you've really, really enojoyed Iris thus far, you can leave exta tips to support the apps further development. Obviously any tip is appreciated but do not feel obligated to do so.
""")
                .multilineTextAlignment(.leading)
            Spacer()
            Group {
                tipButton(type: "Nice Tip", price: 0, index: 0)
                tipButton(type: "Kind Tip", price: 2, index: 1)
                tipButton(type: "Generous Tip", price: 4, index: 2)
                tipButton(type: "Awesome Tip", price: 9, index: 3)
                tipButton(type: "Superhuman Tip", price: 19, index: 4)
                tipButton(type: "Full Send Tip", price: 999, index: 5)
            }
            .padding(.vertical, 8.0)
            Spacer()
            Button(action: {
                print("restoring purchases")
            }) {
                Text("Restore Purchases")
            }
        }
        .onAppear(){
            print("loading product identifiers")
            self.viewModel.viewDidSetup()
        }
        .padding()
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}


struct tipButton: View {
    
    // let iapObserver = StoreObserver.shared
    //    let observer = StoreObserver()
    var viewModel = ViewModel()
    
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
                self.initiateItem()
                let pro = self.viewModel.getProductForItem(at: 1)
                self.showAlert(for: pro!)
            }) {
                Text("$\(price).99")
                    .fontWeight(.bold)
            }
            .padding(5.0)
            .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.75))
            .clipShape(Capsule())
        } //.onAppear() {
//            print("loading product identifiers")
//            self.viewModel.viewDidSetup()
//        }
    }
    
    func initiateItem(){
        guard let product = viewModel.getProductForItem(at: index) else {
            //showSingleAlert(withMessage: "Renewing this item is not possible at the moment.")
            print("Could not do this rn")
            return
        }
    }
    
    func showAlert(for product: SKProduct) {
        guard let price = IAPManager.shared.getPriceFormatted(for: product) else { return }
        
        let alertController = UIAlertController(title: product.localizedTitle,
                                                message: product.localizedDescription,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Buy now for \(price)", style: .default, handler: { (_) in
            
            if !self.viewModel.purchase(product: product) {
                //self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
                print("In-app purchases are not allowed")
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //self.present(alertController, animated: true, completion: nil)
    }
}

struct PurchasePage_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePage()
    }
}
