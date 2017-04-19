//
//  IAPViewModel.swift
//  Real News
//
//  Created by PC on 4/19/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit

enum RegisteredPurchase: String {
    case autoRenewablePurchase = "s1"
}
enum SharedSecret:String{
    case autoRenewablePurchase = "2389de57454c4f55b1dd9405511b040c"
}
func IAPcompleteTransaction(){
    SwiftyStoreKit.completeTransactions(atomically: true) { products in
        
        for product in products {
            
            if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
        }
    }
}
func getInfo(_ purchase: RegisteredPurchase,self:StoriesViewController) {
    
    SwiftyStoreKit.retrieveProductsInfo([purchase.rawValue]) { result in
        showAlert(alertForProductRetrievalInfo(result,self: self),self: self)
    }
}
func alertForProductRetrievalInfo(_ result: RetrieveResults,self:StoriesViewController) -> UIAlertController {
    
    if let product = result.retrievedProducts.first {
        let priceString = product.localizedPrice!
        let alert = UIAlertController(title: product.localizedTitle, message: product.localizedDescription + " "+priceString+" per year", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { alert in
            purchase(.autoRenewablePurchase,self: self)
        }))
        alert.addAction(UIAlertAction(title: "Restore Purchase", style: .default, handler: { alert in
            restorePurchases(self: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    } else if let invalidProductId = result.invalidProductIDs.first {
        return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
    } else {
        let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
        return alertWithTitle("Could not retrieve product info", message: errorString)
    }
}


func purchase(_ purchase: RegisteredPurchase,self:StoriesViewController) {
    
    SwiftyStoreKit.purchaseProduct(purchase.rawValue, atomically: true) { result in
        
        if case .success(let product) = result {
            if product.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(product.transaction)
            }
        }
        if let alert = alertForPurchaseResult(result, self: self) {
            showAlert(alert,self: self)
        }
    }
}

func alertForPurchaseResult(_ result: PurchaseResult,self:StoriesViewController) -> UIAlertController? {
    switch result {
    case .success( _):
        verifyPurchase(.autoRenewablePurchase,self: self)
        return nil
    case .error(let error):
        print("Purchase Failed: \(error)")
        switch error.code {
        case .unknown: return alertWithTitle("Purchase failed", message: "Unknown error. Please contact support")
        case .clientInvalid: // client is not allowed to issue the request, etc.
            return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
        case .paymentCancelled: // user cancelled the request, etc.
            return nil
        case .paymentInvalid: // purchase identifier was invalid, etc.
            return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
        case .paymentNotAllowed: // this device is not allowed to make the payment
            return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
        case .storeProductNotAvailable: // Product is not available in the current storefront
            return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
        case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
            return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
            return alertWithTitle("Purchase failed", message: "Could not connect to the network")
        case .cloudServiceRevoked: // user has revoked permission to use this cloud service
            return alertWithTitle("Purchase failed", message: "Could service was revoked")
        }
    }
}

func restorePurchases(self:StoriesViewController) {
    
    SwiftyStoreKit.restorePurchases(atomically: true) { results in
        
        for product in results.restoredProducts where product.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(product.transaction)
        }
        guard let alert = alertForRestorePurchases(results,self: self) else{
            return
        }
        showAlert(alert, self: self)
    }
}
func alertForRestorePurchases(_ results: RestoreResults,self:StoriesViewController) -> UIAlertController? {
    
    if results.restoreFailedProducts.count > 0 {
        print("Restore Failed: \(results.restoreFailedProducts)")
        return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
    } else if results.restoredProducts.count > 0 {
        verifyPurchase(.autoRenewablePurchase, self:self)
        return nil
    } else {
        print("Nothing to Restore")
        return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
    }
}


func verifyReceipt() {
    
    let appleValidator = AppleReceiptValidator(service: .production)
    SwiftyStoreKit.verifyReceipt(using: appleValidator, password: SharedSecret.autoRenewablePurchase.rawValue) { result in
        switch result {
        case .success(_):
            StoriesViewController.purchased.value = true
        default: return
        }
        
    }
}

func verifyPurchase(_ purchase: RegisteredPurchase,self:StoriesViewController?){
    
    let appleValidator = AppleReceiptValidator(service: .production)
    SwiftyStoreKit.verifyReceipt(using: appleValidator, password: SharedSecret.autoRenewablePurchase.rawValue) { result in
        
        switch result {
        case .success(let receipt):
            
            let productId = purchase.rawValue
            
            switch purchase {
            case .autoRenewablePurchase:
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    type: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt,
                    validUntil: Date()
                )
                let alert = alertForVerifySubscription(purchaseResult)
                guard let unwrappedself = self else{
                    return
                }
                showAlert(alert, self: unwrappedself)
            }
            
        case .error(let error):
            if case .noReceiptData = error {
                SwiftyStoreKit.refreshReceipt { result in
                    switch result{
                    case .success(receiptData: _): verifyPurchase(.autoRenewablePurchase, self: self)
                    default: break
                    }
                }
            }
        }
    }
}



func alertWithTitle(_ title: String, message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return alert
}

func showAlert(_ alert: UIAlertController,self:StoriesViewController) {
        self.present(alert, animated: true, completion: nil)
}


func alertForVerifySubscription(_ result: VerifySubscriptionResult) -> UIAlertController {
    
    switch result {
    case .purchased(let expiresDate):
        StoriesViewController.purchased.value = true
            return alertWithTitle("You are subscribed!", message: "Subscription is valid until \(expiresDate)")
    case .expired(let expiresDate):
        return alertWithTitle("Product expired", message: "Product is expired since \(expiresDate)")
    case .notPurchased:
        return alertWithTitle("Not purchased", message: "This product has never been purchased")
    }
}
    
