//
//  SearchRepositoryRequest.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/9/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation

struct SearchRepositoryRequest: APIRequestType {
    typealias Response = SearchRepositoryResponse
    
    var path: String { return "/search/repositories" }
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "q", value: "SwiftUI"),
            .init(name: "order", value: "desc")
        ]
    }
}
