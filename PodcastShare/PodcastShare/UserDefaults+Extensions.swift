import Foundation


extension UserDefaults {
    @objc dynamic var incomingURL: String {
        return string(forKey: "incomingURL") ?? ""
    }
}
