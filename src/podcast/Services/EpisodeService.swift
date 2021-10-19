import Foundation
import Alamofire


struct EpisodesInListResponse: Decodable{
    let items: [EpisodeInList]
}

struct EpisodeInList: Decodable, Hashable{
    var id: Int
    let title, imageUrl, status: String
}

struct EpisodeDetails: Decodable, Hashable{
    var id: Int
    let title, imageUrl, description: String
}



class EpisodeService{
    private let apiManager = APIManager()
    
    func getEpisodes(limit: Int = 20, podcastID: Int? = nil, completion: @escaping (Result<[EpisodeInList], NetworkError>) -> Void){
        let url: String = (podcastID != nil) ? "/podcasts/\(podcastID ?? 0)/episodes/" : "/episodes/"
        apiManager.request(
            url,
            parameters: ["limit": limit],
            encoding: URLEncoding.default,
            completion: { (result: Result<EpisodesInListResponse, ResponseErrorDetails>) in
                switch result {
                case .success(let episodes):
                    print("API: got episodes from response: \(episodes)")
                    completion(.success(episodes.items))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        )
    }
    
    func createEpisode(podcastID: Int, sourceURL: String, completion: @escaping (Result<EpisodeInList, NetworkError>) -> Void) {
        apiManager.request(
            "/podcasts/\(podcastID)/episodes/",
            method: .post,
            parameters: ["source_url": sourceURL],
            completion: { (result: Result<EpisodeInList, ResponseErrorDetails>) in
                switch result {
                case .success(let episode):
                    print("API: created episode with response: \(episode)")
                    completion(.success(episode))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        )
    }
    
    
    
    
}
