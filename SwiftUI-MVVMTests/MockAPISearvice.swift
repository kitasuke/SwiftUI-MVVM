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
    
    func response<Response>(from path: String, queryItems: [URLQueryItem]) -> AnyPublisher<Response, APIServiceError> where Response : Decodable {
        // TODO
        return Publishers.Once<SearchRepositoryResponse, APIServiceError>(SearchRepositoryResponse(items: []))
            .eraseToAnyPublisher() as! AnyPublisher<Response, APIServiceError>
    }
}
