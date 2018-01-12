//
//  ErrorHelper.swift
//  TransitApp
//
import Foundation

enum TransitAppError: ErrorType {
    case JSONDecodingError(errorMessage:String)
}
