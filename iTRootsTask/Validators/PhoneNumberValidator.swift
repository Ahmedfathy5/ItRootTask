//
//  PhoneNumberValidator.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

public protocol PhoneNumberValidator {
    static func validate(_ phoneNumber: String) -> Bool
    static func format(_ phoneNumber: String) -> String
}

public struct EgyptionPhoneNumberValidator: PhoneNumberValidator {
    
    public static func validate(_ phoneNumber: String) -> Bool {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard cleanedNumber.count == 11 else {
            return false
        }
        
        guard cleanedNumber.hasPrefix("01") else {
            return false
        }
        
        let thirdDigit = cleanedNumber[cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 2)]
        let validThirdDigits: Set<Character> = ["0", "1", "2", "5"]
        
        return validThirdDigits.contains(thirdDigit)
    }
    
    public static func format(_ phoneNumber: String) -> String {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard cleanedNumber.count == 11 else {
            return phoneNumber
        }
        
        let start = cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 0)
        let firstPart = cleanedNumber[start..<cleanedNumber.index(start, offsetBy: 4)]
        let secondPart = cleanedNumber[cleanedNumber.index(start, offsetBy: 4)..<cleanedNumber.index(start, offsetBy: 7)]
        let thirdPart = cleanedNumber[cleanedNumber.index(start, offsetBy: 7)..<cleanedNumber.index(start, offsetBy: 11)]
        
        return "\(firstPart) \(secondPart) \(thirdPart)"
    }
}
