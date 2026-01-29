//
//  FullNameValidator.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

// MARK: - Email Validator
struct EmailValidator {
    static func validate(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func getError(for email: String) -> String? {
        if email.isEmpty {
            return "Email is required"
        }
        
        if !validate(email) {
            return "Please enter a valid email address"
        }
        
        return nil
    }
}

// MARK: - Password Validator
struct PasswordValidator {
    static func validate(_ password: String, minLength: Int = 6) -> Bool {
        return password.count >= minLength
    }
    
    static func validateStrong(_ password: String) -> Bool {
        // At least 8 characters, one uppercase, one lowercase, one number
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func getError(for password: String, requireStrong: Bool = false) -> String? {
        if password.isEmpty {
            return "Password is required"
        }
        
        if requireStrong {
            if password.count < 8 {
                return "Password must be at least 8 characters"
            }
            if !validateStrong(password) {
                return "Password must contain uppercase, lowercase, and number"
            }
        } else {
            if password.count < 6 {
                return "Password must be at least 6 characters"
            }
        }
        
        return nil
    }
}

// MARK: - Full Name Validator
struct FullNameValidator {
    static func validate(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // At least 2 characters, contains at least 2 words
        let components = trimmedName.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        return components.count >= 2 && trimmedName.count >= 2
    }
    
    static func getError(for name: String) -> String? {
        if name.isEmpty {
            return "Full name is required"
        }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.count < 2 {
            return "Name must be at least 2 characters"
        }
        
        let components = trimmedName.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if components.count < 2 {
            return "Please enter your full name (first and last name)"
        }
        
        return nil
    }
}
