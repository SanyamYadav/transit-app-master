//
//  NSTimeInterval+Extension.swift
//  TransitApp
//
import Foundation

extension NSTimeInterval {
    var stringValueInMinutes: String {
        let interval = Int(self)
        let minutes = (interval / 60) % 60
        return String(format: "%02d min", minutes)
    }
}
