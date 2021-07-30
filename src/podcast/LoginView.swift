import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVM = LoginViewModel()

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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
