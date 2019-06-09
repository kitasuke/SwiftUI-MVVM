//
//  URLSession+Combine.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine

extension URLSession {
    func send(request: URLRequest) -> AnyPublisher<Data, APIServiceError> {
        return .init { subscriber in
            let task = self.dataTask(with: request) { data, response, error in
                // This can be replaced with RunLoop integration with Combine framework soon
                DispatchQueue.main.async {
                    guard let httpResponse = response as? HTTPURLResponse,
                        let data = data,
                        200..<300 ~= httpResponse.statusCode else {
                            subscriber.receive(completion: .failure(.responseError))
                            return
                    }
                    
                    _ = subscriber.receive(data)
                    subscriber.receive(completion: .finished)
                }
            }
            
            subscriber.receive(subscription: AnySubscription { task.cancel() })
            task.resume()
        }
    }
}

extension JSONDecoder: TopLevelDecoder {}
