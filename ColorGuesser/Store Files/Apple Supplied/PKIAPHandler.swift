//
//  PKIAPHandler.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/8/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

enum PKIAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class PKIAPHandler: NSObject {
    
    //MARK:- Shared Object
    //MARK:-
    static let shared = PKIAPHandler()
    private override init() { }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductComplition: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    
    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //MARK:- Public
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }

    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        self.purchaseProductComplition = complition
        self.productToPurchase = product

        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            complition(PKIAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        
        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PKIAPHandlerAlertType.setProductIds.message)
            fatalError(PKIAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
//MARK:-
extension PKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            if let complition = self.fetchProductComplition {
                complition(response.products)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let complition = self.purchaseProductComplition {
            complition(PKIAPHandlerAlertType.restored, nil, nil)
        }
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let complition = self.purchaseProductComplition {
                        complition(PKIAPHandlerAlertType.purchased, self.productToPurchase, trans)
                    }
                    break
                    
                case .failed:
                    log("Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    log("Product restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
}


/*  IAPMANAGER STUFFF
 import Foundation
 import StoreKit

 class IAPManager: NSObject {
     
     // MARK: - Custom Types
     
     enum IAPManagerError: Error {
         case noProductIDsFound
         case noProductsFound
         case paymentWasCancelled
         case productRequestFailed
     }

     
     // MARK: - Properties
     
     static let shared = IAPManager()
     
     var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
     
     var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
     
     var totalRestoredPurchases = 0
         
     
     // MARK: - Init
     
     private override init() {
         super.init()
     }
     
     
     // MARK: - General Methods
     
     fileprivate func getProductIDs() -> [String]? {
         guard let url = Bundle.main.url(forResource: "IAP_ProductIDs", withExtension: "plist") else { return nil }
         do {
             let data = try Data(contentsOf: url)
             let productIDs = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
             return productIDs
         } catch {
             print(error.localizedDescription)
             return nil
         }
     }
     
     
     func getPriceFormatted(for product: SKProduct) -> String? {
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         formatter.locale = product.priceLocale
         return formatter.string(from: product.price)
     }
     
     
     func startObserving() {
         SKPaymentQueue.default().add(self)
     }


     func stopObserving() {
         SKPaymentQueue.default().remove(self)
     }
     
     
     func canMakePayments() -> Bool {
         return SKPaymentQueue.canMakePayments()
     }
     
     
     // MARK: - Get IAP Products
     
     func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
         // Keep the handler (closure) that will be called when requesting for
         // products on the App Store is finished.
         onReceiveProductsHandler = productsReceiveHandler

         // Get the product identifiers.
         guard let productIDs = getProductIDs() else {
             productsReceiveHandler(.failure(.noProductIDsFound))
             return
         }

         // Initialize a product request.
         let request = SKProductsRequest(productIdentifiers: Set(productIDs))

         // Set self as the its delegate.
         request.delegate = self

         // Make the request.
         request.start()
     }
     
     
     
     // MARK: - Purchase Products
     
     func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
         let payment = SKPayment(product: product)
         SKPaymentQueue.default().add(payment)

         // Keep the completion handler.
         onBuyProductHandler = handler
     }
     
     
     func restorePurchases(withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
         onBuyProductHandler = handler
         totalRestoredPurchases = 0
         SKPaymentQueue.default().restoreCompletedTransactions()
     }
 }


 // MARK: - SKPaymentTransactionObserver
 extension IAPManager: SKPaymentTransactionObserver {
     func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
         transactions.forEach { (transaction) in
             switch transaction.transactionState {
             case .purchased:
                 onBuyProductHandler?(.success(true))
                 SKPaymentQueue.default().finishTransaction(transaction)
                 
             case .restored:
                 totalRestoredPurchases += 1
                 SKPaymentQueue.default().finishTransaction(transaction)
                 
             case .failed:
                 if let error = transaction.error as? SKError {
                     if error.code != .paymentCancelled {
                         onBuyProductHandler?(.failure(error))
                     } else {
                         onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                     }
                     print("IAP Error:", error.localizedDescription)
                 }
                 SKPaymentQueue.default().finishTransaction(transaction)
                 
             case .deferred, .purchasing: break
             @unknown default: break
             }
         }
     }
     
     
     func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
         if totalRestoredPurchases != 0 {
             onBuyProductHandler?(.success(true))
         } else {
             print("IAP: No purchases to restore!")
             onBuyProductHandler?(.success(false))
         }
     }
     
     
     func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
         if let error = error as? SKError {
             if error.code != .paymentCancelled {
                 print("IAP Restore Error:", error.localizedDescription)
                 onBuyProductHandler?(.failure(error))
             } else {
                 onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
             }
         }
     }
 }




 // MARK: - SKProductsRequestDelegate
 extension IAPManager: SKProductsRequestDelegate {
     func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
         // Get the available products contained in the response.
         let products = response.products

         // Check if there are any products available.
         if products.count > 0 {
             // Call the following handler passing the received products.
             onReceiveProductsHandler?(.success(products))
         } else {
             // No products were found.
             onReceiveProductsHandler?(.failure(.noProductsFound))
         }
     }
     
     
     func request(_ request: SKRequest, didFailWithError error: Error) {
         onReceiveProductsHandler?(.failure(.productRequestFailed))
     }
     
     
     func requestDidFinish(_ request: SKRequest) {
         // Implement this method OPTIONALLY and add any custom logic
         // you want to apply when a product request is finished.
     }
 }




 // MARK: - IAPManagerError Localized Error Descriptions
 extension IAPManager.IAPManagerError: LocalizedError {
     var errorDescription: String? {
         switch self {
         case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
         case .noProductsFound: return "No In-App Purchases were found."
         case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
         case .paymentWasCancelled: return "In-App Purchase process was cancelled."
         }
     }
 }

 */
