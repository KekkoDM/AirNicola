import MultipeerConnectivity
import os
import AVFAudio
import AVFoundation

enum NamedColor: String, CaseIterable {
    case red, green, yellow
}

class ColorMultipeerSession: NSObject, ObservableObject {
    private let serviceType = "nicola"
    private var audioPlayer = AVAudioPlayer()
    private let session: MCSession
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser: MCNearbyServiceBrowser
    private let log = Logger()

    @Published var currentColor: NamedColor? = nil
    @Published var connectedPeers: [MCPeerID] = []
     @Published var stringTaken: String = ""
    @Published var audioTaken: String = ""

    override init() {
        precondition(Thread.isMainThread)
        self.session = MCSession(peer: myPeerId)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)

        super.init()

        session.delegate = self
        serviceBrowser.delegate = self

        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        self.serviceBrowser.stopBrowsingForPeers()
    }

}

extension ColorMultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
    }
}

extension ColorMultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.debugDescription)")
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        if let string = String(data: data, encoding: .utf8) {
//            log.info("didReceive color \(string)")
//            DispatchQueue.main.async {
//                self.stringTaken = string
//                print(self.stringTaken)
//
//
//            }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        print("dio delle città")
            try? audioPlayer = AVAudioPlayer(data: data)
        audioPlayer.play()
       
        nicolamannaccia(audioPlayer: audioPlayer)
        
    }


    func nicolamannaccia(audioPlayer: AVAudioPlayer){
        
        let content = UNMutableNotificationContent()
        content.title = "Feed the Nicola"
        content.subtitle = "It looks hungry"
        content.sound = UserNotifications.UNNotificationSound.default

        // show this notification five seconds from now
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger1)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)

    }
    
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }

    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }

    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
    
   
}

extension MCSessionState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .notConnected:
            return "notConnected"
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        @unknown default:
            return "\(rawValue)"
        }
    }
}
