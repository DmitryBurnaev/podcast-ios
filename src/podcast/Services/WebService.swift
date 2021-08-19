import Foundation
import KeychainAccess


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
    
    func getResourse(url: String, decoder: Any) -> Any?{
        guard let url = URL(string: "\(APIUrl)\(url)") else {
            return ""
        }
        // TODO: try to get response in common method
        guard let token = self.getToken() else { return }
        guard let decoder = try? JSONDecoder().decode(PodcastsListResponse.self, from: data) else {
            completion(.failure(.decodingError))
            return ""
        }
        
    }
    
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
        guard let url = URL(string: "\(APIUrl)/podcasts/") else {
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
