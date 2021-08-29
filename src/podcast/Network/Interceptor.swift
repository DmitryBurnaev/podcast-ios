//
//  Interceptor.swift
//  podcast
//
//  Created by Dmitry Burnaev on 29.08.2021.
//

import Foundation
import Alamofire
import KeychainAccess


class AccessTokenInterceprot: RequestInterceptor{
    private let retryLimit = 5;
    
    func getToken(tokenType: String = "accessToken") -> String?{
        let keychain = Keychain(service: "com.podcast")
        guard let token = try? keychain.get(tokenType) else {
            print("No access token found")
            return nil
        }
        return token
    }

    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let refreshToken = self.getToken(tokenType: "refreshToken") else { return }
        let parameters = ["refresh_token": refreshToken]
        print("Token refreshing ... \(API_URL)/auth/refresh-token/")
        debugPrint(parameters)
        AF.request("\(API_URL)/auth/refresh-token/", method: .post, parameters: parameters, encoder: JSONParameterEncoder()).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
                case .success:
                    guard let data = response.data else {
                        print("\nRefresh token failed: 'No data in response'")
                        debugPrint(response)
                        completion(false)
                        return
                    }
                    guard let response = try? JSONDecoder().decode(ResponstWithTokens.self, from: data) else {
                        print("\nRefresh token failed: 'Unable to decode response JSON'")
                        debugPrint(response)
                        completion(false)
                        return
                    }
                    let keychain = Keychain(service: "com.podcast")
                    do {
                        try keychain.set(response.payload.access_token, key: "accessToken")
                        try keychain.set(response.payload.refresh_token, key: "refreshToken")
                    }
                    catch let error {
                        print("\nCouldn't save access/refresh tokens: \(error)")
                    }
                    completion(true)
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    debugPrint(response)
                    completion(false)
            }
            
        }
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = self.getToken() else { return }
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        print("\nINTERCEPTOR: request adapted; token added to the header field is: \(bearerToken)\n")
        completion(.success(request))
    }
    
        
    func retry(_ request: Request, for session: Session, dueTo error: Error,
                  completion: @escaping (RetryResult) -> Void) {

        print("\n======== Found API error! ======= ")
        print("StatusCode: \(String(describing: request.response?.statusCode)) | error \(error)\n")
        debugPrint(request.response ?? "[empty response]")

        guard request.retryCount < retryLimit else {
            print("Too many retries skip retry actions.")
            completion(.doNotRetry)
            return
        }

        if (request.response?.statusCode == 401){
            let lastRequestURL = request.lastRequest?.url?.absoluteString
            guard let request = request as? DataRequest else { fatalError() }
            print("RETRY: flow (step 1)")
            
            guard let data = request.data else {
                print("RETRY: no data in response found! \(String(describing: request.data))")
                completion(.doNotRetry)
                return
            }
            guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                print("RETRY: no valid response data! \(data)")
                completion(.doNotRetry)
                return
            }
            print("RETRY: status \(errorResponse.status) | \(String(describing: lastRequestURL))")
            if (errorResponse.status == "SIGNATURE_EXPIRED" && !(lastRequestURL?.contains("refresh") ?? false)){
                print("\nretried; retry count: \(request.retryCount) | statusCode \(String(describing: request.response?.statusCode))\n")
                self.refreshToken { isSuccess in
                    isSuccess ? completion(.retry) : completion(.doNotRetry)
                }
            }
            else{
                print("RETRY: was not retried: \(errorResponse.status) != SIGNATURE_EXPIRED")
                completion(.doNotRetry)
            }
        }
        else{
            print("RETRY: Non auth problem. Skip to retry. statusCode \(String(describing: request.response?.statusCode))")
            completion(.doNotRetry)
        }
    }
}
