import Foundation



class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    
    func login(){
        WebService().login(email: self.email, password: self.password){ result in
            switch result{
                case .success(let token):
                    print("Access token \(token)")
                case .failure(let error):
                    print("Auth problems: \(error.localizedDescription)")
            }
            
        }
    }
    
}
