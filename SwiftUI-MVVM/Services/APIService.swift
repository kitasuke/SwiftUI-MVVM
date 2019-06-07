//
//  APIService.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/6/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine

protocol APIServiceType {
    func response<Response: Decodable>(from path: String, queryItems: [URLQueryItem]) -> AnyPublisher<Response, APIServiceError>
}

final class APIService: APIServiceType {
    
    private let baseURL: URL
    init(baseURL: URL = URL(string: "https://api.github.com")!) {
        self.baseURL = baseURL
    }

    func response<Response>(from path: String, queryItems: [URLQueryItem]) -> AnyPublisher<Response, APIServiceError> where Response : Decodable {
    
    let pathURL = URL(string: path, relativeTo: baseURL)!
    
    var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems = queryItems
    var request = URLRequest(url: urlComponents.url!)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let decorder = JSONDecoder()
    decorder.keyDecodingStrategy = .convertFromSnakeCase
    return URLSession.shared.send(request: request)
        .flatMap { data in
            Publishers.Just(data)
                .decode(type: Response.self, decoder: decorder)
                .mapError(APIServiceError.parseError)
        }
        .eraseToAnyPublisher()
    }
}
