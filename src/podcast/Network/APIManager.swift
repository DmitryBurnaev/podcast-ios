import Foundation
import Alamofire

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct ResponseErrorDetails: Error, Decodable {
    let code: String
    let description: String
    
    var innerErrorDescription: String? = nil
    var responseStatusCode: String? = nil
    var unexpectedError: String? = nil
}

struct EmptyErrorPayload: Decodable {
    
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

class ResponseBody<Payload: Decodable, ErrorPayload: Decodable>: Decodable {

    enum Status: String, Decodable {
        case ok = "OK"
        case error = "ERROR"
    }

    let status: Status
    let payload: Payload?
    let errorPayload: ErrorPayload?
    let error: ResponseErrorDetails?
    
    let foundError: Error?

    enum ResponseKeys: String, CodingKey {
        case status, payload, error
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ResponseKeys.self)
        status = try values.decode(Status.self, forKey: .status)
        error = try? values.decode(ResponseErrorDetails.self, forKey: .error)

        switch status {
        case .ok:
            errorPayload = nil
            do {
                payload = try values.decode(Payload.self, forKey: .payload)
                foundError = nil
            } catch (let error) {
                payload = nil
                foundError = error
                print("Can't decode response body: foundError: \(error)")
            }
        case .error:
            payload = nil
            do {
                errorPayload = try values.decode(ErrorPayload.self, forKey: .payload)
                foundError = nil
            } catch (let error) {
                foundError = error
                errorPayload = nil
                print("Can't decode error's response body: foundError: \(error)")
            }
        }
    }
}


class APIManager{
    
    static let session = Session()
    
    let apiBaseUrl: URL

    init() {
        self.apiBaseUrl = URL(string: API_URL)!
    }
    
    
    @discardableResult
    func request<Payload: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (_ result: Result<Payload, ResponseErrorDetails>) -> Void) -> DataRequest?
    {
        let url = apiBaseUrl.appendingPathComponent(path)
        let headers = [
            HTTPHeader(name: "X-Platform", value: "iOS"),
        ]
        let interceptor = AccessTokenInterceptor()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let request = APIManager.session
            .request(url, method: method, parameters: parameters, encoding: encoding, headers: HTTPHeaders(headers), interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ResponseBody<Payload, EmptyErrorPayload>.self, decoder: decoder, completionHandler: { response in
//                debugPrint(response)
                switch response.result {
                case .success(let data):
                    switch data.status {
                    case .ok:
                        if let payload = data.payload {
                            completion(.success(payload))
                        } else {
//                            print("----")
//                            debugPrint(data)
                            print("API REQ: no response data \(String(describing: data.payload))")
                            completion(.failure(ResponseErrorDetails(code: "NO_DATA", description: "API REQ: no response data")))
                        }
                        print("response data \(data)")
                    case .error:
                        print("API REQ: response data \(data) STATUS: \(data.status)")
                        completion(.failure(ResponseErrorDetails(code: "STATUS_NOT_OK", description: "API REQ: status problem \(data.status)")))
                    }
                case .failure(let error):
                    print("API REQ: got err \(error)")
                    completion(.failure(ResponseErrorDetails(code: "STATUS_NOT_OK", description: "API REQ: status problem \(error)")))
                }
            })
        
        return request

    }
    
    
}
