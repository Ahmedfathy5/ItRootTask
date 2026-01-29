//
//  Product.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

// MARK: - Product Model (for static data)
struct Product: Identifiable {
    let id: String
    let name: String
    let price: Double
    let image: String
    let category: String
    
    init(id: String = UUID().uuidString, name: String, price: Double, image: String, category: String) {
        self.id = id
        self.name = name
        self.price = price
        self.image = image
        self.category = category
    }
}

// MARK: - API Post Model (for online API data)
struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// MARK: - Mock Data
extension Product {
    static let horizontalMockData: [Product] = [
        Product(name: "Premium Headphones", price: 299.99, image: "headphones", category: "Audio"),
        Product(name: "Smart Watch Pro", price: 399.99, image: "applewatch", category: "Wearables"),
        Product(name: "Wireless Earbuds", price: 149.99, image: "airpodspro", category: "Audio"),
        Product(name: "Tablet Ultra", price: 799.99, image: "ipad", category: "Tablets"),
        Product(name: "Gaming Console", price: 499.99, image: "gamecontroller", category: "Gaming")
    ]
    
    static let verticalMockData: [Product] = [
        Product(name: "4K Camera", price: 1299.99, image: "camera", category: "Photography"),
        Product(name: "Laptop Pro", price: 1999.99, image: "laptopcomputer", category: "Computers"),
        Product(name: "Smart Speaker", price: 99.99, image: "homepod", category: "Smart Home"),
        Product(name: "Fitness Tracker", price: 79.99, image: "applewatch", category: "Wearables"),
        Product(name: "Drone Pro", price: 899.99, image: "airplane", category: "Photography"),
        Product(name: "VR Headset", price: 349.99, image: "visionpro", category: "Gaming"),
        Product(name: "Mechanical Keyboard", price: 149.99, image: "keyboard", category: "Accessories"),
        Product(name: "Gaming Mouse", price: 69.99, image: "computermouse", category: "Accessories")
    ]
}
