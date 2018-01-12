//
//  GoogleMapsSDKInitializer.swift
//  TransitApp
//
import Foundation
import GoogleMaps

class GoogleMapsSDKInitializer {
    
    var state: Bool = false
    
    // MARK: Google maps ios SDK initialization
    
    func doSetup() {
        
        if let key = ApiKeysHelper.sharedInstance.getGoogleMapsSdkApiKey() {
            if !key.isEmpty {
                GMSServices.provideAPIKey(key)
                self.state = true
            }

        }
        
    }
}
