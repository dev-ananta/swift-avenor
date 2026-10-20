import SwiftUI

struct ClassesScreen: View {
    @EnvironmentObject private var store: AvenorStore
    @State private var showingForm = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(title: "Classes", subtitle: "Your school day, organized.")
                    if store.classes.isEmpty {
                        Panel { VStack(alignment: .leading, spacing: 8) {
                            Text("No classes added").font(.headline)
                            Text("Add a class to keep teacher and room details together.").foregroundStyle(AvenorTheme.muted)
                        }}
                    } else {
                        ForEach(store.classes) { item in
                            Panel {
                                HStack(spacing: 14) {
                                    RoundedRectangle(cornerRadius: 12).fill(AvenorTheme.elevated).frame(width: 48, height: 48)
                                        .overlay(Image(systemName: "book.closed.fill").foregroundStyle(AvenorTheme.accent))
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.name).font(.headline)
                                        if !item.teacher.isEmpty { Text(item.teacher).font(.subheadline).foregroundStyle(AvenorTheme.muted) }
                                        if !item.room.isEmpty { Text("Room \(item.room)").font(.caption).foregroundStyle(AvenorTheme.muted) }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }.padding(20)
            }
            .background(AvenorTheme.background.ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { showingForm = true } label: { Image(systemName: "plus") }.accessibilityLabel("Create class") } }
            .sheet(isPresented: $showingForm) { CreateClassSheet() }
        }
    }
}

struct CreateClassSheet: View {
    @EnvironmentObject private var store: AvenorStore
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var teacher = ""
    @State private var room = ""
    @State private var error = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("Class") {
                    TextField("Class name (required)", text: $name)
                    TextField("Teacher", text: $teacher)
                    TextField("Room", text: $room)
                }
                if !error.isEmpty { Text(error).foregroundStyle(.red) }
            }
            .navigationTitle("New Class")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") {
                    let clean = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !clean.isEmpty else { error = "Enter a class name."; return }
                    store.addClass(AvenorClass(name: clean, teacher: teacher, room: room))
                    dismiss()
                } }
            }
        }.presentationDetents([.medium, .large])
    }
}
