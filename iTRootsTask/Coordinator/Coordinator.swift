import SwiftUI
import Combine

// MARK: - Coordinator

@MainActor
protocol Coordinator {
    func navigateToRegister()
    func navigateToLogin()
    func navigateToMainView()
    func navigateToRoot()
}

// MARK: - Default Coordinator

final class DefaultCoordinator: RoutableCoordinator {
    enum Route: Hashable {
        case RegisterView
        case MainView
        case LoginView
    }
    
    @Published
    var path: [Route] = []
    
    @Published
    var modal: ModalRoute<Route>?
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .LoginView:
            LoginView(viewModel: LoginViewModel(coordinator: self))
        case .RegisterView:
            RegisterView(viewModel: RegisterViewModel(coordinator: self))
        case .MainView:
            MainView(viewModel: MainViewModel(coordinator: self), isLoggedIn: .constant(false))
        }
    }
}

extension DefaultCoordinator: Coordinator {
    func navigateToMainView() {
        path.append(.MainView)
    }
    
    func navigateToRegister() {
        path.append(.RegisterView)
    }
    
    func navigateToLogin() {
        path.append(.LoginView)
    }
    
   
    
    func navigateToRoot() {
        path.removeAll()
    }
}
