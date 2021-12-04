import SwiftUI

struct ColorSwitchView: View {
    @ObservedObject var colorSession : ColorMultipeerSession
    var body: some View {
            
        ZStack{
            Image("Nicola")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(2)
                            .edgesIgnoringSafeArea(.all)
                                    
        VStack(alignment: .leading) {
            Text("Connected Devices:")
                .bold()
            Text(String(describing: colorSession.connectedPeers.map(\.displayName)))
            Text(colorSession.stringTaken).onAppear(perform: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            })
            
            Divider()
            Spacer()
            
        }
        .padding()
        .background((colorSession.currentColor.map(\.color) ?? .clear).ignoresSafeArea())
    }
    }
    

}

extension NamedColor {
    var color: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .yellow:
            return .yellow
        }
    }
}

