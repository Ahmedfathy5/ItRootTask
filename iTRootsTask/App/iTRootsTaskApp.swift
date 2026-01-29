//
//  iTRootsTaskApp.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import SwiftUI
import Combine

// MARK: - Main App
@main
struct LoginApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var localizationManager = LocalizationManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environment(\.locale, Locale(identifier: localizationManager.appLanguage))
                .environmentObject(localizationManager)
                .environment(\.layoutDirection,
                              localizationManager.appLanguage == "ar" ? .rightToLeft : .leftToRight
                )

            
        }
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        isLoggedIn = UserDefaultsService.shared.isLoggedIn()
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainView(isLoggedIn: $appState.isLoggedIn)
            } else {
                LoginView()
                    .onAppear {
                        appState.isLoggedIn = false
                    }
            }
        }
        .onAppear {
            appState.checkLoginStatus()
        }
    }
}
