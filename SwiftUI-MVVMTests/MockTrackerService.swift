//
//  MockTrackerService.swift
//  SwiftUI-MVVMTests
//
//  Created by Yusuke Kita on 6/8/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
@testable import SwiftUI_MVVM

final class MockTrackerService: TrackerType {
    
    private(set) var loggedTypes: [TrackEventType] = []
    
    func log(type: TrackEventType) {
        loggedTypes.append(type)
    }
}
