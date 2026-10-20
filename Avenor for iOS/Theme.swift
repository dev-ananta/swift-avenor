import SwiftUI

enum AvenorTheme {
    static let background = Color(red: 8/255, green: 9/255, blue: 11/255)
    static let surface = Color(red: 17/255, green: 19/255, blue: 24/255)
    static let elevated = Color(red: 24/255, green: 27/255, blue: 33/255)
    static let border = Color(red: 41/255, green: 45/255, blue: 53/255)
    static let muted = Color(red: 150/255, green: 155/255, blue: 166/255)
    static let accent = Color(red: 139/255, green: 156/255, blue: 255/255)
    static let green = Color(red: 101/255, green: 214/255, blue: 160/255)
    static let red = Color(red: 255/255, green: 115/255, blue: 115/255)
    static let orange = Color(red: 255/255, green: 184/255, blue: 107/255)
}

struct Panel<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content.padding(16).frame(maxWidth: .infinity, alignment: .leading)
            .background(AvenorTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(AvenorTheme.border, lineWidth: 1))
    }
}

struct ScreenTitle: View {
    let title: String
    var subtitle: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 30, weight: .bold, design: .rounded))
            if let subtitle { Text(subtitle).foregroundStyle(AvenorTheme.muted).font(.subheadline) }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
