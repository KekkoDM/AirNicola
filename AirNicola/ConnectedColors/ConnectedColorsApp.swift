import SwiftUI

@main
struct ConnectedColorsApp: App {
    @StateObject var colorSession = ColorMultipeerSession()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ColorSwitchView(colorSession: colorSession)
        }
    }
}
