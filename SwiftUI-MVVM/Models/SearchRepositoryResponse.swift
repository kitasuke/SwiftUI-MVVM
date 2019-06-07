//
//  SearchRepositoryResponse.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation

struct SearchRepositoryResponse: Decodable {
    var items: [Repository]
}
