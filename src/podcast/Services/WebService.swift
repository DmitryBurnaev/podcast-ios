import Foundation


enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginRequestBody: Codable{
    let email: String
    let password: String
}

struct LoginResponseBody: Codable{
    let status: String
    let payload: TokenPayload
}

struct TokenPayload: Codable {
    let access_token, refresh_token: String
}


class WebService{
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        guard let url = URL(string: "http://192.168.1.6:8001/api/auth/sign-in/") else {
            return
        }
        let body = LoginRequestBody(email: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request){ (data, resp, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data in response")))
                return
            }
            guard let loginResponse = try? JSONDecoder().decode(LoginResponseBody.self, from: data) else {
                completion(.failure(.custom(errorMessage: "Unable to decode response JSON")))
                return
            }
//            TODO: Support not 200 status
//            guard let token = loginResponse.payload.access_token else {
//                completion(.failure(.invalidCredentials))
//                return
//            }
            let token = loginResponse.payload.access_token
            completion(.success(token))
            
        }.resume()
        
        
        
    }
}
