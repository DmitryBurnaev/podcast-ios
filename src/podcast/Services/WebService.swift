import Foundation
import KeychainAccess
import Alamofire

let API_URL: String = "http://192.168.1.3:8001/api"


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
    let details: String?
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




class WebService{
    private let apiManager = APIManager()
    
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
        apiManager.request(
            "/podcasts/", completion: { (result: Result<[PodcastItem], ResponseErrorDetails>) in
                switch result {
                case .success:
                    print("got result from request: \(result)")
//                    let result = result as? [PodcastItem] else { fatalError() }

//                    TODO: solve this problem
//                    completion(.success(result))
//                    completion(.success(result.payload))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        )
        
        
//        let interceptor: AccessTokenInterceprot = AccessTokenInterceprot()
//        AF.request("\(API_URL)/podcasts/", interceptor: interceptor).validate(statusCode: 200..<300).responseJSON { response in
//            switch response.result {
//                case .success:
//                    guard let data = response.data else {
//                        completion(.failure(.noData))
//                        return
//                    }
//                    guard let podcastResponse = try? JSONDecoder().decode(PodcastsListResponse.self, from: data) else {
//                        completion(.failure(.decodingError))
//                        return
//                    }
//                    completion(.success(podcastResponse.payload))
//                case .failure(let err):
//                    print("Found API problem here: \(err.localizedDescription)")
//                    completion(.failure(.noData))
//            }
//        }
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
