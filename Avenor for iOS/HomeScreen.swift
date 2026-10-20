import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var store: AvenorStore
    private var active: [AvenorTask] { store.tasks.filter { !$0.completed } }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ScreenTitle(title: "Avenor", subtitle: "A little progress, every day.")
                    HStack(spacing: 10) {
                        metric("Active", value: active.count, color: AvenorTheme.accent)
                        metric("Events", value: store.events.count, color: AvenorTheme.orange)
                        metric("Done", value: store.tasks.filter(\.completed).count, color: AvenorTheme.green)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Focus Now").font(.title2.bold())
                        if let task = active.first {
                            Panel {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(task.title).font(.headline)
                                    if !task.details.isEmpty { Text(task.details).foregroundStyle(AvenorTheme.muted) }
                                    Button { store.toggle(task) } label: {
                                        Label("Mark complete", systemImage: "checkmark.circle")
                                    }.buttonStyle(.borderedProminent).tint(AvenorTheme.accent)
                                }
                            }
                        } else {
                            Panel { Label("You're all caught up. Add a task when you're ready.", systemImage: "sparkles").foregroundStyle(AvenorTheme.muted) }
                        }
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming tasks").font(.title2.bold())
                        if active.isEmpty {
                            Text("Your active tasks will appear here.").foregroundStyle(AvenorTheme.muted)
                        } else {
                            ForEach(active.prefix(4)) { task in
                                Panel {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(task.title).font(.headline)
                                            Text("\(task.priority.rawValue) priority · \(task.estimatedMinutes) min").font(.caption).foregroundStyle(AvenorTheme.muted)
                                        }
                                        Spacer()
                                        Circle().fill(task.priority == .high ? AvenorTheme.red : task.priority == .medium ? AvenorTheme.orange : AvenorTheme.green).frame(width: 8, height: 8)
                                    }
                                }
                            }
                        }
                    }
                }.padding(20)
            }
            .background(AvenorTheme.background.ignoresSafeArea())
        }
    }
    private func metric(_ label: String, value: Int, color: Color) -> some View {
        Panel {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(value)").font(.system(size: 26, weight: .bold))
                Text(label).font(.caption).foregroundStyle(AvenorTheme.muted)
            }.foregroundStyle(color)
        }
    }
}
