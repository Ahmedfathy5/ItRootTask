//
//  MainView.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import SwiftUI

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: MainViewModel
    @Binding var isLoggedIn: Bool
    
    init(viewModel: MainViewModel, isLoggedIn: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isLoggedIn = isLoggedIn
    }
    
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            HomeTabView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            PostsTabView(viewModel: viewModel)
                .tabItem {
                    Label("Posts", systemImage: "list.bullet")
                }
                .tag(1)
        }
        .accentColor(.blue)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.logout()
                    isLoggedIn = false
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct HomeTabView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    // User Greeting
                    if let user = viewModel.currentUser {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Welcome back,")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(user.fullName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Featured Products")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.horizontalProducts) { product in
                                    HorizontalProductCard(product: product)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("All Products")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.verticalProducts) { product in
                                VerticalProductCard(product: product)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Home")
        
    }
}

struct HorizontalProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: product.image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct VerticalProductCard: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: product.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct PostsTabView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
  
            ZStack {
                if viewModel.isLoadingPosts {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading posts...")
                            .foregroundColor(.gray)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    NoInternetView(
                        errorMessage: errorMessage,
                        retryAction: {
                            viewModel.retryFetch()
                        }
                    )
                } else {
                    List(viewModel.posts) { post in
                        PostRowView(post: post)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        try? await viewModel.fetchPosts()
                    }
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            try  await viewModel.fetchPosts()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoadingPosts)
                }
            }
        }
}

struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.blue)
                Text("User \(post.userId)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("#\(post.id)")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(post.body)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct NoInternetView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
            
            Text("Connection Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .padding()
    }
}
