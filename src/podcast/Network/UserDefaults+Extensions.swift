import Foundation


extension UserDefaults {
    @objc dynamic var hasLoggedIn: Bool {
        return bool(forKey: "hasLoggedIn")
    }
}
