//
//  Routes.swift
//  TransitApp
//
//

import Foundation
import Unbox

struct Routes: Unboxable {
    let routes: [Route]
    
    init(withRoutes routes: [Route]){
        self.routes = routes
    }
    
    init(unboxer: Unboxer) {
        self.routes = unboxer.unbox("routes")
    }
}
