import Foundation



class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var token: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var notifyUserIsAuthenticated: Bool = false

    
    func login(){
        
        let defaults = UserDefaults.standard
        
        WebService().login(email: self.email, password: self.password){ result in
            switch result{
                case .success(let token):
                    print("Access token \(token)")
                    defaults.setValue(token, forKey: "accessToken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.notifyUserIsAuthenticated = true
                        self.token = token
                    }
//                    self.token = token
                case .failure(let error):
                    print("Auth problems: \(error.localizedDescription)")
            }
            
        }
    }
    
}
