//
//  APIService.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternet
    case decodingError
    case serverError(String)
    case respones
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternet:
            return "No internet connection. Please check your network settings."
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        case .unknown:
            return "An unknown error occurred"
        case .respones:
            return  "Error with the response"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
            
        } catch {
            print("error is \(error.localizedDescription)")
            return []
        }
    }
}
