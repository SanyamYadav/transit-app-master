//
//  DataProvider.swift
//  TransitApp
//
import Foundation
import Unbox

/**
 A data provider that currently serves only fake data provided via a json file.
*/
struct DataProvider {
    
    func searchForRoutes() -> Routes? {
        var routes: Routes?
        
        if let dataPath = NSBundle.mainBundle().pathForResource("data", ofType: "json") {
            if let data = NSData(contentsOfFile: dataPath) {
                routes = Unbox(data)
            }
        }
        
        return routes
    }
    
}
