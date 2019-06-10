//
//  MockAPISearvice.swift
//  SwiftUI-MVVMTests
//
//  Created by Yusuke Kita on 6/7/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine
@testable import SwiftUI_MVVM

final class MockAPIService: APIServiceType {
    var stubs: [String: Any] = [:]
    
    func stub<Response>(for path: String, response: AnyPublisher<Response, APIServiceError>) where Response: Decodable {
        stubs[path] = response
    }
    
    func response<Response>(from path: String, queryItems: [URLQueryItem]) -> AnyPublisher<Response, APIServiceError> where Response : Decodable {
        
        guard let response = stubs[path] as? AnyPublisher<Response, APIServiceError> else {
            return Publishers.Empty<Response, APIServiceError>()
                .eraseToAnyPublisher()
        }
        
        return response
    }
}
