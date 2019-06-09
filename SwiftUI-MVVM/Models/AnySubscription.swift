//
//  AnySubscription.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/9/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import Combine

final class AnySubscription: Subscription {
    
    private let cancellable: AnyCancellable
    
    init(_ cancel: @escaping () -> Void) {
        self.cancellable = AnyCancellable(cancel)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        cancellable.cancel()
    }
}
