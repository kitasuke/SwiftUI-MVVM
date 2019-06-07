//
//  APIServiceError.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/6/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}
