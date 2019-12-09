//
//  ViewModel.swift
//  FakeGame
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation
import StoreKit

protocol ViewModelDelegate {
    func toggleOverlay(shouldShow: Bool)
    func willStartLongProcess()
    func didFinishLongProcess()
    func showIAPRelatedError(_ error: Error)
    func shouldUpdateUI()
    func didFinishRestoringPurchasesWithZeroProducts()
    func didFinishRestoringPurchasedProducts()
}


class ViewModel {
    
    // MARK: - Properties
    
    var delegate: ViewModelDelegate?
    
    private let model = Model()
    
    
    
    // MARK: - Init
        
    init() {

    }
    
    
    // MARK: - Fileprivate Methods
    
//    fileprivate func updateGameDataWithPurchasedProduct(_ product: SKProduct) {
//        // Update the proper game data depending on the keyword the
//        // product identifier of the give product contains.
//        if product.productIdentifier.contains("extra_lives") {
//            model.gameData.extraLives = 3
//        } else if product.productIdentifier.contains("superpowers") {
//            model.gameData.superPowers = 2
//        } else {
//            model.gameData.didUnlockAllMaps = true
//        }
//
//        // Store changes.
//        _ = model.gameData.update()
//
//        // Ask UI to be updated and reload the table view.
//        delegate?.shouldUpdateUI()
//    }
    
    
    // MARK: - Internal Methods
    
    func getProductForItem(at index: Int) -> SKProduct? {
        // Search for a specific keyword depending on the index value.
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
        print("The index called ")
        // Check if there is a product fetched from App Store containing
        // the keyword matching to the selected item's index.
        guard let product = model.getProduct(containing: keyword) else {
            print("Keyword product search returned NIL")
            return nil
        }
        return product
    }
    
    
    
    // MARK: - Methods To Implement
    
    func viewDidSetup() {
        delegate?.willStartLongProcess()
        print("tester Setup")
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                self.delegate?.didFinishLongProcess()
                
                switch result {
                    case .success(let products): self.model.products = products
                    case .failure(let error): self.delegate?.showIAPRelatedError(error)
                }
            }
        }
    }
    
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            delegate?.willStartLongProcess()
            
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    self.delegate?.didFinishLongProcess()

//                    switch result {
//                    case .success(_): self.updateGameDataWithPurchasedProduct(product)
//                    case .failure(let error): self.delegate?.showIAPRelatedError(error)
//                    }
                }
            }
        }

        return true
    }
    
    /*   //NOT NECESSARY BECAUSE NO RESTORES. FOR NOW
    func restorePurchases() {
        delegate?.willStartLongProcess()
        IAPManager.shared.restorePurchases { (result) in
            DispatchQueue.main.async {
                self.delegate?.didFinishLongProcess()

                switch result {
                case .success(let success):
                    if success {
                        self.delegate?.didFinishRestoringPurchasedProducts()
                    } else {
                        self.delegate?.didFinishRestoringPurchasesWithZeroProducts()
                    }

                case .failure(let error): self.delegate?.showIAPRelatedError(error)
                }
            }
        }
    }
    */
}
