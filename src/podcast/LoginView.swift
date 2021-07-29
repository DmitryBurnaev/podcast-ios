import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVM = LoginViewModel()
    @State private var showAlert = false

    var body: some View {
        VStack{
            Form{
                HStack{
                    Spacer()
                    Image(systemName: "lock.fill")
                }
                TextField("Email", text: $loginVM.email).keyboardType(.emailAddress)
                SecureField("Password", text: $loginVM.password)
                HStack{
                    Spacer()
                    Button("Login"){
                        loginVM.login()
                        showAlert = true
                    }.alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Got access token"),
                            message: Text("Access token: \(loginVM.token)")
                        )
                    }
                    Spacer()
                }
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
