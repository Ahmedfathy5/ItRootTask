//
//  User.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

struct User: Codable {
    let id: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let password: String
    
    init(id: String, fullName: String, email: String, phoneNumber: String, password: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
    }
}
