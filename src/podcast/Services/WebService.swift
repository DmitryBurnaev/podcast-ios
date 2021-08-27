import Foundation
import KeychainAccess
import Alamofire

let API_URL: String = "https://podcast-service.devpython.ru/api"
//let API_URL: String = "http://192.168.1.3:8001/api"


enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

enum APIError: Error {
    case invalidCredentials
    case noData
    case decodingError
    case invalidStatusCode
    case custom(errorMessage: String)
    case errorCode(code: String)
}

struct ErrorResponsePayload: Codable{
    let error: String
    let details: String
}

struct ErrorResponse: Codable{
    let status: String
    let payload: ErrorResponsePayload
}

enum NetworkError: Error{
    case invalidURL
    case noData
    case decodingError
}

struct LoginRequestBody: Codable{
    let email: String
    let password: String
}

struct RefreshTokenRequestBody: Codable{
    let refresh_token: String
}

struct ResponstWithTokens: Codable{
    let status: String
    let payload: TokenPayload
}

struct TokenPayload: Codable {
    let access_token, refresh_token: String
}


struct PodcastsListResponse: Decodable{
    let payload: [PodcastItem]
}

struct PodcastItem: Decodable, Hashable {
    let id, episodes_count: Int
    let name, description: String
    let image_url: String?
}

struct EpisodesResponse: Decodable{
    let payload: EpisodesList
}

struct EpisodesList: Decodable{
    let items: [Episode]
}

struct Episode: Decodable, Hashable{
    var id: Int
    let title, image_url: String
}


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

        
        
        
//
//        // todo: using AF.request instead
//        let body = RefreshTokenRequestBody(refresh_token: refreshToken)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONEncoder().encode(body)
//
//        URLSession.shared.dataTask(with: request){ (data, resp, error) in
//            guard let data = data, error == nil else {
//                print("\nRefresh token failed: 'No data in response'")
//                completion(false)
//                return
//            }
//            guard let response = try? JSONDecoder().decode(LoginResponseBody.self, from: data) else {
//                print("\nRefresh token failed: 'Unable to decode response JSON'")
//                completion(false)
//                return
//            }
//            let keychain = Keychain(service: "com.podcast")
//            do {
//                try keychain.set(response.payload.access_token, key: "accessToken")
//                try keychain.set(response.payload.refresh_token, key: "refreshToken")
//            }
//            catch let error {
//                print("Couldn't save access/refresh tokens: \(error)")
//            }
//            completion(true)
//
//        }.resume()
        
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = self.getToken() else { return }
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        print("\nadapted; token added to the header field is: \(bearerToken)\n")
        completion(.success(request))
    }
    
        
    func retry(_ request: Request, for session: Session, dueTo error: Error,
                  completion: @escaping (RetryResult) -> Void) {
        print("Retry starts")
        guard request.retryCount < retryLimit else {
            print("Too many retries skip retry actions.")
            completion(.doNotRetry)
            return
        }
        print("\nFound API error! | statusCode \(String(describing: request.response?.statusCode)) | error \(error)\n")
        debugPrint(request.response ?? "[empty response]")
//        print(request.response?.statusCode)
//        if let httpStatusCode = request.response?.statusCode {
//            switch(httpStatusCode) {
//                case 401:
//                    print("Unauth status code 401")
//            default:
//                print("Unknown status code \(httpStatusCode)")
//            }
//        } else {
//            print("NO status code \(request.response?.statusCode)")
//        }
//
    
        if (request.response?.statusCode == 401){
            print("RETRY: flow (step 1)")
            let lastRequestURL = request.lastRequest?.url?.absoluteString
            guard let request = request as? DataRequest else { fatalError() }
            print("RETRY: flow (step 2)")
            print("response \(String(describing: request.data))")
//                request.responseData { response in
            print("RETRY: flow (step 3)")
            
            guard let data = request.data else {
                print("RETRY: no data in response found!")
                completion(.doNotRetry)
                return
            }
            guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                print("RETRY: no valid response data!")
                completion(.doNotRetry)
                return
            }
            print("RETRY: status \(errorResponse.status) | \(String(describing: lastRequestURL))")
            if (errorResponse.status == "SIGNATURE_EXPIRED" && !(lastRequestURL?.contains("refresh") ?? false)){
                print("\nretried; retry count: \(request.retryCount) | statusCode \(String(describing: request.response?.statusCode))\n")
                self.refreshToken { isSuccess in
                    isSuccess ? completion(.retry) : completion(.doNotRetry)
                }
//                    }
                }
            }
        else{
            print("No auth problem. Skip to retry. statusCode \(String(describing: request.response?.statusCode))")
            completion(.doNotRetry)
            }
        }
    }


class WebService{
    func getToken() -> String?{
        let keychain = Keychain(service: "com.podcast")
        guard let token = try? keychain.get("accessToken") else {
            print("No access token found")
            return nil
        }
        return token
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        guard let url = URL(string: "\(API_URL)/auth/sign-in/") else {
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
            guard let loginResponse = try? JSONDecoder().decode(ResponstWithTokens.self, from: data) else {
                completion(.failure(.custom(errorMessage: "Unable to decode response JSON")))
                return
            }
//            TODO: Support not 200 status
//            guard let token = loginResponse.payload.access_token else {
//                completion(.failure(.invalidCredentials))
//                return
//            }
            
            let accessToken = loginResponse.payload.access_token
            let refreshToken = loginResponse.payload.refresh_token
            let keychain = Keychain(service: "com.podcast")
            do {
                try keychain.set(accessToken, key: "accessToken")
                try keychain.set(refreshToken, key: "refreshToken")
            }
            catch let error {
                print("Couldn't save access/refresh tokens: \(error)")
            }

            completion(.success(accessToken))
            
        }.resume()
    }
    
    func getPodcasts(limit: Int = 20, completion: @escaping (Result<[PodcastItem], NetworkError>) -> Void){
        let interceptor: AccessTokenInterceprot = AccessTokenInterceprot()
        AF.request("\(API_URL)/podcasts/", interceptor: interceptor).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    guard let podcastResponse = try? JSONDecoder().decode(PodcastsListResponse.self, from: data) else {
                        completion(.failure(.decodingError))
                        return
                    }
                    completion(.success(podcastResponse.payload))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
            }
        }
    }
    
    
    func getPodcastsOld(limit: Int = 20, completion: @escaping (Result<[PodcastItem], NetworkError>) -> Void){
        guard let url = URL(string: "\(API_URL)/podcasts/") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        guard let token = self.getToken() else { return }
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ (data, resp, error) in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            guard let podcastResponse = try? JSONDecoder().decode(PodcastsListResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            let podcasts = podcastResponse.payload
            completion(.success(podcasts))
        }.resume()
        
    }

    func getEpisodes(limit: Int = 20, podcastID: Int? = nil, completion: @escaping (Result<[Episode], NetworkError>) -> Void){
        var url: String = ""
        if (podcastID != nil){
            url = "\(API_URL)/podcasts/\(podcastID ?? 0)/episodes/?limit=\(limit)"
        } else {
            url = "\(API_URL)/episodes/?limit=\(limit)"
        }
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        guard let token = self.getToken() else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ (data, resp, error) in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            guard let episodesResponse = try? JSONDecoder().decode(EpisodesResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            let episodes = episodesResponse.payload.items
            completion(.success(episodes))
        }.resume()
        
    }

    
}
