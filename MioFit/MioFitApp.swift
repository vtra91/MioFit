import SwiftUI

@main
struct MioFitApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var router: MioRouter
    @StateObject private var coordinator: MioCoordinator

    @StateObject var currState = MioState()

    var body: some Scene {

//TODO: починить корявое отображение анимации (transition не работает)
        
        WindowGroup {
            Group {
                    if currState.isAuth {
                        NavigationStack(path: $router.path.animation(.linear(duration: 0))) {
                            ClientsListView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)
                                ))
                                .navigationDestination(for: MioScreens.self) { currScreen in
                                    switch currScreen {
                                    case MioScreens.home: ClientsListView()
                                    case MioScreens.login: Auth()
                                    }
                                }
                        }
                    } else {
                        Auth()
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    }
            }
            
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .environmentObject(coordinator)
        }
    }
    init() {
            let tempRouter = MioRouter()
            let tempState = MioState()
            let tempCoordinator = MioCoordinator(router: tempRouter, currState: tempState)
            
            self._router = StateObject(wrappedValue: tempRouter)
            self._currState = StateObject(wrappedValue: tempState)
            self._coordinator = StateObject(wrappedValue: tempCoordinator)
        }
}
