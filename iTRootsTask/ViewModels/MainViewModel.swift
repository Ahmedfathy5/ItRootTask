//
//  MainViewModel.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation
import Combine

// MARK: - Main View Model
class MainViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTab: Int = 0
    @Published var posts: [Post] = []
    @Published var isLoadingPosts: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // Static data
    let horizontalProducts = Product.horizontalMockData
    let verticalProducts = Product.verticalMockData
    
    // MARK: - Properties
    private let apiService = APIService.shared
    
    // MARK: - Current User
    var currentUser: User? {
        UserDefaultsService.shared.getUser()
    }
    
    // MARK: - Initialization
    init() {
        Task {
          try await fetchPosts()
        }
    }
    
    // MARK: - Fetch Posts
    @MainActor
    func fetchPosts() async throws{
        isLoadingPosts = true
        errorMessage = nil
        
        do {
            let fetchedPosts = try await apiService.fetchPosts()
            self.posts = fetchedPosts
            print("✅ Successfully fetched and assigned \(fetchedPosts.count) posts to view model")
        } catch {
            
        }
        isLoadingPosts = false
        print("🏁 Fetch posts completed. Posts count: \(posts.count)")
    }
    
    // MARK: - Retry Fetch
    func retryFetch() {
        print("🔄 Retrying fetch...")
        Task {
           try await fetchPosts()
        }
    }
    
    // MARK: - Logout
    func logout() {
        UserDefaultsService.shared.logout()
        
        print("👋 User logged out")
    }
}
