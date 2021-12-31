import SwiftUI


class ShareViewModel: ObservableObject {
    @Published var incomingURL: String  = ""
    var allowedDomains: [String] = [
        "youtube.com",
        "youtu.be"
    ]
    
    
    init() {
        if let incomingURL = UIPasteboard.general.string {
            for domain in self.allowedDomains {
                if incomingURL.contains(domain){
                    self.incomingURL = incomingURL
                    break
                }
            }
        }
    }
}
