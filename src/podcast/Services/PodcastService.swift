import Foundation


struct PodcastsListResponse: Decodable{
    let payload: [PodcastInList]
}

struct PodcastInList: Decodable, Hashable {
    let id, episodesCount: Int
    let name, description: String
    let imageUrl: String?
}

struct PodcastDetails: Decodable, Hashable {
    let id: Int
    let name, description: String
    let imageUrl: String?
}


class PodcastService{
    private let apiManager = APIManager()

    func getPodcastDetails(podcastID: Int, completion: @escaping (Result<PodcastDetails, NetworkError>) -> Void){
        apiManager.request(
            "/podcasts/\(podcastID)/",
            completion: { (result: Result<PodcastDetails, ResponseErrorDetails>) in
                switch result {
                case .success(let podcast):
                    print("got result from request: \(podcast)")
                    completion(.success(podcast))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        )
    }
   
    func getPodcasts(limit: Int = 20, completion: @escaping (Result<[PodcastInList], NetworkError>) -> Void){
        apiManager.request(
            "/podcasts/",
            completion: { (result: Result<[PodcastInList], ResponseErrorDetails>) in
                switch result {
                case .success(let podcasts):
                    print("got result from request: \(podcasts)")
                    completion(.success(podcasts))
                case .failure(let err):
                    print("Found API problem here: \(err.localizedDescription)")
                    completion(.failure(.noData))
                }
            }
        )
    }
    
}
