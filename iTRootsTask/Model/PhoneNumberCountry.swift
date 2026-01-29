//
//  PhoneNumberCountry.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

public struct PhoneNumberCountry: Identifiable, Sendable {
    public var id: String { code }

    public let name: String
    public let flag: String
    public let code: String
    public let dial_code: String
    public let phoneLength: Int
    public let validator: PhoneNumberValidator.Type

    public init(
        name: String,
        flag: String,
        code: String,
        dial_code: String,
        phoneLength: Int,
        validator: PhoneNumberValidator.Type
    ) {
        self.name = name
        self.flag = flag
        self.code = code
        self.dial_code = dial_code
        self.phoneLength = phoneLength
        self.validator = validator
    }
}

extension PhoneNumberCountry: Equatable {
    public static func == (lhs: PhoneNumberCountry, rhs: PhoneNumberCountry) -> Bool {
        lhs.code == rhs.code && lhs.dial_code == rhs.dial_code
    }
}

public extension PhoneNumberCountry {
    static var all: [PhoneNumberCountry] {
        [.egypt]
    }

    static var egypt: PhoneNumberCountry {
        PhoneNumberCountry(
            name: "Egypt",
            flag: "🇪🇬",
            code: "EG",
            dial_code: "+20",
            phoneLength: 11,
            validator: EgyptionPhoneNumberValidator.self
        )
    }
}
