import Combine
import SwiftUI

enum MioScreens: Hashable {
    case login
    case home
}

@MainActor
final class MioState: ObservableObject {
    @Published var isAuth = false
    func login() {
        isAuth = true
    }
    func logout() {
        isAuth = false
    }
}

@MainActor
final class MioRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ screen: MioScreens) {
        path.append(screen)
    }
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    func popToRoot() {
        path = NavigationPath()
    }
}

@MainActor
final class MioCoordinator: ObservableObject {
    private let router: MioRouter
    private let currState: MioState
    init(router: MioRouter, currState: MioState) {
        self.router = router
        self.currState = currState
    }
    func successLogin() {
        currState.login( )
    }
}


