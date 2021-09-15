import Foundation
import KeychainAccess


class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var token: String = ""
    var me: MePayload? = nil

    @Published var isAuthenticated: Bool = false
    @Published var notifyUserIsAuthenticated: Bool = false
    
    @Published var hasLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(hasLoggedIn, forKey: "hasLoggedIn")
        }
    }
    
    
    init() {
        self.hasLoggedIn = UserDefaults.standard.object(forKey: "hasLoggedIn") as? Bool ?? false
        self.checkMe()
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
                    self.hasLoggedIn = true
                }
            case .failure(let err):
                print("CHECK ME: failed: \(err)")
            }
        }
    }
    
}
