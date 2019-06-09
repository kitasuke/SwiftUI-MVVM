//
//  TrackerService.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/8/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation

enum TrackEventType {
    case listView
}

protocol TrackerType {
    func log(type: TrackEventType)
}

final class TrackerService: TrackerType {
    
    func log(type: TrackEventType) {
        // do something
    }
}
