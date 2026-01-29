//
//  iTRootsTaskApp.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import SwiftUI
import ImperativeNavigation
import Combine

@main
struct LoginApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var localizationManager = LocalizationManager()
    private let coordinator = DefaultAppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationView(controller: coordinator.navigationController, root: {
                RootView(coordinator: coordinator)
            })
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
    let coordinator: AppCoordinator

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainView(viewModel: MainViewModel(coordinator: coordinator), isLoggedIn: .constant(false))
            } else {
                LoginView(viewModel: LoginViewModel(coordinator: coordinator))
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
