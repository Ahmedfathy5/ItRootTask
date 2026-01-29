//
//  UserDefaultService.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let userKey = "logged_in_user"
    private let isLoggedInKey = "is_logged_in"
    
    private init() {}
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
            UserDefaults.standard.set(true, forKey: isLoggedInKey)
        }
    }
    
    func getUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: isLoggedInKey)
    }
}
