import Foundation


struct PodcastsListResponse: Decodable{
    let payload: [PodcastInList]
}

struct PodcastInList: Decodable, Hashable {
    let id, episodes_count: Int
    let name, description: String
    let image_url: String?
}


class PodcastService{
    private let apiManager = APIManager()

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
