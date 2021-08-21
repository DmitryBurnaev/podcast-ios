import Foundation
import KeychainAccess
import Alamofire

let API_URL: String = "https://podcast-service.devpython.ru/api"

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
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

struct LoginResponseBody: Codable{
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
        guard let url = URL(string: "\(API_URL)/auth/sign-in/") else {
            return
        }
        // todo: using AF.request instead
        let body = RefreshTokenRequestBody(refresh_token: refreshToken)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request){ (data, resp, error) in
            guard let data = data, error == nil else {
                print("\nRefresh token failed: 'No data in response'")
                completion(false)
                return
            }
            guard let response = try? JSONDecoder().decode(LoginResponseBody.self, from: data) else {
                print("\nRefresh token failed: 'Unable to decode response JSON'")
                completion(false)
                return
            }
            let keychain = Keychain(service: "com.podcast")
            do {
                try keychain.set(response.payload.access_token, key: "accessToken")
                try keychain.set(response.payload.refresh_token, key: "refreshToken")
            }
            catch let error {
                print("Couldn't save access/refresh tokens: \(error)")
            }
            completion(true)
            
        }.resume()
        
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
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        print("\nretried; retry count: \(request.retryCount)\n")
        refreshToken { isSuccess in
            isSuccess ? completion(.retry) : completion(.doNotRetry)
        }
    }

}


//class AccessTokenAdapter: RequestAdapter {
//    private let accessToken: String
//
//    init(accessToken: String) {
//        self.accessToken = accessToken
//    }
//
////    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
////        var urlRequest = urlRequest
////
////        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://httpbin.org") {
////            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
////        }
////
////        return urlRequest
////    }
//
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var urlRequest = urlRequest
//
//        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://httpbin.org") {
//            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        }
//
//        return urlRequest
//    }
//}


class WebService{
//    let APIUrl: String = "http://192.168.1.6:8001/api"
    let APIUrl: String = "https://podcast-service.devpython.ru/api"

    func getToken() -> String?{
        let keychain = Keychain(service: "com.podcast")
        guard let token = try? keychain.get("accessToken") else {
            print("No access token found")
            return nil
        }
        return token
    }
    
//    func getResourse(url: String, decoder: Any) -> Any?{
//        guard let url = URL(string: "\(APIUrl)\(url)") else {
//            return ""
//        }
//        // TODO: try to get response in common method
//        guard let token = self.getToken() else { return }
//        guard let decoder = try? JSONDecoder().decode(PodcastsListResponse.self, from: data) else {
//            completion(.failure(.decodingError))
//            return ""
//        }
//        
//    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        guard let url = URL(string: "\(APIUrl)/auth/sign-in/") else {
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
        AF.request("\(API_URL)/podcasts/", interceptor: interceptor).response { response in
            debugPrint(response)
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            guard let podcastResponse = try? JSONDecoder().decode(PodcastsListResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            let podcasts = podcastResponse.payload
            completion(.success(podcasts))


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
            url = "\(APIUrl)/podcasts/\(podcastID ?? 0)/episodes/?limit=\(limit)"
        } else {
            url = "\(APIUrl)/episodes/?limit=\(limit)"
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
