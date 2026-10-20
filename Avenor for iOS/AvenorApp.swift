import SwiftUI

@main
struct AvenorApp: App {
    @StateObject private var store = AvenorStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
