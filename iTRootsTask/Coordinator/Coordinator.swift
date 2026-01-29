import SwiftUI
import ImperativeNavigation

// MARK: - Coordinator

//@MainActor
//protocol Coordinator {
//    func navigateToRegister()
//    func navigateToLogin()
//    func navigateToMainView()
//    func navigateToRoot()
//}
//
//// MARK: - Default Coordinator
//
//final class DefaultCoordinator: RoutableCoordinator {
//    enum Route: Hashable {
//        case RegisterView
//        case MainView
//        case LoginView
//    }
//    
//    @Published
//    var path: [Route] = []
//    
//    @Published
//    var modal: ModalRoute<Route>?
//    
//    @ViewBuilder
//    func view(for route: Route) -> some View {
//        switch route {
//        case .LoginView:
//            LoginView(viewModel: LoginViewModel(coordinator: self))
//        case .RegisterView:
//            RegisterView(viewModel: RegisterViewModel(coordinator: self))
//        case .MainView:
//            MainView(viewModel: MainViewModel(coordinator: self), isLoggedIn: .constant(true))
//        }
//    }
//}
//
//extension DefaultCoordinator: Coordinator {
//    func navigateToMainView() {
//        path.append(.MainView)
//    }
//    
//    func navigateToRegister() {
//        path.append(.RegisterView)
//    }
//    
//    func navigateToLogin() {
//        path.append(.LoginView)
//    }
//    
//   
//    
//    func navigateToRoot() {
//        path.removeAll()
//    }
//}


// MARK: - App Coordinator Protocol

@MainActor
protocol AppCoordinator {
    func showRegister()
    func showLogin()
    func showMainView()
    func dismissModal()
    func popToRoot()
}

// MARK: - Coordinator Implementation

@MainActor
final class DefaultAppCoordinator: AppCoordinator {
   
    
    let navigationController = NavigationController()

    // MARK: - AppCoordinator

    func showRegister() {
         navigationController.push(RegisterView(viewModel: RegisterViewModel(coordinator: self)))
    }

    func showLogin() {
         navigationController.push(LoginView(viewModel: LoginViewModel(coordinator: self)))
    }
    
    func showMainView() {
        navigationController.push(MainView(viewModel: MainViewModel(coordinator: self), isLoggedIn: .constant(false)))
    }

    func dismissModal() {
         navigationController.dismiss()
    }

    func popToRoot() {
         navigationController.popToRoot()
    }
}
