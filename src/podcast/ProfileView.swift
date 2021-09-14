import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    init(loginVM: LoginViewModel = LoginViewModel()) {
        self.loginVM = loginVM
    }
    
    var body: some View {
        if !loginVM.isAuthenticated{
            LoginView(loginVM: loginVM)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .leading))
        } else{
            LoggedInView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .leading))
        }
    }
}


struct LoginView : View {
    @ObservedObject var loginVM: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Form{
                HStack{
                    Spacer()
                    Image(systemName: loginVM.isAuthenticated ? "lock.open" : "lock.fill")
                }
                TextField("Email", text: $loginVM.email).keyboardType(.emailAddress).autocapitalization(.none)
                SecureField("Password", text: $loginVM.password)
                HStack{
                    Spacer()
                    Button("Login"){
                        loginVM.login()
                    }.alert(isPresented: $loginVM.notifyUserIsAuthenticated) {
                        Alert(
                            title: Text("Got access token"),
                            message: Text("Access token: \(loginVM.token)"),
                            dismissButton: .default(Text("Got it!"))
                        )
                    }
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}



struct LoggedInView : View {
    var body: some View {
        Text("User profile")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
    }
}
