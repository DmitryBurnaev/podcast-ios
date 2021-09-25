import Foundation
import KeychainAccess


class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var token: String = ""
    var me: MePayload? = nil
    var observer: NSKeyValueObservation?

    @Published var isAuthenticated: Bool = false
    @Published var notifyUserIsAuthenticated: Bool = false
    @Published var hasLoggedIn: Bool  = false
        
    init() {
        self.observer = UserDefaults.standard.observe(\.hasLoggedIn, options: [.initial, .new]) { (observed, change) in
            print("something changed change (new value): \(String(describing: change.newValue)) | observed: \(observed)")
            DispatchQueue.main.async {
                self.hasLoggedIn = change.newValue ?? false
            }
        }
        self.checkMe()
    }
    
    deinit {
        observer?.invalidate()
    }

    func login(){
        AuthService().login(email: self.email, password: self.password){ result in
            switch result{
                case .success(let token):
                    print("Access token \(token)")

                    let keychain = Keychain(service: "com.podcast")
                    do {
                        try keychain.set(token, key: "accessToken")
                    }
                    catch let error {
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.notifyUserIsAuthenticated = true
                        self.token = token
                        UserDefaults.standard.set(true, forKey: "hasLoggedIn")
                    }
                case .failure(let error):
                    print("Auth problems: \(error.localizedDescription)")
            }
        }
    }
    
    func checkMe(){
        AuthService().me{ result in
            switch result{
            case .success(let mePayload):
                print("CHECK ME: Got ME payload (checkMe) \(mePayload)")
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.me = mePayload
                    UserDefaults.standard.set(true, forKey: "hasLoggedIn")
                }
            case .failure(let err):
                print("CHECK ME: failed: \(err)")
            }
        }
    }
    
}
