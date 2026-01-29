//
//  MainViewModel.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    private let coordinator: AppCoordinator
    @Published var selectedTab: Int = 0
    @Published var posts: [Post] = []
    @Published var isLoadingPosts: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    let horizontalProducts = Product.horizontalMockData
    let verticalProducts = Product.verticalMockData
    
    private let apiService = APIService.shared
    
    var currentUser: User? {
        UserDefaultsService.shared.getUser()
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        Task {
            try await fetchPosts()
        }
    }
    
    @MainActor
    func fetchPosts() async throws{
        isLoadingPosts = true
        errorMessage = nil
        
        do {
            let fetchedPosts = try await apiService.fetchPosts()
            self.posts = fetchedPosts
            print("Successfully fetched and assigned \(fetchedPosts.count) posts to view model")
        } catch {
            // Surface the error to the UI
            if let netErr = error as? NetworkError {
                self.errorMessage = netErr.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
            self.posts = []
            self.showError = true
            print("Failed to fetch posts: \(self.errorMessage ?? "Unknown error")")
        }
        isLoadingPosts = false
        print("Fetch posts completed. Posts count: \(posts.count)")
    }
    
    func retryFetch() {
        print("Retrying fetch...")
        Task {
            try await fetchPosts()
        }
    }
    
    func logout() {
        UserDefaultsService.shared.logout()
        coordinator.popToRoot()
    }
}

