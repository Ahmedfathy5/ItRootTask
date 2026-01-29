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
    case tlsError(String)
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
        case .tlsError(let message):
            return "Secure connection error: \(message)"
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
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw NetworkError.serverError("Server returned status code \(http.statusCode)")
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                return posts
            } catch {
                throw NetworkError.decodingError
            }
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .timedOut, .networkConnectionLost:
                throw NetworkError.noInternet
            case .secureConnectionFailed,
                 .serverCertificateUntrusted,
                 .serverCertificateHasBadDate,
                 .serverCertificateHasUnknownRoot,
                 .clientCertificateRejected,
                 .clientCertificateRequired,
                 .cannotLoadFromNetwork:
                throw NetworkError.tlsError("\(urlError.code.rawValue) \(urlError.localizedDescription)")
            default:
                throw NetworkError.unknown
            }
        } catch let netErr as NetworkError {
            throw netErr
        } catch {
            throw NetworkError.unknown
        }
    }
}
