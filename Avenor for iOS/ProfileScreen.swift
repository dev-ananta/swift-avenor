import SwiftUI

struct ProfileScreen: View {
    @State private var showingAbout = false
    @State private var showingPreferences = false
    @State private var notificationsEnabled = false
    @State private var accentStyle = "Lavender"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenTitle(title: "Profile", subtitle: "Make Avenor feel like yours.")
                    Panel {
                        HStack(spacing: 14) {
                            Circle().fill(AvenorTheme.elevated).frame(width: 58, height: 58)
                                .overlay(Image(systemName: "person.fill").font(.title2).foregroundStyle(AvenorTheme.accent))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Avenor Student").font(.headline)
                                Text("Student").font(.subheadline).foregroundStyle(AvenorTheme.muted)
                            }
                        }
                    }
                    Panel {
                        VStack(spacing: 0) {
                            Button { showingPreferences = true } label: { option("Preferences", icon: "slider.horizontal.3") }
                            Divider().overlay(AvenorTheme.border)
                            Toggle(isOn: $notificationsEnabled) { Label("Notifications", systemImage: "bell") }
                                .padding(.vertical, 12).tint(AvenorTheme.accent)
                            Divider().overlay(AvenorTheme.border)
                            Picker(selection: $accentStyle) { Text("Lavender").tag("Lavender"); Text("Green").tag("Green"); Text("Orange").tag("Orange") } label: { Label("Appearance", systemImage: "paintpalette") }
                                .padding(.vertical, 10)
                            Divider().overlay(AvenorTheme.border)
                            Button { showingAbout = true } label: { option("About Avenor", icon: "info.circle") }
                        }
                    }
                    Text("Your planner data stays on this device.").font(.caption).foregroundStyle(AvenorTheme.muted)
                }.padding(20)
            }.background(AvenorTheme.background.ignoresSafeArea())
            .sheet(isPresented: $showingAbout) {
                NavigationStack { VStack(alignment: .leading, spacing: 12) {
                    Text("Avenor").font(.largeTitle.bold())
                    Text("A calm, local-first student planner for tasks, classes, and events.")
                    Text("Version 1.0").foregroundStyle(AvenorTheme.muted)
                    Spacer()
                }.padding(24).background(AvenorTheme.background.ignoresSafeArea())
                    .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showingAbout = false } } }
                }.presentationDetents([.medium])
            }
            .sheet(isPresented: $showingPreferences) {
                NavigationStack { Form {
                    Section("Preferences") {
                        Text("Data is stored locally on this device.")
                        Text("Notification delivery is not implemented in this version.")
                    }
                }.navigationTitle("Preferences")
                    .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showingPreferences = false } } }
                }.presentationDetents([.medium])
            }
        }
    }
    private func option(_ title: String, icon: String) -> some View {
        HStack { Label(title, systemImage: icon); Spacer(); Image(systemName: "chevron.right").font(.caption).foregroundStyle(AvenorTheme.muted) }
            .padding(.vertical, 14).contentShape(Rectangle())
    }
}
