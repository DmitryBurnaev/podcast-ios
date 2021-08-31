//
//  APIManager.swift
//  podcast
//
//  Created by Dmitry Burnaev on 29.08.2021.
//

import Foundation
import Alamofire


struct ResponseErrorDetails: Error, Decodable {
//    let invalidCredentials: String
//    let noData: String
//    let decodingError: String
//    let invalidStatusCode: String
//    let custom(errorMessage: String)
//    let errorCode(code: String)
    let code: String
    let description: String
    
    var innerErrorDescription: String? = nil
    var responseStatusCode: String? = nil
    
//    var unexpectedNetworkErrorReason: UnexpectedNetworkErrorReason? = nil
}

struct EmptyErrorPayload: Decodable {
    
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
        headers: [HTTPHeader]? = nil,
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
//            TODO: check on http status too
            .validate({ (request, response, data) -> DataRequest.ValidationResult in
//                TODO: implement validate method
                return self.validate(data: data)
            })
            .responseDecodable(of: ResponseBody<Payload, EmptyErrorPayload>.self, decoder: decoder, completionHandler: { response in
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    switch data.status {
                    case .ok:
                        print("response data \(data)")
                    case .error:
                        print("got err response data \(data)")
                    }
                case .failure(let error):
                    print("fail \(error)")
                }
            })

//            TODO: implement responseDecodable
        
        return request

    }
    
    private func validate(data: Data?) -> DataRequest.ValidationResult {
        print('validate....')
        debugPrint(data)
    }
    
    
}
