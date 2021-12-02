import Foundation
import Alamofire
import KeychainAccess


class AccessTokenInterceptor: RequestInterceptor{
    private let retryLimit = 5;

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        let accessToken = AuthService().getToken()
        if (accessToken != nil){
            let bearerToken = "Bearer \(accessToken!)"
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            print("\nINTERCEPTOR: request adapted; token added to the header field is: \(bearerToken)\n")
        } else {
            print("\nINTERCEPTOR: No access token found (skip header adding)\n")
        }
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error,
                  completion: @escaping (RetryResult) -> Void) {

        print("\n======== Found API error! ======= ")
        print("RETRY: StatusCode: \(String(describing: request.response?.statusCode)) | error \(error)\n")
        debugPrint(request.response ?? "[empty response]")

        guard request.retryCount < retryLimit else {
            print("RETRY: Too many retries skip retry actions.")
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
                
                AuthService().refreshToken{isSuccess in
                    isSuccess ? completion(.retry) : completion(.doNotRetry)
                }
            }
            else{
                print("RETRY: was not retried: \(errorResponse.status) != SIGNATURE_EXPIRED")
                UserDefaults.standard.set(false, forKey: "hasLoggedIn")
                completion(.doNotRetry)
            }
        }
        else{
            print("RETRY: Non auth problem. Skip to retry. statusCode \(String(describing: request.response?.statusCode))")
            completion(.doNotRetry)
        }
    }
}
