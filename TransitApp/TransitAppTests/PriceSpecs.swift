//
//  PriceSpecs.swift
//  TransitApp
//

import Quick
import Nimble
@testable import TransitApp

class PriceSpecs: QuickSpec {
    
    override func spec() {
        
        describe("Price") {
            
            var price: Price!
            
            context("initialization") {
                beforeEach {
                    let amount = 100.00
                    let currency = "EUR"
                    
                    price = Price(amount: amount, currency: currency)
                }
                
                it("initializes a new price"){
                    expect(price).toNot(beNil())
                }
                
                it("stores the amount correctly"){
                    expect(price.amount).to(equal(100.00))
                }
                
                
                it("initializes the currency correctly"){
                    let expectedCurrency = "EUR"
                    
                    expect(price.currency).to(equal(expectedCurrency))
                }
                
            }
            
        }
        
    }
    
}
