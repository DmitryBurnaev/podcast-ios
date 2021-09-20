//
//  AuthService.swift
//  podcast
//
//  Created by Dmitry Burnaev on 04.09.2021.
//

import Foundation
import KeychainAccess
import Alamofire


struct ResponstWithTokens: Codable{
    let status: String
    let payload: TokenPayload
}

struct TokenPayload: Codable {
    let accessToken, refreshToken: String
}

struct MePayload: Codable{
    let id: Int
    let email: String
}


class AuthService{
    private let apiManager = APIManager()

    func getToken(tokenType: String = "accessToken") -> String?{
        let keychain = Keychain(service: "com.podcast")
        guard let token = try? keychain.get(tokenType) else {
            print("No access token found")
            return nil
        }
        return token
    }
    
    func setTokens(accessToken: String, refreshToken: String) -> Void{
        let keychain = Keychain(service: "com.podcast")
        do {
            try keychain.set(accessToken, key: "accessToken")
            try keychain.set(refreshToken, key: "refreshToken")
        }
        catch let error {
            print("Couldn't save access/refresh tokens: \(error)")
        }
    }
    
    func me(completion: @escaping (Result<MePayload, NetworkError>) -> Void){
        apiManager.request(
            "/auth/me/",
            completion: { (result: Result<MePayload, ResponseErrorDetails>) in
                switch result {
                case .success(let me):
                    print("API: got me from response: \(me)")
                    completion(.success(me))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        )
    }
    
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        apiManager.request(
            "/auth/sign-in/",
            method: .post,
            parameters: ["email": email, "password": password],
            completion: { (result: Result<TokenPayload, ResponseErrorDetails>) in
                switch result {
                case .success(let tokenPayload):
                    let accessToken = tokenPayload.accessToken
                    let refreshToken = tokenPayload.refreshToken
                    let keychain = Keychain(service: "com.podcast")
                    do {
                        try keychain.set(accessToken, key: "accessToken")
                        try keychain.set(refreshToken, key: "refreshToken")
                    }
                    catch let error {
                        print("Couldn't save access/refresh tokens: \(error)")
                    }
                    completion(.success(accessToken))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.custom(errorMessage: err.description)))
                }
            }
        )
    }
    

    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let refreshToken = self.getToken(tokenType: "refreshToken") else { return }
        let parameters = ["refresh_token": refreshToken]
        print("Token refreshing ... \(API_URL)/auth/refresh-token/ | params: \(parameters)")

        apiManager.request(
            "/auth/refresh-token/",
            method: .post,
            parameters: parameters,
            completion: { (result: Result<TokenPayload, ResponseErrorDetails>) in
                switch result {
                case .success(let tokenPayload):
                    self.setTokens(accessToken: tokenPayload.accessToken, refreshToken: tokenPayload.refreshToken)
                    completion(true)
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(false)
                }
            }
        )

    }

    
}
