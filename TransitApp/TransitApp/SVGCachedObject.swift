//
//  SVGCachedObject.swift
//  TransitApp
//
//

import Foundation


class SVGCachedObject {
    var data: NSData
    var fileName: String
    
    init(data: NSData, fileName: String){
        self.data = data
        self.fileName = fileName
    }
}
