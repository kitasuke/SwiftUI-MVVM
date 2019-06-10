//
//  MockExperimentService.swift
//  SwiftUI-MVVMTests
//
//  Created by Yusuke Kita on 6/9/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
@testable import SwiftUI_MVVM

final class MockExperimentService: ExperimentServiceType {
    
    var stubs: [ExperimentKey: Bool] = [:]
    func experiment(for key: ExperimentKey, value: Bool) {
        stubs[key] = value
    }
    
    func experiment(for key: ExperimentKey) -> Bool {
        return stubs[key] ?? false
    }
}
