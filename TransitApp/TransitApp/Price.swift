//
//  Price.swift
//  TransitApp
//
//

import Foundation
import Unbox

//Not need to be a class here, a struct will be fine
struct Price: Unboxable {
    
    var amount: Double
    var currency: String
    
    init(amount: Double, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    
    init(unboxer: Unboxer) {
        self.amount = unboxer.unbox("amount")
        self.currency = unboxer.unbox("currency")
    }
    
}
