import SwiftUI

@main
struct MioFitApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            Auth()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
