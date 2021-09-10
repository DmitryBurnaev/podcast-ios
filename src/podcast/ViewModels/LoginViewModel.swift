import Foundation
import KeychainAccess


class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var token: String = ""

    @Published var isAuthenticated: Bool = false
    @Published var notifyUserIsAuthenticated: Bool = false
       
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
    
}
