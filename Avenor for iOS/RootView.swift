import SwiftUI

enum Destination: String, CaseIterable {
    case home = "Home", tasks = "Tasks", calendar = "Calendar", classes = "Classes", profile = "Profile"
    var symbol: String {
        switch self {
        case .home: return "house.fill"
        case .tasks: return "checklist"
        case .calendar: return "calendar"
        case .classes: return "books.vertical.fill"
        case .profile: return "person.crop.circle"
        }
    }
}

struct RootView: View {
    @State private var selected: Destination = .home
    var body: some View {
        TabView(selection: $selected) {
            HomeScreen().tabItem { Label("Home", systemImage: Destination.home.symbol) }.tag(Destination.home)
            TasksScreen().tabItem { Label("Tasks", systemImage: Destination.tasks.symbol) }.tag(Destination.tasks)
            EventsScreen().tabItem { Label("Calendar", systemImage: Destination.calendar.symbol) }.tag(Destination.calendar)
            ClassesScreen().tabItem { Label("Classes", systemImage: Destination.classes.symbol) }.tag(Destination.classes)
            ProfileScreen().tabItem { Label("Profile", systemImage: Destination.profile.symbol) }.tag(Destination.profile)
        }
        .tint(AvenorTheme.accent)
        .background(AvenorTheme.background)
    }
}
