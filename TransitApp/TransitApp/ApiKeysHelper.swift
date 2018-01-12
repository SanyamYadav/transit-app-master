//
//  ApiKeysHelper.swift
//  TransitApp
//

import Foundation

/**
This class interacts with Keys/keys.plist and retrieve values from it
*/
class ApiKeysHelper {
    
    static let sharedInstance = ApiKeysHelper()
    
    // MARK: Keys dictionary
    var keys: NSDictionary?
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
            self.keys = NSDictionary(contentsOfFile: path)
        }
    }
    
    
    /**
     The key could not be present or informed in the dictionary
    */
    func getGoogleMapsSdkApiKey() -> String? {
        if let keys = self.keys {
           return keys["googleMapsApiKey"] as? String
        }
        
        return nil
    }
    
}
