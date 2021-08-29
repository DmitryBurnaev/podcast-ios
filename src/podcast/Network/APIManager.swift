//
//  APIManager.swift
//  podcast
//
//  Created by Dmitry Burnaev on 29.08.2021.
//

import Foundation
import Alamofire

//
//struct ErrorResponsePayload: Codable{
//    let error: String
//    let details: String?
//}

//struct ResponseErrorDetails: Codable{
//    let status: String
//    let payload: ErrorResponsePayload
//}

enum ResponseErrorDetails: Error {
    case invalidCredentials
    case noData
    case decodingError
    case invalidStatusCode
    case custom(errorMessage: String)
    case errorCode(code: String)
}


class APIManager{
    
    static let session = Session()
    
    let apiBaseUrl: URL

    init() {
        self.apiBaseUrl = URL(API_URL)
    }
    
    
    @discardableResult
    func makeRequest<Payload: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: [HTTPHeader]? = nil,
        convertFromSnakeCase: Bool = true,
        completion: @escaping (_ result: Result<Payload, ResponseErrorDetails>) -> Void) -> DataRequest?
    {
        let url = apiBaseUrl.appendingPathComponent(path)
//        TODO: add makeRequest implementation here
//
//        return makeRequest2(
//            url,
//            method: method,
//            parameters: parameters,
//            encoding: encoding,
//            headers: headers,
//            needAuth: needAuth,
//            convertFromSnakeCase: convertFromSnakeCase,
//            completion: completion
//        )
    }
    
    
    
}
