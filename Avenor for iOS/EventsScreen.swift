import SwiftUI

struct EventsScreen: View {
    @EnvironmentObject private var store: AvenorStore
    @State private var showingForm = false
    @State private var eventPendingDeletion: AvenorEvent?
    @State private var showingDeleteConfirmation = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(title: "Calendar", subtitle: Date.now.formatted(date: .complete, time: .omitted))
                    if store.events.isEmpty {
                        Panel { VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: "calendar").font(.title).foregroundStyle(AvenorTheme.accent)
                            Text("No events yet").font(.headline)
                            Text("Add a class, deadline, or something you want to remember.").foregroundStyle(AvenorTheme.muted)
                        }}
                    } else {
                        ForEach(store.events.sorted { $0.date < $1.date }) { event in
                            Panel {
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(event.title).font(.headline)
                                    Text(event.date.formatted(date: .long, time: .omitted)).foregroundStyle(AvenorTheme.muted)
                                    let range = [event.startTime, event.endTime].filter { !$0.isEmpty }.joined(separator: " – ")
                                    if !range.isEmpty { Text(range).font(.subheadline).foregroundStyle(AvenorTheme.accent) }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay(alignment: .topTrailing) {
                                    Button(role: .destructive) {
                                        eventPendingDeletion = event
                                        showingDeleteConfirmation = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.body)
                                            .foregroundStyle(AvenorTheme.red)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("Delete event \(event.title)")
                                    .padding(.leading, 8)
                                }
                            }
                        }
                    }
                }.padding(20)
            }
            .background(AvenorTheme.background.ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { showingForm = true } label: { Image(systemName: "plus") }.accessibilityLabel("Create event") } }
            .sheet(isPresented: $showingForm) { CreateEventSheet() }
            .alert("Delete event permanently?", isPresented: $showingDeleteConfirmation, presenting: eventPendingDeletion) { event in
                Button("Delete Permanently", role: .destructive) {
                    store.deleteEvent(id: event.id)
                    eventPendingDeletion = nil
                }
                Button("Cancel", role: .cancel) {
                    eventPendingDeletion = nil
                }
            } message: { event in
                Text("“\(event.title)” will be removed from Avenor and cannot be recovered.")
            }
        }
    }
}

struct CreateEventSheet: View {
    @EnvironmentObject private var store: AvenorStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var date = Date()
    @State private var start = ""
    @State private var end = ""
    @State private var error = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("Event") {
                    TextField("Title (required)", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Start time (e.g. 3:00 PM)", text: $start)
                    TextField("End time (e.g. 4:00 PM)", text: $end)
                }
                if !error.isEmpty { Text(error).foregroundStyle(.red) }
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") {
                    let clean = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !clean.isEmpty else { error = "Enter an event title."; return }
                    store.addEvent(AvenorEvent(title: clean, date: date, startTime: start, endTime: end))
                    dismiss()
                } }
            }
        }.presentationDetents([.medium, .large])
    }
}
